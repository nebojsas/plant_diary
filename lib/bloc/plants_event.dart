// enum PlantsEvent { load, add, remove }

import 'package:plant_diary/bloc/plants_state.dart';

abstract class PlantsEvent {

}

class LoadPlantsEvent extends PlantsEvent {
final int userId;
  LoadPlantsEvent(this.userId);
}

class AddPlantEvent extends PlantsEvent {
final int userId;
final Plant newPlant;
  AddPlantEvent(this.userId, this.newPlant);
}

class RemovePlantsEvent extends PlantsEvent {
final int userId;
final Plant plant;
  RemovePlantsEvent(this.userId, this.plant);
}
