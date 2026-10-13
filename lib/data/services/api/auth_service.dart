import '../../models/user_profile_model.dart';

abstract class AuthService {
  Future<bool> sendOtp(String phoneNumber);
  Future<UserProfileModel> verifyOtp(String phoneNumber, String otp);
  Future<UserProfileModel> getUserProfile();
  Future<void> updatePreferences(UserPreferencesModel preferences);
  Future<void> logout();
  Stream<String>? get otpAutoReadStream => null;
}
