import 'package:flutter/material.dart';
import 'package:plant_diary/bloc/model/plant.dart';

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
    return Card(
        margin: const EdgeInsets.all(2.0),
        child: ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: plant.profileImageUrl?.isNotEmpty != null
                      ? Image.network(
                          plant.profileImageUrl,
                          width: 56,
                          height: 56,
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
                                    print(exception);
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
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/default_plant.png',
                              width: 56,
                              height: 46,
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
    );
  }
}
