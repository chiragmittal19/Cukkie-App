import 'dynamic_form_model.dart';

class PortionDefinition {
  const PortionDefinition({
    required this.unit,
    required this.defaultAmount,
    required this.stepIncrement,
    required this.minAmount,
    required this.maxAmount,
  });

  final String unit; // e.g. "pieces", "grams", "servings"
  final double defaultAmount; // e.g. 4.0 for parathas, 250.0 for halwa, 2.0 for curry
  final double stepIncrement; // e.g. 1.0 or 50.0
  final double minAmount;
  final double maxAmount;

  factory PortionDefinition.fromJson(Map<String, dynamic> json) =>
      PortionDefinition(
        unit: json['unit'] as String? ?? 'servings',
        defaultAmount: (json['defaultAmount'] as num?)?.toDouble() ?? 2.0,
        stepIncrement: (json['stepIncrement'] as num?)?.toDouble() ?? 1.0,
        minAmount: (json['minAmount'] as num?)?.toDouble() ?? 1.0,
        maxAmount: (json['maxAmount'] as num?)?.toDouble() ?? 20.0,
      );

  Map<String, dynamic> toJson() => {
    'unit': unit,
    'defaultAmount': defaultAmount,
    'stepIncrement': stepIncrement,
    'minAmount': minAmount,
    'maxAmount': maxAmount,
  };
}

class IngredientItem {
  const IngredientItem({
    required this.id,
    required this.name,
    required this.baseQuantity,
    required this.unit,
    this.isOptional = false,
    this.imageUrl,
  });

  final String id;
  final String name;
  final double baseQuantity; // Quantity at default portion size
  final String unit; // e.g. "tsp", "cups", "grams", "cloves", "pieces"
  final bool isOptional;
  final String? imageUrl;

  double getScaledQuantity(double currentPortion, double basePortion) {
    if (basePortion <= 0) return baseQuantity;
    return (baseQuantity / basePortion) * currentPortion;
  }

  factory IngredientItem.fromJson(Map<String, dynamic> json) => IngredientItem(
    id: json['id'] as String,
    name: json['name'] as String,
    baseQuantity: (json['baseQuantity'] as num?)?.toDouble() ?? 1.0,
    unit: json['unit'] as String? ?? '',
    isOptional: json['isOptional'] as bool? ?? false,
    imageUrl: json['imageUrl'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'baseQuantity': baseQuantity,
    'unit': unit,
    'isOptional': isOptional,
    'imageUrl': imageUrl,
  };
}

class RecipeStepItem {
  const RecipeStepItem({
    required this.index,
    required this.heading,
    required this.instructionText,
    required this.audioNarrationText,
    this.todos = const [],
    this.imageUrl,
  });

  final int index;
  final String heading; // E.g. "Description", "Portion Size", "Ingredients", "Sauté Spices"
  final String instructionText;
  final String audioNarrationText;
  final List<String> todos; // Checkboxes rendered only if todos.length > 1
  final String? imageUrl;

  bool get hasChecklist => todos.length > 1;

  factory RecipeStepItem.fromJson(Map<String, dynamic> json) => RecipeStepItem(
    index: json['index'] as int? ?? 0,
    heading: json['heading'] as String,
    instructionText: json['instructionText'] as String,
    audioNarrationText: json['audioNarrationText'] as String? ?? json['instructionText'] as String,
    todos: (json['todos'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    imageUrl: json['imageUrl'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'index': index,
    'heading': heading,
    'instructionText': instructionText,
    'audioNarrationText': audioNarrationText,
    'todos': todos,
    'imageUrl': imageUrl,
  };
}

class DishDetailModel {
  const DishDetailModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.shareUrl,
    required this.description,
    required this.history,
    required this.nutritionalBreakdown,
    required this.portionDefinition,
    required this.ingredients,
    required this.steps,
    required this.feedbackFormFields,
    this.isFavourite = false,
  });

  final String id;
  final String name;
  final String imageUrl;
  final String shareUrl; // e.g. "https://cukkie.com/recipe/dish_01"
  final String description;
  final String history;
  final Map<String, dynamic> nutritionalBreakdown;
  final PortionDefinition portionDefinition;
  final List<IngredientItem> ingredients;
  final List<RecipeStepItem> steps;
  final List<DynamicFormFieldModel> feedbackFormFields;
  final bool isFavourite;

  DishDetailModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? shareUrl,
    String? description,
    String? history,
    Map<String, dynamic>? nutritionalBreakdown,
    PortionDefinition? portionDefinition,
    List<IngredientItem>? ingredients,
    List<RecipeStepItem>? steps,
    List<DynamicFormFieldModel>? feedbackFormFields,
    bool? isFavourite,
  }) {
    return DishDetailModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      shareUrl: shareUrl ?? this.shareUrl,
      description: description ?? this.description,
      history: history ?? this.history,
      nutritionalBreakdown: nutritionalBreakdown ?? this.nutritionalBreakdown,
      portionDefinition: portionDefinition ?? this.portionDefinition,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      feedbackFormFields: feedbackFormFields ?? this.feedbackFormFields,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }

  factory DishDetailModel.fromJson(Map<String, dynamic> json) => DishDetailModel(
    id: json['id'] as String,
    name: json['name'] as String,
    imageUrl: json['imageUrl'] as String,
    shareUrl: json['shareUrl'] as String? ?? 'https://cukkie.com/recipe/${json['id']}',
    description: json['description'] as String? ?? '',
    history: json['history'] as String? ?? '',
    nutritionalBreakdown: json['nutritionalBreakdown'] as Map<String, dynamic>? ?? {},
    portionDefinition: PortionDefinition.fromJson(json['portionDefinition'] as Map<String, dynamic>),
    ingredients: (json['ingredients'] as List<dynamic>?)
            ?.map((e) => IngredientItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    steps: (json['steps'] as List<dynamic>?)
            ?.map((e) => RecipeStepItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    feedbackFormFields: (json['feedbackFormFields'] as List<dynamic>?)
            ?.map((e) => DynamicFormFieldModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    isFavourite: json['isFavourite'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'shareUrl': shareUrl,
    'description': description,
    'history': history,
    'nutritionalBreakdown': nutritionalBreakdown,
    'portionDefinition': portionDefinition.toJson(),
    'ingredients': ingredients.map((e) => e.toJson()).toList(),
    'steps': steps.map((e) => e.toJson()).toList(),
    'feedbackFormFields': feedbackFormFields.map((e) => e.toJson()).toList(),
    'isFavourite': isFavourite,
  };
}
