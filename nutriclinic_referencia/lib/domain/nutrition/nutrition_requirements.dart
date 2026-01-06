import 'package:equatable/equatable.dart';

class NutritionRequirements extends Equatable {
  const NutritionRequirements({
    required this.method,
    required this.caloriesPerDay,
    required this.proteinGrams,
    required this.notes,
  });

  final String method;
  final double caloriesPerDay;
  final double proteinGrams;
  final String? notes;

  @override
  List<Object?> get props => [method, caloriesPerDay, proteinGrams, notes];
}
