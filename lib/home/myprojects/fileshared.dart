import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FileSharedPage extends StatefulWidget {



  FileSharedPage({Key key}) : super(key: key);


  @override
  FileSharedPageState createState() => FileSharedPageState();
}

class FileSharedPageState extends State<FileSharedPage> {



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return new Scaffold(
      backgroundColor: Colors.black,
      body: new NestedScrollView(
        scrollDirection: Axis.vertical,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget> [
            new CupertinoSliverNavigationBar(
              actionsForegroundColor: Colors.purpleAccent[700],
              previousPageTitle: 'Home',
              automaticallyImplyTitle: true,
              automaticallyImplyLeading: true,
              transitionBetweenRoutes: true,
              backgroundColor: Colors.black.withOpacity(0.7),
              largeTitle: new Text('Files shared',
                  style: new TextStyle(color: Colors.white),
                  ),
            ),
          ];
        }, 
        body: new Container(
          child: new SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
              new Container(
                child: new Text('Find here, all files shared in discussion.',
                style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w500),
                ),
              ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                new Container(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Divider
                      new Container(
                        height: MediaQuery.of(context).size.height*0.02,
                        width: MediaQuery.of(context).size.width*0.05,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}