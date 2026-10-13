class PreferenceOptionItem {
  const PreferenceOptionItem({
    required this.id,
    required this.label,
    this.iconUrl,
  });

  final String id;
  final String label;
  final String? iconUrl;

  factory PreferenceOptionItem.fromJson(Map<String, dynamic> json) => PreferenceOptionItem(
    id: json['id'] as String,
    label: json['label'] as String,
    iconUrl: json['iconUrl'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'iconUrl': iconUrl,
  };
}

class PreferenceGroupConfig {
  const PreferenceGroupConfig({
    required this.id,
    required this.title,
    required this.options,
    this.isMultiSelect = true,
  });

  final String id;
  final String title;
  final List<PreferenceOptionItem> options;
  final bool isMultiSelect;

  factory PreferenceGroupConfig.fromJson(Map<String, dynamic> json) => PreferenceGroupConfig(
    id: json['id'] as String,
    title: json['title'] as String,
    isMultiSelect: json['isMultiSelect'] as bool? ?? true,
    options: (json['options'] as List<dynamic>? ?? [])
        .map((e) => PreferenceOptionItem.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

class PreferencesConfigModel {
  const PreferencesConfigModel({
    required this.title,
    required this.subtitle,
    required this.saveButtonText,
    required this.groups,
  });

  final String title;
  final String subtitle;
  final String saveButtonText;
  final List<PreferenceGroupConfig> groups;

  factory PreferencesConfigModel.fromJson(Map<String, dynamic> json) => PreferencesConfigModel(
    title: json['title'] as String? ?? 'Your Food Preferences',
    subtitle: json['subtitle'] as String? ?? 'Personalize recommendations based on what you love to cook and eat.',
    saveButtonText: json['saveButtonText'] as String? ?? 'Save Preferences',
    groups: (json['groups'] as List<dynamic>? ?? [])
        .map((e) => PreferenceGroupConfig.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
