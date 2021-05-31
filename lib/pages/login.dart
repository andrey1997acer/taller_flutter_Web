import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/blocs/user/bloc/user_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controllerText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final md = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(40),
          width: md.width * 0.40,
          height: md.height * 0.40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, state) {
              if (state.state == STATEUSER.data) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (route) => false);
              }

              if (state.state == STATEUSER.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('This user not found!')));
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LOGIN',
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CupertinoTextField(
                        controller: controllerText,
                        placeholder: 'Insert user ...',
                        onSubmitted: (value) {
                          BlocProvider.of<UserBloc>(context)
                              .add(Login(controllerText.text));
                        },
                      ),
                    ],
                  ),
                  CupertinoButton.filled(
                      child: (state.state == STATEUSER.loading
                          ? CupertinoActivityIndicator()
                          : Text('Login')),
                      onPressed: () {
                        BlocProvider.of<UserBloc>(context)
                            .add(Login(controllerText.text));
                      })
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
