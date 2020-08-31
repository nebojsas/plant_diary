import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:plant_diary/bloc/plants_bloc.dart';
import 'package:plant_diary/bloc/plants_state.dart';

class CreatePlantWidget extends StatefulWidget {
  const CreatePlantWidget({
    Key key,
  }) : super(key: key);

  @override
  _CreatePlantWidgetState createState() => _CreatePlantWidgetState();
}

class _CreatePlantWidgetState extends State<CreatePlantWidget> {
  static const String INFO_STEP = 'Plant Info';
  static const String SPECIES_STEP = 'Plant Species';
  static const List<String> CREATION_STEPS = [SPECIES_STEP, INFO_STEP];
  int _currentStepIndex = 0;
  PlantSpecies _selectedPlantSpecies;
  String _searchCriteria;
  String _name;
  static const String LAST_TIME_WATERED = 'lastTimeWatered';
  static const String LAST_TIME_FED = 'lastTimeFed';
  static const String LAST_TIME_REPOTTED = 'lastTimeRePotted';
  Map<String, DateTime> _careDatesMap = {
    LAST_TIME_WATERED: DateTime.now(),
    LAST_TIME_FED: DateTime.now(),
    LAST_TIME_REPOTTED: DateTime.now()
  };
  Future<void> _selectDate(BuildContext context, String dateToChangeKey) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _careDatesMap[dateToChangeKey] ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _careDatesMap[dateToChangeKey])
      setState(() {
        _careDatesMap[dateToChangeKey] = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Add a new plant'),
      ),
      body: ListView(
        children: [
          ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              print('Panel at: $index is expanded: $isExpanded');
              setState(() {
                if (!isExpanded) {
                  _currentStepIndex = index;
                } else {
                  _currentStepIndex = -1;
                }
              });
            },
            children: [
              ExpansionPanel(
                  isExpanded: _currentStepIndex == 0,
                  body: ListTile(
                    title: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: TextField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Search plant species',
                                    labelStyle:
                                        TextStyle(color: Colors.green.shade900),
                                    hintText: 'Parsley, Basil, etc.',
                                    hintStyle:
                                        TextStyle(color: Colors.green.shade100),
                                    filled: true,
                                    fillColor: Colors.white),
                                onChanged: (text) {
                                  setState(() {
                                    _searchCriteria = text;
                                  });
                                },
                              ),
                            ),
                            Container(
                              child: StreamBuilder(
                                stream: context
                                    .bloc<PlantsBloc>()
                                    .plantsRepo
                                    .plantSpeciesStream()
                                    .map((event) => event
                                        .where((element) =>
                                            _searchCriteria == null ||
                                            element.name.toLowerCase().contains(
                                                _searchCriteria.toLowerCase()))
                                        .toList()),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.hasData) {
                                    final List<PlantSpecies> speciesList =
                                        snapshot.data;
                                    return GridView.count(
                                        shrinkWrap: true,
                                        primary: true,
                                        crossAxisCount: 3,
                                        children: speciesList
                                            .map((species) => Card(
                                                margin: EdgeInsets.all(4),
                                                elevation: species.id ==
                                                        _selectedPlantSpecies
                                                            ?.id
                                                    ? 4
                                                    : 0,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: InkResponse(
                                                    onTap: () {
                                                      setState(() {
                                                        if (_selectedPlantSpecies
                                                                ?.id ==
                                                            species.id) {
                                                          _selectedPlantSpecies =
                                                              null;
                                                        } else {
                                                          _selectedPlantSpecies =
                                                              species;
                                                          _currentStepIndex++;
                                                          _searchCriteria =
                                                              null;
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      child: GridTile(
                                                        child: Image.network(
                                                          species.defaultImage,
                                                          width: 48,
                                                          height: 48,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        footer: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            color:
                                                                Colors.white70,
                                                            child: Text(
                                                                species.name)),
                                                        // onTap: () {
                                                        //   print('$species species selected');
                                                        // },
                                                      ),
                                                    ),
                                                  ),
                                                )))
                                            .toList());
                                  } else {
                                    return Text('Loading...');
                                  }
                                },
                              ),
                            ),
                          ],
                        )),
                  ),
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                        title: Text(
                            _selectedPlantSpecies?.name ?? 'select species'),
                        leading: Image.network(
                          _selectedPlantSpecies?.defaultImage ?? '',
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ));
                  }),
              ExpansionPanel(
                  isExpanded: _currentStepIndex == 1,
                  body: ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        title: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Name',
                                labelStyle:
                                    TextStyle(color: Colors.green.shade900),
                                hintText: 'Mr. Parsley, My Firstborn, etc.',
                                hintStyle:
                                    TextStyle(color: Colors.green.shade100),
                                filled: true,
                                fillColor: Colors.white),
                            onChanged: (text) {
                              setState(() {
                                _name = text;
                              });
                            },
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(MdiIcons.waterPump),
                        title: Text(
                            'Last time watered: ${_careDatesMap[LAST_TIME_WATERED].toLocal().toString().split(' ')[0]}'),
                        onTap: () {
                          _selectDate(context, LAST_TIME_WATERED);
                        },
                      ),
                      ListTile(
                        leading: Icon(MdiIcons.seed),
                        title: Text(
                            'Last time fed: ${_careDatesMap[LAST_TIME_FED].toLocal().toString().split(' ')[0]}'),
                        onTap: () {
                          _selectDate(context, LAST_TIME_FED);
                        },
                      ),
                      ListTile(
                        leading: Icon(MdiIcons.pot),
                        title: Text(
                            'Last time re-potted: ${_careDatesMap[LAST_TIME_REPOTTED].toLocal().toString().split(' ')[0]}'),
                        onTap: () {
                          _selectDate(context, LAST_TIME_REPOTTED);
                        },
                      ),
                      ListTile(
                          title: Container(
                        padding: EdgeInsets.all(16),
                        child: RaisedButton(
                            padding: EdgeInsets.all(16),
                            color: Colors.green.shade900,
                            child: Text(
                              'Create',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: _isDataValid()
                                ? () {
                                    final createdPlant = Plant(
                                        '', _name, _selectedPlantSpecies,
                                        lastTimeWatered:
                                            _careDatesMap[LAST_TIME_WATERED],
                                        lastTimeFed:
                                            _careDatesMap[LAST_TIME_FED],
                                        lastTimeRePotted:
                                            _careDatesMap[LAST_TIME_REPOTTED],
                                        imageUrl: '');
                                    context
                                        .bloc<PlantsBloc>()
                                        .addPlant(createdPlant);
                                    Navigator.of(context).pop();
                                  }
                                : null),
                      ))
                    ],
                  ),
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(title: Text('Plant info'));
                  }),
            ],
          ),
        ],
      ),
    );
  }

  bool _isDataValid() =>
      _name != null && _name.length > 0 && _selectedPlantSpecies != null;
}
