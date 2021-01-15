import 'dart:async';
import 'package:SONOZ/inscriptionProcess/landingPage.dart';
import 'package:SONOZ/splash.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'navigation.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: new FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        //checkErrors
        if(snapshot.hasError) {
          return new Container(
            color: Colors.black,
            child: new Center(child: new CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
          )));
        }
        if(snapshot.connectionState == ConnectionState.done) {
          return new SplashPage();
        }
         return new Container(
         color: Colors.black,
         child: new Center(child: new CircularProgressIndicator(
         valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
       )));
      }
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
    );
  }
}
