import 'package:bloc/bloc.dart';
import 'package:plant_diary/bloc/plants_state.dart';

enum PlantsEvent { load, add, remove }

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
    switch (event) {
      case PlantsEvent.load:
        yield PlantsState.loading();
        await Future.delayed(Duration(milliseconds: 300));
        yield PlantsState.loaded(serverPlantList);
        break;
      case PlantsEvent.add:
        final plants = state.plants.toList();
        yield PlantsState.loading();
        await Future.delayed(Duration(milliseconds: 300));
        yield PlantsState.loaded(
            plants..add(Plant('Plant ${plants.length + 1}')));
        break;
      case PlantsEvent.remove:
        final plants = state.plants.toList();
        yield PlantsState.loading();
        await Future.delayed(Duration(milliseconds: 300));
        yield plants.isEmpty
            ? PlantsState.empty()
            : PlantsState.loaded(plants..removeLast());
        break;
    }
  }

  void loadPlants() {
    add((PlantsEvent.load));
  }

  void addPlant() {
    add((PlantsEvent.add));
  }

  void removePlant() {
    add((PlantsEvent.remove));
  }
}
