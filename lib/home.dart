import 'package:SONOZ/DiscoverTab/discoverTab.dart';
import 'package:SONOZ/home/styleMusicTab.dart';
import 'package:SONOZ/home/uploadMusic.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'DiscoverTab/profileDetails.dart';
import 'profile.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'services/slideRoute.dart';

class HomePage extends StatefulWidget {

  String currentUser; 
  String currentUserType;
  String currentUserUsername;
  String currentUserPhoto;

  HomePage({Key key, this.currentUser, this.currentUserType, this.currentUserUsername, this.currentUserPhoto}) : super(key: key);




  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {


  TabController _tabController;
  PageController _pageController;
  ScrollController _scrollViewController;
  ScrollController _djListViewController;
  TextEditingController _searchTextEditingController = new TextEditingController();
  String artistQueryName;
  var top = 0.0;
  
  //
  bool inSearching = false;

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
    listenIfAlreadyliked();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new Container(
        color: Colors.black,
        child: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            setState(() {
              inSearching = false;
            });
          },
        child: new SingleChildScrollView(
          scrollDirection: Axis.vertical,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            new Container(
              height: MediaQuery.of(context).size.height*0.07,
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
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height*0.05,
                    width: MediaQuery.of(context).size.width,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Padding(
                          padding: EdgeInsets.only(left: 20.0),
                        child: new Container(
                          height: MediaQuery.of(context).size.height*0.06,
                          color: Colors.transparent,
                          child: new Text('Discover',
                          style: new TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
                          ),
                        )),
                        new Padding(
                          padding: EdgeInsets.only(right: 20.0),
                        child: new IconButton(
                          color: inSearching == true ? Colors.grey[900] : Colors.white,
                          icon: new Icon(Icons.search,
                          size: 30.0,
                          ), 
                          onPressed: (){
                            setState(() {
                            inSearching = true;
                            });
                          },
                          )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            /*new Container(
              height: MediaQuery.of(context).size.height*0.05,
              color: Colors.transparent,
              child: new Container(
                height: MediaQuery.of(context).size.height*0.05,
                width: MediaQuery.of(context).size.width*0.50,
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(5.0),
                  color: Colors.grey[900],
                ),
                child: new Center(
                  child: new TextField(
                    onChanged: (value) {

                    },
                    onTap: () {
                      setState(() {
                        inSearching = true;
                      });
                    },
                    controller: _searchTextEditingController,
                    cursorColor: Colors.grey,
                    keyboardType: TextInputType.text,
                    minLines: 1,
                    maxLines: 1,
                    style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.normal),
                    decoration: new InputDecoration(
                      hintText: 'Artist name ...',
                      hintStyle: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.normal),
                      contentPadding: new EdgeInsets.only(left: 10.0),
                      border: new OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),*/
            new Container(
              height: MediaQuery.of(context).size.height*0.03,
              color: Colors.transparent,
            ),
            inSearching == false
            ? new Container(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
            new Container(
              height: MediaQuery.of(context).size.height*0.05,
              color: Colors.transparent,
              child: new Center(
                child: new ListView(
                  scrollDirection: Axis.horizontal,
                  controller: _songStyleController,
                  padding: EdgeInsets.only(top: 3.0,left: 10.0, right: 20.0, bottom: 3.0),
                  children: [
                    //EDM
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: edmChoosen == true ? Colors.grey[900] :  Colors.transparent,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        listenIfAlreadyliked();
                        setState(() {
                          edmChoosen = true;
                          //
                          electroChoosen = false;
                          houseChoosen = false;
                          acidHouseChoosen = false;
                          futureHouseChoosen = false;
                          deepHouseChoosen = false;
                          chillHouseChoosen = false;
                          technoChoosen = false;
                          tranceChoosen = false;
                          progressiveChoosen = false;
                          minimaleChoosen = false;
                          dubstepChoosen = false;
                          trapChoosen = false;
                          dirtyDutchChoosen = false;
                          moombathtonChoosen = false;
                          hardstyleChoosen = false;
                        });
                      },
                       child: new Text('EDM',
                       style: new TextStyle(color: edmChoosen == true ? Colors.white : Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                       ))),
                    //ELECTRO
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: electroChoosen == true ? Colors.grey[900] :  Colors.transparent,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        listenIfAlreadyliked();
                        setState(() {
                          edmChoosen = false;
                          electroChoosen = true;
                          //
                          houseChoosen = false;
                          acidHouseChoosen = false;
                          futureHouseChoosen = false;
                          deepHouseChoosen = false;
                          chillHouseChoosen = false;
                          technoChoosen = false;
                          tranceChoosen = false;
                          progressiveChoosen = false;
                          minimaleChoosen = false;
                          dubstepChoosen = false;
                          trapChoosen = false;
                          dirtyDutchChoosen = false;
                          moombathtonChoosen = false;
                          hardstyleChoosen = false;
                        });
                      },
                       child: new Text('ELECTRO',
                       style: new TextStyle(color: electroChoosen == true ? Colors.white : Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                       ))),
                    //HOUSE
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: houseChoosen == true ? Colors.grey[900] :  Colors.transparent,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        listenIfAlreadyliked();
                        setState(() {
                          edmChoosen = false;
                          electroChoosen = false;
                          houseChoosen = true;
                          //
                          acidHouseChoosen = false;
                          futureHouseChoosen = false;
                          deepHouseChoosen = false;
                          chillHouseChoosen = false;
                          technoChoosen = false;
                          tranceChoosen = false;
                          progressiveChoosen = false;
                          minimaleChoosen = false;
                          dubstepChoosen = false;
                          trapChoosen = false;
                          dirtyDutchChoosen = false;
                          moombathtonChoosen = false;
                          hardstyleChoosen = false;
                        });
                      },
                       child: new Text('HOUSE',
                       style: new TextStyle(color: houseChoosen == true ? Colors.white : Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                       ))),
                    //ACID-HOUSE
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: acidHouseChoosen == true ? Colors.grey[900] :  Colors.transparent,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        listenIfAlreadyliked();
                        setState(() {
                          edmChoosen = false;
                          electroChoosen = false;
                          houseChoosen = false;
                          acidHouseChoosen = true;
                          //
                          futureHouseChoosen = false;
                          deepHouseChoosen = false;
                          chillHouseChoosen = false;
                          technoChoosen = false;
                          tranceChoosen = false;
                          progressiveChoosen = false;
                          minimaleChoosen = false;
                          dubstepChoosen = false;
                          trapChoosen = false;
                          dirtyDutchChoosen = false;
                          moombathtonChoosen = false;
                          hardstyleChoosen = false;
                        });
                      },
                       child: new Text('ACID-HOUSE',
                       style: new TextStyle(color: acidHouseChoosen == true ? Colors.white : Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                       ))),
                    //FUTURE-HOUSE
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: futureHouseChoosen == true ? Colors.grey[900] : Colors.transparent,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        listenIfAlreadyliked();
                       setState(() {
                         edmChoosen = false;
                         electroChoosen = false;
                         houseChoosen = false;
                         acidHouseChoosen = false;
                         futureHouseChoosen = true;
                         //
                         deepHouseChoosen = false;
                         chillHouseChoosen = false;
                         technoChoosen = false;
                         tranceChoosen = false;
                         progressiveChoosen = false;
                         minimaleChoosen = false;
                         dubstepChoosen = false;
                         trapChoosen = false;
                         dirtyDutchChoosen = false;
                         moombathtonChoosen = false;
                         hardstyleChoosen = false;
                       });
                      },
                       child: new Text('FUTURE-HOUSE',
                       style: new TextStyle(color: futureHouseChoosen == true ? Colors.white : Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                       ))),
                    //DEEPHOUSE
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: deepHouseChoosen == true ? Colors.grey[900] : Colors.transparent,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                      listenIfAlreadyliked();
                      setState(() {
                        edmChoosen = false;
                        electroChoosen = false;
                        houseChoosen = false;
                        acidHouseChoosen = false;
                        futureHouseChoosen = false;
                        deepHouseChoosen = true;
                        //
                        chillHouseChoosen = false;
                        technoChoosen = false;
                        tranceChoosen = false;
                        progressiveChoosen = false;
                        minimaleChoosen = false;
                        dubstepChoosen = false;
                        trapChoosen = false;
                        dirtyDutchChoosen = false;
                        moombathtonChoosen = false;
                        hardstyleChoosen = false;
                      });
                      },
                       child: new Text('DEEP-HOUSE',
                       style: new TextStyle(color: deepHouseChoosen == true ? Colors.white : Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                       ))),
                    //CHILL-HOUSE
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: chillHouseChoosen == true ? Colors.grey[900] : Colors.transparent,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        listenIfAlreadyliked();
                      setState(() {
                        edmChoosen = false;
                        electroChoosen = false;
                        houseChoosen = false;
                        acidHouseChoosen = false;
                        futureHouseChoosen = false;
                        deepHouseChoosen = false;
                        chillHouseChoosen = true;
                        //
                        technoChoosen = false;
                        tranceChoosen = false;
                        progressiveChoosen = false;
                        minimaleChoosen = false;
                        dubstepChoosen = false;
                        trapChoosen = false;
                        dirtyDutchChoosen = false;
                        moombathtonChoosen = false;
                        hardstyleChoosen = false;
                      });  
                      },
                       child: new Text('CHILL-HOUSE',
                       style: new TextStyle(color: chillHouseChoosen == true ? Colors.white : Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                       ))),
                    //TECHNO
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: technoChoosen == true ? Colors.grey[900] : Colors.transparent,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        listenIfAlreadyliked();
                      setState(() {
                        edmChoosen = false;
                        electroChoosen = false;
                        houseChoosen = false;
                        acidHouseChoosen = false;
                        futureHouseChoosen = false;
                        deepHouseChoosen = false;
                        chillHouseChoosen = false;
                        technoChoosen = true;
                        //
                        tranceChoosen = false;
                        progressiveChoosen = false;
                        minimaleChoosen = false;
                        dubstepChoosen = false;
                        trapChoosen = false;
                        dirtyDutchChoosen = false;
                        moombathtonChoosen = false;
                        hardstyleChoosen = false;
                      });
                      },
                       child: new Text('TECHNO',
                       style: new TextStyle(color: technoChoosen == true ? Colors.white : Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                       ))),
                    //TRANCE
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: tranceChoosen == true ? Colors.grey[900] : Colors.transparent,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        listenIfAlreadyliked();
                      setState(() {
                        edmChoosen = false;
                        electroChoosen = false;
                        houseChoosen = false;
                        acidHouseChoosen = false;
                        futureHouseChoosen = false;
                        deepHouseChoosen = false;
                        chillHouseChoosen = false;
                        technoChoosen = false;
                        tranceChoosen = true;
                        //
                        progressiveChoosen = false;
                        minimaleChoosen = false;
                        dubstepChoosen = false;
                        trapChoosen = false;
                        dirtyDutchChoosen = false;
                        moombathtonChoosen = false;
                        hardstyleChoosen = false;
                      });
                      },
                       child: new Text('TRANCE',
                       style: new TextStyle(color: tranceChoosen == true ? Colors.white : Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                       ))),
                    //PROGRESSIVE
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: progressiveChoosen == true ? Colors.grey[900] : Colors.transparent,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        listenIfAlreadyliked();
                      setState(() {
                        edmChoosen = false;
                        electroChoosen = false;
                        houseChoosen = false;
                        acidHouseChoosen = false;
                        futureHouseChoosen = false;
                        deepHouseChoosen = false;
                        chillHouseChoosen = false;
                        technoChoosen = false;
                        tranceChoosen = false;
                        progressiveChoosen = true;
                        //
                        minimaleChoosen = false;
                        dubstepChoosen = false;
                        trapChoosen = false;
                        dirtyDutchChoosen = false;
                        moombathtonChoosen = false;
                        hardstyleChoosen = false;
                      });
                      },
                       child: new Text('PROGRESSIVE',
                       style: new TextStyle(color: progressiveChoosen == true ? Colors.white : Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                       ))),
                    //MINIMALE
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: minimaleChoosen == true ? Colors.grey[900] : Colors.transparent,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        listenIfAlreadyliked();
                      setState(() {
                        edmChoosen = false;
                        electroChoosen = false;
                        houseChoosen = false;
                        acidHouseChoosen = false;
                        futureHouseChoosen = false;
                        deepHouseChoosen = false;
                        chillHouseChoosen = false;
                        technoChoosen = false;
                        tranceChoosen = false;
                        progressiveChoosen = false;
                        minimaleChoosen = true;
                        //
                        dubstepChoosen = false;
                        trapChoosen = false;
                        dirtyDutchChoosen = false;
                        moombathtonChoosen = false;
                        hardstyleChoosen = false;
                      });
                      },
                       child: new Text('MINIMALE',
                       style: new TextStyle(color: minimaleChoosen == true ? Colors.white : Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                       ))),
                    //DUBSTEP
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: dubstepChoosen == true ? Colors.grey[900] : Colors.transparent,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        listenIfAlreadyliked();
                      setState(() {
                        edmChoosen = false;
                        electroChoosen = false;
                        houseChoosen = false;
                        acidHouseChoosen = false;
                        futureHouseChoosen = false;
                        deepHouseChoosen = false;
                        chillHouseChoosen = false;
                        technoChoosen = false;
                        tranceChoosen = false;
                        progressiveChoosen = false;
                        minimaleChoosen = false;
                        dubstepChoosen = true;
                        //
                        trapChoosen = false;
                        dirtyDutchChoosen = false;
                        moombathtonChoosen = false;
                        hardstyleChoosen = false;
                      });
                      },
                       child: new Text('DUBSTEP',
                       style: new TextStyle(color: dubstepChoosen == true ? Colors.white : Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                       ))),
                    //Trap
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: trapChoosen == true ? Colors.grey[900] : Colors.transparent,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        listenIfAlreadyliked();
                      setState(() {
                        edmChoosen = false;
                        electroChoosen = false;
                        houseChoosen = false;
                        acidHouseChoosen = false;
                        futureHouseChoosen = false;
                        deepHouseChoosen = false;
                        chillHouseChoosen = false;
                        technoChoosen = false;
                        tranceChoosen = false;
                        progressiveChoosen = false;
                        minimaleChoosen = false;
                        dubstepChoosen = false;
                        trapChoosen = true;
                        //
                        dirtyDutchChoosen = false;
                        moombathtonChoosen = false;
                        hardstyleChoosen = false;
                      });
                      },
                       child: new Text('TRAP',
                       style: new TextStyle(color: trapChoosen == true ? Colors.white : Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                       ))),
                    //DIRTY DUTCH
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: dirtyDutchChoosen == true ? Colors.grey[900] : Colors.transparent,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        listenIfAlreadyliked();
                       setState(() {
                         edmChoosen = false;
                         electroChoosen = false;
                         houseChoosen = false;
                         acidHouseChoosen = false;
                         futureHouseChoosen = false;
                         deepHouseChoosen = false;
                         chillHouseChoosen = false;
                         technoChoosen = false;
                         tranceChoosen = false;
                         progressiveChoosen = false;
                         minimaleChoosen = false;
                         dubstepChoosen = false;
                         trapChoosen = false;
                         dirtyDutchChoosen = true;
                         //
                         moombathtonChoosen = false;
                         hardstyleChoosen = false;
                       });
                      },
                       child: new Text('DIRTY-DUTCH',
                       style: new TextStyle(color: dirtyDutchChoosen == true ? Colors.white : Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                       ))),
                    //MOOMBAHTON
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: moombathtonChoosen == true ? Colors.grey[900] : Colors.transparent,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        listenIfAlreadyliked();
                      setState(() {
                        edmChoosen = false;
                        electroChoosen = false;
                        houseChoosen = false;
                        acidHouseChoosen = false;
                        futureHouseChoosen = false;
                        deepHouseChoosen = false;
                        chillHouseChoosen = false;
                        technoChoosen = false;
                        tranceChoosen = false;
                        progressiveChoosen = false;
                        minimaleChoosen = false;
                        dubstepChoosen = false;
                        trapChoosen = false;
                        dirtyDutchChoosen = false;
                        moombathtonChoosen = true;
                        //
                        hardstyleChoosen = false;
                      });
                      },
                       child: new Text('MOOMBAHTON',
                       style: new TextStyle(color: moombathtonChoosen == true ? Colors.white : Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                       ))),
                    //HARDSTYLE
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: hardstyleChoosen == true ? Colors.grey[900] : Colors.transparent,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        listenIfAlreadyliked();
                      setState(() {
                        edmChoosen = false;
                        electroChoosen = false;
                        houseChoosen = false;
                        acidHouseChoosen = false;
                        futureHouseChoosen = false;
                        deepHouseChoosen = false;
                        chillHouseChoosen = false;
                        technoChoosen = false;
                        tranceChoosen = false;
                        progressiveChoosen = false;
                        minimaleChoosen = false;
                        dubstepChoosen = false;
                        trapChoosen = false;
                        dirtyDutchChoosen = false;
                        moombathtonChoosen = false;
                        hardstyleChoosen = true;
                        //
                      }); 
                      },
                       child: new Text('HARDSTYLE',
                       style: new TextStyle(color: hardstyleChoosen == true ? Colors.white : Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                       ))),
                  ],
                ),
              ),
              ),
              new Container(
                child: new StyleMusicTab(
                  songsLikedMap: songsLikedMap,
                  currentUser: widget.currentUser, 
                  currentUserUsername: widget.currentUserUsername, 
                  style: edmChoosen == true ? 'edm' : electroChoosen == true ? 'electro' : houseChoosen == true ? 'house' : acidHouseChoosen == true ? 'acidHouse' : futureHouseChoosen == true ? 'futureHouse' : deepHouseChoosen == true ? 'deepHouse' : chillHouseChoosen == true ? 'chillHouse' : technoChoosen == true ? 'techno' : tranceChoosen == true ? 'trance' : progressiveChoosen == true ? 'progressive' : minimaleChoosen == true ? 'minimale' : dubstepChoosen == true ? 'dubstep' :  trapChoosen == true ? 'trap' : dirtyDutchChoosen == true ? 'dirtyDuctch' : moombathtonChoosen == true ? 'moombathton' : hardstyleChoosen == true ? 'hardstyle' : 'edm')
                ),
                ],
              ),
            )
            : new Container(
              child: new Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
                child: new StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users').where('iam', isEqualTo: 'iamDJ').snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if(!snapshot.hasData){
                      return new Container();
                    }
                    if(snapshot.data.documents.isEmpty) {
                      return new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          new Container(
                            height: MediaQuery.of(context).size.height*0.06,
                            child: new Center(
                              child: new Text("No found your favorite artist ?",
                              style: new TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),
                              ),
                              ),
                          ),
                          new Container(
                            height: MediaQuery.of(context).size.height*0.06,
                            child: new Center(
                              child: new Text("Invite her/him to join us.",
                              style: new TextStyle(color: Colors.grey, fontSize: 18.0, fontWeight: FontWeight.w600),
                              ),
                              ),
                          ),
                              new Container(
                              height: MediaQuery.of(context).size.height*0.06,
                              width: MediaQuery.of(context).size.width*0.40,
                            child: new Center(
                              child: new FlatButton(
                                color: Colors.yellowAccent,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(5.0),
                                ),
                                
                                onPressed: () {
                                  print('Share Reverb');
                                }, 
                                child: new Center(
                                  child: new Text('INVITE',
                                  style: new TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ),
                              ),
                          ),
                        ],
                      );
                    }
                    return new Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: new ListView.builder(
                        scrollDirection: Axis.vertical,
                        controller: _djListViewController,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot ds = snapshot.data.documents[index];
                          return new Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                          child: new InkWell(
                            onTap: () {
                              Navigator.push(
                                context, 
                                new MaterialPageRoute(builder: (context) => new ProfilDetailsPage(
                                  currentUser: widget.currentUser,
                                  artistUID: ds.data()['uid'],
                                  artistUsername: ds.data()['userName'],
                                  artistProfilePhoto: ds.data()['profilePhoto'],
                                )));
                            },
                          child: new ListTile(
                            tileColor: Colors.grey[900].withOpacity(0.4),
                            leading: new Container(
                              height: 40.0,
                              width: 40.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[900],
                              ),
                              child: ds.data()['profilePhoto'] != null
                              ? new ClipOval(child: new Image.network(ds.data()['profilePhoto'], fit: BoxFit.cover))
                              : new Container(),
                            ),
                            title: new Center(
                              child: new Text(
                                ds.data()['userName'] != null
                                ? ds.data()['userName']
                                : 'Username',
                                style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                            trailing: new Icon(Icons.keyboard_arrow_right_outlined, color: Colors.grey, size: 35.0)
                          )));
                        }),
                    );
                  }),
              ),
            ),
          ],
        ),
      ),
    )
    ),
    floatingActionButton: widget.currentUserType == 'iamDJ'
    ? new Padding(
      padding: EdgeInsets.only(right: 10.0, bottom: 10.0),
      child: new FloatingActionButton.extended(
      label: new Text('Publish',
      style: new TextStyle(color: Colors.black, fontSize: 14.0,fontWeight: FontWeight.bold),
      ),
      shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      backgroundColor: Colors.yellowAccent,
      elevation: 5.0,
      onPressed: () {
        Navigator.push(context, new SlideBottomRoute(page: new UploadMusicPage(
          currentUser: widget.currentUser, 
          currentUserUserName: widget.currentUserUsername, 
          currentUserPhoto: widget.currentUserPhoto)));
      },
      ))
      : new Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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