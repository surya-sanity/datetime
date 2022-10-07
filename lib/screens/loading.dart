import 'package:datetime/screens/get_username.dart';
import 'package:datetime/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserName(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return GetUserName();
        } else if (snapshot.hasData && snapshot.data is String) {
          return Home(userName: snapshot.data);
        }
        return Scaffold(
            body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: Center(
                child: CupertinoActivityIndicator(),
              ))
            ],
          ),
        ));
      },
    );
  }
}
