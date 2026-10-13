import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/sensory_service.dart';
import '../view_models/settings_view_model.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsVm = context.watch<SettingsViewModel>();
    final strings = settingsVm.strings;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final currentLang = settingsVm.locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(key: ValueKey('settings_back_button')),
        title: Text(strings.settings),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // Language Selection Section (Stored locally only)
            Text(
              strings.selectLanguage,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              strings.langStoredLocally,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 12),
            _buildLanguageCard(
              context,
              code: 'en',
              title: strings.english,
              subtitle: 'English',
              isSelected: currentLang == 'en',
              onTap: () => settingsVm.setLanguage('en'),
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            _buildLanguageCard(
              context,
              code: 'hi',
              title: strings.hindi,
              subtitle: 'हिन्दी',
              isSelected: currentLang == 'hi',
              onTap: () => settingsVm.setLanguage('hi'),
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            _buildLanguageCard(
              context,
              code: 'ar',
              title: strings.arabic,
              subtitle: 'العربية (RTL)',
              isSelected: currentLang == 'ar',
              onTap: () => settingsVm.setLanguage('ar'),
              isDark: isDark,
            ),

            const SizedBox(height: 28),

            // Theme Mode Section
            Text(
              strings.theme,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildThemeCard(
                    context,
                    keyName: 'light',
                    title: strings.lightMode,
                    icon: Icons.light_mode_rounded,
                    isSelected: settingsVm.themeMode == ThemeMode.light,
                    onTap: () => settingsVm.setThemeMode(ThemeMode.light),
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildThemeCard(
                    context,
                    keyName: 'dark',
                    title: strings.darkMode,
                    icon: Icons.dark_mode_rounded,
                    isSelected: settingsVm.themeMode == ThemeMode.dark,
                    onTap: () => settingsVm.setThemeMode(ThemeMode.dark),
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildThemeCard(
                    context,
                    keyName: 'system',
                    title: strings.systemMode,
                    icon: Icons.brightness_auto_rounded,
                    isSelected: settingsVm.themeMode == ThemeMode.system,
                    onTap: () => settingsVm.setThemeMode(ThemeMode.system),
                    isDark: isDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Sound & Haptics Section
            Text(
              strings.soundEffects,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              margin: EdgeInsets.zero,
              elevation: 0,
              color: isDark ? AppColors.surfaceDark : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  SwitchListTile(
                    key: const ValueKey('settings_haptic_switch'),
                    title: Text(strings.tactileHaptic),
                    subtitle: Text(strings.tactileHapticSubtitle, style: const TextStyle(fontSize: 11)),
                    value: settingsVm.hapticsEnabled,
                    activeThumbColor: AppColors.saffronPrimary,
                    onChanged: (val) {
                      SensoryService.instance.lightTap();
                      settingsVm.toggleHaptics(val);
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    key: const ValueKey('settings_sound_switch'),
                    title: Text(strings.soundAudio),
                    subtitle: Text(strings.soundAudioSubtitle, style: const TextStyle(fontSize: 11)),
                    value: settingsVm.soundEnabled,
                    activeThumbColor: AppColors.saffronPrimary,
                    onChanged: (val) {
                      SensoryService.instance.lightTap();
                      settingsVm.toggleSound(val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard(
    BuildContext context, {
    required String keyName,
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      key: ValueKey('theme_card_$keyName'),
      onTap: () {
        SensoryService.instance.selectionClick();
        onTap();
      },
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.saffronPrimary.withAlpha(isDark ? 35 : 20)
              : isDark
                  ? AppColors.surfaceDark
                  : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.saffronPrimary
                : isDark
                    ? AppColors.borderDark
                    : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? AppColors.saffronPrimary
                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.saffronPrimary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard(
    BuildContext context, {
    required String code,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      key: ValueKey('language_card_$code'),
      onTap: () {
        SensoryService.instance.selectionClick();
        onTap();
      },
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.saffronPrimary.withAlpha(isDark ? 30 : 20)
              : isDark
                  ? AppColors.surfaceDark
                  : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.saffronPrimary
                : isDark
                    ? AppColors.borderDark
                    : AppColors.borderLight,
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppColors.saffronPrimary : null,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.saffronPrimary, size: 20),
          ],
        ),
      ),
    );
  }
}
