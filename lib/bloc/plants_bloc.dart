import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:plant_diary/bloc/plants_event.dart';
import 'package:plant_diary/bloc/plants_state.dart';
import 'package:plant_diary/repository/plants_repo.dart';

class PlantsBloc extends Bloc<PlantsEvent, PlantsState> {
  PlantsRepo _plantsRepo = PlantsRepo();
  Stream<List<Plant>> plantListStream;
  Map<String, PlantSpecies> _plantSpeciesMap;
  PlantsBloc() : super(PlantsStateInit());

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
      yield PlantsStateLoading();
      _plantSpeciesMap = await _plantsRepo.plantSpeciesMap();
      plantListStream = _plantsRepo.plantListStream(_plantSpeciesMap)
        ..forEach((plantList) {
          print('Loaded ${plantList.length} plants.');
        });
      yield PlantsStateLoaded();
    } else if (event is AddPlantEvent) {
      Map<String, PlantSpecies> plantSpeciesMap =
          await _plantsRepo.plantSpeciesMap();
      plantSpeciesMap.forEach((key, value) async {
        bool success = await _plantsRepo.postPlant(
          Plant(
            '',
            'My ${value.name}',
            value,
            imageUrl:
                'https://hips.hearstapps.com/hbu.h-cdn.co/assets/17/27/1499286008-chinese-money-plant.jpg?crop=1.0xw:1xh;center,top&resize=980:*',
            lastTimeWatered:
                DateTime.now().subtract(Duration(days: Random().nextInt(10))),
            lastTimeFed:
                DateTime.now().subtract(Duration(days: Random().nextInt(100))),
            lastTimeRePotted:
                DateTime.now().subtract(Duration(days: Random().nextInt(1000))),
          ),
        );
        print('Plant addition ${success ? 'succeeded' : 'failed'}');
      });
    } else if (event is AddSpeciesEvent) {
      bool success = await _plantsRepo.postSpecies(event.species);
      print('Plant species addition ${success ? 'succeeded' : 'failed'}');
      // } else if (event is RemovePlantsEvent) {
      //   final plants = (state as PlantsStateLoaded)?.plants?.toList() ?? [];
      //   yield PlantsStateLoading();
      //   yield PlantsStateLoaded(plants.isEmpty ? [] : plants
      //     ..remove(event.plant));
      // } else if (event is ReplacePlantsEvent) {
      //   final plants = (state as PlantsStateLoaded)?.plants?.toList() ?? [];
      //   yield PlantsStateLoading();
      //   yield PlantsStateLoaded(plants.isEmpty ? [] : plants
      //     ..remove(event.plant)
      //     ..add(event.newPlant));
    } else if (event is WaterPlantEvent) {
      _plantsRepo.updatePlant(
          Map<String, dynamic>.of({'lastTimeWatered': DateTime.now()}),
          event.plant.id);
      } else if (event is FeedPlantEvent) {
        _plantsRepo.updatePlant(
          Map<String, dynamic>.of({'lastTimeFed': DateTime.now()}),
          event.plant.id);
      } else if (event is RePotPlantEvent) {
        _plantsRepo.updatePlant(
          Map<String, dynamic>.of({'lastTimeRePotted': DateTime.now()}),
          event.plant.id);
      // } else if (event is WaterAllPlantsEvent) {
      //   final plants = (state as PlantsStateLoaded)?.plants?.toList() ?? [];
      //   yield PlantsStateLoading();
      //   await Future.delayed(Duration(milliseconds: 300));
      //   yield PlantsStateLoading();
      //   yield PlantsStateLoaded(plants
      //     ..forEach((element) {
      //       element.lastTimeWatered = DateTime.now();
      //     }));
    }
  }

  void loadPlants() async {
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

  void feedPlant(Plant plant) {
    add((FeedPlantEvent(0, plant)));
  }

  void rePotPlant(Plant plant) {
    add((RePotPlantEvent(0, plant)));
  }

  void waterAllPlants() {
    add((WaterAllPlantsEvent(0)));
  }

  void addPlantSpecies() {
    add(AddSpeciesEvent(0, PlantSpecies.PHILODENDRON));
  }

  Stream<Plant> plantStream(String plantId) =>
      _plantsRepo.plantStream(plantId, _plantSpeciesMap);
}
