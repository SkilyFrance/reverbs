import 'package:SONOZ/DiscoverTab/discoverTab.dart';
import 'package:SONOZ/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'following.dart';

class NavigationPage extends StatefulWidget {

  String currentUser;
  String currentUserType;
  String currentUserUsername;
  String currentUserPhoto;

  NavigationPage({Key key, this.currentUser, this.currentUserType, this.currentUserUsername, this.currentUserPhoto}) : super(key: key);

  @override 
  NavigationPageState createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationPage> {
 

  @override 
  void initState() {
    currentScreen = new HomePage(currentUser: widget.currentUser, currentUserType: widget.currentUserType, currentUserUsername: widget.currentUserUsername, currentUserPhoto: widget.currentUserPhoto);
    currentTab = 0;
    super.initState();
  }


  
  //Active tab initialization
  int currentTab = 0; 
  final List<Widget> screens = [
    new HomePage(),
    new FollowingPage(),
    new ProfilePage(),
  ];
  final PageStorageBucket bucket = new PageStorageBucket();
  Widget currentScreen;


  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: new PageStorage(
        bucket: bucket, 
        child: currentScreen,
        ),
        bottomNavigationBar: new BottomAppBar(
          color: Colors.black,
          elevation: 0.0,
          child: new Container(
            height: 50.0,
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(20.0),
              color: Colors.transparent,
            ),
            child: new Padding(
              padding: EdgeInsets.only(top: 5.0),
            child: widget.currentUserType == 'iamDJ'
            ? new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                  new MaterialButton(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Image.asset(currentTab == 0 ? 'lib/assets/homeActive.png' : 'lib/assets/home.png', color: currentTab == 0 ? Colors.white : Colors.grey, height: 19.0, width: 19.0),
                        new Text('Home', 
                        style: new TextStyle(color: currentTab == 0 ? Colors.white : Colors.grey, fontSize: 10.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    minWidth: 20.0,
                    onPressed: (){
                      setState(() {
                        currentScreen = new HomePage(
                          currentUser: widget.currentUser,
                          currentUserType: widget.currentUserType,
                          currentUserUsername: widget.currentUserUsername,
                          currentUserPhoto: widget.currentUserPhoto,
                        );
                        currentTab = 0;
                      });
                    },
                    ),
                new MaterialButton(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Image.asset('lib/assets/subscription.png' , color: currentTab == 1 ? Colors.white : Colors.grey, height: 20.0, width: 20.0,),
                        new Text('Following', 
                        style: new TextStyle(color: currentTab == 1 ? Colors.white : Colors.grey, fontSize: 10.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  minWidth: 40.0,
                  onPressed: (){
                      setState(() {
                        currentScreen = new FollowingPage(
                          currentUser: widget.currentUser,
                          currentUserUsername: widget.currentUserUsername,
                          currentUserType: widget.currentUserType,
                        );
                        currentTab = 1;
                      });
                  },
                  ),
                  new MaterialButton(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Image.asset( currentTab == 2 ? 'lib/assets/userActive.png' : 'lib/assets/user.png' , color: currentTab == 2 ? Colors.white : Colors.grey, height: 20.0, width: 20.0,),
                        new Text('Profile', 
                        style: new TextStyle(color: currentTab == 2 ? Colors.white : Colors.grey, fontSize: 10.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  minWidth: 40.0,
                  onPressed: (){
                      setState(() {
                        currentScreen = new ProfilePage(
                          currentUser: widget.currentUser,
                          currentUserUsername: widget.currentUserUsername,
                          currentUserPhoto: widget.currentUserPhoto,
                          );
                        currentTab = 2;
                      });
                  },
                  ),
              ],
            )
////// USER IS A FAN /////////
            : new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                  new MaterialButton(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Image.asset(currentTab == 0 ? 'lib/assets/homeActive.png' : 'lib/assets/home.png', color: currentTab == 0 ? Colors.white : Colors.grey, height: 19.0, width: 19.0),
                        new Text('Home', 
                        style: new TextStyle(color: currentTab == 0 ? Colors.white : Colors.grey, fontSize: 10.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    minWidth: 20.0,
                    onPressed: (){
                      setState(() {
                        currentScreen = new HomePage(
                          currentUser: widget.currentUser,
                          currentUserType: widget.currentUserType,
                          currentUserUsername: widget.currentUserUsername,
                          currentUserPhoto: widget.currentUserPhoto,
                        );
                        currentTab = 0;
                      });
                    },
                    ),
                new MaterialButton(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Image.asset('lib/assets/subscription.png' , color: currentTab == 1 ? Colors.white : Colors.grey, height: 20.0, width: 20.0,),
                        new Text('Following', 
                        style: new TextStyle(color: currentTab == 1 ? Colors.white : Colors.grey, fontSize: 10.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  minWidth: 40.0,
                  onPressed: (){
                      setState(() {
                        currentScreen = new FollowingPage(
                          currentUser: widget.currentUser,
                          currentUserUsername: widget.currentUserUsername,
                          currentUserType: widget.currentUserType,
                        );
                        currentTab = 1;
                      });
                  },
                  ),
              ],
            ),
            ),
          ),
          ),
    );
  }
}