import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/sensory_service.dart';
import '../../../../../core/widgets/remote_icon.dart';
import '../../../settings/view_models/settings_view_model.dart';
import '../../view_models/home_view_model.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key, required this.homeVm});

  final HomeViewModel homeVm;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, List<String>> _tempFilters;
  late String? _tempSortId;

  @override
  void initState() {
    super.initState();
    // Copy existing active filters & sorter into local state
    _tempFilters = {
      for (final entry in widget.homeVm.selectedFilters.entries)
        entry.key: List<String>.from(entry.value),
    };
    _tempSortId = widget.homeVm.activeSortId;
  }

  void _resetLocalFilters() {
    setState(() {
      _tempFilters.clear();
      _tempSortId = 'rating_desc';
    });
  }

  void _applyToDishList(BuildContext context) {
    widget.homeVm.applyFiltersAndSort(
      filters: _tempFilters,
      sortId: _tempSortId,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final payload = widget.homeVm.homePayload;
    if (payload == null) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = context.watch<SettingsViewModel>().strings;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title & Reset
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  strings.filtersAndSorting,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
                ),
                TextButton(
                  onPressed: () {
                    SensoryService.instance.lightTap();
                    _resetLocalFilters();
                  },
                  child: Text(
                    strings.resetAll,
                    style: const TextStyle(
                      color: AppColors.saffronPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                children: [
                  // Sorters Section
                  Text(
                    strings.sortBy,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: payload.sorters.map((sort) {
                      final isSelected = _tempSortId == sort.id;
                      return ChoiceChip(
                        avatar: sort.iconUrl != null
                            ? RemoteIcon(url: sort.iconUrl, size: 16)
                            : null,
                        label: Text(sort.label),
                        selected: isSelected,
                        selectedColor: AppColors.saffronPrimary.withAlpha(35),
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.saffronPrimary : null,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        onSelected: (_) {
                          SensoryService.instance.selectionClick();
                          setState(() {
                            _tempSortId = sort.id;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Dynamic Filter Groups from Backend
                  ...payload.filterGroups.map((group) {
                    final selectedOptions = _tempFilters[group.id] ?? [];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: group.options.map((option) {
                            final isSelected = selectedOptions.contains(option.id);
                            return FilterChip(
                              avatar: option.iconUrl != null
                                  ? RemoteIcon(url: option.iconUrl, size: 16)
                                  : null,
                              label: Text(option.label),
                              selected: isSelected,
                              selectedColor: AppColors.saffronPrimary.withAlpha(35),
                              checkmarkColor: AppColors.saffronPrimary,
                              labelStyle: TextStyle(
                                color: isSelected ? AppColors.saffronPrimary : null,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              ),
                              onSelected: (_) {
                                SensoryService.instance.lightTap();
                                setState(() {
                                  final currentList = _tempFilters[group.id] ?? [];
                                  if (currentList.contains(option.id)) {
                                    final updated = List<String>.from(currentList)..remove(option.id);
                                    if (updated.isEmpty) {
                                      _tempFilters.remove(group.id);
                                    } else {
                                      _tempFilters[group.id] = updated;
                                    }
                                  } else {
                                    _tempFilters[group.id] = [...currentList, option.id];
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }),
                ],
              ),
            ),

            // Apply Button - Responsible for applying changes to the dish list
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  SensoryService.instance.lightTap();
                  _applyToDishList(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.saffronPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  strings.applyFilters,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
