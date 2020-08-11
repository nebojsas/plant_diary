import 'package:bloc/bloc.dart';
import 'package:plant_diary/bloc/plants_event.dart';
import 'package:plant_diary/bloc/plants_state.dart';

class PlantsBloc extends Bloc<PlantsEvent, PlantsState> {
  PlantsBloc() : super(PlantsState.empty());

  @override
  Future<void> onChange(Change<PlantsState> change) async {
    print(change);
    super.onChange(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }

  @override
  Stream<PlantsState> mapEventToState(PlantsEvent event) async* {
    if (event is LoadPlantsEvent) {
      yield PlantsState.loading();
      await Future.delayed(Duration(milliseconds: 300));
      yield PlantsState.loaded(serverPlantList);
    } else if (event is AddPlantEvent) {
      final plants = state.plants.toList();
      yield PlantsState.loading();
      await Future.delayed(Duration(milliseconds: 300));
      yield PlantsState.loaded(plants..add(event.newPlant));
    } else if (event is RemovePlantsEvent) {
      final plants = state.plants.toList();
      yield PlantsState.loading();
      await Future.delayed(Duration(milliseconds: 300));
      yield plants.isEmpty
          ? PlantsState.empty()
          : PlantsState.loaded(plants..remove(event.plant));
    } else if (event is ReplacePlantsEvent) {
      final plants = state.plants.toList();
      yield PlantsState.loading();
      await Future.delayed(Duration(milliseconds: 300));
      yield plants.isEmpty
          ? PlantsState.empty()
          : PlantsState.loaded(plants
            ..remove(event.plant)
            ..add(event.newPlant));
    } else if (event is WaterPlantEvent) {
      final plants = state.plants.toList();
      yield PlantsState.loading();
      await Future.delayed(Duration(milliseconds: 300));
      yield plants.isEmpty
          ? PlantsState.empty()
          : PlantsState.loaded(plants
            ..where((e) => e == event.plant).forEach((element) {
              element.lastTimeWatered = DateTime.now();
            }));
    } else if (event is WaterAllPlantsEvent) {
      final plants = state.plants.toList();
      yield PlantsState.loading();
      await Future.delayed(Duration(milliseconds: 300));
      yield plants.isEmpty
          ? PlantsState.empty()
          : PlantsState.loaded(plants
            ..forEach((element) {
              element.lastTimeWatered = DateTime.now();
            }));
    }
  }

  void loadPlants() {
    add((LoadPlantsEvent(0)));
  }

  void addPlant(Plant plant) {
    add((AddPlantEvent(0, plant)));
  }

  void removePlant(Plant plant) {
    add((RemovePlantsEvent(0, plant)));
  }

  void replacePlant(Plant plant, Plant newPlant) {
    add((ReplacePlantsEvent(0, plant, newPlant)));
  }

  void waterPlant(Plant plant) {
    add((WaterPlantEvent(0, plant)));
  }

  void waterAllPlants() {
    add((WaterAllPlantsEvent(0)));
  }
}
