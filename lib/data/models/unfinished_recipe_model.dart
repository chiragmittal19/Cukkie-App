import 'dart:convert';

class UnfinishedRecipeModel {
  const UnfinishedRecipeModel({
    required this.dishId,
    required this.dishName,
    required this.dishImage,
    required this.stepIndex,
    required this.stepHeading,
    required this.portionAmount,
    this.completedTodoIds = const [],
    required this.lastInteractedAt,
  });

  final String dishId;
  final String dishName;
  final String dishImage;
  final int stepIndex; // Exact rendered step index
  final String stepHeading; // Exact rendered step heading
  final double portionAmount;
  final List<String> completedTodoIds;
  final DateTime lastInteractedAt;

  Map<String, dynamic> toSqlMap() => {
    'dish_id': dishId,
    'dish_name': dishName,
    'dish_image': dishImage,
    'step_index': stepIndex,
    'step_heading': stepHeading,
    'portion_amount': portionAmount,
    'completed_todos_json': jsonEncode(completedTodoIds),
    'last_interacted_at': lastInteractedAt.millisecondsSinceEpoch,
  };

  factory UnfinishedRecipeModel.fromSqlMap(Map<String, dynamic> map) {
    List<String> todos = [];
    final jsonStr = map['completed_todos_json'] as String?;
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        final decoded = jsonDecode(jsonStr);
        if (decoded is List) {
          todos = decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {}
    }

    return UnfinishedRecipeModel(
      dishId: map['dish_id'] as String,
      dishName: map['dish_name'] as String,
      dishImage: map['dish_image'] as String? ?? '',
      stepIndex: map['step_index'] as int? ?? 0,
      stepHeading: map['step_heading'] as String? ?? 'Overview',
      portionAmount: (map['portion_amount'] as num?)?.toDouble() ?? 2.0,
      completedTodoIds: todos,
      lastInteractedAt: DateTime.fromMillisecondsSinceEpoch(
        map['last_interacted_at'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
