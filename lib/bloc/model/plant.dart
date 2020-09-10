import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_diary/bloc/model/plant_species.dart';

class Plant {
  final String id;
  final String name;
  final PlantSpecies species;
  DateTime lastTimeWatered;
  DateTime lastTimeRePotted;
  DateTime lastTimeFed;
  String profileImageUrl;

  Plant(
    this.id,
    this.name,
    this.species, {
    this.lastTimeWatered,
    this.lastTimeFed,
    this.lastTimeRePotted,
    this.profileImageUrl,
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
        profileImageUrl: data['profileImageUrl'],
      );

  Map<String, dynamic> toMap() {
    final dataMap = Map<String, dynamic>.from({});
    dataMap.putIfAbsent('name', () => name);
    dataMap.putIfAbsent('lastTimeWatered', () => Timestamp.fromDate(lastTimeWatered));
    dataMap.putIfAbsent('lastTimeFed', () => Timestamp.fromDate(lastTimeFed));
    dataMap.putIfAbsent('lastTimeRePotted', () => Timestamp.fromDate(lastTimeRePotted));
    dataMap.putIfAbsent('profileImageUrl', () => profileImageUrl);
    return dataMap;
  }
}