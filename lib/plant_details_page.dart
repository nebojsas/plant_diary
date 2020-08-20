import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/plants_bloc.dart';
import 'bloc/plants_state.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
            expandedHeight: 250.0,
            pinned: true,
            floating: true,
            snap: true,
            flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.plant.name,
                    style: TextStyle(
                      color: Colors.white,
                    )),
                background: Container(
                  foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Colors.black26,
                        Colors.transparent,
                        Colors.black26
                      ],
                          stops: [
                        0.1,
                        0.5,
                        0.9
                      ])),
                  child: widget.plant.imageUrl != null
                      ? Image.network(
                          widget.plant.imageUrl,
                          fit: BoxFit.cover,
                        )
                      : widget.plant.species.defaultImage != null
                          ? Image.network(
                              widget.plant.species.defaultImage,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/default_plant.png',
                              fit: BoxFit.contain,
                            ),
                )),
          ),
          SliverFillRemaining(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 100.0, horizontal: 16.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: widget.plant.isHappy()
                              ? Icon(
                                  Icons.mood,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.mood_bad,
                                  color: Colors.red,
                                ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.plant.isHappy()
                              ? 'Plant is happy.\n'
                              : 'Plant is unhappy.\n'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BlocBuilder<PlantsBloc, PlantsState>(
                            builder: (context, state) => IconButton(
                              icon: Icon(MdiIcons.waterPump),
                              color: !widget.plant.needsWatering()
                                  ? Colors.green
                                  : Colors.red,
                              onPressed: () {
                                context
                                    .bloc<PlantsBloc>()
                                    .waterPlant(widget.plant);
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.plant.needsWatering()
                                ? 'Plant needs water.\nIt was last time watered ${widget.plant.lastTimeWatered?.difference(DateTime.now())?.abs()?.inDays ?? UNKNOWN} day(s) ago.'
                                : 'It was last time wattered ${widget.plant.lastTimeWatered?.difference(DateTime.now())?.abs()?.inDays ?? UNKNOWN} day(s) ago.'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BlocBuilder<PlantsBloc, PlantsState>(
                            builder: (context, state) => IconButton(
                              icon: Icon(MdiIcons.seed),
                              color: !widget.plant.needsFeeding()
                                  ? Colors.green
                                  : Colors.red,
                              onPressed: () {
                                context
                                    .bloc<PlantsBloc>()
                                    .feedPlant(widget.plant);
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.plant.needsFeeding()
                                ? 'Plant needs food.\nIt was last time fed ${widget.plant.lastTimeFed?.difference(DateTime.now())?.abs()?.inDays ?? UNKNOWN} day(s) ago.'
                                : 'It was last time wattered ${widget.plant.lastTimeWatered?.difference(DateTime.now())?.abs()?.inDays ?? UNKNOWN} day(s) ago.'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BlocBuilder<PlantsBloc, PlantsState>(
                            builder: (context, state) => IconButton(
                              icon: Icon(MdiIcons.pot),
                              color: !widget.plant.needsRePotting()
                                  ? Colors.green
                                  : Colors.red,
                              onPressed: () {
                                context
                                    .bloc<PlantsBloc>()
                                    .rePotPlant(widget.plant);
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.plant.needsRePotting()
                                ? 'Plant needs repotting.\nIt was last time repotted ${widget.plant.lastTimeRePotted?.difference(DateTime.now())?.abs()?.inDays ?? UNKNOWN} day(s) ago.'
                                : 'It was last time repotted ${widget.plant.lastTimeWatered?.difference(DateTime.now())?.abs()?.inDays ?? UNKNOWN} day(s) ago.'),
                          ),
                        ),
                      ],
                    ),

                    // Text(
                    //     '${widget.plant.name} is a type of ${widget.plant.species.name}'),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
