import 'dart:async';
import '../api/auth_service.dart';
import '../local/secure_prefs_service.dart';
import '../../models/user_profile_model.dart';
import 'api_client.dart';

class HttpAuthService implements AuthService {
  HttpAuthService({ApiClient? client, SecurePrefsService? prefsService})
      : _client = client ?? ApiClient.instance,
        _prefsService = prefsService ?? SecurePrefsService.instance;

  final ApiClient _client;
  final SecurePrefsService _prefsService;

  final StreamController<String> _otpAutoReadController =
      StreamController<String>.broadcast();
  @override
  Stream<String> get otpAutoReadStream => _otpAutoReadController.stream;

  @override
  Future<bool> sendOtp(String phoneNumber) async {
    final uri = Uri.parse('${ApiClient.userServiceUrl}/api/v1/auth/send-otp');
    final res = await _client.post(uri, body: {
      'phoneNumber': phoneNumber,
    });

    // Auto-read simulation for smooth testing UX (broadcasts 1234 after 1.5s)
    Timer(const Duration(milliseconds: 1500), () {
      if (!_otpAutoReadController.isClosed) {
        _otpAutoReadController.add('1234');
      }
    });

    return res != null && res['success'] == true;
  }

  @override
  Future<UserProfileModel> verifyOtp(String phoneNumber, String otp) async {
    final uri = Uri.parse('${ApiClient.userServiceUrl}/api/v1/auth/verify-otp');
    final res = await _client.post(uri, body: {
      'phoneNumber': phoneNumber,
      'otp': otp,
    });

    final profile = UserProfileModel.fromJson(res as Map<String, dynamic>);
    if (profile.token != null && profile.token!.isNotEmpty) {
      await _prefsService.saveAuthSession(profile.token!, phoneNumber);
    }
    return profile;
  }

  @override
  Future<UserProfileModel> getUserProfile() async {
    final token = _prefsService.getAuthToken();
    final phone = _prefsService.getPhoneNumber();

    if (token == null || token.isEmpty || phone == null || phone.isEmpty) {
      return const UserProfileModel(
        phoneNumber: '',
        isLoggedIn: false,
        preferences: UserPreferencesModel(hasSavedPreferences: false),
      );
    }

    try {
      final uri = Uri.parse('${ApiClient.userServiceUrl}/api/v1/user/profile');
      final res = await _client.get(uri);
      return UserProfileModel.fromJson(res as Map<String, dynamic>);
    } catch (_) {
      // Fallback to local session state if network is temporarily unreachable
      return UserProfileModel(
        phoneNumber: phone,
        token: token,
        isLoggedIn: true,
        preferences: const UserPreferencesModel(hasSavedPreferences: false),
      );
    }
  }

  @override
  Future<void> updatePreferences(UserPreferencesModel preferences) async {
    final uri = Uri.parse('${ApiClient.userServiceUrl}/api/v1/user/preferences');
    await _client.put(uri, body: preferences.toJson());
  }

  @override
  Future<void> logout() async {
    try {
      final uri = Uri.parse('${ApiClient.userServiceUrl}/api/v1/auth/logout');
      await _client.post(uri);
    } catch (_) {}
    await _prefsService.clearAuthSession();
  }

  void dispose() {
    _otpAutoReadController.close();
  }
}
