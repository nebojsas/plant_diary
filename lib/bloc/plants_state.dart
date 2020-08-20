import 'dart:collection';

final serverPlantList = UnmodifiableListView<Plant>([
  Plant('plant 1', PARSLEY,
      lastTimeWatered: DateTime.now().subtract(Duration(days: 5))),
  Plant('plant 2', BASIL,
      lastTimeWatered: DateTime.now().subtract(Duration(days: 1))),
  Plant(
    'plant 3',
    FITTONIA,
  ),
  Plant('plant 4', PHILODENDRON,
      imageUrl:
          'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/corner-of-a-stylish-living-room-royalty-free-image-638859268-1553272443.jpg?crop=0.947xw:0.949xh;0.0527xw,0.0511xh&resize=980:*',
      lastTimeWatered: DateTime.now().subtract(Duration(days: 1))),
  Plant('plant 5', MONKEY_LEAF,
      imageUrl:
          'https://hips.hearstapps.com/hbu.h-cdn.co/assets/17/27/1499286008-chinese-money-plant.jpg?crop=1.0xw:1xh;center,top&resize=980:*',
      lastTimeWatered: DateTime.now().subtract(Duration(days: 4))),
  Plant('plant 6', FITTONIA,
      imageUrl:
          'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/tender-and-unusual-string-of-pearls-weirdest-royalty-free-image-869615030-1553272264.jpg?crop=1xw:1xh;center,top&resize=980:*'),
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
  final PlantSpecies species;
  DateTime lastTimeWatered;
  DateTime lastTimeRePotted;
  DateTime lastTimeFed;
  final String imageUrl;

  Plant(
    this.name,
    this.species, {
    this.lastTimeWatered,
    this.imageUrl,
  });

  bool needsWatering() => lastTimeWatered == null
      ? true
      : DateTime.now().difference(lastTimeWatered) > species.wateringFrequency;

  bool needsRePotting() => lastTimeRePotted == null
      ? true
      : DateTime.now().difference(lastTimeRePotted) >
          species.rePottingFrequency;

  bool needsFeeding() => lastTimeFed == null
      ? true
      : DateTime.now().difference(lastTimeFed) > species.feedingFrequency;

  bool isHappy() => !needsWatering() && !needsFeeding() && !needsRePotting();
}

class PlantSpecies {
  final String name;
  final String defaultImage;
  final Duration wateringFrequency;
  final Duration feedingFrequency;

  final Duration rePottingFrequency;

  const PlantSpecies(this.name, this.defaultImage, this.wateringFrequency,
      this.feedingFrequency, this.rePottingFrequency);
}

const PARSLEY = PlantSpecies(
    'Parsley',
    'https://www.kidsdogardening.com/wp-content/uploads/2020/02/Parsley-in-pot-1536x1025.jpeg',
    Duration(days: 2),
    Duration(days: 90),
    Duration(days: 365));
const BASIL = PlantSpecies(
    'Basil',
    'https://cdn.shopify.com/s/files/1/0022/5338/9887/products/Basil_plant_in_terracotta_pot_2000x.jpg',
    Duration(days: 2),
    Duration(days: 90),
    Duration(days: 365));
const FITTONIA = PlantSpecies(
    'Fittonia',
    'https://cdn.shopify.com/s/files/1/0109/7996/7072/products/48157-04-BAKIE_20190719150740_960x960_crop_center.jpg',
    Duration(days: 2),
    Duration(days: 90),
    Duration(days: 365));
const PHILODENDRON = PlantSpecies(
    'Philodendron',
    'https://cdn.shopify.com/s/files/1/0109/7996/7072/products/46787-01-BAKIE_20190221111731_f58132aa-7b3d-4626-9d40-eaa8f2e8aeac_960x960_crop_center.jpg',
    Duration(days: 2),
    Duration(days: 90),
    Duration(days: 365));
const MONKEY_LEAF = PlantSpecies(
    'Monkey Leaf',
    'https://cdn.shopify.com/s/files/1/0109/7996/7072/products/77674-04-BAKIE_20200203131817_960x960_crop_center.jpg',
    Duration(days: 2),
    Duration(days: 90),
    Duration(days: 365));
