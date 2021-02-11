import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ContributorsPage extends StatefulWidget {



  ContributorsPage({Key key}) : super(key: key);


  @override
  ContributorsPageState createState() => ContributorsPageState();
}

class ContributorsPageState extends State<ContributorsPage> {


  ScrollController _contributorsListViewController = new ScrollController();


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
              actionsForegroundColor: Colors.purpleAccent,
              previousPageTitle: 'Home',
              automaticallyImplyTitle: true,
              automaticallyImplyLeading: true,
              transitionBetweenRoutes: true,
              backgroundColor: Colors.black.withOpacity(0.7),
              largeTitle: new Text('Contributors',
                  style: new TextStyle(color: Colors.white),
                  ),
              trailing: new Material(
                color: Colors.transparent, 
                child: new IconButton(
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                icon: new Icon(Icons.add_circle_outline_rounded, color: Colors.purpleAccent, size: 25.0),
                onPressed: () {},
                ),
                ),
            ),
          ];
        }, 
        body: new Container(
          child: new SingleChildScrollView(
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
                child: new Text('As an admin, you can manage contributors.',
                style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w500),
                ),
              ),
              //Divider
              new Container(
                height: MediaQuery.of(context).size.height*0.02,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
                    new Container(
                      width: MediaQuery.of(context).size.width,
                      child: new ListView.builder(
                        shrinkWrap: true,
                        physics: new NeverScrollableScrollPhysics(),
                        controller: _contributorsListViewController,
                        scrollDirection: Axis.vertical,
                        itemCount: 8,
                        itemBuilder: (BuildContext context, int item) {
                        return new Container(
                          height: MediaQuery.of(context).size.height*0.10,
                          width: MediaQuery.of(context).size.width,
                          child: new ListTile(
                            leading: new Container(
                            height: MediaQuery.of(context).size.height*0.05,
                            width: MediaQuery.of(context).size.height*0.05,
                            child: new ClipOval(child: new Image.asset('lib/assets/background.jpg', fit: BoxFit.cover),
                          )),
                          title: new Text('Aldos',
                          style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          trailing: new IconButton(
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: new Icon(Icons.more_horiz_rounded, color: Colors.white, size: 20.0,), 
                            onPressed: () {
                            final act = new CupertinoActionSheet(
                                title: new Text('Manage this track',
                                style: new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.bold),
                                ),
                                message: new Text('Please select an action from the options below.',
                                style: new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.w500),
                                ),
                                actions: <Widget>[
                                  new CupertinoActionSheetAction(
                                    child: new Text('Promote as admin'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      showDialog(
                                      context: context,
                                      builder: (BuildContext context) => 
                                      new CupertinoAlertDialog(
                                        title: new Text("Promote as admin?",
                                        style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                                        ),
                                        content: new Padding(
                                          padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                                          child: new Text("Be careful, this producer will become admin.",
                                          style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.normal),
                                        )),
                                        actions: <Widget>[
                                          new CupertinoDialogAction(
                                            child: new Text("Promote", style: new TextStyle(color: Colors.red, fontSize: 13.0, fontWeight: FontWeight.normal)),
                                            onPressed: () {Navigator.pop(context);},
                                          ),
                                          new CupertinoDialogAction(
                                            child: Text("No, thanks", style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal)),
                                            onPressed: () {Navigator.pop(context);},
                                          )
                                        ],
                                      ),
                                      );
                                    },
                                  ),
                                  new CupertinoActionSheetAction(
                                    child: new Text('Remove from project', style: new TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      showDialog(
                                      context: context,
                                      builder: (BuildContext context) => 
                                      new CupertinoAlertDialog(
                                        title: new Text("Remove this producer ?",
                                        style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                                        ),
                                        content: new Padding(
                                          padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                                          child: new Text("Be careful, this producer will be remove from project.",
                                          style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.normal),
                                        )),
                                        actions: <Widget>[
                                          new CupertinoDialogAction(
                                            child: new Text("Remove", style: new TextStyle(color: Colors.red, fontSize: 13.0, fontWeight: FontWeight.normal)),
                                            onPressed: () {Navigator.pop(context);},
                                          ),
                                          new CupertinoDialogAction(
                                            child: Text("No, thanks", style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal)),
                                            onPressed: () {Navigator.pop(context);},
                                          )
                                        ],
                                      ),
                                      );
                                    },
                                  ),
                                ],
                                cancelButton: new CupertinoActionSheetAction(
                                  child: new Text('Cancel',
                                  style: new TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ));
                            showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) => act);
                            },
                            ),
                          ),
                        );
                        }),
                    ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}