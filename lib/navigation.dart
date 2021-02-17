import 'package:SONOZ/DiscoverTab/discoverTab.dart';
import 'package:SONOZ/home/home.dart';
import 'package:SONOZ/profileOld.dart';
import 'package:SONOZ/services/notifications.dart';
import 'package:SONOZ/storage/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Discover/discoverPage.dart';
import 'chat/disccusions.dart';

class NavigationPage extends StatefulWidget {

  String currentUser;
  String currentUserUsername;
  String currentUserPhoto;

  NavigationPage({Key key, this.currentUser, this.currentUserUsername, this.currentUserPhoto}) : super(key: key);

  @override 
  NavigationPageState createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationPage> {
 

  @override 
  void initState() {
    print('currentUser = '+ widget.currentUser);
    currentScreen = new HomePage(
      currentUser: widget.currentUser,
      currentUserPhoto: widget.currentUserPhoto,
      currentUserUsername: widget.currentUserUsername,
    );
    currentTab = 0;
    super.initState();
  }


  
  //Active tab initialization
  int currentTab = 0; 
  final List<Widget> screens = [
    new HomePage(),
    new DiscoverPage(),
    new DiscussionsPage(),
    new StoragePage(),
  ];
  final PageStorageBucket bucket = new PageStorageBucket();
  Widget currentScreen;


  @override 
  Widget build(BuildContext context) {
    return new CupertinoTabScaffold(
      tabBar: new CupertinoTabBar(
        activeColor: Colors.white,
        backgroundColor: Colors.black.withOpacity(0.7),
        items: [
            new BottomNavigationBarItem(icon: new Icon(CupertinoIcons.house), label: 'Home'),
            new BottomNavigationBarItem(icon: new Icon(CupertinoIcons.search), label: 'Discover'),
            new BottomNavigationBarItem(icon: new Icon(CupertinoIcons.bubble_right), label: 'Discussions'),
            new BottomNavigationBarItem(icon: new Icon(CupertinoIcons.bell), label: 'Notifications'),
        ],
        ), 
      tabBuilder: (context, index) {
            switch (index) {
              case 0:
                return HomePage(
                  currentUser: widget.currentUser,
                  currentUserPhoto: widget.currentUserPhoto,
                  currentUserUsername: widget.currentUserUsername,
                );
                break;
              case 1:
                return DiscoverPage(
                  currentUser: widget.currentUser,
                  currentUserPhoto: widget.currentUserPhoto,
                  currentUserUsername: widget.currentUserUsername,
                );
                break;
              case 2:
                return DiscussionsPage(
                  currentUser: widget.currentUser,
                  currentUserPhoto: widget.currentUserPhoto,
                  currentUserUsername: widget.currentUserUsername,
                );
                break;
              default:
                return NotificationsPage(
                  currentUser: widget.currentUser,
                  currentUserProfilePhoto: widget.currentUserPhoto,
                  currentUsername: widget.currentUserUsername,
                );
                break;
            }
      },
      );
  }
}