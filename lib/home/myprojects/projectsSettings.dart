import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ProjectSettingsPage extends StatefulWidget {



  ProjectSettingsPage({Key key}) : super(key: key);


  @override
  ProjectSettingsPageState createState() => ProjectSettingsPageState();
}

class ProjectSettingsPageState extends State<ProjectSettingsPage> {

  final removeFromPublication = new SnackBar(
    backgroundColor: Colors.deepPurpleAccent,
    content: new Text('This project is now private.',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
    ),
    );

  final putInPublication = new SnackBar(
    backgroundColor: Colors.deepPurpleAccent,
    content: new Text('This project is now public.',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
    ),
    );


  TextEditingController _projectContextTextController = new TextEditingController();
  ScrollController _listMusicController = new ScrollController();

  String _trackChoosenToPost;
  int tabTracksSelected = 0;
  bool _publishingValueSwitch = true;
  int selectedStyleInt;


  @override
  void initState() {
    _projectContextTextController = new TextEditingController();
    _listMusicController = new ScrollController();
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
              actionsForegroundColor: Colors.deepPurpleAccent,
              previousPageTitle: 'Home',
              automaticallyImplyTitle: true,
              automaticallyImplyLeading: true,
              transitionBetweenRoutes: true,
              backgroundColor: Colors.black.withOpacity(0.7),
              largeTitle: new Text('Settings',
                  style: new TextStyle(color: Colors.white),
                  ),
              trailing: new Material(
                color: Colors.transparent,
                child: new CupertinoSwitch(
                  //trackColor: Colors.grey,
                  activeColor: Colors.deepPurpleAccent,
                  value: _publishingValueSwitch,
                  onChanged: (bool value) {
                    setState(() {
                      _publishingValueSwitch = value;
                      });
                    if(value == false) {
                      Scaffold.of(context).showSnackBar(removeFromPublication);
                    } else if(value == true) {
                      Scaffold.of(context).showSnackBar(putInPublication);
                    }
                    },
                  ),
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
                  child: new Text('Modify, remove from publication or delete.',
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
                  child: new Center(
                    child: new Text('Modify context',
                    style: new TextStyle(color: Colors.grey[300], fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.02,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  child: new Center(
                    child: new Text("Explain what you need to create this new track.",
                    style: new TextStyle(color: Colors.grey[700], fontSize: 11.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.02,
                  width: MediaQuery.of(context).size.width,
                ),
                //TextField
                new Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[900].withOpacity(0.5),
                  child: new Center(
                    child: new CupertinoTextField(
                      textAlign: TextAlign.justify,
                      padding: EdgeInsets.all(10.0),
                      maxLength: 170,
                      style: new TextStyle(color: Colors.white, fontSize: 18.0),
                      keyboardType: TextInputType.text,
                      scrollPhysics: new ScrollPhysics(),
                      keyboardAppearance: Brightness.dark,
                      placeholder: 'Aa',
                      placeholderStyle: new TextStyle(color: Colors.grey, fontSize: 15.0),
                      minLines: 5,
                      maxLines: 5,
                      controller: _projectContextTextController,
                      decoration: new BoxDecoration(
                      ),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.01,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      new Container(
                        child: new Text('170 max',
                        style: new TextStyle(color: Colors.grey, fontSize: 11.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      new Container(
                        height: MediaQuery.of(context).size.height*0.01,
                        width: MediaQuery.of(context).size.width*0.04,
                      ),
                    ],
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.05,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  child: new Center(
                    child: new Text('Modify the demo',
                    style: new TextStyle(color: Colors.grey[300], fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.02,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  child: new Center(
                    child: new Text("If you don't have a demo, choose a similar track.",
                    style: new TextStyle(color: Colors.grey[700], fontSize: 11.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.02,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  height: MediaQuery.of(context).size.height*0.30,
                  color: Colors.transparent,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    new Container(
                      width: MediaQuery.of(context).size.width*0.90,
                    child: new CupertinoSlidingSegmentedControl(
                      backgroundColor: Colors.grey[900],
                      children: <int, Widget>{
                        0: new Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                        child: new Container(
                          child: new Text("Demo",
                          style: new TextStyle(color: tabTracksSelected == 0 ? Colors.white : Colors.grey, fontSize: 10.0, fontWeight: FontWeight.w700),
                          ),
                        ),
                        ),
                        1: new Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          child: new Container(
                          child:  new Text("Unreleased",
                          style: new TextStyle(color: tabTracksSelected == 1 ? Colors.white : Colors.grey, fontSize: 10.0, fontWeight: FontWeight.w700),
                          ),
                        ),
                        ),
                        2: new Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          child: new Container(
                          child:  new Text("Released",
                          style: new TextStyle(color: tabTracksSelected == 2 ? Colors.white : Colors.grey, fontSize: 10.0, fontWeight: FontWeight.w700),
                          ),
                        ),
                        ),
                      },
                      groupValue: tabTracksSelected,
                      onValueChanged: (value) {
                        setState(() {
                        tabTracksSelected = value;
                        });
                    })),
                    new Container(
                      height: MediaQuery.of(context).size.height*0.20,
                      child: new ListView.builder(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        controller: _listMusicController,
                        scrollDirection: Axis.horizontal,
                        physics: new ScrollPhysics(),
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int item) {
                          return new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              new Container(
                                height: MediaQuery.of(context).size.height*0.20,
                                child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                     new InkWell(
                                       onTap: () {
                                         setState(() {
                                           _trackChoosenToPost = item.toString();
                                         });
                                       },
                                     child: new Container(
                                      height: MediaQuery.of(context).size.height*0.15,
                                      width: MediaQuery.of(context).size.height*0.15,
                                      decoration: new BoxDecoration(
                                        color: Colors.grey[900].withOpacity(0.7),
                                        borderRadius: new BorderRadius.circular(5.0),
                                      ),
                                      child: new Stack(
                                        children: [
                                          new Positioned(
                                            top: 0.0,
                                            left: 0.0,
                                            right: 0.0,
                                            bottom: 0.0,
                                            child: new ClipRRect(
                                        borderRadius: new BorderRadius.circular(5.0),
                                        child: new Image.asset('lib/assets/background.jpg', fit: BoxFit.cover),
                                           ),
                                          ),
                                          _trackChoosenToPost == item.toString()
                                          ? new Positioned(
                                            top: 0.0,
                                            left: 0.0,
                                            right: 0.0,
                                            bottom: 0.0,
                                            child: new Container(
                                              height: MediaQuery.of(context).size.height*0.15,
                                              width: MediaQuery.of(context).size.height*0.15,
                                              decoration: new BoxDecoration(
                                                color: Colors.grey[900].withOpacity(0.7),
                                                borderRadius: new BorderRadius.circular(5.0),
                                              ),
                                              child: new Center(
                                                child: new Icon(Icons.check, color: Colors.white, size: 40.0),
                                              ),
                                            ),
                                            )
                                            : new Container(),
                                        ],
                                      ),
                                      ),
                                     ),
                                          new Container(
                                            child: new Text('Something about you',
                                            style: new TextStyle(color: Colors.grey[700],fontSize: 10.0, fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          ],
                                      ),
                                    ),
                                    //Divider
                                    new Container(
                                      height: MediaQuery.of(context).size.height*0.02,
                                      width: MediaQuery.of(context).size.width*0.04,
                                    ),
                            ],
                          );
                        }
                      ),
                    ),
                    ],
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.05,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  child: new Center(
                    child: new Text('Modify a style',
                    style: new TextStyle(color: Colors.grey[300], fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.02,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  child: new Center(
                    child: new Text("Which style is this track.",
                    style: new TextStyle(color: Colors.grey[700], fontSize: 11.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.03,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  height: MediaQuery.of(context).size.height*0.10,
                  decoration: new BoxDecoration(
                    color: Colors.grey[900].withOpacity(0.5),
                    //borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: new Padding(
                    padding: EdgeInsets.all(0.0),
                  child: new CupertinoPicker(
                    backgroundColor: Colors.transparent,
                    itemExtent: 50.0, 
                    onSelectedItemChanged: (value) {
                      setState(() {
                        selectedStyleInt = value;
                      });
                    }, 
                    children: [
                      new Center(
                      child: new Text('Future-House',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                      new Center(
                      child: new Text('Progressive-House',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                      new Center(
                      child: new Text('Deep-House',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                      new Center(
                      child: new Text('Acid-House',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                      new Center(
                      child: new Text('Chill-House',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                      new Center(
                      child: new Text('Trap',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                      new Center(
                      child: new Text('Dubstep',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                      new Center(
                      child: new Text('Dirty-Dutch',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                      new Center(
                      child: new Text('Techno',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                      new Center(
                      child: new Text('Trance',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                      new Center(
                      child: new Text('Hardstyle',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                    ],
                    ),
                  ),
                  ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.08,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  width: MediaQuery.of(context).size.width*0.70,
                child: new CupertinoButton(
                  onPressed: () {},
                  color: Colors.deepPurpleAccent,
                  child: new Center(
                    child: new Text('MODIFY'),
                  ),
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