import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../data/models/dish_detail_model.dart';
import '../../../../data/models/unfinished_recipe_model.dart';
import '../../../../data/services/api/recipe_service.dart';
import '../../../../data/services/local/local_sql_database_service.dart';
import '../../../../core/services/tts_service.dart';
import '../../settings/view_models/settings_view_model.dart';

class RecipeViewModel with ChangeNotifier {
  RecipeViewModel({
    required this.recipeService,
    required this.ttsService,
    this.settingsViewModel,
    LocalSqlDatabaseService? localDbService,
  }) : _localDbService = localDbService ?? LocalSqlDatabaseService.instance {
    settingsViewModel?.addListener(_onSettingsChanged);
    _lastLanguageCode = settingsViewModel?.locale.languageCode;
  }

  final RecipeService recipeService;
  final TtsService ttsService;
  final SettingsViewModel? settingsViewModel;
  final LocalSqlDatabaseService _localDbService;
  String? _lastLanguageCode;

  bool _isLoading = true;
  String? _errorMessage;
  DishDetailModel? _dish;

  int _currentStepIndex = 0;
  double _currentPortion = 2.0;

  // Track checked todo indices or IDs: key = "step_{index}_todo_{todoIdx}"
  final Set<String> _checkedTodos = {};

  // Dynamic feedback responses: key = fieldId, value = dynamic (rating int, choice string, text string, etc.)
  final Map<String, dynamic> _feedbackResponses = {};
  bool _isSubmittingFeedback = false;
  bool _isRecipeCompleted = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DishDetailModel? get dish => _dish;
  int get currentStepIndex => _currentStepIndex;
  double get currentPortion => _currentPortion;
  Set<String> get checkedTodos => _checkedTodos;
  Map<String, dynamic> get feedbackResponses => _feedbackResponses;
  bool get isSubmittingFeedback => _isSubmittingFeedback;
  bool get isRecipeCompleted => _isRecipeCompleted;

  RecipeStepItem? get currentStep {
    if (_dish == null || _currentStepIndex >= _dish!.steps.length) return null;
    return _dish!.steps[_currentStepIndex];
  }

  bool get isFirstStep => _currentStepIndex == 0;
  bool get isLastStep => _dish != null && _currentStepIndex == _dish!.steps.length - 1;

  Future<void> loadRecipe(String dishId, {int? initialStepIndex}) async {
    await ttsService.stop();
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _dish = await recipeService.getDishDetail(dishId);
      _currentPortion = _dish!.portionDefinition.defaultAmount;

      // Check if there was an unfinished recipe saved in local SQL database
      final savedProgress = await _localDbService.getRecipeProgress(dishId);
      if (initialStepIndex != null) {
        _currentStepIndex = initialStepIndex.clamp(0, _dish!.steps.length - 1);
      } else if (savedProgress != null) {
        _currentStepIndex = savedProgress.stepIndex.clamp(0, _dish!.steps.length - 1);
        _currentPortion = savedProgress.portionAmount;
        _checkedTodos.addAll(savedProgress.completedTodoIds);
      } else {
        _currentStepIndex = 0;
      }

      // Initialize default feedback rating if available
      for (final field in _dish!.feedbackFormFields) {
        if (field.initialValue != null) {
          _feedbackResponses[field.id] = field.initialValue;
        }
      }

      // Only auto-save if user has reached at least the second step (stepIndex >= 1)
      if (_currentStepIndex >= 1) {
        await _autoSaveCurrentStep();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sets the active step index and immediately persists progress to SQL DB
  Future<void> setStepIndex(int index) async {
    if (_dish == null) return;
    final clamped = index.clamp(0, _dish!.steps.length - 1);
    if (_currentStepIndex == clamped) return;

    // Unconditionally stop any active or pending TTS speech when leaving or changing step
    await ttsService.stop();

    _currentStepIndex = clamped;
    notifyListeners();

    // Immediately save current step to local SQL DB
    await _autoSaveCurrentStep();
  }

  Future<void> nextStep() async {
    if (_dish == null || isLastStep) return;
    await setStepIndex(_currentStepIndex + 1);
  }

  Future<void> prevStep() async {
    if (_dish == null || isFirstStep) return;
    await setStepIndex(_currentStepIndex - 1);
  }

  Future<void> updatePortion(double amount) async {
    if (_dish == null) return;
    final min = _dish!.portionDefinition.minAmount;
    final max = _dish!.portionDefinition.maxAmount;
    _currentPortion = amount.clamp(min, max);
    notifyListeners();

    // Save portion change to local SQL DB
    await _autoSaveCurrentStep();
  }

  void toggleTodo(int stepIndex, int todoIdx) {
    final key = 'step_${stepIndex}_todo_$todoIdx';
    if (_checkedTodos.contains(key)) {
      _checkedTodos.remove(key);
    } else {
      _checkedTodos.add(key);
    }
    notifyListeners();
    _autoSaveCurrentStep();
  }

  bool isTodoChecked(int stepIndex, int todoIdx) {
    return _checkedTodos.contains('step_${stepIndex}_todo_$todoIdx');
  }

  /// Text-To-Speech audio narration toggle for the current step
  Future<void> toggleStepAudio() async {
    final step = currentStep;
    if (step == null) return;
    await ttsService.speak(step.audioNarrationText);
  }

  /// Share CTA invoking native OS share options with pre-generated backend deep link
  Future<void> shareRecipe() async {
    if (_dish == null) return;
    final text = 'Check out this delicious ${_dish!.name} recipe on Cukkie: ${_dish!.shareUrl}';
    await Share.share(
      text,
      subject: _dish!.name,
    );
  }

  void setFeedbackResponse(String fieldId, dynamic value) {
    _feedbackResponses[fieldId] = value;
    notifyListeners();
  }

  /// Submits dynamic feedback form and completes recipe
  Future<bool> submitFeedback() async {
    if (_dish == null) return false;
    _isSubmittingFeedback = true;
    notifyListeners();

    try {
      await recipeService.submitFeedback(_dish!.id, _feedbackResponses);

      // Recipe is finished: remove from local SQL database
      await _localDbService.removeRecipe(_dish!.id);

      _isRecipeCompleted = true;
      return true;
    } catch (_) {
      return false;
    } finally {
      _isSubmittingFeedback = false;
      notifyListeners();
    }
  }

  /// Auto-saves the exact rendered step to local SQL DB
  Future<void> _autoSaveCurrentStep() async {
    if (_dish == null || _isRecipeCompleted) return;

    // Requirement 8: Only add to unfinished recipes if user has reached at least the second step (index >= 1)
    if (_currentStepIndex < 1) return;

    final step = currentStep;
    if (step == null) return;

    final entry = UnfinishedRecipeModel(
      dishId: _dish!.id,
      dishName: _dish!.name,
      dishImage: _dish!.imageUrl,
      stepIndex: _currentStepIndex,
      stepHeading: step.heading,
      portionAmount: _currentPortion,
      completedTodoIds: _checkedTodos.toList(),
      lastInteractedAt: DateTime.now(),
    );

    await _localDbService.saveProgress(entry);
  }

  void _onSettingsChanged() {
    final currentLang = settingsViewModel?.locale.languageCode;
    if (currentLang != null && currentLang != _lastLanguageCode) {
      _lastLanguageCode = currentLang;
      if (_dish != null) {
        loadRecipe(_dish!.id, initialStepIndex: _currentStepIndex);
      }
    }
  }

  @override
  void dispose() {
    settingsViewModel?.removeListener(_onSettingsChanged);
    ttsService.stop();
    super.dispose();
  }
}
