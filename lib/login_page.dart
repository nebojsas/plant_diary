import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_diary/bloc/auth_bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  final String errorMessage;

  const LoginPage({Key key, this.errorMessage}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState(errorMessage);
}

class _LoginPageState extends State<LoginPage> {
  final String errorMessage;
  String _email;
  String _password;

  _LoginPageState(this.errorMessage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Log In')),
        body: Container(
            margin: EdgeInsets.all(32),
            child: Center(
                heightFactor: 1.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'e-mail',
                                labelStyle:
                                    TextStyle(color: Colors.green.shade900),
                                hintText: 'john.flowers@plantdiary.com',
                                hintStyle:
                                    TextStyle(color: Colors.green.shade100),
                                filled: true,
                                fillColor: Colors.white),
                            onChanged: (text) {
                              setState(() {
                                _email = text;
                              });
                            })),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'password',
                                labelStyle:
                                    TextStyle(color: Colors.green.shade900),
                                hintText: 'Was it your favourite plant?',
                                hintStyle:
                                    TextStyle(color: Colors.green.shade100),
                                filled: true,
                                fillColor: Colors.white),
                            onChanged: (text) {
                              setState(() {
                                _password = text;
                              });
                            })),
                    ConstrainedBox(
                        constraints:
                            const BoxConstraints(minWidth: double.infinity),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: FlatButton.icon(
                                color: Colors.green,
                                padding: EdgeInsets.all(16),
                                onPressed: () {
                                  context
                                      .bloc<AuthBloc>()
                                      .login(_email, _password);
                                },
                                icon: Icon(MdiIcons.login),
                                label: Text('LOG IN'),
                                textColor: Colors.white))),
                    Visibility(
                        visible: errorMessage?.isNotEmpty != null,
                        child: Container(
                          padding: EdgeInsets.all(16),
                            child: Text(errorMessage ?? '',
                                style: TextStyle(color: Colors.red))))
                  ],
                ))));
  }
}
