// enum PlantsEvent { load, add, remove }

import 'package:plant_diary/bloc/model/plant.dart';
import 'package:plant_diary/bloc/model/plant_species.dart';

abstract class PlantsEvent {}

class LoadPlantsEvent extends PlantsEvent {
  final int userId;
  LoadPlantsEvent(this.userId);
}

class AddPlantEvent extends PlantsEvent {
  final int userId;
  final Plant newPlant;
  AddPlantEvent(this.userId, this.newPlant);
}

class AddSpeciesEvent extends PlantsEvent {
  final int userId;
  final PlantSpecies species;
  AddSpeciesEvent(this.userId, this.species);
}

class RemovePlantsEvent extends PlantsEvent {
  final int userId;
  final Plant plant;
  RemovePlantsEvent(this.userId, this.plant);
}

class ReplacePlantsEvent extends PlantsEvent {
  final int userId;
  final Plant plant;
  final Plant newPlant;
  ReplacePlantsEvent(this.userId, this.plant, this.newPlant);
}

class WaterPlantEvent extends PlantsEvent {
  final int userId;
  final Plant plant;
  WaterPlantEvent(this.userId, this.plant);
}

class FeedPlantEvent extends PlantsEvent {
  final int userId;
  final Plant plant;
  FeedPlantEvent(this.userId, this.plant);
}

class RePotPlantEvent extends PlantsEvent {
  final int userId;
  final Plant plant;
  RePotPlantEvent(this.userId, this.plant);
}

class UpdateDefaultPhotoPlantEvent extends PlantsEvent {
  final String imageUrl;
  final Plant plant;
  UpdateDefaultPhotoPlantEvent(this.plant, this.imageUrl);
}

class WaterAllPlantsEvent extends PlantsEvent {
  final int userId;
  WaterAllPlantsEvent(this.userId);
}
