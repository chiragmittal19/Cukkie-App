import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/sensory_service.dart';
import '../../../../data/models/preferences_config_model.dart';
import '../../../../data/services/local/secure_prefs_service.dart';
import '../../settings/view_models/settings_view_model.dart';
import '../view_models/preferences_view_model.dart';
import '../../home/view_models/home_view_model.dart';

class PreferencesView extends StatefulWidget {
  const PreferencesView({super.key, this.isInitialOnboarding = false});

  final bool isInitialOnboarding;

  @override
  State<PreferencesView> createState() => _PreferencesViewState();
}

class _PreferencesViewState extends State<PreferencesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lang = context.read<SettingsViewModel>().locale.languageCode;
      context.read<PreferencesViewModel>().loadBackendConfig(lang);
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefsVm = context.watch<PreferencesViewModel>();
    final strings = context.watch<SettingsViewModel>().strings;
    final config = prefsVm.config;

    return Scaffold(
      appBar: AppBar(
        title: Text(config?.title ?? strings.preferencesTitle),
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
        child: prefsVm.isLoadingConfig && config == null
            ? const Center(child: CircularProgressIndicator(color: AppColors.saffronPrimary))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config?.title ?? strings.preferencesTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      config?.subtitle ?? strings.preferencesSubtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 28),

                    // Dynamic Preference Groups from Backend
                    if (config != null)
                      ...config.groups.map((group) => _buildGroup(context, prefsVm, group)),

                    const SizedBox(height: 36),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: prefsVm.isSaving ? null : () => _handleSave(context, prefsVm),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.saffronPrimary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: prefsVm.isSaving
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Text(
                                config?.saveButtonText ?? strings.savePreferences,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildGroup(BuildContext context, PreferencesViewModel prefsVm, PreferenceGroupConfig group) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.restaurant_menu_rounded, size: 20, color: AppColors.saffronPrimary),
              const SizedBox(width: 8),
              Text(
                group.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: group.options.map((option) {
              if (group.isMultiSelect) {
                final isSelected = group.id == 'cuisines'
                    ? prefsVm.selectedCuisines.contains(option.id)
                    : prefsVm.selectedDietaryChoices.contains(option.id);

                return FilterChip(
                  label: Text(option.label),
                  selected: isSelected,
                  onSelected: (_) {
                    SensoryService.instance.lightTap();
                    if (group.id == 'cuisines') {
                      prefsVm.toggleCuisine(option.id);
                    } else {
                      prefsVm.toggleDietaryChoice(option.id);
                    }
                  },
                  selectedColor: AppColors.saffronPrimary.withAlpha(35),
                  checkmarkColor: AppColors.saffronPrimary,
                  labelStyle: TextStyle(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppColors.saffronPrimary : null,
                  ),
                );
              } else {
                final isSelected = group.id == 'spice'
                    ? prefsVm.selectedSpiceLevel == option.id
                    : prefsVm.selectedSweetnessLevel == option.id;

                return ChoiceChip(
                  label: Text(option.label),
                  selected: isSelected,
                  onSelected: (_) {
                    SensoryService.instance.lightTap();
                    if (group.id == 'spice') {
                      prefsVm.setSpiceLevel(option.id);
                    } else {
                      prefsVm.setSweetnessLevel(option.id);
                    }
                  },
                  selectedColor: AppColors.chiliRed.withAlpha(35),
                  labelStyle: TextStyle(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppColors.chiliRed : null,
                  ),
                );
              }
            }).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave(BuildContext context, PreferencesViewModel prefsVm) async {
    SensoryService.instance.mediumImpact();
    final ok = await prefsVm.savePreferences();
    if (context.mounted && ok) {
      context.read<HomeViewModel>().loadHomePageData();

      if (widget.isInitialOnboarding) {
        await SecurePrefsService.instance.setFirstLaunchDone();
        if (context.mounted) {
          context.go('/home');
        }
      } else {
        context.pop();
      }
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
