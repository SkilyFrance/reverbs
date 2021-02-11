import 'dart:io';
import 'package:SONOZ/DiscoverTab/profileDetails.dart';
import 'package:SONOZ/permissionsHandler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String currentUserUsername;
  String currentUserType;

  DiscussionsPage({Key key, this.currentUser, this.currentUserUsername, this.currentUserType}) : super(key: key);

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
                                  child: new ListView.builder(
                                    padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
                                    shrinkWrap: true,
                                    itemCount: 50,
                                    scrollDirection: Axis.vertical,
                                    controller: _listOfContactsController,
                                    physics: new ScrollPhysics(),
                                    itemBuilder: (BuildContext context, int item) {
                                      return new Container(
                                        height: MediaQuery.of(context).size.height*0.10,
                                        width: MediaQuery.of(context).size.width,
                                        child: new ListTile(
                                          onTap: () {
                                            print('GoToConvers');
                                          },
                                          leading: new Container(
                                          height: MediaQuery.of(context).size.height*0.04,
                                          width: MediaQuery.of(context).size.height*0.04,
                                          constraints: new BoxConstraints(
                                            minHeight: 30.0,
                                          ),
                                          child: new ClipOval(child: new Image.asset('lib/assets/userPhoto.png', fit: BoxFit.cover),
                                        )),
                                        title: new Text('Festival project',
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
                          Navigator.push(context, new CupertinoPageRoute(builder: (context) => new ChatPage(heroTag: item.toString())));
                        },
                        leading: new Container(
                        height: MediaQuery.of(context).size.height*0.05,
                        width: MediaQuery.of(context).size.height*0.05,
                        child: new ClipOval(child: new Image.asset(item == 0 ? 'lib/assets/userPhoto.png' : 'lib/assets/user2.jpg', fit: BoxFit.cover),
                      )),
                      title: new Text(item == 0 ? 'Future house track' : 'Trap project',
                      style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: new Text(item == 0 ? 'Yes, last version has been sent this morning ...' : 'We know that it is gonna be huge ahah, right...',
                      style: new TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.normal),
                      ),
                      trailing: new Text('12:00',
                      style: new TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.normal),
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