import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_diary/bloc/plants_bloc.dart';

import 'bloc/plants_state.dart';

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
                          fit: BoxFit.fitWidth,
                        )
                      : Image.asset(
                          'assets/default_plant.png',
                          width: 48,
                          height: 48,
                          fit: BoxFit.fitWidth,
                        )),
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

class PlantDetailsPage extends StatefulWidget {
  final Plant plant;

  const PlantDetailsPage({
    Key key,
    this.plant,
  }) : super(key: key);

  @override
  _PlantDetailsPageState createState() => _PlantDetailsPageState();
}

class _PlantDetailsPageState extends State<PlantDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.plant.name),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            floating: true,
            snap: true,
            flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.plant.name,
                    style: TextStyle(
                      color: Colors.white,
                    )),
                background: widget.plant.imageUrl != null
                    ? Image.network(
                        widget.plant.imageUrl,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/default_plant.png',
                        fit: BoxFit.contain,
                      )),
          ),
          SliverFillRemaining(
            child: Center(
              child: Text(
                  '${widget.plant.name} is a type of ${widget.plant.species}'),
            ),
          ),
        ],
      ),
    );
  }
}
