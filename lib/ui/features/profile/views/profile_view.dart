import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/sensory_service.dart';
import '../../auth/view_models/auth_view_model.dart';
import '../../home/view_models/home_view_model.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final user = authVm.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Phone Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.saffronPrimary,
                      child: Icon(Icons.person_rounded, size: 36, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Logged in as',
                            style: TextStyle(fontSize: 12, color: AppColors.saffronPrimary, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.phoneNumber.isNotEmpty ? user.phoneNumber : 'Authenticated Chef',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Option 1: Food Preferences
              InkWell(
                onTap: () {
                  SensoryService.instance.lightTap();
                  context.push('/preferences');
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.saffronPrimary.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.restaurant_menu_rounded, color: AppColors.saffronPrimary, size: 22),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Food Preferences',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Cuisines, dietary choices & spice levels',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.saffronPrimary),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Option 2: Logout
              InkWell(
                onTap: () => _confirmLogout(context, authVm),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.chiliRed.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.logout_rounded, color: AppColors.chiliRed, size: 22),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Log Out',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.chiliRed),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Sign out from this device',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.chiliRed),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthViewModel authVm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out from Cukkie?'),
        content: const Text(
          'You can log back in with your phone number at any time to access your saved food preferences and favourites.',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              SensoryService.instance.mediumImpact();
              await authVm.logout();

              // Refresh home page per rule
              if (context.mounted) {
                final homeVm = context.read<HomeViewModel>();
                await homeVm.loadHomePageData();
                await homeVm.loadDrawerConfig();
                if (context.mounted) {
                  context.go('/home');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.chiliRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
