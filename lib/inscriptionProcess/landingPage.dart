import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:SONOZ/inscriptionProcess/login.dart';
import 'package:SONOZ/inscriptionProcess/register.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class LandingPage extends StatefulWidget {
  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            new Container(
              height: MediaQuery.of(context).size.height*0.55,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  new Container(
              height: MediaQuery.of(context).size.height*0.10,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
            ),
            new Container(
              height: MediaQuery.of(context).size.height*0.09,
              color: Colors.transparent,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new Container(
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        new Container(
                          width: MediaQuery.of(context).size.width*0.05,
                          color: Colors.transparent,
                        ),
                        new Container(
                          color: Colors.transparent,
                          child: new Center(
                          child: new Text('Reverbs.',
                          style: new TextStyle(color: Colors.grey[800], fontSize: 30.0, fontWeight: FontWeight.bold),
                          )),
                        ),
                        new Container(
                          height: MediaQuery.of(context).size.height*0.06,
                          width: MediaQuery.of(context).size.width*0.02,
                          color: Colors.transparent,
                        ),
                        ],
                      ),
                  ),
                ],
              ),
            ),
           new Container(
             height: MediaQuery.of(context).size.height*0.06,
             color: Colors.transparent,
           ),
           new Container(
             color: Colors.transparent,
               child: new Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            new Container(
                              height: MediaQuery.of(context).size.height*0.02,
                              width: MediaQuery.of(context).size.width*0.05,
                            ),
                            new Text('The collaborative',
                            style: new TextStyle(color: Colors.white, fontSize: 33.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        //Divider
                        new Container(
                          height: MediaQuery.of(context).size.height*0.01,
                          width: MediaQuery.of(context).size.width,
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            new Container(
                              height: MediaQuery.of(context).size.height*0.02,
                              width: MediaQuery.of(context).size.width*0.05,
                            ),
                            new Text('hub of electronic',
                            style: new TextStyle(color: Colors.white, fontSize: 33.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        //Divider
                        new Container(
                          height: MediaQuery.of(context).size.height*0.02,
                          width: MediaQuery.of(context).size.width,
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            new Container(
                              height: MediaQuery.of(context).size.height*0.02,
                              width: MediaQuery.of(context).size.width*0.05,
                            ),
                            new Text('music projects.',
                            style: new TextStyle(color: Colors.grey, fontSize: 28.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                  ),
                 ],
               ),
             ),
             //Divider
             new Container(
              height: MediaQuery.of(context).size.height*0.04,
              width: MediaQuery.of(context).size.width*0.05,
             ),
            //Start button
           new Container(
             child: new Row(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 //Divider
                 new Container(
                  height: MediaQuery.of(context).size.height*0.02,
                  width: MediaQuery.of(context).size.width*0.05,
                 ),
                 new InkWell(
                   onTap: () {
                    Navigator.pushAndRemoveUntil(
                    context, new PageRouteBuilder(pageBuilder: (_,__,___) => new RegisterPage()),
                    (route) => false);
                   },
                   hoverColor: Colors.transparent,
                   highlightColor: Colors.transparent,
                   splashColor: Colors.transparent,
                   child: new Container(
                     height: MediaQuery.of(context).size.height*0.06,
                     width: MediaQuery.of(context).size.width*0.40,
                     decoration: new BoxDecoration(
                       color: Colors.transparent,
                       borderRadius: new BorderRadius.circular(8.0),
                       border: new Border.all(
                         width: 4.0,
                         color: Colors.white,
                       ),
                     ),
                     child: new Center(
                       child: new Text('START',
                       style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                       ),
                     ),
                   ),
                 ),
               ],
             ),
              ),
                ],
              ),
            ),
          new Container(
            height: MediaQuery.of(context).size.height*0.05,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
          ),
           new Image.asset('lib/assets/dj.png',
           height: MediaQuery.of(context).size.height*0.40,
           width: MediaQuery.of(context).size.height*0.40,
           ),
                 //BUTTON : SIGN UP
                 /*new InkWell(
                   onTap: () {
                    Navigator.pushAndRemoveUntil(
                    context, new PageRouteBuilder(pageBuilder: (_,__,___) => new RegisterPage()),
                    (route) => false);
                     },
                 child: new Container(
                   height: MediaQuery.of(context).size.height*0.08,
                   width: MediaQuery.of(context).size.width*0.8,
                   decoration: new BoxDecoration(
                     color: Colors.yellowAccent,
                     borderRadius: new BorderRadius.circular(10.0)
                   ),
                   child: new Center(
                     child: new Text('SIGN UP',
                     style: new TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                     ),
                   ),
                 ),
                 ),
                 //BUTTON : SIGN IN
                    new InkWell(
                      onTap: () {
                    Navigator.pushAndRemoveUntil(
                    context, new PageRouteBuilder(pageBuilder: (_,__,___) => new LoginPage()),
                    (route) => false);
                      },
                      child:  new Container(
                        height: MediaQuery.of(context).size.height*0.08,
                        width: MediaQuery.of(context).size.width*0.8,
                        decoration: new BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: new BorderRadius.circular(10.0)
                        ),
                        child: new Center(
                          child: new Text('SIGN IN',
                          style: new TextStyle(color: Colors.yellowAccent, fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ),*/

               ],
             ),
             ),
    );
  }
}



