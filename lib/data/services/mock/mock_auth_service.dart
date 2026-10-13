import 'dart:async';
import '../api/auth_service.dart';
import '../local/secure_prefs_service.dart';
import '../../models/user_profile_model.dart';

class MockAuthService implements AuthService {
  MockAuthService({SecurePrefsService? prefsService})
      : _prefsService = prefsService ?? SecurePrefsService.instance;

  final SecurePrefsService _prefsService;

  // Stream controller to simulate SMS auto-read broadcast
  final StreamController<String> _otpAutoReadController = StreamController<String>.broadcast();
  @override
  Stream<String> get otpAutoReadStream => _otpAutoReadController.stream;

  UserProfileModel _currentUser = const UserProfileModel(
    phoneNumber: '',
    isLoggedIn: false,
    preferences: UserPreferencesModel(hasSavedPreferences: false),
  );

  @override
  Future<bool> sendOtp(String phoneNumber) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Simulate auto-read: broadcast OTP '1234' after 1.5 seconds
    Timer(const Duration(milliseconds: 1500), () {
      if (!_otpAutoReadController.isClosed) {
        _otpAutoReadController.add('1234');
      }
    });

    return true;
  }

  @override
  Future<UserProfileModel> verifyOtp(String phoneNumber, String otp) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // For mock testing, allow '1234' or any 4 digit code
    if (otp.length != 4) {
      throw Exception('Invalid verification code');
    }

    final token = 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
    await _prefsService.saveAuthSession(token, phoneNumber);

    _currentUser = UserProfileModel(
      phoneNumber: phoneNumber,
      token: token,
      isLoggedIn: true,
      preferences: _currentUser.preferences,
    );

    return _currentUser;
  }

  @override
  Future<UserProfileModel> getUserProfile() async {
    final token = _prefsService.getAuthToken();
    final phone = _prefsService.getPhoneNumber();

    if (token != null && phone != null) {
      _currentUser = _currentUser.copyWith(
        phoneNumber: phone,
        token: token,
        isLoggedIn: true,
      );
    } else {
      _currentUser = const UserProfileModel(
        phoneNumber: '',
        isLoggedIn: false,
        preferences: UserPreferencesModel(hasSavedPreferences: false),
      );
    }
    return _currentUser;
  }

  @override
  Future<void> updatePreferences(UserPreferencesModel preferences) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _currentUser = _currentUser.copyWith(
      preferences: preferences.copyWith(hasSavedPreferences: true),
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _prefsService.clearAuthSession();
    _currentUser = const UserProfileModel(
      phoneNumber: '',
      isLoggedIn: false,
      preferences: UserPreferencesModel(hasSavedPreferences: false),
    );
  }

  void dispose() {
    _otpAutoReadController.close();
  }
}
