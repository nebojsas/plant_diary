import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_diary/bloc/image_bloc.dart';
import 'package:plant_diary/bloc/model/plant.dart';
import 'package:plant_diary/bloc/plants_bloc.dart';
import 'package:plant_diary/bloc/plants_state.dart';
import 'package:plant_diary/create_plant_widget.dart';
import 'package:plant_diary/plant_item_tile.dart';
import 'package:plant_diary/repository/user_repo/firebase_user_repo.dart';

import 'bloc/auth.dart';
import 'colors.dart';
import 'login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebaseDefault();

  runApp(MyApp());
}

Future<void> initializeFirebaseDefault() async {
  // final FirebaseOptions firebaseOptions = const FirebaseOptions(
  //   appId: '1:448618578101:ios:0b650370bb29e29cac3efc',
  //   apiKey: 'AIzaSyAgUhHU8wSJgO5MVNy95tMT07NEjzMOfz0',
  //   projectId: 'react-native-firebase-testing',
  //   messagingSenderId: '448618578101',
  // );
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  FirebaseAuth auth = FirebaseAuth.instanceFor(app: firebaseApp);

  FirebaseAuth.instance.authStateChanges().listen((User user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });

  assert(firebaseApp != null);
  print('Initialized default app $firebaseApp');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PlantsBloc()),
        BlocProvider(create: (_) => ImageBloc()),
        BlocProvider(create: (_) => AuthBloc(FirestoreUserRepo())),
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
            primaryColorDark: PDColors.PRIMARY_DARK,
            primaryColorLight: PDColors.PRIMARY_LIGHT,
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
          home: AuthWidget()),
    );
  }
}

class AuthWidget extends StatelessWidget {
  const AuthWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (BuildContext context, AuthState state) {
        if (state is InitAuthState) {
          context.bloc<AuthBloc>().checkAuth();
          return Center(child: CircularProgressIndicator());
        } else if (state is LoadingAuthState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is AuthErrorState) {
          return LoginPage(
            errorMessage: state.errorMessage,
          );
        } else if (state is UnAuthenticatedState) {
          return LoginPage();
        } else if (state is AuthenticatedState) {
          return MyHomePage(title: 'Plant Diary Home Page');
        }

        throw StateError(
            'State ${Error.safeToString(state)} is unknown or not handled.');
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlantsBloc, PlantsState>(builder: (blocContext, state) {
      if (state is PlantsStateInit) {
        blocContext.bloc<PlantsBloc>().loadPlants();
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            PopupMenuButton(
              onSelected: (String selectedItem) {
                if (selectedItem == 'LogOut') {
                  context.bloc<AuthBloc>().logout();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  child: Text('log out'),
                  value: 'LogOut',
                )
              ],
            )
          ],
        ),
        body: Center(
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
      },
      tooltip: 'Add',
      child: Icon(Icons.add),
    );
  }
}
