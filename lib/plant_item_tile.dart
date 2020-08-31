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
                          errorBuilder: (context, object, stackTrace) =>
                              DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Image.network(
                              'https://example.does.not.exist/image.jpg',
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace stackTrace) {
                                // Appropriate logging or analytics, e.g.
                                // myAnalytics.recordError(
                                //   'An error occurred loading "https://example.does.not.exist/image.jpg"',
                                //   exception,
                                //   stackTrace,
                                // );
                                return Text('😢');
                              },
                            ),
                          ),
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
                      Icons.mood,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.mood_bad,
                      color: Colors.red,
                    ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => PlantDetailsPage(
                          plantId: plant.id,
                        )));
          },
        ),
      ),
    );
  }
}
