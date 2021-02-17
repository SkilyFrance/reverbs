import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


class ChatPage extends StatefulWidget {

  //CurrentUserDatas
  String currentUser;
  String currentUserphoto;
  String currentUsername;
  //RecipientUserDatas
  String recipientUserUID;
  String recipientUserPhoto;
  String recipientUserUsername;

  final String heroTag;


  ChatPage({Key key, 
  this.currentUser,
  this.currentUserphoto,
  this.currentUsername,
  this.recipientUserUID,
  this.recipientUserPhoto,
  this.recipientUserUsername,
  this.heroTag,
  }) : super(key: key);


  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {

  ScrollController _messagesListViewBuilder = new ScrollController(initialScrollOffset: 0.0);
  ScrollController _listMusicController = new ScrollController();
  TextEditingController _messageTextController = new TextEditingController();
  FocusNode _textFieldFocusNode = new FocusNode();

  //AudioPlayerVariables
  AudioPlayer audioPlayer;
  String _trackChoosenToListen;
  bool _audioIsInitializing = false;
  bool _audioLaunched = false;

  //List booleans
  bool _textFieldDeploy = false;
  bool _textFieldOnChanged = false;
  String _fileMusicURL;
  int _fileMusicDuration;
  String _fileMusicTitle;
  int tabTracksSelected = 0;

  @override
  void initState() {
    audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
    _messagesListViewBuilder = new ScrollController(initialScrollOffset: 0.0);
    _listMusicController = new ScrollController();
    _textFieldFocusNode = new FocusNode();
    _messageTextController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: new CupertinoNavigationBar(
        heroTag: widget.heroTag,
        transitionBetweenRoutes: false,
        backgroundColor: Colors.black.withOpacity(0.5),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios_rounded, color: Colors.grey, size: 25.0),
          onPressed: () {Navigator.pop(context);}),
          middle: new Text(widget.recipientUserUsername != null
          ? widget.recipientUserUsername
          : 'Unknown',
          style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
          ),
            ),
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
      child: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: new Stack(
          children: [
            new Positioned(
              top: 0.0,
              right: 0.0,
              left: 0.0,
              bottom: 0.0,
              child: new Container(
                color: Colors.transparent,
                child: new StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users').doc(widget.currentUser).collection('discussions').doc(widget.recipientUserUID).collection('messages').orderBy('timestamp', descending: true).snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if(snapshot.hasError) {return new Container();}
                    if(!snapshot.hasData || snapshot.data.documents.isEmpty) {return new Container();}
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return new Container(
                        height: MediaQuery.of(context).size.height*0.30,
                        width: MediaQuery.of(context).size.height,
                        child: new Center(
                          /*child: new CupertinoActivityIndicator(
                            animating: true,radius: 13.0,),*/
                            ),
                        );
                        }
                        return new Container(
                          child: new ListView.builder(
                            padding: EdgeInsets.only(top: 50.0, bottom: 110.0),
                            reverse: true,
                            shrinkWrap: true,
                            controller: _messagesListViewBuilder,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              DocumentSnapshot ds = snapshot.data.documents[index];
                              return new Container(
                                child: new ListTile(
                                  contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
                                  leading: new Container(
                                  height: MediaQuery.of(context).size.height*0.04,
                                  width: MediaQuery.of(context).size.height*0.04,
                                  child: new ClipOval(
                                    child: ds.data()['senderPhoto'] != null
                                    ? new Image.network(ds.data()['senderPhoto'], fit: BoxFit.cover)
                                    : new Container(),
                                )),
                                subtitle: ds.data()['typeOfContent'] == 'track'
                                ? new Container(
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      new Container(
                                        height: MediaQuery.of(context).size.height*0.05,
                                        width: MediaQuery.of(context).size.height*0.05,
                                        decoration: new BoxDecoration(
                                          color: ds.data()['fromMe'] == true ? Colors.deepPurpleAccent : Colors.grey[900],
                                          shape: BoxShape.circle,
                                        ),
                                        child: new Padding(
                                          padding: EdgeInsets.all(0.0),
                                          child: _trackChoosenToListen == ds.data()['content'] && _audioIsInitializing == true
                                          ? new CupertinoActivityIndicator(radius: 6.0, animating: true)
                                          //
                                          : _trackChoosenToListen == ds.data()['content'] && _audioIsInitializing == false && _audioLaunched == true
                                          ? new IconButton(
                                            alignment: Alignment.center,
                                            onPressed: (){
                                              audioPlayer.stop().whenComplete(() {
                                                setState(() {
                                                  _audioIsInitializing = false;
                                                  _audioLaunched = false;
                                                  _trackChoosenToListen = '';
                                                });
                                                print(('AudioPlayer : Stop'));
                                              });
                                            },
                                          icon: new Icon(Icons.stop, color: Colors.white, size: 30.0))
                                          : new IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _trackChoosenToListen = ds.data()['content'];
                                                _audioIsInitializing = true;
                                              });
                                              AudioPlayer.logEnabled = true;
                                                audioPlayer.play(ds.data()['content'], volume: 1.0).whenComplete(() {
                                                setState(() {
                                                  _audioIsInitializing = false;
                                                  _audioLaunched = true;
                                                  print(('AudioPlayer : Play'));
                                                });
                                              });
                                            },
                                          icon: new Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30.0)),
                                        ),
                                      ),
                                      new Padding(
                                        padding: EdgeInsets.only(top: 5.0,left: 10.0),
                                        child: new Text(ds.data()['title'] != null
                                        ? '-  ' + ds.data()['title']
                                        : 'Unknown',
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : new Container(
                                  decoration: new BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: new BorderRadius.circular(20.0)
                                  ),
                                child: new Padding(
                                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 15.0),
                                child: new Text(
                                  ds.data()['content'] != null
                                  ? ds.data()['content'].toString()
                                  : '',
                                textAlign: TextAlign.left,
                                style: new TextStyle(color: ds.data()['fromMe'] == true 
                                 ? Colors.purpleAccent : Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                                ))),
                                ),
                              );
                            },
                          ),
                        );
                  }),
              ),
              ),
              new Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    new Container(
                      width: MediaQuery.of(context).size.width,
                       constraints: new BoxConstraints(
                         minHeight: MediaQuery.of(context).size.height*0.08,
                         //maxHeight: MediaQuery.of(context).size.height*0.08,
                       ),
                      color: Colors.black.withOpacity(0.9),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        //Divider
                        new Container(
                          height: MediaQuery.of(context).size.height*0.01,
                          width: MediaQuery.of(context).size.width,
                        ),
                        new Padding(
                          padding: EdgeInsets.all(10.0),
                        child: new Container(
                          width: MediaQuery.of(context).size.width,
                          constraints: new BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height*0.05,
                            //maxHeight: MediaQuery.of(context).size.height*0.11,
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new Container(
                                width: _textFieldOnChanged == false ? MediaQuery.of(context).size.width*0.80 : MediaQuery.of(context).size.width*0.90, 
                                constraints: new BoxConstraints(
                                  minHeight: MediaQuery.of(context).size.height*0.05,
                                  maxHeight: MediaQuery.of(context).size.height*0.11,
                                ),
                                child: new CupertinoTextField(
                                  placeholder: 'Aa',
                                  placeholderStyle: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                                  keyboardAppearance: Brightness.dark,
                                  suffix: new Padding(
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: new InkWell(
                                      onTap: () {
                                        sendMessageAndCreateDiscussion();
                                        _messagesListViewBuilder.animateTo(0.0, duration: new Duration(milliseconds: 500),curve: Curves.fastLinearToSlowEaseIn);
                                      },
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                     child: new Text('SENT',
                                  style: new TextStyle(color: _textFieldOnChanged == true ? Colors.purpleAccent : Colors.grey, fontSize: 12.0, fontWeight: FontWeight.bold),
                                  ))),
                                  controller: _messageTextController,
                                  autocorrect: true,
                                  scrollPhysics: new ScrollPhysics(),
                                   onSubmitted: (value) {
                                     sendMessageAndCreateDiscussion();
                                     _messagesListViewBuilder.animateTo(0.0, duration: new Duration(milliseconds: 500),curve: Curves.fastLinearToSlowEaseIn);

                                   },
                                  onChanged: (value) {
                                    if(_messageTextController.text.length > 0 && _messageTextController.text.length == 1) {
                                      setState(() {
                                        _textFieldOnChanged = true;
                                      });
                                    } else if (_messageTextController.text.length == 0) {
                                      setState(() {
                                        _textFieldOnChanged = false;
                                      });
                                    }
                                  },
                                  onTap: () {
                                     _messagesListViewBuilder.animateTo(0.0, duration: new Duration(milliseconds: 500),curve: Curves.fastLinearToSlowEaseIn);
                                  },
                                focusNode: _textFieldFocusNode,
                                expands: true,
                                cursorColor: Colors.white,
                                padding: EdgeInsets.all(15.0),
                                minLines: null,
                                maxLines: null,
                                keyboardType: TextInputType.text,
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(30.0),
                                  color: Colors.grey[900],
                                ),
                                style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w500),
                                ),
                              ),
                              _textFieldOnChanged == false ?
                              new Container(
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    new IconButton(
                                      icon: new Icon(Icons.music_note_outlined, color: Colors.deepPurpleAccent, size: 25.0), 
                                      onPressed: () {
                                        showBarModalBottomSheet(
                                          context: context,
                                          builder: (context) {
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
                                                        height: MediaQuery.of(context).size.height*0.03,
                                                        width: MediaQuery.of(context).size.width,
                                                        color: Colors.transparent,
                                                      ),
                                                      new Container(
                                                        child: new Center(
                                                          child: new Text(
                                                            'Send a track',
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
                                                              modalSetState(() {
                                                              tabTracksSelected = value;
                                                              });
                                                          })),
                                                          new Container(
                                                            height: MediaQuery.of(context).size.height*0.20,
                                                            child: new FutureBuilder(
                                                              future: FirebaseFirestore.instance.collection('users').doc(widget.currentUser).collection(tabTracksSelected == 0 ? 'demoTracks' : tabTracksSelected == 1 ? 'unreleasedTracks' : 'releasedTracks').get(),
                                                              builder: (BuildContext context, snapshot) {
                                                                if(snapshot.connectionState == ConnectionState.waiting) {
                                                                return new Container(
                                                                  color: Colors.transparent,
                                                                  child: new Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      ],
                                                                      ),
                                                                    );
                                                                }
                                                                if(snapshot.hasError) {
                                                                return new Container(
                                                                  color: Colors.grey[900].withOpacity(0.5),
                                                                  child: new Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      new Center(child: new Text('Check your network connection.', style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold))),
                                                                      new Padding(
                                                                        padding: EdgeInsets.only(top: 30.0),
                                                                      child: new Icon(Icons.network_check_outlined, color: Colors.grey, size: 40.0),
                                                                      ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                }
                                                                if(!snapshot.hasData) {
                                                                return new Container(
                                                                  color: Colors.grey[900].withOpacity(0.5),
                                                                  child: new Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: [
                                                                      new Center(child: new Text('No track here.', style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold))),
                                                                      new Center(child: new Text('Upload a track to storage tab', style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.bold))),
                                                                      new Center(child: new Text('before find it here.', style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.bold))),
                                                                        ],
                                                                      ),
                                                                    );
                                                                }
                                                                if(snapshot.data.documents.isEmpty){
                                                                return new Container(
                                                                  color: Colors.grey[900].withOpacity(0.5),
                                                                  child: new Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: [
                                                                      new Center(child: new Text('No track here.', style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold))),
                                                                      new Center(child: new Text('Upload a track to storage tab', style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.bold))),
                                                                      new Center(child: new Text('before find it here.', style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.bold))),
                                                                        ],
                                                                      ),
                                                                    );
                                                                }
                                                            return new ListView.builder(
                                                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                                              controller: _listMusicController,
                                                              scrollDirection: Axis.horizontal,
                                                              physics: new ScrollPhysics(),
                                                              itemCount: snapshot.data.documents.length,
                                                              itemBuilder: (BuildContext context, int index) {
                                                                DocumentSnapshot ds = snapshot.data.documents[index];
                                                                return StatefulBuilder(
                                                                  builder: (BuildContext context, setListViewState) {
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
                                                                              modalSetState(() {
                                                                                _fileMusicURL = ds.data()['fileMusicURL'];
                                                                                _fileMusicDuration = ds.data()['fileMusicDuration'];
                                                                                _fileMusicTitle = ds.data()['title'];
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
                                                                              child: ds.data()['coverImage'] != null
                                                                              ? new Image.network(ds.data()['coverImage'], fit: BoxFit.cover)
                                                                              : new Container(),
                                                                                ),
                                                                                ),
                                                                                _fileMusicURL == ds.data()['fileMusicURL']
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
                                                                                  child: new Text(
                                                                                    ds.data()['title'] != null
                                                                                    ? ds.data()['title'].toString()
                                                                                    : '',
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
                                                                );
                                                              }
                                                            );
                                                              }
                                                              ),
                                                          ),
                                                          ],
                                                        ),
                                                      ),
                                                          _fileMusicURL != null
                                                          ? new Padding(
                                                            padding: EdgeInsets.only(top: 5.0),
                                                          child: new CupertinoButton(
                                                            color: Colors.deepPurpleAccent,
                                                            child: new Text('SEND', style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold)), 
                                                            onPressed: () {
                                                              sendATrack();
                                                            }))
                                                          : new Container(),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          });
                                      },
                                      ),
                                  ],
                                ),
                              )
                              : new Container(),
                            ],
                          ),
                         )),
                      ],
                     ),
                    ),
                    _textFieldFocusNode.hasFocus == true
                    ? new Container()
                    : new Container(
                      height: MediaQuery.of(context).size.height*0.03,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black.withOpacity(0.9),
                    ),
                  ],
                  ),
                ),
             /*child: new ListTile(
                contentPadding: EdgeInsets.fromLTRB(15.0, 20.0, 10.0, 0.0),
                leading: new Container(
                height: MediaQuery.of(context).size.height*0.03,
                width: MediaQuery.of(context).size.height*0.03,
                child: new ClipOval(child: new Image.asset('lib/assets/userPhoto.png', fit: BoxFit.cover),
              )),
              subtitle: new Container(
                decoration: new BoxDecoration(
                  color: Colors.grey[900].withOpacity(0.6),
                  borderRadius: new BorderRadius.circular(20.0)
                ),
              child: new Padding(
                padding: EdgeInsets.all(15.0),
              child: new Text('Of course, we do it again, when you want !',
              textAlign: TextAlign.left,
              style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
              ))),
              trailing: new Text('12:00',
              style: new TextStyle(color: Colors.grey, fontSize: 10.0, fontWeight: FontWeight.normal),
            ),
             ),*/
            
           /* return new Container(
              height: MediaQuery.of(context).size.height*0.10,
              width: MediaQuery.of(context).size.width,
             child: new ListTile(
                contentPadding: EdgeInsets.fromLTRB(15.0, 20.0, 10.0, 0.0),
                leading: new Container(
                height: MediaQuery.of(context).size.height*0.03,
                width: MediaQuery.of(context).size.height*0.03,
                child: new ClipOval(child: new Image.asset('lib/assets/userPhoto.png', fit: BoxFit.cover),
              )),
              subtitle: new Container(
                decoration: new BoxDecoration(
                  color: Colors.grey[900].withOpacity(0.6),
                  borderRadius: new BorderRadius.circular(20.0)
                ),
              child: new Padding(
                padding: EdgeInsets.all(15.0),
              child: new Text('Of course, we do it again, when you want !',
              textAlign: TextAlign.left,
              style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
              ))),
              trailing: new Text('12:00',
              style: new TextStyle(color: Colors.grey, fontSize: 10.0, fontWeight: FontWeight.normal),
            ),
             ),
            );*/
          ],
        ),
        ),
      ),
    );
  }


  sendATrack() {
  int _timestampMessage = DateTime.now().microsecondsSinceEpoch;
  /// CURRENT USER ///
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .collection('discussions')
      .doc(widget.recipientUserUID)
      .set({
        'typeOfContent': 'track',
        'lastFromMe': true,
        'senderUID': widget.currentUser,
        'senderUsername': widget.currentUsername,
        'senderPhoto': widget.currentUserphoto,
        'recipientUID': widget.recipientUserUID,
        'recipientUsername': widget.recipientUserUsername,
        'recipientUserPhoto': widget.recipientUserPhoto,
        'lastMessageContent': 'track',
        'lastTimestamp': _timestampMessage,
        'lastMessageIsOpened': false,
      }).whenComplete(() {
        FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUser)
          .collection('discussions')
          .doc(widget.recipientUserUID)
          .collection('messages')
          .doc(_timestampMessage.toString())
          .set({
            'typeOfContent': 'track',
            'title': _fileMusicTitle,
            'content': _fileMusicURL,
            'duration': _fileMusicDuration,
            'fromMe': true,
            'senderUID': widget.currentUser,
            'senderUsername': widget.currentUsername,
            'senderPhoto': widget.currentUserphoto,
            'recipientUID': widget.recipientUserUID,
            'recipientUsername': widget.recipientUserUsername,
            'recipientUserPhoto': widget.recipientUserPhoto,
            'timestamp': _timestampMessage,
          });
    /// RECIPIENT USER ///
        FirebaseFirestore.instance
          .collection('users')
          .doc(widget.recipientUserUID)
          .collection('discussions')
          .doc(widget.currentUser)
          .set({
            'typeOfContent': 'track',
            'lastFromMe': false,
            'senderUID': widget.currentUser,
            'senderUsername': widget.currentUsername,
            'senderPhoto': widget.currentUserphoto,
            'recipientUID': widget.recipientUserUID,
            'recipientUsername': widget.recipientUserUsername,
            'recipientUserPhoto': widget.recipientUserPhoto,
            'lastMessageContent': 'track',
            'lastTimestamp': _timestampMessage,
            'lastMessageIsOpened': false,
          }).whenComplete(() {
            FirebaseFirestore.instance
              .collection('users')
              .doc(widget.recipientUserUID)
              .collection('discussions')
              .doc(widget.currentUser)
              .collection('messages')
              .doc(_timestampMessage.toString())
              .set({
                'typeOfContent': 'track',
                'title': _fileMusicTitle,
                'content': _fileMusicURL,
                'duration': _fileMusicDuration,
                'fromMe': false,
                'senderUID': widget.currentUser,
                'senderUsername': widget.currentUsername,
                'senderPhoto': widget.currentUserphoto,
                'recipientUID': widget.recipientUserUID,
                'recipientUsername': widget.recipientUserUsername,
                'recipientUserPhoto': widget.recipientUserPhoto,
                'timestamp': _timestampMessage,
              }).whenComplete(() {
                print('Cloud Firestore : message datas updated');
                Navigator.pop(context);
              });
          });
      });
  }
  sendMessageAndCreateDiscussion() {
  int _timestampMessage = DateTime.now().microsecondsSinceEpoch;
  /// CURRENT USER ///
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .collection('discussions')
      .doc(widget.recipientUserUID)
      .set({
        'typeOfContent': 'text',
        'lastFromMe': true,
        'senderUID': widget.currentUser,
        'senderUsername': widget.currentUsername,
        'senderPhoto': widget.currentUserphoto,
        'recipientUID': widget.recipientUserUID,
        'recipientUsername': widget.recipientUserUsername,
        'recipientUserPhoto': widget.recipientUserPhoto,
        'lastMessageContent': _messageTextController.value.text.toString(),
        'lastTimestamp': _timestampMessage,
        'lastMessageIsOpened': false,
      }).whenComplete(() {
        FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUser)
          .collection('discussions')
          .doc(widget.recipientUserUID)
          .collection('messages')
          .doc(_timestampMessage.toString())
          .set({
            'typeOfContent': 'text',
            'content': _messageTextController.value.text.toString(),
            'fromMe': true,
            'senderUID': widget.currentUser,
            'senderUsername': widget.currentUsername,
            'senderPhoto': widget.currentUserphoto,
            'recipientUID': widget.recipientUserUID,
            'recipientUsername': widget.recipientUserUsername,
            'recipientUserPhoto': widget.recipientUserPhoto,
            'timestamp': _timestampMessage,
          });
    /// RECIPIENT USER ///
        FirebaseFirestore.instance
          .collection('users')
          .doc(widget.recipientUserUID)
          .collection('discussions')
          .doc(widget.currentUser)
          .set({
            'typeOfContent': 'text',
            'lastFromMe': false,
            'senderUID': widget.currentUser,
            'senderUsername': widget.currentUsername,
            'senderPhoto': widget.currentUserphoto,
            'recipientUID': widget.recipientUserUID,
            'recipientUsername': widget.recipientUserUsername,
            'recipientUserPhoto': widget.recipientUserPhoto,
            'lastMessageContent': _messageTextController.value.text.toString(),
            'lastTimestamp': _timestampMessage,
            'lastMessageIsOpened': false,
          }).whenComplete(() {
            FirebaseFirestore.instance
              .collection('users')
              .doc(widget.recipientUserUID)
              .collection('discussions')
              .doc(widget.currentUser)
              .collection('messages')
              .doc(_timestampMessage.toString())
              .set({
                'typeOfContent': 'text',
                'content': _messageTextController.value.text.toString(),
                'fromMe': false,
                'senderUID': widget.currentUser,
                'senderUsername': widget.currentUsername,
                'senderPhoto': widget.currentUserphoto,
                'recipientUID': widget.recipientUserUID,
                'recipientUsername': widget.recipientUserUsername,
                'recipientUserPhoto': widget.recipientUserPhoto,
                'timestamp': _timestampMessage,
              }).whenComplete(() {
                print('Cloud Firestore : message datas updated');
                _messageTextController.clear();
                setState(() {
                  _textFieldOnChanged = false;
                });
              });
          });
      });
      
  }

}