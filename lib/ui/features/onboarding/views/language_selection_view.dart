import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/sensory_service.dart';
import '../../settings/view_models/settings_view_model.dart';

class LanguageSelectionView extends StatelessWidget {
  const LanguageSelectionView({super.key, this.isInitialOnboarding = false});

  final bool isInitialOnboarding;

  @override
  Widget build(BuildContext context) {
    final settingsVm = context.watch<SettingsViewModel>();
    final strings = settingsVm.strings;
    final currentCode = settingsVm.locale.languageCode;

    final languages = [
      {'code': 'en', 'name': 'English', 'native': 'English', 'flag': '🇬🇧'},
      {'code': 'hi', 'name': 'Hindi', 'native': 'हिन्दी', 'flag': '🇮🇳'},
      {'code': 'ar', 'name': 'Arabic (RTL)', 'native': 'العربية', 'flag': '🇦🇪'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.selectLanguage),
        actions: isInitialOnboarding
            ? [
                TextButton(
                  onPressed: () => _onProceed(context),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.welcomeTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                strings.welcomeSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.separated(
                  itemCount: languages.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = languages[index];
                    final isSelected = currentCode == item['code'];

                    return InkWell(
                      onTap: () async {
                        await SensoryService.instance.selectionClick();
                        await settingsVm.setLanguage(item['code']!);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.saffronPrimary.withAlpha(20)
                              : Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.saffronPrimary
                                : Theme.of(context).dividerColor.withAlpha(40),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              item['flag']!,
                              style: const TextStyle(fontSize: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['native']!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected
                                          ? AppColors.saffronPrimary
                                          : null,
                                    ),
                                  ),
                                  Text(
                                    item['name']!,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.saffronPrimary,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (isInitialOnboarding)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => _onProceed(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.saffronPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      strings.continueButton,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _onProceed(BuildContext context) {
    SensoryService.instance.lightTap();
    if (isInitialOnboarding) {
      context.push('/login?isInitialOnboarding=true');
    } else {
      context.pop();
    }
  }
}
