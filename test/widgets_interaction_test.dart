import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cukkie/core/services/tts_service.dart';
import 'package:cukkie/data/models/dish_detail_model.dart';
import 'package:cukkie/data/services/local/secure_prefs_service.dart';
import 'package:cukkie/data/services/mock/mock_auth_service.dart';
import 'package:cukkie/data/services/mock/mock_content_service.dart';
import 'package:cukkie/data/services/mock/mock_recipe_data.dart';
import 'package:cukkie/data/services/mock/mock_recipe_service.dart';
import 'package:cukkie/ui/features/auth/view_models/auth_view_model.dart';
import 'package:cukkie/ui/features/home/view_models/home_view_model.dart';
import 'package:cukkie/ui/features/recipe/view_models/recipe_view_model.dart';
import 'package:cukkie/ui/features/recipe/views/widgets/cooking_step_item.dart';
import 'package:cukkie/ui/features/recipe/views/recipe_detail_view.dart';
import 'package:cukkie/ui/features/settings/view_models/settings_view_model.dart';
import 'package:cukkie/ui/features/settings/views/settings_view.dart';

class _MockTtsService extends ChangeNotifier implements TtsService {
  bool mockIsPlaying = false;
  int speakCount = 0;
  int stopCount = 0;

  @override
  bool get isPlaying => mockIsPlaying;

  @override
  String? get currentlySpeakingText => null;

  @override
  String get activeLanguageTag => 'en-US';

  @override
  String get currentLanguageCode => 'en';

  @override
  Future<void> setLanguage(String languageCode) async {}

  @override
  Future<void> speak(String text) async {
    if (mockIsPlaying) {
      await stop();
      return;
    }
    speakCount++;
    mockIsPlaying = true;
    notifyListeners();
  }

  @override
  Future<void> stop() async {
    stopCount++;
    mockIsPlaying = false;
    notifyListeners();
  }
}

class _InstantRecipeService extends MockRecipeService {
  @override
  Future<DishDetailModel> getDishDetail(String dishId) async {
    return MockRecipeData.getDishDetail(dishId, 'en');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SecurePrefsService prefsService;
  late MockContentService contentService;
  late _InstantRecipeService recipeService;
  late MockAuthService authService;
  late _MockTtsService fakeTts;
  late SettingsViewModel settingsVm;
  late RecipeViewModel recipeVm;
  late HomeViewModel homeVm;
  late AuthViewModel authVm;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefsService = SecurePrefsService.instance;
    await prefsService.init();

    contentService = MockContentService();
    recipeService = _InstantRecipeService();
    authService = MockAuthService();
    fakeTts = _MockTtsService();

    settingsVm = SettingsViewModel(
      contentService: contentService,
      prefsService: prefsService,
      ttsService: fakeTts,
    );

    authVm = AuthViewModel(
      authService: authService,
    );

    recipeVm = RecipeViewModel(
      recipeService: recipeService,
      ttsService: fakeTts,
      settingsViewModel: settingsVm,
    );

    homeVm = HomeViewModel(
      recipeService: recipeService,
      authViewModel: authVm,
      settingsViewModel: settingsVm,
    );
  });

  Widget buildTestableWidget(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsViewModel>.value(value: settingsVm),
        ChangeNotifierProvider<TtsService>.value(value: fakeTts),
        ChangeNotifierProvider<RecipeViewModel>.value(value: recipeVm),
        ChangeNotifierProvider<HomeViewModel>.value(value: homeVm),
        ChangeNotifierProvider<AuthViewModel>.value(value: authVm),
      ],
      child: MaterialApp(
        home: Scaffold(body: child),
      ),
    );
  }

  group('Semantic Widget Key & Fast Interaction Tests', () {
    testWidgets('CookingStepItem: Speaker button toggles audio state via semantic ValueKey', (tester) async {
      await recipeVm.loadRecipe('dish_pbm');
      recipeVm.setStepIndex(3); // A cooking step

      final step = recipeVm.dish!.steps[3];

      await tester.pumpWidget(
        buildTestableWidget(
          CookingStepItem(
            step: step,
            recipeVm: recipeVm,
          ),
        ),
      );

      final speakerButtonFinder = find.byKey(const ValueKey('recipe_speaker_button'));
      expect(speakerButtonFinder, findsOneWidget);

      // Verify initial idle icon
      expect(find.byIcon(Icons.volume_up_outlined), findsOneWidget);
      expect(fakeTts.mockIsPlaying, false);

      // Tap speaker button to start audio
      await tester.tap(speakerButtonFinder);
      await tester.pump();

      expect(fakeTts.speakCount, 1);
      expect(fakeTts.mockIsPlaying, true);
      expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);

      // Tap speaker button again to stop audio
      await tester.tap(speakerButtonFinder);
      await tester.pump();

      expect(fakeTts.mockIsPlaying, false);
      expect(find.byIcon(Icons.volume_up_outlined), findsOneWidget);
    });

    testWidgets('RecipeDetailView: Navigation buttons (Next, Prev, Exit, StepChips) targetable by ValueKey', (tester) async {
      await recipeVm.loadRecipe('dish_pbm', initialStepIndex: 1);

      await tester.pumpWidget(
        buildTestableWidget(
          RecipeDetailView(dishId: 'dish_pbm', initialStepIndex: 1),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Verify Exit button
      final exitBtn = find.byKey(const ValueKey('recipe_exit_button'));
      expect(exitBtn, findsOneWidget);

      // Verify Prev button
      final prevBtn = find.byKey(const ValueKey('recipe_prev_button'));
      expect(prevBtn, findsOneWidget);

      // Verify Next button
      final nextBtn = find.byKey(const ValueKey('recipe_next_button'));
      expect(nextBtn, findsOneWidget);

      // Tap Next button
      await tester.tap(nextBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(recipeVm.currentStepIndex, 2);

      // Tap Prev button
      await tester.tap(prevBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(recipeVm.currentStepIndex, 1);

      // Tap step chip directly via ValueKey (step chip 1 is currently active and centered in sticky bar)
      final stepChip1 = find.byKey(const ValueKey('step_chip_1'));
      expect(stepChip1, findsOneWidget);
      await tester.tap(stepChip1);
      await tester.pump();
      expect(recipeVm.currentStepIndex, 1);
    });

    testWidgets('SettingsView: Language cards, theme cards, and switches targetable by ValueKey', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const SettingsView(),
        ),
      );
      await tester.pumpAndSettle();

      // Find language cards by Key
      final enCard = find.byKey(const ValueKey('language_card_en'));
      final hiCard = find.byKey(const ValueKey('language_card_hi'));
      final arCard = find.byKey(const ValueKey('language_card_ar'));

      expect(enCard, findsOneWidget);
      expect(hiCard, findsOneWidget);
      expect(arCard, findsOneWidget);

      // Tap Hindi card and verify language change
      await tester.tap(hiCard);
      await tester.pumpAndSettle();
      expect(settingsVm.locale.languageCode, 'hi');

      // Tap Arabic card and verify language change
      await tester.tap(arCard);
      await tester.pumpAndSettle();
      expect(settingsVm.locale.languageCode, 'ar');

      // Tap English card to restore
      await tester.tap(enCard);
      await tester.pumpAndSettle();
      expect(settingsVm.locale.languageCode, 'en');

      // Find theme cards by Key
      final lightCard = find.byKey(const ValueKey('theme_card_light'));
      final darkCard = find.byKey(const ValueKey('theme_card_dark'));
      final systemCard = find.byKey(const ValueKey('theme_card_system'));

      expect(lightCard, findsOneWidget);
      expect(darkCard, findsOneWidget);
      expect(systemCard, findsOneWidget);

      // Tap dark theme
      await tester.tap(darkCard);
      await tester.pumpAndSettle();
      expect(settingsVm.themeMode, ThemeMode.dark);

      // Find and toggle haptic and sound switches
      final hapticSwitch = find.byKey(const ValueKey('settings_haptic_switch'));
      final soundSwitch = find.byKey(const ValueKey('settings_sound_switch'));

      expect(hapticSwitch, findsOneWidget);
      expect(soundSwitch, findsOneWidget);

      // Toggle haptic switch
      final initialHaptics = settingsVm.hapticsEnabled;
      await tester.tap(hapticSwitch);
      await tester.pumpAndSettle();
      expect(settingsVm.hapticsEnabled, !initialHaptics);
    });

    testWidgets('TTS stops speaking immediately when navigating to another step', (tester) async {
      await recipeVm.loadRecipe('dish_pbm');
      recipeVm.setStepIndex(3);
      final step = recipeVm.dish!.steps[3];

      await tester.pumpWidget(
        buildTestableWidget(
          CookingStepItem(
            step: step,
            recipeVm: recipeVm,
          ),
        ),
      );

      final speakerButtonFinder = find.byKey(const ValueKey('recipe_speaker_button'));
      await tester.tap(speakerButtonFinder);
      await tester.pump();
      expect(fakeTts.mockIsPlaying, true);

      // Now change step
      await recipeVm.setStepIndex(4);
      expect(fakeTts.mockIsPlaying, false);
      expect(fakeTts.stopCount, greaterThanOrEqualTo(1));
    });
  });
}
