import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../data/models/user_profile_model.dart';
import '../../../../data/services/api/auth_service.dart';

enum PendingActionType { toggleFavourite }

class PendingAction {
  const PendingAction({
    required this.type,
    required this.targetId,
  });

  final PendingActionType type;
  final String targetId;
}

class AuthViewModel with ChangeNotifier {
  AuthViewModel({required this.authService}) {
    _initAutoReadListener();
  }

  final AuthService authService;
  StreamSubscription<String>? _autoReadSubscription;

  UserProfileModel _user = const UserProfileModel(
    phoneNumber: '',
    isLoggedIn: false,
    preferences: UserPreferencesModel(hasSavedPreferences: false),
  );

  bool _isLoading = false;
  String? _errorMessage;
  String? _autoFilledOtp;
  PendingAction? _pendingAction;

  UserProfileModel get user => _user;
  bool get isLoggedIn => _user.isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get autoFilledOtp => _autoFilledOtp;
  PendingAction? get pendingAction => _pendingAction;

  void _initAutoReadListener() {
    final stream = authService.otpAutoReadStream;
    if (stream != null) {
      _autoReadSubscription = stream.listen((otp) {
        _autoFilledOtp = otp;
        notifyListeners();
      });
    }
  }

  void setPendingAction(PendingAction? action) {
    _pendingAction = action;
  }

  PendingAction? consumePendingAction() {
    final action = _pendingAction;
    _pendingAction = null;
    return action;
  }

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await authService.getUserProfile();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendOtp(String phoneNumber) async {
    _isLoading = true;
    _errorMessage = null;
    _autoFilledOtp = null;
    notifyListeners();

    try {
      final success = await authService.sendOtp(phoneNumber);
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await authService.verifyOtp(phoneNumber, otp);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePreferences(UserPreferencesModel preferences) async {
    _isLoading = true;
    notifyListeners();

    try {
      await authService.updatePreferences(preferences);
      _user = _user.copyWith(
        preferences: preferences.copyWith(hasSavedPreferences: true),
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await authService.logout();
      _user = const UserProfileModel(
        phoneNumber: '',
        isLoggedIn: false,
        preferences: UserPreferencesModel(hasSavedPreferences: false),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _autoReadSubscription?.cancel();
    super.dispose();
  }
}
