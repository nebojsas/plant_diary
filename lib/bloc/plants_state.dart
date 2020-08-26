import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

// final serverPlantList = UnmodifiableListView<Plant>([
//   Plant(0, 'plant 1', PARSLEY,
//       lastTimeWatered: DateTime.now().subtract(Duration(days: 5))),
//   Plant(1, 'plant 2', BASIL,
//       lastTimeWatered: DateTime.now().subtract(Duration(days: 6))),
//   Plant(
//     2,
//     'plant 3',
//     FITTONIA,
//   ),
//   Plant(3, 'plant 4', PHILODENDRON,
//       imageUrl:
//           'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/corner-of-a-stylish-living-room-royalty-free-image-638859268-1553272443.jpg?crop=0.947xw:0.949xh;0.0527xw,0.0511xh&resize=980:*',
//       lastTimeWatered: DateTime.now().subtract(Duration(days: 8))),
//   Plant(4, 'plant 5', MONKEY_LEAF,
//       imageUrl:
//           'https://hips.hearstapps.com/hbu.h-cdn.co/assets/17/27/1499286008-chinese-money-plant.jpg?crop=1.0xw:1xh;center,top&resize=980:*',
//       lastTimeWatered: DateTime.now().subtract(Duration(days: 4))),
//   Plant(5, 'plant 6', FITTONIA,
//       imageUrl:
//           'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/tender-and-unusual-string-of-pearls-weirdest-royalty-free-image-869615030-1553272264.jpg?crop=1xw:1xh;center,top&resize=980:*'),
// ]);

abstract class PlantsState {}

class PlantsStateInit extends PlantsState {}

class PlantsStateLoading extends PlantsState {}

class PlantsStateLoaded extends PlantsState {}

class Plant {
  final String id;
  final String name;
  final PlantSpecies species;
  DateTime lastTimeWatered;
  DateTime lastTimeRePotted;
  DateTime lastTimeFed;
  final String imageUrl;

  Plant(
    this.id,
    this.name,
    this.species, {
    this.lastTimeWatered,
    this.lastTimeFed,
    this.lastTimeRePotted,
    this.imageUrl,
  });

  bool needsWatering() => lastTimeWatered == null
      ? true
      : DateTime.now().difference(lastTimeWatered) > species.wateringFrequency;

  bool needsFeeding() => lastTimeFed == null
      ? true
      : DateTime.now().difference(lastTimeFed) > species.feedingFrequency;

  bool needsRePotting() => lastTimeRePotted == null
      ? true
      : DateTime.now().difference(lastTimeRePotted) >
          species.rePottingFrequency;

  bool isHappy() => !needsWatering() && !needsFeeding() && !needsRePotting();

  static Plant fromData(
          Map<String, dynamic> data, String id, PlantSpecies plantSpecies) =>
      Plant(
        id,
        data['name'],
        plantSpecies,
        lastTimeWatered: data['lastTimeWatered'].toDate(),
        lastTimeFed: data['lastTimeFed'].toDate(),
        lastTimeRePotted: data['lastTimeRePotted'].toDate(),
        imageUrl: data['imageUrl'],
      );

  Map<String, dynamic> toMap() {
    final dataMap = Map<String, dynamic>.from({});
    dataMap.putIfAbsent('name', () => name);
    dataMap.putIfAbsent('lastTimeWatered', () => Timestamp.fromDate(lastTimeWatered));
    dataMap.putIfAbsent('lastTimeFed', () => Timestamp.fromDate(lastTimeFed));
    dataMap.putIfAbsent('lastTimeRePotted', () => Timestamp.fromDate(lastTimeRePotted));
    return dataMap;
  }
}

class PlantSpecies {
  final String id;
  final String name;
  final String defaultImage;
  final Duration wateringFrequency;
  final Duration feedingFrequency;
  final Duration rePottingFrequency;

  const PlantSpecies(this.id, this.name, this.defaultImage,
      this.wateringFrequency, this.feedingFrequency, this.rePottingFrequency);

  static PlantSpecies fromData(Map<String, dynamic> data, String id) =>
      PlantSpecies(
          id,
          data['name'],
          data['defaultImage'],
          Duration(days: data['wateringFrequency']),
          Duration(days: data['feedingFrequency']),
          Duration(days: data['rePottingFrequency']));

  Map<String, dynamic> toMap() {
    final dataMap = Map<String, dynamic>.from({});
    dataMap.putIfAbsent('name', () => name);
    dataMap.putIfAbsent('defaultImage', () => defaultImage);
    dataMap.putIfAbsent('wateringFrequency', () => wateringFrequency.inDays);
    dataMap.putIfAbsent('feedingFrequency', () => feedingFrequency.inDays);
    dataMap.putIfAbsent('rePottingFrequency', () => rePottingFrequency.inDays);
    return dataMap;
  }

  static const PARSLEY = PlantSpecies(
      '0',
      'Parsley',
      'https://www.kidsdogardening.com/wp-content/uploads/2020/02/Parsley-in-pot-1536x1025.jpeg',
      Duration(days: 2),
      Duration(days: 90),
      Duration(days: 365));
  static const BASIL = PlantSpecies(
      '1',
      'Basil',
      'https://cdn.shopify.com/s/files/1/0022/5338/9887/products/Basil_plant_in_terracotta_pot_2000x.jpg',
      Duration(days: 2),
      Duration(days: 90),
      Duration(days: 365));
  static const FITTONIA = PlantSpecies(
      '2',
      'Fittonia',
      'https://cdn.shopify.com/s/files/1/0109/7996/7072/products/48157-04-BAKIE_20190719150740_960x960_crop_center.jpg',
      Duration(days: 2),
      Duration(days: 90),
      Duration(days: 365));
  static const PHILODENDRON = PlantSpecies(
      '3',
      'Philodendron',
      'https://cdn.shopify.com/s/files/1/0109/7996/7072/products/46787-01-BAKIE_20190221111731_f58132aa-7b3d-4626-9d40-eaa8f2e8aeac_960x960_crop_center.jpg',
      Duration(days: 2),
      Duration(days: 90),
      Duration(days: 365));
  static const MONKEY_LEAF = PlantSpecies(
      '4',
      'Monkey Leaf',
      'https://cdn.shopify.com/s/files/1/0109/7996/7072/products/77674-04-BAKIE_20200203131817_960x960_crop_center.jpg',
      Duration(days: 2),
      Duration(days: 90),
      Duration(days: 365));
}
