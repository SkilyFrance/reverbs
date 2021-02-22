import 'dart:io';
import 'package:SONOZ/DiscoverTab/profileDetails.dart';
import 'package:SONOZ/permissionsHandler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

import 'chat.dart';


class DiscussionsPage extends StatefulWidget {

  String currentUser;
  String currentUserPhoto;
  String currentUserUsername;

  DiscussionsPage({Key key, this.currentUser, this.currentUserUsername, this.currentUserPhoto}) : super(key: key);

  @override
  DiscussionsPageState createState() => DiscussionsPageState();
}

class DiscussionsPageState extends State<DiscussionsPage> {


  TextEditingController _searchBarTextEditingController = new TextEditingController();
  ScrollController _listDiscussionsController = new ScrollController();
  ScrollController _listOfContactsController = new ScrollController();



  @override
  void initState() {
    _searchBarTextEditingController = new TextEditingController();
    _listOfContactsController = new ScrollController();
    _listDiscussionsController = new ScrollController(initialScrollOffset: 0.0);
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
              largeTitle: new Text('Discussions',
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
                  showBarModalBottomSheet(
                    context: context, 
                    builder: (context){
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter modalSetState) {
                         return new Container(
                         height: MediaQuery.of(context).size.height*0.70,
                         width: MediaQuery.of(context).size.width,
                         color: Color(0xFF181818),
                         child: new Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             new Container(
                               height: MediaQuery.of(context).size.height*0.07,
                               width: MediaQuery.of(context).size.width,
                               color: Colors.grey[800].withOpacity(0.5),
                               constraints: new BoxConstraints(
                                 minHeight: 60.0,
                               ),
                               child: new Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                    new Container(
                                  height: MediaQuery.of(context).size.height*0.04,
                                  width: MediaQuery.of(context).size.width*0.80,
                                  color: Colors.transparent,
                                  constraints: new BoxConstraints(
                                    minHeight: 40.0,
                                  ),
                                    child: new CupertinoTextField(
                                        prefix: new Padding(
                                          padding: EdgeInsets.only(left: 20.0),
                                          child: new Icon(Icons.search, color: Colors.grey),
                                          ),
                                        placeholder: 'Search',
                                        placeholderStyle: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.normal),
                                        controller: _searchBarTextEditingController,
                                        cursorColor: Colors.blue,
                                        padding: EdgeInsets.only(left: 20.0),
                                        minLines: 1,
                                        maxLines: 1,
                                        keyboardType: TextInputType.text,
                                        decoration: new BoxDecoration(
                                          borderRadius: new BorderRadius.circular(10.0),
                                          color: Colors.grey[800],
                                        ),
                                        style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
                                      ),
                                ),
                                 ],
                               ),
                                ),
                                new Container(
                                  height: MediaQuery.of(context).size.height*0.63,
                                  child: new StreamBuilder(
                                    stream: FirebaseFirestore.instance.collection('users').snapshots(),
                                    builder: (BuildContext context, snapshot) {
                                      if(snapshot.connectionState == ConnectionState.waiting) {
                                      return new Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            new CupertinoActivityIndicator(radius: 6.0, animating: true),
                                            new Padding(
                                              padding: EdgeInsets.only(top: 30.0),
                                            child: new Text('Fetching datas',
                                            style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                            )),
                                          ],
                                        );
                                      }
                                      if(snapshot.hasError || !snapshot.hasData || snapshot.data.documents.isEmpty) {
                                      return new Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            new Icon(Icons.error, size: 30.0, color: Colors.white),
                                            new Padding(
                                              padding: EdgeInsets.only(top: 30.0),
                                            child: new Text('Check your network connection',
                                            style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                                            )),
                                          ],
                                        );
                                      }
                                      return new Container(
                                       child: new ListView.builder(
                                         padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
                                         shrinkWrap: true,
                                         itemCount: snapshot.data.documents.length,
                                         scrollDirection: Axis.vertical,
                                         controller: _listOfContactsController,
                                         physics: new ScrollPhysics(),
                                         itemBuilder: (BuildContext context, int index) {
                                           DocumentSnapshot ds = snapshot.data.documents[index];
                                           return new Container(
                                             height: MediaQuery.of(context).size.height*0.10,
                                             width: MediaQuery.of(context).size.width,
                                             child: new ListTile(
                                               onTap: () {
                                                 Navigator.pop(context);
                                                 Navigator.push(context, 
                                                 new CupertinoPageRoute(
                                                   builder: (context) => new ChatPage(
                                                     heroTag: ds.data()['uid'],
                                                     //CurrentUser datas
                                                     currentUser: widget.currentUser,
                                                     currentUserphoto: widget.currentUserPhoto,
                                                     currentUsername: widget.currentUserUsername,
                                                     //
                                                     conversationID: ds.data()['uid'],
                                                     titleOfConversation: ds.data()['userName'],
                                                     //RecipientData
                                                     recipientUID: ds.data()['uid'],
                                                     recipientUserPhoto: ds.data()['profilePhoto'],
                                                     recipientUsername: ds.data()['userName'],
                                                    )));
                                               },
                                               leading: new Container(
                                               height: MediaQuery.of(context).size.height*0.04,
                                               width: MediaQuery.of(context).size.height*0.04,
                                               constraints: new BoxConstraints(
                                                 minHeight: 30.0,
                                               ),
                                               child: new ClipOval(
                                                 child: ds.data()['profilePhoto'] != null
                                                  ? new Image.network(ds.data()['profilePhoto'], fit: BoxFit.cover)
                                                  : new Container(),
                                             )),
                                             title: new Text(ds.data()['userName'] != null
                                             ? ds.data()['userName']
                                             : ds.data()['userName'],
                                             style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                             ),
                                             trailing: new IconButton(
                                               icon: new Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey), 
                                               onPressed: (){
        
                                               })
                                             ),
                                           );
                                         },
                                       ),
                                        );
                                    }),
                                ),
                             ],
                            ),
                         );
                        },
                      );
                    });
                },
                ),
                ),
            ),
          ];
        }, 
        body: new SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              new Container(
                child: new StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users').doc(widget.currentUser).collection('discussions').orderBy('lastTimestamp', descending: true).snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if(snapshot.hasError) {
                      return new Container(
                        height: MediaQuery.of(context).size.height*0.60,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: new Center(
                        child: new Container(
                          height: MediaQuery.of(context).size.height*0.30,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              new Icon(Icons.error, size: 30.0, color: Colors.white),
                              new Padding(
                              padding: EdgeInsets.only(top: 30.0),
                              child: new Text('Check your network connection',
                              style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                              )),
                            ],
                        ),
                      )),
                    );
                    }
                    if(!snapshot.hasData || snapshot.data.documents.isEmpty) {
                      return new Container(
                        height: MediaQuery.of(context).size.height*0.60,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: new Center(
                        child: new Container(
                          height: MediaQuery.of(context).size.height*0.30,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              new Icon(Icons.more_horiz_rounded, size: 30.0, color: Colors.white),
                              new Padding(
                              padding: EdgeInsets.only(top: 30.0),
                              child: new Text('No conversation yet.',
                              style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                              )),
                            ],
                        ),
                      )),
                    );
                    }
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return new Container(
                        height: MediaQuery.of(context).size.height*0.60,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: new Center(
                        child: new Container(
                          height: MediaQuery.of(context).size.height*0.30,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            ],
                          ),
                          )),
                    );  
                    }
                    return new Container(
                      child: new ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        scrollDirection: Axis.vertical,
                        controller: _listDiscussionsController,
                        physics: new NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot ds = snapshot.data.documents[index];
                          return new Container(
                            height: MediaQuery.of(context).size.height*0.10,
                            width: MediaQuery.of(context).size.width,
                            child: new ListTile(
                              onTap: () {
                                Navigator.push(
                                  context, 
                                  new CupertinoPageRoute(builder: (context) => new ChatPage(
                                    heroTag: ds.data()['titleOfConversation'],
                                    //CurrentUser
                                    currentUser: widget.currentUser,
                                    currentUserphoto: widget.currentUserPhoto,
                                    currentUsername: widget.currentUserUsername,
                                    //RecipientUser
                                    recipientUID: ds.data()['recipientUID'],
                                    recipientUsername: ds.data()['recipientUsername'],
                                    recipientUserPhoto: ds.data()['recipientUserPhoto'],
                                    conversationID: ds.data()['conversationID'],
                                    titleOfConversation: ds.data()['titleOfConversation'],
                                    )));
                              },
                              leading: new Container(
                              height: MediaQuery.of(context).size.height*0.05,
                              width: MediaQuery.of(context).size.height*0.05,
                              child: new ClipOval(
                                child: ds.data()['coverOfConversation'] != null && ds.data()['coverOfConversation'] == 'reverbsImage'
                                ? new Image.asset('lib/assets/reverbsCover.png', fit: BoxFit.cover)
                                : ds.data()['coverOfConversation'] != null && ds.data()['coverOfConversation'] != 'reverbsImage'
                                ? new Image.network(ds.data()['coverOfConversation'], fit: BoxFit.cover)
                                : new Container(),
                            )),
                            title: new Text(ds.data()['titleOfConversation'] != null
                            ? ds.data()['titleOfConversation']
                            : 'Unknown',
                            style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                            subtitle: new Text(ds.data()['lastMessageContent'] != null && ds.data()['typeOfContent'] == 'track'
                            ? 'File audio'
                            : ds.data()['lastMessageContent'] != null && ds.data()['typeOfContent'] == 'text'
                            ? ds.data()['lastMessageContent']
                            : '',
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.normal),
                            ),
                            trailing: ds.data()['lastTimestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds.data()['lastTimestamp'])).inMinutes < 1
                              ? new Text('few sec', style: new TextStyle(color: Colors.grey))
                              : ds.data()['lastTimestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds.data()['lastTimestamp'])).inMinutes < 60
                              ? new Text(DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds.data()['lastTimestamp'])).inMinutes.toString() + ' min', style: new TextStyle(color: Colors.grey))
                              : ds.data()['lastTimestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds.data()['lastTimestamp'])).inMinutes >= 60
                              ? new Text(DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds.data()['lastTimestamp'])).inHours.toString() + ' hours', style: new TextStyle(color: Colors.grey))
                              : ds.data()['lastTimestamp'] != null && DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds.data()['lastTimestamp'])).inHours >= 24
                              ? new Text(DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(ds.data()['lastTimestamp'])).inDays.toString() + ' days', style: new TextStyle(color: Colors.grey))
                              : '',
                            ),
                          );
                        },
                      ),
                    );
                  }
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}