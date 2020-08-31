import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/plants_bloc.dart';
import 'bloc/plants_state.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PlantDetailsPage extends StatefulWidget {
  final String plantId;

  const PlantDetailsPage({
    Key key,
    this.plantId,
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
      body: BlocBuilder<PlantsBloc, PlantsState>(
        builder: (context, state) {
          print('PlantDetailsPage: state=$state');
          if (state is PlantsStateInit) return Container();
          if (state is PlantsStateLoading) return CircularProgressIndicator();
          if (state is PlantsStateLoaded) {
            return StreamBuilder(
              stream: context.bloc<PlantsBloc>().plantStream(widget.plantId),
              builder: (BuildContext context, AsyncSnapshot<Plant> snapshot) {
                if (snapshot.hasData) {
                  final plant = snapshot.data;
                  print('PlantDetailsPage: ${plant.id}');
                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        actions: [
                          BlocConsumer<PlantsBloc, PlantsState>(
                            builder: (context, state) => IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                context.bloc<PlantsBloc>().removePlant(plant);
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
                            title: Text('${plant.name}',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            background: Container(
                              foregroundDecoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                    Colors.black38,
                                    Colors.transparent,
                                    Colors.black38
                                  ],
                                      stops: [
                                    0.1,
                                    0.5,
                                    0.9
                                  ])),
                              child: plant.imageUrl != null
                                  ? Image.network(
                                      plant.imageUrl,
                                      fit: BoxFit.cover,
                                    )
                                  : plant.species.defaultImage != null
                                      ? Image.network(
                                          plant.species.defaultImage,
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
                          padding: const EdgeInsets.only(
                              top: 100.0, left: 16.0, right: 16.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: plant.isHappy()
                                      ? Icon(
                                          Icons.mood,
                                          color: Colors.green,
                                          size: 36.0,
                                        )
                                      : Icon(
                                          Icons.mood_bad,
                                          color: Colors.red,
                                          size: 36.0,
                                        ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(plant.isHappy()
                                      ? 'Plant is happy.\n'
                                      : 'Plant is unhappy.\n'),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                          BlocBuilder<PlantsBloc, PlantsState>(
                                        builder: (context, state) =>
                                            FloatingActionButton(
                                          child: Icon(MdiIcons.waterPump),
                                          backgroundColor:
                                              !plant.needsWatering()
                                                  ? Colors.green
                                                  : Colors.red,
                                          onPressed: () {
                                            context
                                                .bloc<PlantsBloc>()
                                                .waterPlant(plant);
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(plant.needsWatering()
                                            ? 'Plant needs water.\nIt was last time watered ${plant.lastTimeWatered?.difference(DateTime.now())?.abs()?.inDays ?? UNKNOWN} day(s) ago.'
                                            : 'It was last time wattered ${plant.lastTimeWatered?.difference(DateTime.now())?.abs()?.inDays ?? UNKNOWN} day(s) ago.'),
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
                                      child:
                                          BlocBuilder<PlantsBloc, PlantsState>(
                                        builder: (context, state) =>
                                            FloatingActionButton(
                                          child: Icon(MdiIcons.seed),
                                          backgroundColor: !plant.needsFeeding()
                                              ? Colors.green
                                              : Colors.red,
                                          onPressed: () {
                                            context
                                                .bloc<PlantsBloc>()
                                                .feedPlant(plant);
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(plant.needsFeeding()
                                            ? 'Plant needs food.\nIt was last time fed ${plant.lastTimeFed?.difference(DateTime.now())?.abs()?.inDays ?? UNKNOWN} day(s) ago.'
                                            : 'It was last time wattered ${plant.lastTimeWatered?.difference(DateTime.now())?.abs()?.inDays ?? UNKNOWN} day(s) ago.'),
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
                                      child:
                                          BlocBuilder<PlantsBloc, PlantsState>(
                                        builder: (context, state) =>
                                            FloatingActionButton(
                                          child: Icon(MdiIcons.pot),
                                          backgroundColor:
                                              !plant.needsRePotting()
                                                  ? Colors.green
                                                  : Colors.red,
                                          onPressed: () {
                                            context
                                                .bloc<PlantsBloc>()
                                                .rePotPlant(plant);
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(plant.needsRePotting()
                                            ? 'Plant needs repotting.\nIt was last time repotted ${plant.lastTimeRePotted?.difference(DateTime.now())?.abs()?.inDays ?? UNKNOWN} day(s) ago.'
                                            : 'It was last time repotted ${plant.lastTimeWatered?.difference(DateTime.now())?.abs()?.inDays ?? UNKNOWN} day(s) ago.'),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
