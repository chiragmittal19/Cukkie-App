import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/sensory_service.dart';
import '../../../../data/services/local/secure_prefs_service.dart';
import '../../settings/view_models/settings_view_model.dart';
import '../view_models/auth_view_model.dart';
import '../../home/view_models/home_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    super.key,
    this.isInitialOnboarding = false,
  });

  final bool isInitialOnboarding;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final strings = context.watch<SettingsViewModel>().strings;

    // React to simulated or real auto-read OTP
    if (authVm.autoFilledOtp != null && _otpController.text != authVm.autoFilledOtp) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _otpController.text = authVm.autoFilledOtp!;
        SensoryService.instance.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Auto-read OTP: ${authVm.autoFilledOtp}'),
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.saffronPrimary,
          ),
        );
      });
    }

    final defaultPinTheme = PinTheme(
      width: 58,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.saffronPrimary,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight, width: 1.5),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.loginTitle),
        actions: widget.isInitialOnboarding
            ? [
                TextButton(
                  onPressed: () => _onSkip(context),
                  child: Text(
                    strings.skip,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.saffronPrimary,
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isOtpSent ? strings.enterOtp : strings.loginTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                _isOtpSent
                    ? 'A 4-digit code was sent to ${_phoneController.text}'
                    : strings.loginSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              if (!_isOtpSent) ...[
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: strings.phoneNumberHint,
                    prefixIcon: const Icon(Icons.phone_rounded, color: AppColors.saffronPrimary),
                    filled: true,
                    fillColor: Theme.of(context).cardTheme.color,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.borderLight),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.borderLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.saffronPrimary, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: authVm.isLoading ? null : () => _handleSendOtp(context, authVm),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.saffronPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: authVm.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            strings.sendOtp,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
              ] else ...[
                Center(
                  child: Pinput(
                    controller: _otpController,
                    length: 4,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration?.copyWith(
                        border: Border.all(color: AppColors.saffronPrimary, width: 2),
                      ),
                    ),
                    onCompleted: (pin) => _handleVerifyOtp(context, authVm, pin),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: authVm.isLoading
                        ? null
                        : () => _handleVerifyOtp(context, authVm, _otpController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.saffronPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: authVm.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            strings.verifyAndProceed,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isOtpSent = false;
                        _otpController.clear();
                      });
                    },
                    child: Text(
                      'Change Phone Number',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSendOtp(BuildContext context, AuthViewModel authVm) async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    SensoryService.instance.lightTap();
    final ok = await authVm.sendOtp(phone);
    if (ok) {
      setState(() {
        _isOtpSent = true;
      });
    }
  }

  Future<void> _handleVerifyOtp(BuildContext context, AuthViewModel authVm, String otp) async {
    final phone = _phoneController.text.trim();
    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter 4-digit verification code')),
      );
      return;
    }

    SensoryService.instance.mediumImpact();
    final success = await authVm.verifyOtp(phone, otp);

    if (!context.mounted) return;

    if (success) {
      // Check if user had a pending favorite action
      final pendingAction = authVm.consumePendingAction();
      if (pendingAction != null && pendingAction.type == PendingActionType.toggleFavourite) {
        final homeVm = context.read<HomeViewModel>();
        await homeVm.toggleFavourite(pendingAction.targetId);
      }

      if (!context.mounted) return;

      // Check preferences condition: "We will ask for food preferences only if user logs in and hasn't saved preferences in the past."
      if (!authVm.user.preferences.hasSavedPreferences) {
        context.pushReplacement('/preferences?isInitialOnboarding=${widget.isInitialOnboarding}');
      } else {
        if (widget.isInitialOnboarding) {
          await SecurePrefsService.instance.setFirstLaunchDone();
          if (!context.mounted) return;
          context.go('/home');
        } else {
          context.pop();
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authVm.errorMessage ?? 'Verification failed')),
      );
    }
  }

  Future<void> _onSkip(BuildContext context) async {
    SensoryService.instance.lightTap();
    await SecurePrefsService.instance.setFirstLaunchDone();
    if (context.mounted) {
      context.go('/home');
    }
  }
}
