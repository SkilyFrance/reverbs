import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


class NotificationsPage extends StatefulWidget {
  @override
  
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {


  ScrollController _listDiscussionsController = new ScrollController();
  ScrollController _listMusicArtistController = new ScrollController();
  ScrollController _artistListTracks = new ScrollController();
  PageController _projectsListsManagement = new PageController();


  String _trackChoosenToListen;

  @override
  void initState() {
    _listDiscussionsController = new ScrollController();
    _artistListTracks = new ScrollController();
    _projectsListsManagement = new PageController();
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
              transitionBetweenRoutes: false,
              backgroundColor: Colors.black.withOpacity(0.7),
              largeTitle: new Text('Notifications',
                  style: new TextStyle(color: Colors.white),
              ),
            ),
          ];
        }, 
        body: new SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              new Container(
                child: new ListView.builder(
                  shrinkWrap: true,
                  itemCount: 2,
                  scrollDirection: Axis.vertical,
                  controller: _listDiscussionsController,
                  physics: new NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int item) {
                    return new Container(
                      height: MediaQuery.of(context).size.height*0.10,
                      width: MediaQuery.of(context).size.width,
                      child: new ListTile(
                        onTap: () {
                  showBarModalBottomSheet(
                    context: context, 
                    builder: (context){
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter modalSetState) {
                         return new Container(
                         height: MediaQuery.of(context).size.height*0.65,
                         width: MediaQuery.of(context).size.width,
                         color: Color(0xFF181818),
                         child: new Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             new Container(
                               child: new Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children: [
                             new Container(
                               height: MediaQuery.of(context).size.height*0.03,
                               width: MediaQuery.of(context).size.width,
                               color: Colors.transparent,
                             ),
                             new Container(
                               child: new Center(
                                 child: new Text('Aldos tracks',
                                 style: new TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16.0, fontWeight: FontWeight.bold),
                                 ),
                               ),
                             ),
                             new Container(
                               height: MediaQuery.of(context).size.height*0.03,
                               width: MediaQuery.of(context).size.width,
                               color: Colors.transparent,
                              ),
                             new Container(
                               height: MediaQuery.of(context).size.height*0.06,
                               width: MediaQuery.of(context).size.height*0.06,
                               decoration: new BoxDecoration(
                                 shape: BoxShape.circle,
                                 color: Colors.grey[900].withOpacity(0.5),
                               ),
                               child: new ClipOval(
                               child: new Image.asset('lib/assets/userPhoto.png', fit: BoxFit.cover),
                               ),
                              ),
                             new Container(
                               height: MediaQuery.of(context).size.height*0.03,
                               width: MediaQuery.of(context).size.width,
                               color: Colors.transparent,
                              ),
                              new Container(
                                height: MediaQuery.of(context).size.height*0.20,
                                child: new ListView.builder(
                                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                  controller: _listMusicArtistController,
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
                                                    _trackChoosenToListen = item.toString();
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
                                                    new Positioned(
                                                      top: 0.0,
                                                      left: 0.0,
                                                      right: 0.0,
                                                      bottom: 0.0,
                                                      child: new Container(
                                                        child: new Center(
                                                          child: new Container(
                                                            decoration: new BoxDecoration(
                                                              color: Colors.white.withOpacity(0.3),
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: new Padding(
                                                              padding: EdgeInsets.all(7.0),
                                                              child: new IconButton(
                                                                icon: new Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30.0), 
                                                                onPressed: () {},
                                                                ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
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
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.08,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  child: new Center(
                    child: new Text('Accept this artist ?',
                    style: new TextStyle(color: Colors.grey[400], fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.04,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    new Container(
                    child: new CupertinoButton(
                      onPressed: () {},
                      color: Colors.grey[800],
                      child: new Center(
                        child: new Text('Decline',
                        style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ),
                    ),
                    new Container(
                    child: new CupertinoButton(
                      onPressed: () {},
                      color: Colors.deepPurpleAccent,
                      child: new Center(
                        child: new Text('Accept',
                        style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
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
                             ],
                            ),
                         );
                        },
                      );
                    });
                        },
                        leading: new Container(
                        height: MediaQuery.of(context).size.height*0.03,
                        width: MediaQuery.of(context).size.height*0.03,
                        child: new ClipOval(child: new Image.asset('lib/assets/userPhoto.png', fit: BoxFit.cover),
                      )),
                      title: new Text('Future-house project',
                      style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: new Text('This artist would like to integrate this project',
                      style: new TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.normal),
                      ),
                      trailing: new Material(
                        color: Colors.transparent,
                        child: new IconButton(
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: new Icon(Icons.keyboard_arrow_up_rounded, color: Colors.white, size: 35.0),
                          onPressed: (){
                          }),
                      ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}