import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_diary/bloc/plants_bloc.dart';

import 'bloc/plants_state.dart';

class PlantItemTile extends StatelessWidget {
  final Plant plant;
  final BuildContext buildContext;

  const PlantItemTile({
    Key key,
    this.plant, this.buildContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        child: ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.local_florist,
                color: Colors.green,
              ),
            ],
          ),
          title: Text(plant.name),
          subtitle: Text(plant.species),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                color: Colors.grey,
                focusColor: Colors.redAccent,
                icon: Icon(
                  Icons.delete,
                ),
                onPressed: () {
                  buildContext.bloc<PlantsBloc>().removePlant(plant);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
