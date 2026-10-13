enum FormFieldType {
  rating,
  singleChoice,
  multipleChoice,
  text,
  imageUpload,
}

class DynamicFormFieldModel {
  const DynamicFormFieldModel({
    required this.id,
    required this.title,
    required this.type,
    this.subtitle,
    this.isRequired = false,
    this.options,
    this.placeholder,
    this.initialValue,
  });

  final String id;
  final String title;
  final String? subtitle;
  final FormFieldType type;
  final bool isRequired;
  final List<String>? options;
  final String? placeholder;
  final dynamic initialValue;

  factory DynamicFormFieldModel.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'text';
    FormFieldType parsedType;
    switch (typeStr) {
      case 'rating':
        parsedType = FormFieldType.rating;
        break;
      case 'single_choice':
        parsedType = FormFieldType.singleChoice;
        break;
      case 'multiple_choice':
        parsedType = FormFieldType.multipleChoice;
        break;
      case 'image_upload':
        parsedType = FormFieldType.imageUpload;
        break;
      case 'text':
      default:
        parsedType = FormFieldType.text;
    }

    return DynamicFormFieldModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      type: parsedType,
      isRequired: json['isRequired'] as bool? ?? false,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      placeholder: json['placeholder'] as String?,
      initialValue: json['initialValue'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'type': type.name,
    'isRequired': isRequired,
    'options': options,
    'placeholder': placeholder,
    'initialValue': initialValue,
  };
}
