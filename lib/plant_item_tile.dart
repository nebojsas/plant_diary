import 'package:flutter/material.dart';

import 'bloc/plants_state.dart';
import 'plant_details_page.dart';

class PlantItemTile extends StatelessWidget {
  final Plant plant;
  final BuildContext buildContext;

  const PlantItemTile({
    Key key,
    this.plant,
    this.buildContext,
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
              ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: plant.imageUrl != null
                      ? Image.network(
                          plant.imageUrl,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        )
                      : plant.species.defaultImage != null
                          ? Image.network(
                              plant.species.defaultImage,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/default_plant.png',
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            )),
            ],
          ),
          title: Text(plant.name),
          subtitle: Text(plant.species.name),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              plant.isHappy()
                  ? Icon(
                      Icons.mood_bad,
                      color: Colors.red,
                    )
                  : Icon(
                      Icons.mood,
                      color: Colors.green,
                    ),
              // IconButton(
              //   color: Colors.grey,
              //   focusColor: Colors.redAccent,
              //   icon: Icon(
              //     Icons.delete,
              //   ),
              //   onPressed: () {
              //     buildContext.bloc<PlantsBloc>().removePlant(plant);
              //   },
              // ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => PlantDetailsPage(
                          plant: plant,
                        )));
          },
        ),
      ),
    );
  }
}
