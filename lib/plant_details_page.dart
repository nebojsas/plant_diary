import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/plants_bloc.dart';
import 'bloc/plants_state.dart';

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
  static const String UNKNOWN = 'unknown';

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
            actions: [
              BlocConsumer<PlantsBloc, PlantsState>(
                builder: (context, state) => IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      context.bloc<PlantsBloc>().removePlant(widget.plant);
                      Navigator.pop(context);
                    },
                  ),
                listener: (context, state) => {},
              ),
            ],
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
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 16.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: widget.plant.needsWater()
                              ? Icon(
                                  Icons.mood_bad,
                                  color: Colors.red,
                                )
                              : Icon(
                                  Icons.mood,
                                  color: Colors.green,
                                ),
                        ),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.plant.needsWater()
                                ? '${widget.plant.name} needs water.\nIt was last time wattered ${widget.plant.lastTimeWatered?.difference(DateTime.now())?.abs()?.inDays ?? UNKNOWN} day(s) ago.'
                                : '${widget.plant.name} is happy.\nIt was last time wattered ${widget.plant.lastTimeWatered?.difference(DateTime.now())?.abs()?.inDays ?? UNKNOWN} day(s) ago.'),
                          ),
                        ),
                      ],
                    ),
                    Text(
                        '${widget.plant.name} is a type of ${widget.plant.species}'),
                  ]),
            ),
          ),
        ],
      ),
      floatingActionButton: BlocConsumer<PlantsBloc, PlantsState>(
        builder: (context, state) => Visibility(
          visible: widget.plant.needsWater(),
          child: FloatingActionButton(
            heroTag: widget.plant,
            isExtended: true,
            onPressed: () {
              context.bloc<PlantsBloc>().waterPlant(widget.plant);
            },
            tooltip: 'Add',
            child: Icon(Icons.format_color_fill),
          ),
        ),
        listener: (context, state) => {},
      ),
    );
  }
}
