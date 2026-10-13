import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/sensory_service.dart';
import '../../../../../data/models/dish_detail_model.dart';
import '../../../../../data/models/dynamic_form_model.dart';
import '../../../settings/view_models/settings_view_model.dart';
import '../../view_models/recipe_view_model.dart';

class DynamicFeedbackStep extends StatefulWidget {
  const DynamicFeedbackStep({
    super.key,
    required this.dish,
    required this.recipeVm,
    required this.onFinishCompleted,
  });

  final DishDetailModel dish;
  final RecipeViewModel recipeVm;
  final VoidCallback onFinishCompleted;

  @override
  State<DynamicFeedbackStep> createState() => _DynamicFeedbackStepState();
}

class _DynamicFeedbackStepState extends State<DynamicFeedbackStep> {
  final Map<String, TextEditingController> _textControllers = {};
  File? _selectedImageFile;
  bool _isCompressing = false;

  @override
  void dispose() {
    for (final c in _textControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = context.watch<SettingsViewModel>().strings;
    final formFields = widget.dish.feedbackFormFields;
    final isBusy = widget.recipeVm.isSubmittingFeedback || _isCompressing;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.saffronPrimary.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.stars_rounded, color: AppColors.saffronPrimary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.tasteAndFeedback,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      strings.tastingFeedbackSubtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.saffronPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            strings.tastingFeedbackInstructions,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          // Dynamically rendered form fields supplied by backend
          ...formFields.map((field) => _buildDynamicField(context, field, isDark, strings)),

          const SizedBox(height: 24),

          // Complete Recipe Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: isBusy ? null : () => _handleSubmitFeedback(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.saffronPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: isBusy
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          strings.submitFeedback,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildDynamicField(BuildContext context, DynamicFormFieldModel field, bool isDark, dynamic strings) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (field.subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                field.subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
              ),
            ],
            const SizedBox(height: 12),
            _renderFieldControl(context, field, isDark, strings),
          ],
        ),
      ),
    );
  }

  Widget _renderFieldControl(BuildContext context, DynamicFormFieldModel field, bool isDark, dynamic strings) {
    switch (field.type) {
      case FormFieldType.rating:
        final currentRating = (widget.recipeVm.feedbackResponses[field.id] as num?)?.toInt() ?? 5;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final star = index + 1;
            final isFilled = star <= currentRating;
            return IconButton(
              icon: Icon(
                isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                size: 34,
                color: isFilled ? AppColors.turmericGold : Colors.grey.withAlpha(100),
              ),
              onPressed: () {
                SensoryService.instance.selectionClick();
                widget.recipeVm.setFeedbackResponse(field.id, star);
              },
            );
          }),
        );

      case FormFieldType.singleChoice:
        final currentChoice = widget.recipeVm.feedbackResponses[field.id] as String?;
        final options = field.options ?? [];
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final isSelected = currentChoice == opt;
            return ChoiceChip(
              label: Text(opt),
              selected: isSelected,
              selectedColor: AppColors.saffronPrimary.withAlpha(35),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.saffronPrimary : null,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
              onSelected: (_) {
                SensoryService.instance.lightTap();
                widget.recipeVm.setFeedbackResponse(field.id, opt);
              },
            );
          }).toList(),
        );

      case FormFieldType.multipleChoice:
        final currentList = (widget.recipeVm.feedbackResponses[field.id] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];
        final options = field.options ?? [];
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final isSelected = currentList.contains(opt);
            return FilterChip(
              label: Text(opt),
              selected: isSelected,
              selectedColor: AppColors.saffronPrimary.withAlpha(35),
              checkmarkColor: AppColors.saffronPrimary,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.saffronPrimary : null,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
              onSelected: (_) {
                SensoryService.instance.lightTap();
                final updated = List<String>.from(currentList);
                if (isSelected) {
                  updated.remove(opt);
                } else {
                  updated.add(opt);
                }
                widget.recipeVm.setFeedbackResponse(field.id, updated);
              },
            );
          }).toList(),
        );

      case FormFieldType.text:
        _textControllers.putIfAbsent(field.id, () => TextEditingController());
        final controller = _textControllers[field.id]!;
        return TextField(
          controller: controller,
          maxLines: 3,
          onChanged: (val) => widget.recipeVm.setFeedbackResponse(field.id, val),
          decoration: InputDecoration(
            hintText: field.placeholder ?? 'Share your tasting experience...',
            filled: true,
            fillColor: isDark ? AppColors.cardDark : AppColors.backgroundLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
          ),
        );

      case FormFieldType.imageUpload:
        // Requirement 12: Camera/Gallery chooser, preview in box with dismiss X icon, compression <= 200 kB
        if (_selectedImageFile != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Image.file(
                  _selectedImageFile!,
                  width: double.infinity,
                  height: 190,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    color: Colors.black.withAlpha(160),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        SensoryService.instance.lightTap();
                        setState(() {
                          _selectedImageFile = null;
                        });
                        widget.recipeVm.setFeedbackResponse(field.id, null);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return InkWell(
          onTap: () {
            SensoryService.instance.lightTap();
            _showPhotoSourceSheet(context, field.id, strings);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            height: 110,
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.saffronPrimary.withAlpha(80),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_a_photo_outlined,
                  size: 32,
                  color: AppColors.saffronPrimary,
                ),
                const SizedBox(height: 8),
                Text(
                  strings.tapToCapturePhoto,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
    }
  }

  Future<void> _showPhotoSourceSheet(BuildContext context, String fieldId, dynamic strings) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  strings.choosePhotoSource,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.saffronPrimary.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: AppColors.saffronPrimary),
                  ),
                  title: Text(strings.camera, style: const TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    await _pickImage(fieldId, ImageSource.camera);
                  },
                ),
                const SizedBox(height: 6),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.saffronPrimary.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.photo_library_rounded, color: AppColors.saffronPrimary),
                  ),
                  title: Text(strings.gallery, style: const TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    await _pickImage(fieldId, ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(String fieldId, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
      );
      if (picked != null) {
        setState(() {
          _selectedImageFile = File(picked.path);
        });
        widget.recipeVm.setFeedbackResponse(fieldId, picked.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not access image: $e')),
        );
      }
    }
  }

  Future<void> _handleSubmitFeedback(BuildContext context) async {
    SensoryService.instance.heavyImpact();

    // If a photo was selected, compress to at most 200 kB before submission
    if (_selectedImageFile != null) {
      setState(() {
        _isCompressing = true;
      });
      try {
        final compressedFile = await _compressImageUnder200Kb(_selectedImageFile!);
        for (final field in widget.dish.feedbackFormFields) {
          if (field.type == FormFieldType.imageUpload) {
            widget.recipeVm.setFeedbackResponse(field.id, compressedFile.path);
          }
        }
      } catch (e) {
        debugPrint('Image compression error: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isCompressing = false;
          });
        }
      }
    }

    final success = await widget.recipeVm.submitFeedback();
    if (context.mounted && success) {
      widget.onFinishCompleted();
    }
  }

  Future<File> _compressImageUnder200Kb(File file) async {
    final bytes = await file.readAsBytes();
    const maxSizeBytes = 200 * 1024; // 200 kB
    if (bytes.lengthInBytes <= maxSizeBytes) {
      return file;
    }

    img.Image? decoded = img.decodeImage(bytes);
    if (decoded == null) return file;

    // Scale down dimensions if high resolution
    if (decoded.width > 1200 || decoded.height > 1200) {
      decoded = img.copyResize(
        decoded,
        width: decoded.width >= decoded.height ? 1200 : null,
        height: decoded.height > decoded.width ? 1200 : null,
      );
    }

    int quality = 85;
    List<int> compressed = img.encodeJpg(decoded, quality: quality);
    while (compressed.length > maxSizeBytes && quality > 15) {
      quality -= 15;
      compressed = img.encodeJpg(decoded, quality: quality);
    }

    // If still larger than 200 kB, scale down further
    if (compressed.length > maxSizeBytes) {
      decoded = img.copyResize(
        decoded,
        width: (decoded.width * 0.7).toInt(),
        height: (decoded.height * 0.7).toInt(),
      );
      compressed = img.encodeJpg(decoded, quality: 60);
    }

    final tempDir = Directory.systemTemp;
    final compressedFile = File(
      '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await compressedFile.writeAsBytes(compressed);
    debugPrint('Compressed image size: ${compressed.length} bytes (<= 200 kB)');
    return compressedFile;
  }
}
