import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/sensory_service.dart';
import '../../../../../core/widgets/remote_icon.dart';
import '../../../../../data/models/drawer_payload_model.dart';
import '../../../auth/view_models/auth_view_model.dart';
import '../../../settings/view_models/settings_view_model.dart';
import '../../view_models/home_view_model.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final homeVm = context.watch<HomeViewModel>();
    final authVm = context.watch<AuthViewModel>();
    final strings = context.watch<SettingsViewModel>().strings;
    final drawerConfig = homeVm.drawerPayload;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isLoggedIn = authVm.isLoggedIn;
    final phoneNumber = authVm.user.phoneNumber.isNotEmpty
        ? authVm.user.phoneNumber
        : drawerConfig?.phoneNumber ?? 'Guest Gourmet';

    return Drawer(
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            _buildDrawerHeader(context, isLoggedIn, phoneNumber, drawerConfig?.avatarUrl, isDark, strings),
            const Divider(height: 1),

            // Dynamic Drawer Items from backend config
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: (drawerConfig?.items ?? _defaultItems(isLoggedIn, strings)).map((item) {
                  return _buildDrawerItem(context, item, authVm, homeVm, strings);
                }).toList(),
              ),
            ),

            // Version info footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.soup_kitchen_rounded, size: 18, color: AppColors.saffronPrimary),
                  const SizedBox(width: 8),
                  Text(
                    'Cukkie v1.0 • Taste the Art',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(
    BuildContext context,
    bool isLoggedIn,
    String phoneNumber,
    String? avatarUrl,
    bool isDark,
    dynamic strings,
  ) {
    return InkWell(
      onTap: () {
        SensoryService.instance.lightTap();
        Navigator.of(context).pop();
        if (isLoggedIn) {
          context.push('/profile');
        } else {
          context.push('/login');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        color: AppColors.saffronPrimary.withAlpha(isDark ? 25 : 15),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.saffronPrimary,
              backgroundImage: avatarUrl != null ? CachedNetworkImageProvider(avatarUrl) : null,
              child: avatarUrl == null
                  ? Icon(
                      isLoggedIn ? Icons.person_rounded : Icons.person_outline_rounded,
                      color: Colors.white,
                      size: 28,
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isLoggedIn ? phoneNumber : strings.welcomeToCukkie,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isLoggedIn ? strings.viewProfileAndPreferences : strings.loginToSyncFavourites,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.saffronLight : AppColors.saffronPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.saffronPrimary),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    DrawerItemModel item,
    AuthViewModel authVm,
    HomeViewModel homeVm,
    dynamic strings,
  ) {
    return ListTile(
      key: ValueKey('drawer_item_${item.id}'),
      leading: item.iconUrl != null
          ? RemoteIcon(
              url: item.iconUrl,
              size: 22,
              fallbackIcon: _fallbackIconForId(item.id),
              color: item.id == 'logout' ? AppColors.chiliRed : AppColors.saffronPrimary,
            )
          : Icon(
              _fallbackIconForId(item.id),
              color: item.id == 'logout' ? AppColors.chiliRed : AppColors.saffronPrimary,
            ),
      title: Text(
        item.title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: item.id == 'logout' ? AppColors.chiliRed : null,
        ),
      ),
      subtitle: item.subtitle != null
          ? Text(
              item.subtitle!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11),
            )
          : null,
      onTap: () async {
        await SensoryService.instance.lightTap();
        if (!context.mounted) return;
        Navigator.of(context).pop();

        if (item.id == 'logout') {
          _confirmLogout(context, authVm, homeVm, strings);
        } else if (item.route != null) {
          context.push(item.route!);
        }
      },
    );
  }

  IconData _fallbackIconForId(String id) {
    switch (id) {
      case 'profile':
        return Icons.person_rounded;
      case 'preferences':
        return Icons.restaurant_menu_rounded;
      case 'favourites':
        return Icons.favorite_rounded;
      case 'settings':
        return Icons.settings_rounded;
      case 'logout':
        return Icons.logout_rounded;
      case 'login':
      default:
        return Icons.login_rounded;
    }
  }

  void _confirmLogout(
    BuildContext context,
    AuthViewModel authVm,
    HomeViewModel homeVm,
    dynamic strings,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(strings.logoutConfirmTitle),
        content: Text(strings.logoutConfirmMessage),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(strings.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              SensoryService.instance.mediumImpact();
              await authVm.logout();
              // After logout, home page is refreshed:
              await homeVm.loadHomePageData();
              await homeVm.loadDrawerConfig();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.chiliRed,
              foregroundColor: Colors.white,
            ),
            child: Text(strings.logout),
          ),
        ],
      ),
    );
  }

  List<DrawerItemModel> _defaultItems(bool isLoggedIn, dynamic strings) {
    if (isLoggedIn) {
      return [
        DrawerItemModel(id: 'profile', title: strings.profile, route: '/profile'),
        DrawerItemModel(id: 'preferences', title: strings.preferencesTitle, route: '/preferences'),
        DrawerItemModel(id: 'favourites', title: strings.favourites, route: '/favourites'),
        DrawerItemModel(id: 'settings', title: strings.settings, route: '/settings'),
        DrawerItemModel(id: 'logout', title: strings.logout),
      ];
    } else {
      return [
        DrawerItemModel(id: 'login', title: strings.login, route: '/login'),
        DrawerItemModel(id: 'settings', title: strings.settings, route: '/settings'),
      ];
    }
  }
}
