import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_diary/bloc/image_bloc.dart';
import 'package:plant_diary/bloc/model/plant.dart';
import 'package:plant_diary/bloc/plants_bloc.dart';
import 'package:plant_diary/bloc/plants_state.dart';
import 'package:plant_diary/create_plant_widget.dart';
import 'package:plant_diary/plant_item_tile.dart';

void main() {
  runApp(MyApp());
}

class PDColors {
  static const PRIMARY = Color(0xff2e7d32);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initializeFirebaseDefault();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PlantsBloc()),
        BlocProvider(create: (_) => ImageBloc()),
        ],
      child: MaterialApp(
        title: 'Plant Diary', // Change for Manuela
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.green,
          primaryColor: PDColors.PRIMARY,
          primaryColorDark: Color(0xff005005),
          primaryColorLight: Color(0xff60ad5e),
//           <!--?xml version="1.0" encoding="UTF-8"?-->
// <resources>
//   <color name="primaryColor"></color>
//   <color name="primaryLightColor">#</color>
//   <color name="primaryDarkColor">#</color>
//   <color name="primaryTextColor">#ffffff</color>
// </resources>
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Plant Diary Home Page'),
      ),
    );
  }

  Future<void> initializeFirebaseDefault() async {
    // final FirebaseOptions firebaseOptions = const FirebaseOptions(
    //   appId: '1:448618578101:ios:0b650370bb29e29cac3efc',
    //   apiKey: 'AIzaSyAgUhHU8wSJgO5MVNy95tMT07NEjzMOfz0',
    //   projectId: 'react-native-firebase-testing',
    //   messagingSenderId: '448618578101',
    // );
    FirebaseApp app = await Firebase.initializeApp();
    assert(app != null);
    print('Initialized default app $app');
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return BlocBuilder<PlantsBloc, PlantsState>(builder: (blocContext, state) {
      if (state is PlantsStateInit) {
        blocContext.bloc<PlantsBloc>().loadPlants();
      }

      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: state is PlantsStateLoading
              ? CircularProgressIndicator()
              : (state is PlantsStateLoaded)
                  ? StreamBuilder(
                      stream: context.bloc<PlantsBloc>().plantListStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Plant>> snapshot) {
                        if (snapshot.hasData) {
                          final plants = snapshot.data;
                          return plants.isEmpty
                              ? Text('You have no plants :(')
                              : RefreshIndicator(
                                  onRefresh: () async {
                                    context.bloc<PlantsBloc>().loadPlants();
                                    return await Future.delayed(
                                        Duration(seconds: 3));
                                  },
                                  child: ListView(
                                    children: plants
                                        .map((element) => PlantItemTile(
                                              plant: element,
                                              buildContext: context,
                                            ))
                                        .toList(),
                                  ));
                        } else {
                          return Text('You have no plants :(');
                        }
                      },
                    )
                  : Text('Error: Unknown state.'),
        ),
        floatingActionButton: state is PlantsStateLoaded
            ? Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // FloatingActionButton(
                  //   heroTag: null,
                  //   mini: true,
                  //   isExtended: true,
                  //   onPressed: () {
                  //     context.bloc<PlantsBloc>().waterAllPlants();
                  //   },
                  //   tooltip: 'Water All Plants',
                  //   child: Icon(Icons.format_color_fill),
                  // ),
                  CreatePlantFloatingActionButton(),
                ],
              )
            : null,
      );
    });
  }
}

class CreatePlantFloatingActionButton extends StatelessWidget {
  const CreatePlantFloatingActionButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      isExtended: true,
      onPressed: () {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => CreatePlantWidget()));
        // showBottomSheet(
        //     context: context, builder: (context) => CreatePlantWidget());
        // context.bloc<PlantsBloc>().addPlant(null // Plant()
        //     );

        // if (state.plants.isEmpty) {
        //   context
        //       .bloc<PlantsBloc>()
        //       .addPlant(Plant('', 'New Plant', FITTONIA));
        // } else {
        //   context.bloc<PlantsBloc>().addPlant(Plant(
        //       state.plants
        //               .reduce((value, element) =>
        //                   value.id > element.id ? value : element)
        //               .id +
        //           1,
        //       'New Plant',
        //       FITTONIA));
        // }
      },
      tooltip: 'Add',
      child: Icon(Icons.add),
    );
  }
}
