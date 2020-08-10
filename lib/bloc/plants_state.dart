import 'dart:collection';

final serverPlantList = UnmodifiableListView<Plant>([
  Plant('plant 1'),
  Plant('plant 2'),
  Plant('plant 3'),
  Plant('plant 4'),
  Plant('plant 5'),
  Plant('plant 6'),
]);

class PlantsState {
  final List<Plant> plants;
  final bool isLoading;

  const PlantsState._(this.plants, this.isLoading);

  static PlantsState loading() => PlantsState._(List.empty(), true);
  static PlantsState loaded(List<Plant> plants) => PlantsState._(plants, false);
  static PlantsState empty() => PlantsState._(List.empty(), false);

  bool isEmpty() => plants.isEmpty;
}

class Plant {
  final String name;
  const Plant(this.name);
}
