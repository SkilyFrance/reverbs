import 'package:SONOZ/Discover/projectPublication.dart';
import 'package:SONOZ/DiscoverTab/discoverTab.dart';
import 'package:SONOZ/homeOld/styleMusicTab.dart';
import 'package:SONOZ/homeOld/uploadMusic.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../DiscoverTab/profileDetails.dart';
import '../profileOld.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../services/slideRoute.dart';

class DiscoverPage extends StatefulWidget {

  String currentUser; 
  String currentUserType;
  String currentUserUsername;
  String currentUserPhoto;

  DiscoverPage({Key key, this.currentUser, this.currentUserType, this.currentUserUsername, this.currentUserPhoto}) : super(key: key);




  @override
  DiscoverPageState createState() => DiscoverPageState();
}

class DiscoverPageState extends State<DiscoverPage> with SingleTickerProviderStateMixin {



  int sharedValue = 0;
  String _trackChoosenToListen;

  ScrollController _futureHouseListViewController = new ScrollController();
  ScrollController _progressiveHouseListViewController = new ScrollController();
  ScrollController _artistListTracks = new ScrollController();

final Map<int, Widget> segmentTextWidgets = <int, Widget>{
    0: new Padding(
      padding: EdgeInsets.all(10.0),
    child: new Container(
      child: new Text("Projets"),
    ),
    ),
    1: new Padding(
      padding: EdgeInsets.all(10.0),
      child: new Container(
      child:  new Text("Musics"),
    ),
    ),
  };

  TabController _tabController;
  PageController _pageController;
  ScrollController _scrollViewController;
  ScrollController _djListViewController;
  TextEditingController _searchTextEditingController = new TextEditingController();
  String artistQueryName;
  var top = 0.0;
  
  //
  bool inSearching = false;
  bool _audioLaunched = false;

  //Filter for Home //
  bool filterRecentIsChoosen = true;
  bool filterTrendIsChoosen = false;
  //ListView flatButton//
  bool edmChoosen = true;
  bool electroChoosen = false;
  bool houseChoosen = false;
  bool acidHouseChoosen = false;
  bool futureHouseChoosen = false;
  bool deepHouseChoosen = false;
  bool chillHouseChoosen = false;
  bool technoChoosen = false;
  bool tranceChoosen = false;
  bool progressiveChoosen = false;
  bool minimaleChoosen = false;
  bool dubstepChoosen = false;
  bool trapChoosen = false;
  bool dirtyDutchChoosen = false;
  bool moombathtonChoosen = false;
  bool hardstyleChoosen = false;

  var songsList = new List<int>.generate(50, (i) => i + 1);
  ScrollController songsGriViewController = new ScrollController(initialScrollOffset: 0.0);
  ScrollController _songStyleController = new ScrollController(initialScrollOffset: 0.0);

  @override
  void initState() {
    print(widget.currentUserType);
    _tabController = new TabController(length: 6, vsync: this);
    _scrollViewController = new ScrollController();
    _djListViewController = new ScrollController();
    _artistListTracks = new ScrollController();
    listenIfAlreadyliked();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget> [
            new CupertinoSliverNavigationBar(
              transitionBetweenRoutes: false,
              backgroundColor: Colors.black.withOpacity(0.7),
              largeTitle: new Text('Discover',
                  style: new TextStyle(color: Colors.white),
                  ),
              trailing: new Material(
                color: Colors.transparent,
                child: new IconButton(
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                icon: new Icon(Icons.add_circle_outline_rounded, color: Colors.purpleAccent, size: 25.0),
                onPressed: () {
                  Navigator.push(context, new CupertinoPageRoute(fullscreenDialog: true, builder: (context) => new ProjectPublicationPage()));
                },
              ),
                ),
            ),
          ];
        }, 
        body: new Container(
          child: new Stack(
            children: [
              new Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: new Container(
                  child: new SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 170.0),
                    child: new Container(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        //Divider
                        new Container(
                          height: MediaQuery.of(context).size.height*0.03,
                          width: MediaQuery.of(context).size.width,
                        ),
                new CupertinoSlidingSegmentedControl(
                  backgroundColor: Colors.grey[900],
                  children: <int, Widget>{
                    0: new Padding(
                      padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                    child: new Container(
                      child: new Text("Projects",
                      style: new TextStyle(color: sharedValue == 0 ? Colors.white : Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w700),
                      ),
                    ),
                    ),
                    1: new Padding(
                      padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                      child: new Container(
                      child:  new Text("Musics",
                      style: new TextStyle(color: sharedValue == 1 ? Colors.white : Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w700),
                      ),
                    ),
                    ),
                  },
                  groupValue: sharedValue,
                  onValueChanged: (value) {
                    setState(() {
                    sharedValue = value;
                    });
                }),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.05,
                  width: MediaQuery.of(context).size.width,
                ),
                sharedValue == 0
                ? new Container(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    new Container(
                      height: MediaQuery.of(context).size.height*0.50,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Divider
                          new Container(
                            width: MediaQuery.of(context).size.width,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //Divider
                                new Container(
                                  height: MediaQuery.of(context).size.height*0.01,
                                  width: MediaQuery.of(context).size.width*0.05,
                                ),
                                new Text('Future-house',
                                style: new TextStyle(color: Colors.grey[700],fontSize: 15.0, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          new Container(
                            height: MediaQuery.of(context).size.height*0.45,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.transparent,
                            child: new ListView.builder(
                              padding: EdgeInsets.only(left: 10.0),
                              scrollDirection: Axis.horizontal,
                              controller: _futureHouseListViewController,
                              itemCount: 10,
                              itemBuilder: (BuildContext context, int item) {
                                return new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.45,
                                    width: MediaQuery.of(context).size.width*0.80,
                                    constraints: new BoxConstraints(
                                      minHeight: 400.0,
                                      minWidth: 300.0,
                                    ),
                                    decoration: new BoxDecoration(
                                      color: Colors.grey[900].withOpacity(0.5),
                                      border: new Border.all(
                                        width: 1.0,
                                        color: Colors.grey[900],
                                      ),
                                      borderRadius: new BorderRadius.circular(5.0),
                                    ),
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        new Container(
                                          height: MediaQuery.of(context).size.height*0.07,
                                          color: Colors.transparent,
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              //Divider
                                              new Container(
                                                height: MediaQuery.of(context).size.height*0.07,
                                                width: MediaQuery.of(context).size.width*0.03,
                                              ),
                                              new Container(
                                                height: MediaQuery.of(context).size.height*0.05,
                                                width: MediaQuery.of(context).size.height*0.05,
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey[800],
                                                ),
                                                child: new ClipOval(
                                                  child: new Image.asset('lib/assets/userPhoto.png'),
                                                ),
                                              ),
                                              //Divider
                                              new Container(
                                                height: MediaQuery.of(context).size.height*0.07,
                                                width: MediaQuery.of(context).size.width*0.03,
                                              ),
                                              new Container(
                                                child: new Text('David Morillo',
                                                style: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        new Container(
                                          height: MediaQuery.of(context).size.height*0.13,
                                          width: MediaQuery.of(context).size.width*0.80,
                                          color: Colors.transparent,
                                          child: new Center(
                                          child: new Padding(
                                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                          child: new Text('Hey guys, We are two producers in trap, and would like to create a record between these two styles. We already have created a part the track but need help on Future-House part 🙌.',
                                          style: new TextStyle(color: Colors.white),
                                          textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ),
                                        ),
                                        new Container(
                                          height: MediaQuery.of(context).size.height*0.10,
                                          width: MediaQuery.of(context).size.width*0.80,
                                          color: Colors.transparent,
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              new InkWell(
                                                highlightColor: Colors.transparent,
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                onTap: () {
                                                  setState(() {
                                                    _audioLaunched = true;
                                                  });
                                                },
                                              child: new Container(
                                                height: MediaQuery.of(context).size.height*0.09,
                                                width: MediaQuery.of(context).size.height*0.09,
                                                decoration: new BoxDecoration(
                                                  color: Colors.grey[900].withOpacity(0.8),
                                                  shape: BoxShape.circle,
                                                  border: new Border.all(
                                                    width: 2.0,
                                                    color: Colors.purpleAccent,
                                                  ),
                                                ),
                                                child: new Center(
                                                  child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40.0),
                                                ),
                                              ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        new Container(
                                          height: MediaQuery.of(context).size.height*0.08,
                                          width: MediaQuery.of(context).size.width*0.80,
                                          color: Colors.transparent,
                                          child: new Center(
                                            child: new Container(
                                              height: MediaQuery.of(context).size.height*0.05,
                                              width: MediaQuery.of(context).size.width*0.50,
                                              decoration: new BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius: new BorderRadius.circular(5.0),
                                                border: new Border.all(
                                                  width: 1.0,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            child: new InkWell(
                                              onTap: () { },
                                              child: new Container(
                                                child: new Center(
                                                child: new Text('Submit',
                                                style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                                                ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.02,
                                    width: MediaQuery.of(context).size.width*0.03,
                                  ),
                                  ],
                                );
                              }),
                          ),
                        ],
                      ),
                    ),
                    //Divider
                    new Container(
                      height: MediaQuery.of(context).size.height*0.05,
                      width: MediaQuery.of(context).size.width,
                    ),
/// Second Container
                    new Container(
                      height: MediaQuery.of(context).size.height*0.50,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Divider
                          new Container(
                            width: MediaQuery.of(context).size.width,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //Divider
                                new Container(
                                  height: MediaQuery.of(context).size.height*0.01,
                                  width: MediaQuery.of(context).size.width*0.05,
                                ),
                                new Text('Progressive-house',
                                style: new TextStyle(color: Colors.grey[700],fontSize: 15.0, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          new Container(
                            height: MediaQuery.of(context).size.height*0.45,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.transparent,
                            child: new ListView.builder(
                              padding: EdgeInsets.only(left: 10.0),
                              scrollDirection: Axis.horizontal,
                              controller: _progressiveHouseListViewController,
                              itemCount: 10,
                              itemBuilder: (BuildContext context, int item) {
                                return new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.45,
                                    width:  MediaQuery.of(context).size.width*0.80,
                                    constraints: new BoxConstraints(
                                      minHeight: 400.0,
                                      minWidth: 300.0,
                                    ),
                                    decoration: new BoxDecoration(
                                      color: Colors.grey[900].withOpacity(0.5),
                                      border: new Border.all(
                                        width: 1.0,
                                        color: Colors.grey[900],
                                      ),
                                      borderRadius: new BorderRadius.circular(5.0),
                                    ),
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        new Container(
                                          height: MediaQuery.of(context).size.height*0.07,
                                          color: Colors.transparent,
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              //Divider
                                              new Container(
                                                height: MediaQuery.of(context).size.height*0.07,
                                                width: MediaQuery.of(context).size.width*0.03,
                                              ),
                                              new Container(
                                                height: MediaQuery.of(context).size.height*0.05,
                                                width: MediaQuery.of(context).size.height*0.05,
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey[800],
                                                ),
                                                child: new ClipOval(
                                                  child: new Image.asset('lib/assets/userPhoto.png', fit: BoxFit.cover),
                                                ),
                                              ),
                                              //Divider
                                              new Container(
                                                height: MediaQuery.of(context).size.height*0.07,
                                                width: MediaQuery.of(context).size.width*0.03,
                                              ),
                                              new Container(
                                                child: new Text('David Morillo',
                                                style: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        new Container(
                                          height: MediaQuery.of(context).size.height*0.13,
                                          width: MediaQuery.of(context).size.width*0.80,
                                          color: Colors.transparent,
                                          child: new Center(
                                          child: new Padding(
                                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                          child: new Text('Hey guys, We are two producers in trap, and would like to create a record between these two styles. We already have created a part the track but need help on Future-House part 🙌.',
                                          style: new TextStyle(color: Colors.white),
                                          textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ),
                                        ),
                                        new Container(
                                          height: MediaQuery.of(context).size.height*0.10,
                                          width: MediaQuery.of(context).size.width*0.80,
                                          color: Colors.transparent,
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              new Container(
                                                height: MediaQuery.of(context).size.height*0.09,
                                                width: MediaQuery.of(context).size.height*0.09,
                                                decoration: new BoxDecoration(
                                                  color: Colors.grey[900].withOpacity(0.8),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: new Center(
                                                  child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        new Container(
                                          height: MediaQuery.of(context).size.height*0.08,
                                          width: MediaQuery.of(context).size.width*0.80,
                                          color: Colors.transparent,
                                          child: new Center(
                                            child: new Container(
                                              height: MediaQuery.of(context).size.height*0.05,
                                              width: MediaQuery.of(context).size.width*0.50,
                                              decoration: new BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius: new BorderRadius.circular(5.0),
                                                border: new Border.all(
                                                  width: 1.0,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            child: new InkWell(
                                              onTap: () { },
                                              child: new Container(
                                                child: new Center(
                                                child: new Text('Submit',
                                                style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                                                ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.02,
                                    width: MediaQuery.of(context).size.width*0.03,
                                  ),
                                  ],
                                );
                              }),
                          ),
                        ],
                      ),
                    ),
                  ],
                  ),
                )
                //MusicsContainer
                : new Container(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    new Container(
                      height: MediaQuery.of(context).size.height*0.30,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Divider
                          new Container(
                            width: MediaQuery.of(context).size.width,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //Divider
                                new Container(
                                  height: MediaQuery.of(context).size.height*0.01,
                                  width: MediaQuery.of(context).size.width*0.05,
                                ),
                                new Text('Future-house',
                                style: new TextStyle(color: Colors.grey[600],fontSize: 15.0, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                              new Container(
                                height: MediaQuery.of(context).size.height*0.25,
                                color: Colors.transparent,
                                child: new ListView.builder(
                                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                  controller: _futureHouseListViewController,
                                  scrollDirection: Axis.horizontal,
                                  physics: new ScrollPhysics(),
                                  itemCount: 10,
                                  itemBuilder: (BuildContext context, int item) {
                                    return new Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        new Container(
                                          height: MediaQuery.of(context).size.height*0.25,
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
                                                height: MediaQuery.of(context).size.height*0.18,
                                                width: MediaQuery.of(context).size.height*0.18,
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
                                                child: new Text('Aldos',
                                                style: new TextStyle(color: Colors.white,fontSize: 12.0, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              new Container(
                                                child: new Text('Something about you',
                                                style: new TextStyle(color: Colors.grey,fontSize: 10.0, fontWeight: FontWeight.w500),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ),
        ),
        _audioLaunched == true
        ? new Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              new InkWell(
                onTap: () {
                  showBarModalBottomSheet(
                    context: context, 
                    builder: (context){
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter modalSetState) {
                         return new Container(
                         height: MediaQuery.of(context).size.height*0.50,
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
                                  controller: _artistListTracks,
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
              child: new Container(
                height: MediaQuery.of(context).size.height*0.07,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[900],
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Container(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        new Container(
                          height: MediaQuery.of(context).size.height*0.07,
                          width: MediaQuery.of(context).size.height*0.08,
                          child: new Image.asset('lib/assets/background.jpg', fit: BoxFit.cover),
                        ),
                        //Divider
                        new Container(
                          height: MediaQuery.of(context).size.height*0.07,
                          width: MediaQuery.of(context).size.width*0.04,
                        ),
                        new Container(
                          height: MediaQuery.of(context).size.height*0.07,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new Container(
                                width: MediaQuery.of(context).size.width*0.50,
                                color: Colors.transparent,
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    new Text('Aldos', style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              new Container(
                                width: MediaQuery.of(context).size.width*0.50,
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    new Text('Something about you', style: new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ),
                        new Container(
                          height: MediaQuery.of(context).size.height*0.07,
                          width: MediaQuery.of(context).size.width*0.28,
                          color: Colors.transparent,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new IconButton(
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                icon: new Icon(Icons.pause_outlined, color: Colors.white, size: 30.0), 
                                onPressed: () {},
                                ),
                              new IconButton(
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                icon: new Icon(Icons.close, color: Colors.white, size: 30.0), 
                                onPressed: () {
                                  setState(() {
                                    _audioLaunched = false;
                                  });
                                },
                                ),
                            ],
                          ),
                        ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ),
              new Container(
                height: MediaQuery.of(context).size.height*0.09,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
            ],
          )
          )
          : new Container(),
        ],
       ),
        ),
      ),
    );
  }


  //
  Map<dynamic, dynamic> songsLikedMap;
  listenIfAlreadyliked() {
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .get().then((value) {
        if(value.exists) {
          if(this.mounted) {
            setState(() {
              songsLikedMap = value.data()['songsLiked'];
              print('songsLikedMap = $songsLikedMap');
            });
        }
      }
  });
  }

}