class UserPreferencesModel {
  const UserPreferencesModel({
    this.cuisines = const [],
    this.dietaryChoices = const [],
    this.spiceLevel = 'Medium',
    this.sweetnessLevel = 'Balanced',
    this.hasSavedPreferences = false,
  });

  final List<String> cuisines; // e.g. ["North Indian", "Maharashtrian", "Italian"]
  final List<String> dietaryChoices; // e.g. ["Vegetarian", "Vegan", "Jain"]
  final String spiceLevel; // e.g. "Mild", "Medium", "Spicy", "Extra Hot"
  final String sweetnessLevel; // e.g. "Low", "Balanced", "Sweet"
  final bool hasSavedPreferences;

  UserPreferencesModel copyWith({
    List<String>? cuisines,
    List<String>? dietaryChoices,
    String? spiceLevel,
    String? sweetnessLevel,
    bool? hasSavedPreferences,
  }) {
    return UserPreferencesModel(
      cuisines: cuisines ?? this.cuisines,
      dietaryChoices: dietaryChoices ?? this.dietaryChoices,
      spiceLevel: spiceLevel ?? this.spiceLevel,
      sweetnessLevel: sweetnessLevel ?? this.sweetnessLevel,
      hasSavedPreferences: hasSavedPreferences ?? this.hasSavedPreferences,
    );
  }

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) =>
      UserPreferencesModel(
        cuisines: (json['cuisines'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        dietaryChoices: (json['dietaryChoices'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        spiceLevel: json['spiceLevel'] as String? ?? 'Medium',
        sweetnessLevel: json['sweetnessLevel'] as String? ?? 'Balanced',
        hasSavedPreferences: json['hasSavedPreferences'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
    'cuisines': cuisines,
    'dietaryChoices': dietaryChoices,
    'spiceLevel': spiceLevel,
    'sweetnessLevel': sweetnessLevel,
    'hasSavedPreferences': hasSavedPreferences,
  };
}

class UserProfileModel {
  const UserProfileModel({
    required this.phoneNumber,
    this.token,
    this.isLoggedIn = false,
    this.preferences = const UserPreferencesModel(),
  });

  final String phoneNumber;
  final String? token;
  final bool isLoggedIn;
  final UserPreferencesModel preferences;

  UserProfileModel copyWith({
    String? phoneNumber,
    String? token,
    bool? isLoggedIn,
    UserPreferencesModel? preferences,
  }) {
    return UserProfileModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      token: token ?? this.token,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      preferences: preferences ?? this.preferences,
    );
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        phoneNumber: json['phoneNumber'] as String? ?? '',
        token: json['token'] as String?,
        isLoggedIn: json['isLoggedIn'] as bool? ?? false,
        preferences: json['preferences'] != null
            ? UserPreferencesModel.fromJson(json['preferences'] as Map<String, dynamic>)
            : const UserPreferencesModel(),
      );

  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
    'token': token,
    'isLoggedIn': isLoggedIn,
    'preferences': preferences.toJson(),
  };
}
