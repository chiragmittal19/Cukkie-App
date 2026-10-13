class DishSummaryModel {
  const DishSummaryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.tasteProfiles,
    required this.prepTimeMinutes,
    required this.caloriesKcal,
    required this.proteinGrams,
    required this.isFavourite,
    required this.cuisine,
    required this.dietaryType,
    this.rating = 4.8,
  });

  final String id;
  final String name;
  final String imageUrl;
  final List<String> tasteProfiles; // e.g. ["Sweet", "Sour", "Savory", "Spicy"]
  final int prepTimeMinutes;
  final int caloriesKcal;
  final int proteinGrams;
  final bool isFavourite;
  final String cuisine; // e.g. "North Indian", "Maharashtrian", "Italian"
  final String dietaryType; // e.g. "Vegetarian", "Vegan", "Jain"
  final double rating;

  DishSummaryModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    List<String>? tasteProfiles,
    int? prepTimeMinutes,
    int? caloriesKcal,
    int? proteinGrams,
    bool? isFavourite,
    String? cuisine,
    String? dietaryType,
    double? rating,
  }) {
    return DishSummaryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      tasteProfiles: tasteProfiles ?? this.tasteProfiles,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      caloriesKcal: caloriesKcal ?? this.caloriesKcal,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      isFavourite: isFavourite ?? this.isFavourite,
      cuisine: cuisine ?? this.cuisine,
      dietaryType: dietaryType ?? this.dietaryType,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'tasteProfiles': tasteProfiles,
    'prepTimeMinutes': prepTimeMinutes,
    'caloriesKcal': caloriesKcal,
    'proteinGrams': proteinGrams,
    'isFavourite': isFavourite,
    'cuisine': cuisine,
    'dietaryType': dietaryType,
    'rating': rating,
  };

  factory DishSummaryModel.fromJson(Map<String, dynamic> json) =>
      DishSummaryModel(
        id: json['id'] as String,
        name: json['name'] as String,
        imageUrl: json['imageUrl'] as String,
        tasteProfiles: (json['tasteProfiles'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        prepTimeMinutes: json['prepTimeMinutes'] as int? ?? 20,
        caloriesKcal: json['caloriesKcal'] as int? ?? 250,
        proteinGrams: json['proteinGrams'] as int? ?? 8,
        isFavourite: json['isFavourite'] as bool? ?? false,
        cuisine: json['cuisine'] as String? ?? 'General',
        dietaryType: json['dietaryType'] as String? ?? 'Vegetarian',
        rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      );
}
