import 'dart:collection';

final serverPlantList = UnmodifiableListView<Plant>([
  Plant('plant 1', 'Type 1',
      imageUrl:
          'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/coffea-arabica-coffee-plant-in-a-flower-pot-royalty-free-image-909851626-1553277122.jpg?crop=1xw:0.99953xh;center,top&resize=980:*',
      lastTimeWatered: DateTime.now().subtract(Duration(days: 2))),
  Plant('plant 2', 'Type 1', imageUrl: 'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/concept-of-home-gardening-zamioculcas-in-flowerpot-royalty-free-image-1580854121.jpg?crop=0.833xw:0.833xh;0.107xw,0.167xh&resize=980:*'),
  Plant('plant 3', 'Type 1', imageUrl: 'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/small-plant-aglaonema-in-white-pot-on-desk-royalty-free-image-1580854625.jpg?crop=0.384xw:0.868xh;0.438xw,0.132xh&resize=980:*'),
  Plant('plant 4', 'Type 1', imageUrl: 'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/corner-of-a-stylish-living-room-royalty-free-image-638859268-1553272443.jpg?crop=0.947xw:0.949xh;0.0527xw,0.0511xh&resize=980:*'),
  Plant('plant 5', 'Type 1', imageUrl: 'https://hips.hearstapps.com/hbu.h-cdn.co/assets/17/27/1499286008-chinese-money-plant.jpg?crop=1.0xw:1xh;center,top&resize=980:*'),
  Plant('plant 6', 'Type 1', imageUrl: 'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/tender-and-unusual-string-of-pearls-weirdest-royalty-free-image-869615030-1553272264.jpg?crop=1xw:1xh;center,top&resize=980:*'),
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
  final String species;
  final DateTime lastTimeWatered;
  final String imageUrl;
  const Plant(
    this.name,
    this.species, {
    this.lastTimeWatered,
    this.imageUrl,
  });
}
