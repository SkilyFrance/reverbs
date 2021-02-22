import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


class NotificationsPage extends StatefulWidget {

  String currentUser;
  String currentUsername;
  String currentUserProfilePhoto;

  NotificationsPage({
    Key key,
    this.currentUser,
    this.currentUsername,
    this.currentUserProfilePhoto,
    }) : super(key: key);


  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {


  ScrollController _listOfProjectsController = new ScrollController();
  ScrollController _listOfSubmissionsController = new ScrollController();
  ScrollController _listMusicArtistController = new ScrollController();
  ScrollController _hasSubmittedListController = new ScrollController();
  ScrollController _artistListTracks = new ScrollController();
  PageController _projectsListsManagement = new PageController();


  final submissionAccepted = new SnackBar(
    backgroundColor: Colors.deepPurpleAccent,
    content: new Text('You can start working with this artist 🚀',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
    ),
    );
  final submissionDeclined = new SnackBar(
    backgroundColor: Colors.deepPurpleAccent,
    content: new Text('You have declined this proposal 😭',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
    ),
    );
  final groupDiscussionCreated = new SnackBar(
    backgroundColor: Colors.deepPurpleAccent,
    content: new Text('A group discussion has been created 💬',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
    ),
    );


  //AudioPlayer variables
  String _trackChoosenToListen;
  AudioPlayer audioPlayer;
  bool _musicIsInitializing = false;
  bool _audioLaunched = false;

  @override
  void initState() {
    audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
    _listOfProjectsController = new ScrollController();
    _listOfSubmissionsController = new ScrollController();
    _hasSubmittedListController = new ScrollController();
    _artistListTracks = new ScrollController();
    _projectsListsManagement = new PageController();
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
                color: Colors.transparent,
                child: new StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users').doc(widget.currentUser).collection('projects').snapshots(),
                  builder: (BuildContext context, snapshotProject) {
                    if(snapshotProject.hasError) {return new Container();}
                    if(!snapshotProject.hasData || snapshotProject.data.documents.isEmpty) {return new Container();}
                    return new Container(
                      child: new ListView.builder(
                        padding: EdgeInsets.all(0.0),
                        itemCount: snapshotProject.data.documents.length,
                        physics: new NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        controller: _listOfProjectsController,
                        itemBuilder: (BuildContext context, int indexProject) {
                          DocumentSnapshot dsProject = snapshotProject.data.documents[indexProject];
                          return new StreamBuilder(
                                stream: FirebaseFirestore.instance.collection('users').doc(widget.currentUser).collection('projects').doc(dsProject.data()['documentUID']).collection('submissions').snapshots(),
                                builder: (BuildContext context, snapshot) {
                                  if(snapshot.hasError) {return new Container();}
                                  if(!snapshot.hasData || snapshot.data.documents.isEmpty) {return new Container();}
                                  return new Container(
                                    child: new ListView.builder(
                                      padding: EdgeInsets.all(0.0),
                                       itemCount: snapshot.data.documents.length,
                                       physics: new NeverScrollableScrollPhysics(),
                                       controller: _listOfSubmissionsController,
                                       shrinkWrap: true,
                                       itemBuilder: (BuildContext context, int index) {
                                         DocumentSnapshot ds = snapshot.data.documents[index];
                                         return new Container(
                                           height: MediaQuery.of(context).size.height*0.10,
                                           width: MediaQuery.of(context).size.width,
                                           color: ds.data()['state'] == 'inWaiting' ? Colors.deepPurpleAccent.withOpacity(0.3) : Colors.transparent,
                                           child: new ListTile(
                                             selectedTileColor: Colors.transparent,
                                             focusColor: Colors.transparent,
                                             hoverColor: Colors.transparent,
                                             tileColor: Colors.transparent,
                                             onTap: () {
                                               if(ds.data()['state'] == 'accepted') {
                                                 Scaffold.of(context).showSnackBar(groupDiscussionCreated);
                                               } else if(ds.data()['state'] == 'inWaiting' && dsProject.data()['alreadyAccepted'] == true) {
                                                //Decline function
                                                print('DeclineFunction cause already accepted other producer');
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
                                                           child: new Text(
                                                             ds.data()['senderUsername'] != null
                                                             ? ds.data()['senderUsername']
                                                             : 'Unknown',
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
                                                         child: ds.data()['senderPhoto'] != null
                                                          ? new Image.network(ds.data()['senderPhoto'], fit: BoxFit.cover)
                                                          : new Container(),
                                                         ),
                                                         ),
                                                       new Container(
                                                         height: MediaQuery.of(context).size.height*0.03,
                                                         width: MediaQuery.of(context).size.width,
                                                         color: Colors.transparent,
                                                         ),
                                                         new Container(
                                                           height: MediaQuery.of(context).size.height*0.20,
                                                           child: new FutureBuilder(
                                                             future: FirebaseFirestore.instance.collection('users').doc(ds.data()['senderUID']).collection('releasedTracks').get(),
                                                             builder: (BuildContext context, snapshotSenderTracks) {
                                                              if(snapshotSenderTracks.hasError) {return new Container();}
                                                              if(!snapshotSenderTracks.hasData || snapshotSenderTracks.data.documents.isEmpty) {return new Container(
                                                                height: MediaQuery.of(context).size.height*0.05,
                                                                width: MediaQuery.of(context).size.width,
                                                                color: Colors.transparent,
                                                                child: new Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                  children: [
                                                                    new Icon(Icons.music_note_rounded, color: Colors.white, size: 20.0),
                                                                    new Text('This artist has not track.',
                                                                    style: new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.bold)
                                                                    ),
                                                                  ],
                                                                ),
                                                              );}
                                                            return new Container(
                                                           child: new ListView.builder(
                                                             padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                                             controller: _listMusicArtistController,
                                                             scrollDirection: Axis.horizontal,
                                                             physics: new ScrollPhysics(),
                                                             itemCount: snapshotSenderTracks.data.documents.length,
                                                             itemBuilder: (BuildContext context, int indexTracks) {
                                                               DocumentSnapshot dsTrack = snapshotSenderTracks.data.documents[indexTracks];
                                                               return new Row(
                                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                                 children: [
                                                                   new Container(
                                                                     height: MediaQuery.of(context).size.height*0.20,
                                                                     child: new Column(
                                                                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                       children: [
                                                                         new InkWell(
                                                                         child: new Container(
                                                                           height: MediaQuery.of(context).size.height*0.15,
                                                                           width: MediaQuery.of(context).size.height*0.15,
                                                                           decoration: new BoxDecoration(
                                                                             color: Colors.grey[900].withOpacity(0.7),
                                                                             borderRadius: new BorderRadius.circular(5.0),
                                                                             border: new Border.all(
                                                                               width: 2.0,
                                                                               color: _trackChoosenToListen == dsTrack.data()['fileMusicURL'] && _audioLaunched == true ? Colors.purpleAccent : Colors.transparent,
                                                                             ),
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
                                                                             child: dsTrack.data()['coverImage'] != null
                                                                              ? new Image.network(dsTrack.data()['coverImage'] ,fit: BoxFit.cover)
                                                                              : new Container(),
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
                                                                                         child: 
                                                                                         _trackChoosenToListen == dsTrack.data()['fileMusicURL'] 
                                                                                         && _musicIsInitializing == true
                                                                                         && _audioLaunched == false
                                                                                         ? new CupertinoActivityIndicator(animating: true, radius: 9.0)
                                                                                         : _trackChoosenToListen == dsTrack.data()['fileMusicURL'] 
                                                                                         && _musicIsInitializing == false
                                                                                         && _audioLaunched == true
                                                                                         ? new IconButton(
                                                                                           icon: new Icon(Icons.stop, color: Colors.white, size: 30.0), 
                                                                                           onPressed: () {
                                                                                             modalSetState(() {
                                                                                               _audioLaunched = false;
                                                                                             });
                                                                                             audioPlayer.stop();
                                                                                           },
                                                                                           )
                                                                                          : new IconButton(
                                                                                           icon: new Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30.0), 
                                                                                           onPressed: () {
                                                                                            modalSetState((){
                                                                                              _trackChoosenToListen = dsTrack.data()['fileMusicURL'];
                                                                                               _musicIsInitializing = true;
                                                                                            });
                                                                                            AudioPlayer.logEnabled = true;
                                                                                            audioPlayer.play(dsTrack.data()['fileMusicURL'], volume: 1.0).whenComplete(() {
                                                                                              modalSetState((){
                                                                                                _musicIsInitializing = false;
                                                                                                _audioLaunched = true;
                                                                                              });
                                                                                            });
                                                                                           },
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
                                                                           child: new Text(
                                                                             dsTrack.data()['title'] != null
                                                                             ? dsTrack.data()['title']
                                                                             : 'Unknown',
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
                                                                     color: Colors.transparent,
                                                                   ),
                                                                 ],
                                                               );
                                                             }
                                                           ),
                                                               );
                                                             }),
                                                         ),
                                                        //Divider
                                                        new Container(
                                                          height: MediaQuery.of(context).size.height*0.08,
                                                          width: MediaQuery.of(context).size.width,
                                                          color: Colors.transparent,
                                                          child: new Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              new Text('Even if you accepted another artist for this project.',
                                                              style: new TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                              ),
                                                              new Text('You can decline or discuss with ' + ds.data()['senderUsername'] + '.',
                                                              style: new TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                              ),
                                                            ],
                                                          )
                                                        ),
                                                        new Container(
                                                          child: new Center(
                                                            child: new Text('What do you want to do ?',
                                                            style: new TextStyle(color: Colors.grey[400], fontSize: 13.0, fontWeight: FontWeight.bold),
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
                                                              onPressed: () {
                                                              declineSubmission(
                                                                ds.data()['projectID'],
                                                                ds.data()['senderUID'],
                                                                ds.data()['projectStyle'],
                                                              );
                                                              Navigator.pop(context);
                                                              Scaffold.of(context).showSnackBar(submissionDeclined);
                                                              },
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
                                                              onPressed: () {
                                                                discussWithSubmissionsNotRetained(
                                                                 ds.data()['senderUID'],
                                                                 ds.data()['senderUsername'],
                                                                 ds.data()['senderPhoto'],
                                                                 ds.data()['projectID'],
                                                                 ds.data()['projectStyle'],
                                                               );
                                                               Navigator.pop(context);
                                                               Scaffold.of(context).showSnackBar(groupDiscussionCreated);
                                                              },
                                                              color: Colors.deepPurpleAccent,
                                                              child: new Center(
                                                                child: new Text('Discuss',
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
                                               }).whenComplete(() {
                                                    if(_musicIsInitializing == true || _audioLaunched == true) {
                                                      setState(() {
                                                        _musicIsInitializing = false;
                                                        _audioLaunched = false;
                                                      });
                                                      audioPlayer.stop();
                                                      }
                                                    });
                                                //
                                                 } else if(ds.data()['state'] == 'inWaiting' && dsProject.data()['alreadyAccepted'] == false) {
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
                                                           child: new Text(
                                                             ds.data()['senderUsername'] != null
                                                             ? ds.data()['senderUsername']
                                                             : 'Unknown',
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
                                                         child: ds.data()['senderPhoto'] != null
                                                          ? new Image.network(ds.data()['senderPhoto'], fit: BoxFit.cover)
                                                          : new Container(),
                                                         ),
                                                         ),
                                                       new Container(
                                                         height: MediaQuery.of(context).size.height*0.03,
                                                         width: MediaQuery.of(context).size.width,
                                                         color: Colors.transparent,
                                                         ),
                                                         new Container(
                                                           height: MediaQuery.of(context).size.height*0.20,
                                                           child: new FutureBuilder(
                                                             future: FirebaseFirestore.instance.collection('users').doc(ds.data()['senderUID']).collection('releasedTracks').get(),
                                                             builder: (BuildContext context, snapshotSenderTracks) {
                                                              if(snapshotSenderTracks.hasError) {return new Container();}
                                                              if(!snapshotSenderTracks.hasData || snapshotSenderTracks.data.documents.isEmpty) {return new Container(
                                                                height: MediaQuery.of(context).size.height*0.05,
                                                                width: MediaQuery.of(context).size.width,
                                                                color: Colors.transparent,
                                                                child: new Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                  children: [
                                                                    new Icon(Icons.music_note_rounded, color: Colors.white, size: 20.0),
                                                                    new Text('This artist has not track.',
                                                                    style: new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.bold)
                                                                    ),
                                                                  ],
                                                                ),
                                                              );}
                                                            return new Container(
                                                           child: new ListView.builder(
                                                             padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                                             controller: _listMusicArtistController,
                                                             scrollDirection: Axis.horizontal,
                                                             physics: new ScrollPhysics(),
                                                             itemCount: snapshotSenderTracks.data.documents.length,
                                                             itemBuilder: (BuildContext context, int indexTracks) {
                                                               DocumentSnapshot dsTrack = snapshotSenderTracks.data.documents[indexTracks];
                                                               return new Row(
                                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                                 children: [
                                                                   new Container(
                                                                     height: MediaQuery.of(context).size.height*0.20,
                                                                     child: new Column(
                                                                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                       children: [
                                                                         new InkWell(
                                                                         child: new Container(
                                                                           height: MediaQuery.of(context).size.height*0.15,
                                                                           width: MediaQuery.of(context).size.height*0.15,
                                                                           decoration: new BoxDecoration(
                                                                             color: Colors.grey[900].withOpacity(0.7),
                                                                             borderRadius: new BorderRadius.circular(5.0),
                                                                             border: new Border.all(
                                                                               width: 2.0,
                                                                               color: _trackChoosenToListen == dsTrack.data()['fileMusicURL'] && _audioLaunched == true ? Colors.purpleAccent : Colors.transparent,
                                                                             ),
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
                                                                             child: dsTrack.data()['coverImage'] != null
                                                                              ? new Image.network(dsTrack.data()['coverImage'] ,fit: BoxFit.cover)
                                                                              : new Container(),
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
                                                                                         child: 
                                                                                         _trackChoosenToListen == dsTrack.data()['fileMusicURL'] 
                                                                                         && _musicIsInitializing == true
                                                                                         && _audioLaunched == false
                                                                                         ? new CupertinoActivityIndicator(animating: true, radius: 9.0)
                                                                                         : _trackChoosenToListen == dsTrack.data()['fileMusicURL'] 
                                                                                         && _musicIsInitializing == false
                                                                                         && _audioLaunched == true
                                                                                         ? new IconButton(
                                                                                           icon: new Icon(Icons.stop, color: Colors.white, size: 30.0), 
                                                                                           onPressed: () {
                                                                                             modalSetState(() {
                                                                                               _audioLaunched = false;
                                                                                             });
                                                                                             audioPlayer.stop();
                                                                                           },
                                                                                           )
                                                                                          : new IconButton(
                                                                                           icon: new Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30.0), 
                                                                                           onPressed: () {
                                                                                            modalSetState((){
                                                                                              _trackChoosenToListen = dsTrack.data()['fileMusicURL'];
                                                                                               _musicIsInitializing = true;
                                                                                            });
                                                                                            AudioPlayer.logEnabled = true;
                                                                                            audioPlayer.play(dsTrack.data()['fileMusicURL'], volume: 1.0).whenComplete(() {
                                                                                              modalSetState((){
                                                                                                _musicIsInitializing = false;
                                                                                                _audioLaunched = true;
                                                                                              });
                                                                                            });
                                                                                           },
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
                                                                           child: new Text(
                                                                             dsTrack.data()['title'] != null
                                                                             ? dsTrack.data()['title']
                                                                             : 'Unknown',
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
                                                               );
                                                             }),
                                                         ),
                                                        //Divider
                                                        new Container(
                                                          height: MediaQuery.of(context).size.height*0.08,
                                                          width: MediaQuery.of(context).size.width,
                                                        ),
                                                        new Container(
                                                          child: new Center(
                                                            child: new Text('Accept this artist on your project ?',
                                                            style: new TextStyle(color: Colors.grey[400], fontSize: 13.0, fontWeight: FontWeight.bold),
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
                                                              onPressed: () {
                                                                showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) => 
                                                                new CupertinoAlertDialog(
                                                                  title: new Text("Are you sure to decline ?",
                                                                  style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                                                                  ),
                                                                  content: new Padding(
                                                                    padding: EdgeInsets.only(top: 0.0),
                                                                    child: new Text("This artist will be notified. Other producers will still be able to submit to this project.",
                                                                    style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.normal),
                                                                  )),
                                                                  actions: <Widget>[
                                                                    new CupertinoDialogAction(
                                                                      child: new Text("Decline", style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal)),
                                                                      onPressed: () {
                                                                        declineSubmission(
                                                                          ds.data()['projectID'],
                                                                          ds.data()['senderUID'],
                                                                          ds.data()['projectStyle'],
                                                                        );
                                                                        Navigator.pop(context);
                                                                        Scaffold.of(context).showSnackBar(submissionDeclined);
                                                                        },
                                                                    ),
                                                                    new CupertinoDialogAction(
                                                                      child: Text("Not decline", style: new TextStyle(color: Colors.red, fontSize: 14.0, fontWeight: FontWeight.normal)),
                                                                      onPressed: () {Navigator.pop(context);},
                                                                    )
                                                                  ],
                                                                )
                                                                );
                                                              },
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
                                                              onPressed: () {
                                                                showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) => 
                                                                new CupertinoAlertDialog(
                                                                  title: new Text("Work with this artist ?",
                                                                  style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                                                                  ),
                                                                  content: new Padding(
                                                                    padding: EdgeInsets.only(top: 0.0),
                                                                    child: new Text("if you accept, the project will be deleted from discover tab. A Discussion group will be created. ",
                                                                    
                                                                    style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.normal),
                                                                  )),
                                                                  actions: <Widget>[
                                                                    new CupertinoDialogAction(
                                                                      child: new Text("Accept", style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal)),
                                                                      onPressed: () {
                                                                      Navigator.pop(context);
                                                                      acceptationRequest(
                                                                        ds.data()['projectID'], 
                                                                        ds.data()['senderUID'],
                                                                        ds.data()['senderUsername'],
                                                                        ds.data()['senderPhoto'],
                                                                        ds.data()['projectStyle'],
                                                                        ds.data()['context'],
                                                                        ds.data()['fileMusicURL'], 
                                                                        dsProject.data()['timestamp']);
                                                                        },
                                                                    ),
                                                                    new CupertinoDialogAction(
                                                                      child: Text("No, sorry", style: new TextStyle(color: Colors.red, fontSize: 14.0, fontWeight: FontWeight.normal)),
                                                                      onPressed: () {Navigator.pop(context);},
                                                                    )
                                                                  ],
                                                                )
                                                                );
                                                              },
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
                                               }).whenComplete(() {
                                                    if(_musicIsInitializing == true || _audioLaunched == true) {
                                                      setState(() {
                                                        _musicIsInitializing = false;
                                                        _audioLaunched = false;
                                                      });
                                                      audioPlayer.stop();
                                                      }
                                                    });
                                                    }
                                                    },
                                                   leading: new Container(
                                                   height: MediaQuery.of(context).size.height*0.05,
                                                   width: MediaQuery.of(context).size.height*0.05,
                                                   child: new ClipOval(
                                                     child: ds.data()['senderPhoto'] != null
                                                     ? new Image.network(ds.data()['senderPhoto'], fit: BoxFit.cover)
                                                     : new Container(),
                                                 )),
                                                 title: new RichText(
                                                   text: new TextSpan(
                                                     text: ds.data()['projectStyle'] != null ? 'Your ' + ds.data()['projectStyle'] + ' project' : 'Unkwnown',
                                                     style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                                                   )),
                                                 subtitle: new Text(
                                                   ds.data()['senderUsername'] != null && ds.data()['state'] == 'inWaiting'
                                                   ? ds.data()['senderUsername'] + ' has submitted for your project'
                                                   : ds.data()['senderUsername'] != null && ds.data()['state'] == 'accepted'
                                                   ? ds.data()['senderUsername'] + ' is working with you now'
                                                   : ds.data()['senderUsername'] != null && ds.data()['state'] == 'declined'
                                                   ? ds.data()['senderUsername'] + ' has been declined.'
                                                   : ds.data()['senderUsername'] != null && ds.data()['state'] == 'inDiscussion'
                                                   ? 'You can discuss now with ' + ds.data()['senderUsername']
                                                   : 'This artist would like to integrate your project',
                                                  overflow: TextOverflow.ellipsis,
                                                 style: new TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.normal),
                                                 ),
                                                 trailing: new Material(
                                                   color: Colors.transparent,
                                                   child: new Text(
                                                     ds.data()['state'] == 'inWaiting'
                                                     ? '💡'
                                                     : ds.data()['state'] == 'accepted'
                                                     ? '🎉'
                                                     : ds.data()['state'] == 'declined'
                                                     ? '😭'
                                                     : ds.data()['state'] == 'inDiscussion'
                                                     ? '💬'
                                                     : '',
                                                   style: new TextStyle(fontSize: 23.0),
                                                   )
                                                 ),
                                                 ),
                                                );
                                                    },
                                                  ),
                                                );
                                              }
                                              //),
                               
                                        );
                                      },
                                  ));
                                }),
               /* child: new ListView.builder(
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
                ),*/
              ),
              new Container(
                child: new StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users').doc(widget.currentUser).collection('hasSubmitted').snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if(snapshot.hasError) {return new Container();}
                    if(!snapshot.hasData || snapshot.data.documents.isEmpty) {return new Container();}
                    return new ListView.builder(
                        padding: EdgeInsets.only(bottom: 100.0),
                        itemCount: snapshot.data.documents.length,
                        shrinkWrap: true,
                        controller: _hasSubmittedListController,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot dsHasSubmitted = snapshot.data.documents[index];
                          return dsHasSubmitted.data()['state'] == 'inWaiting'
                          ? new Container()
                          : new Container(
                            height: MediaQuery.of(context).size.height*0.10,
                            width: MediaQuery.of(context).size.width,
                            color: dsHasSubmitted.data()['alreadyOpened'] == false ? Colors.deepPurpleAccent.withOpacity(0.3) : Colors.transparent,
                            child: new ListTile(
                              onTap: () {
                                if(dsHasSubmitted.data()['state'] == 'accepted') {
                                  if(dsHasSubmitted.data()['alreadyOpened'] == false) {
                                    FirebaseFirestore.instance
                                      .collection('users').doc(widget.currentUser)
                                      .collection('hasSubmitted').doc(dsHasSubmitted.data()['projectID'])
                                      .update({'alreadyOpened': true}).whenComplete(() => print('Cloud Firestore : AlreadyOpened updated'));
                                  }
                                  Scaffold.of(context).showSnackBar(groupDiscussionCreated);
                                } else if(dsHasSubmitted.data()['state'] == 'declined') {
                                  if(dsHasSubmitted.data()['alreadyOpened'] == false) {
                                    FirebaseFirestore.instance
                                      .collection('users').doc(widget.currentUser)
                                      .collection('hasSubmitted').doc(dsHasSubmitted.data()['projectID'])
                                      .update({'alreadyOpened': true}).whenComplete(() => print('Cloud Firestore : AlreadyOpened updated'));
                                  }
                                } else if(dsHasSubmitted.data()['state'] == 'inDiscussion') {
                                  if(dsHasSubmitted.data()['alreadyOpened'] == false) {
                                    FirebaseFirestore.instance
                                      .collection('users').doc(widget.currentUser)
                                      .collection('hasSubmitted').doc(dsHasSubmitted.data()['projectID'])
                                      .update({'alreadyOpened': true}).whenComplete(() => print('Cloud Firestore : AlreadyOpened updated'));
                                  }
                                  Scaffold.of(context).showSnackBar(groupDiscussionCreated);
                                }
                              },
                              selectedTileColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              tileColor: Colors.transparent,
                              leading: new Container(
                              height: MediaQuery.of(context).size.height*0.05,
                              width: MediaQuery.of(context).size.height*0.05,
                              child: new ClipOval(
                                child: dsHasSubmitted.data()['adminProfilePhoto'] != null
                                ? new Image.network(dsHasSubmitted.data()['adminProfilePhoto'], fit: BoxFit.cover)
                                : new Container(),
                              )),
                              title: new RichText(
                                text: new TextSpan(
                                  text: dsHasSubmitted.data()['adminUsername'] != null ? dsHasSubmitted.data()['adminUsername'] : 'Unkwnown',
                                  style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                                )),
                                subtitle: new Text(
                                  dsHasSubmitted.data()['adminUsername'] != null && dsHasSubmitted.data()['state'] == 'accepted'
                                  ? 'Has accepted your submission.'
                                  : dsHasSubmitted.data()['adminUsername'] != null && dsHasSubmitted.data()['state'] == 'declined'
                                  ? 'Has declined your submission. Sorry.'
                                  : dsHasSubmitted.data()['adminUsername'] != null && dsHasSubmitted.data()['state'] == 'inDiscussion'
                                  ? 'Has declined but wants to discuss with you'
                                  : '',
                                style: new TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.normal),
                                ),
                                trailing: new Material(
                                  color: Colors.transparent,
                                  child: new Text(
                                    dsHasSubmitted.data()['state'] == 'accepted'
                                    ? '🎉'
                                    : dsHasSubmitted.data()['state'] == 'declined'
                                    ? '😭'
                                    : dsHasSubmitted.data()['state'] == 'inDiscussion'
                                    ? '💬'
                                    : '',
                                  style: new TextStyle(fontSize: 23.0),
                                  )
                                ),
                            ),
                          );
                        },
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



  declineSubmission(String projectID, String senderUID, String projectStyle) {
    //n°1 Update state of submissions admin project
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .collection('projects')
      .doc(projectID)
      .collection('submissions')
      .doc(senderUID)
      .update({
        'state': 'declined',
      }).whenComplete(() {
        print('Cloud Firestore : notifyAdminState done.');
        //n°2 Create state on sender (hasSubmitted collection)
        FirebaseFirestore.instance
          .collection('users')
          .doc(senderUID)
          .collection('hasSubmitted')
          .doc(projectID)
          .set({
            'adminUID': widget.currentUser,
            'adminUsername': widget.currentUsername,
            'adminProfilePhoto': widget.currentUserProfilePhoto,
            'projectStyle': projectStyle,
            'state': 'declined',
            'projectID': projectID,
            'alreadyOpened': false,
          }).whenComplete(() 
          => print('Cloud Firestore : notifySenderState done.'));
      });
  }

  discussWithSubmissionsNotRetained(String senderUID, String senderUsername, String senderUserPhoto, String projectID, String projectStyle) {
    int _timestampMessage = DateTime.now().microsecondsSinceEpoch;
    //n°1 Create discussion in Admin DB
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .collection('discussions')
      .doc(senderUID)
      .set({
        'conversationID': senderUID,
        'messageFromReverbs': true,
        'typeOfContent': 'text',
        'lastFromMe': false,
        'currentUser': widget.currentUser,
        'titleOfConversation': senderUsername,
        'recipientUID': senderUID,
        'recipientUsername': senderUsername,
        'recipientUserPhoto': senderUserPhoto,
        'coverOfConversation': 'reverbsImage',
        'lastMessageContent': "Even if you have declined $senderUsername's proposal for your project, you can discuss with him/her. Here is your discussion group 💬",
        'lastTimestamp': _timestampMessage,
        'lastMessageIsOpened': false,
      }).whenComplete(() {
        print('Cloud Firestore : createDiscussionAdmin done');
        //
        //n°2 Create discussion in sender DB
        FirebaseFirestore.instance
          .collection('users')
          .doc(senderUID)
          .collection('discussions')
          .doc(widget.currentUser)
          .set({
            'conversationID': widget.currentUser,
            'messageFromReverbs': true,
            'typeOfContent': 'text',
            'lastFromMe': false,
            'currentUser': senderUID,
            'titleOfConversation': widget.currentUsername,
            'recipientUID': widget.currentUser,
            'recipientUsername': widget.currentUsername,
            'recipientUserPhoto': widget.currentUserProfilePhoto,
            'coverOfConversation': 'reverbsImage',
            'lastMessageContent': "Even if your proposal has been declined. ${widget.currentUsername} wants to discuss with you. Here is your discussion group 💬",
            'lastTimestamp': _timestampMessage,
            'lastMessageIsOpened': false,
          }).whenComplete(() {
            print('Cloud Firestore : createDiscussionSender done');
            //
            //n°3 Send message to admin DB
            FirebaseFirestore.instance
              .collection('users')
              .doc(widget.currentUser)
              .collection('discussions')
              .doc(senderUID)
              .collection('messages')
              .doc(_timestampMessage.toString())
              .set({
                'messageFromReverbs': true,
                'typeOfContent': 'text',
                'content': "Even if you have declined $senderUsername's proposal for your project, you can discuss with him/her. Here is your discussion group 💬",
                'fromMe': false,
                'currentUser': widget.currentUser,
                'currentUserPhoto': widget.currentUserProfilePhoto,
                'currentUsername': widget.currentUsername,
                'recipientUID': senderUID,
                'recipientUsername': senderUsername,
                'recipientUserPhoto': senderUserPhoto,
                'timestamp': _timestampMessage,
              }).whenComplete(() {
                print('Cloud Firestore : sendMessageToAdmin done');
                //
                //n°3 Send message to sender DB
                FirebaseFirestore.instance
                  .collection('users')
                  .doc(senderUID)
                  .collection('discussions')
                  .doc(widget.currentUser)
                  .collection('messages')
                  .doc(_timestampMessage.toString())
                  .set({
                    'messageFromReverbs': true,
                    'typeOfContent': 'text',
                    'content': "Even if your proposal has been declined. ${widget.currentUsername} wants to discuss with you. Here is your discussion group 💬",
                    'fromMe': false,
                    'currentUser': senderUID,
                    'currentUserPhoto': senderUserPhoto,
                    'currentUsername': senderUsername,
                    'recipientUID': widget.currentUser,
                    'recipientUsername': widget.currentUsername,
                    'recipientUserPhoto': widget.currentUserProfilePhoto,
                    'timestamp': _timestampMessage,
                  }).whenComplete(() {
                    print('Cloud Firestore : sendMessageToSender done');
                    //
                    //n°4 notify adminState
                    FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.currentUser)
                      .collection('projects')
                      .doc(projectID)
                      .collection('submissions')
                      .doc(senderUID)
                      .update({
                        'state': 'inDiscussion',
                      }).whenComplete(() {
                        print('Cloud Firestore : notifyAdminState done.');
                        //
                        //n°4 notify senderState
                        FirebaseFirestore.instance
                          .collection('users')
                          .doc(senderUID)
                          .collection('hasSubmitted')
                          .doc(projectID)
                          .set({
                            'adminUID': widget.currentUser,
                            'adminUsername': widget.currentUsername,
                            'adminProfilePhoto': widget.currentUserProfilePhoto,
                            'projectStyle': projectStyle,
                            'state': 'inDiscussion',
                            'projectID': projectID,
                            'alreadyOpened': false,
                          }).whenComplete(() {
                            print('Cloud Firestore : notifySenderState done.');
                          });
                      });
                  });
              });
          });
      });
  }


  acceptationRequest(
    String projectID,
    String senderUID,
    String senderUsername,
    String senderPhoto,
    String projectStyle,
    String projectContext,
    String fileMusicURL,
    String timestamp,
  ) {
    int _timestampMessage = DateTime.now().microsecondsSinceEpoch;
    // n°1 Notify users about new submission state
    //   - Update state "AlreadyAccepted" admin project
           notifyAlreadyAcceptedAdmin(projectID);
    //   - Update state of submissions admin project
           notifyAdminState(projectID,senderUID);
    //   - Create state on sender (hasSubmitted collection)
           notifySenderState(projectID, senderUID, projectStyle);
    // n°2 Create project in sender
           creationSenderProject(senderUID, projectID, projectContext, fileMusicURL, projectStyle, timestamp);
    // n°3 Create discusssion users
    //   - in admin DB
          createDiscussionAdmin(projectID, projectStyle, _timestampMessage, senderUID ,senderUsername, senderPhoto);
    //   - in sender DB
          createDiscussionSender(senderUID, projectID, projectStyle, _timestampMessage);
    // n°4 Send message to contributors
          sendMessageToAdmin(_timestampMessage, projectID, senderUID, senderUsername, senderPhoto);
          sendMessageToSender(_timestampMessage, projectID, senderUID, senderUsername, senderPhoto);
    // n°5 Delete from discover
          deleteFromDiscover(timestamp,projectStyle);
          Navigator.pop(context);
          Scaffold.of(context).showSnackBar(submissionAccepted);
  }

  notifyAlreadyAcceptedAdmin(String projectID) {
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .collection('projects')
      .doc(projectID)
      .update({
        'alreadyAccepted': true,
      }).whenComplete(()
      => print('Cloud Firestore : notifyAlreadyAcceptedAdmin done.'));
  }

  notifyAdminState(String projectID, String senderUID) {
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .collection('projects')
      .doc(projectID)
      .collection('submissions')
      .doc(senderUID)
      .update({
        'state': 'accepted',
      }).whenComplete(() 
      => print('Cloud Firestore : notifyAdminState done.'));
  }

  notifySenderState(String projectID, String senderUID, String projectStyle) {
    FirebaseFirestore.instance
      .collection('users')
      .doc(senderUID)
      .collection('hasSubmitted')
      .doc(projectID)
      .set({
        'adminUID': widget.currentUser,
        'adminUsername': widget.currentUsername,
        'adminProfilePhoto': widget.currentUserProfilePhoto,
        'projectStyle': projectStyle,
        'state': 'accepted',
        'projectID': projectID,
        'alreadyOpened': false,
      }).whenComplete(() 
      => print('Cloud Firestore : notifySenderState done.'));
  }

  creationSenderProject(String senderUID, String projectID, String projectContext, String fileMusicURL, String projectStyle, String timestamp) {
    FirebaseFirestore.instance
      .collection('users')
      .doc(senderUID)
      .collection('projects')
      .doc(projectID)
      .set({
        'adminUID': widget.currentUser,
        'artistUID': widget.currentUser,
        'artistProfilePhoto': widget.currentUserProfilePhoto,
        'artistUsername': widget.currentUsername,
        'context': projectContext,
        'documentUID': projectID,
        'fileMusicURL': fileMusicURL,
        'style': projectStyle,
        'timestamp': timestamp,
      }).whenComplete(() 
      => print('Cloud Firestore : creationSenderProject done'));
  }

  createDiscussionAdmin(String projectID, String projectStyle, int _timestampMessage, String recipientUID, String recipientUsername, String recipientUserPhoto) {
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .collection('discussions')
      .doc(projectID)
      .set({
        'conversationID': projectID,
        'messageFromReverbs': true,
        'typeOfContent': 'text',
        'lastFromMe': false,
        'currentUser': widget.currentUser,
        'titleOfConversation': '$projectStyle project',
        'recipientUID': recipientUID,
        'recipientUsername': recipientUsername,
        'recipientUserPhoto': recipientUserPhoto,
        'coverOfConversation': 'reverbsImage',
        'lastMessageContent': 'Hey guys, here is your discussion project between you & $recipientUsername. Discuss & send audio files here 🚀',
        'lastTimestamp': _timestampMessage,
        'lastMessageIsOpened': false,
      }).whenComplete(() 
      => print('Cloud Firestore : createDiscussionAdmin done'));
  }

  createDiscussionSender(String senderUID, String projectID, String projectStyle, int _timestampMessage) {
    FirebaseFirestore.instance
      .collection('users')
      .doc(senderUID)
      .collection('discussions')
      .doc(projectID)
      .set({
        'conversationID': projectID,
        'messageFromReverbs': true,
        'typeOfContent': 'text',
        'lastFromMe': false,
        'currentUser': senderUID,
        'titleOfConversation': '$projectStyle project',
        'recipientUID': widget.currentUser,
        'recipientUsername': widget.currentUsername,
        'recipientUserPhoto': widget.currentUserProfilePhoto,
        'coverOfConversation': 'reverbsImage',
        'lastMessageContent': 'Hey guys, here is your discussion project between you & ${widget.currentUsername}. Discuss & send audio files here 🚀',
        'lastTimestamp': _timestampMessage,
        'lastMessageIsOpened': false,
      }).whenComplete(()
      => print('Cloud Firestore : createDiscussionSender done'));
  }

  sendMessageToAdmin(int _timestampMessage, String projectID, String recipientUID, String recipientUsername, String recipientUserPhoto) {
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .collection('discussions')
      .doc(projectID)
      .collection('messages')
      .doc(_timestampMessage.toString())
      .set({
        'messageFromReverbs': true,
        'typeOfContent': 'text',
        'content': 'Hey guys, here is your discussion project between you & $recipientUsername. Discuss & send audio files here 🚀',
        'fromMe': false,
        'currentUser': widget.currentUser,
        'currentUserPhoto': widget.currentUserProfilePhoto,
        'currentUsername': widget.currentUsername,
        'recipientUID': recipientUID,
        'recipientUsername': recipientUsername,
        'recipientUserPhoto': recipientUserPhoto,
        'timestamp': _timestampMessage,
      }).whenComplete(()
      => print('Cloud Firestore : sendMessageToAdmin done'));
  }
  
  sendMessageToSender(int _timestampMessage, String projectID, String recipientUID, String recipientUsername, String recipientUserPhoto) {
    FirebaseFirestore.instance
      .collection('users')
      .doc(recipientUID)
      .collection('discussions')
      .doc(projectID)
      .collection('messages')
      .doc(_timestampMessage.toString())
      .set({
        'messageFromReverbs': true,
        'typeOfContent': 'text',
        'content': 'Hey guys, here is your discussion project between you & ${widget.currentUsername}. Discuss & send audio files here 🚀',
        'fromMe': false,
        'currentUser': recipientUID,
        'currentUserPhoto': recipientUserPhoto,
        'currentUsername': recipientUsername,
        'recipientUID': widget.currentUser,
        'recipientUsername': widget.currentUsername,
        'recipientUserPhoto': widget.currentUserProfilePhoto,
        'timestamp': _timestampMessage,
      }).whenComplete(()
      => print('Cloud Firestore : sendMessageToSender done'));
  }


  deleteFromDiscover(String timestampProject, String projectStyle) {
    FirebaseFirestore.instance
      .collection('Project$projectStyle')
      .doc(timestampProject)
      .delete()
      .whenComplete(()
      => print('Cloud Firestore : deleteFromDiscover done'));
  }



  /*acceptationRequest(
    String projectID, 
    String senderUID, 
    String projectStyleUnion, 
    String styleTrackMinuscule,
    String projectContext,
    String fileMusicURL,
    ) {

    int _timestampMessage = DateTime.now().microsecondsSinceEpoch;
    //Notify users about new submission state
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .collection('projects')
      .doc(projectID)
      .collection('submissions')
      .doc(senderUID)
      .update({
        'state': 'accepted',
      }).whenComplete(() {
        FirebaseFirestore.instance
          .collection('users')
          .doc(senderUID)
          .collection('hasSubmitted')
          .doc(projectID)
          .set({
            'adminUID': widget.currentUser,
            'adminUsername': widget.currentUsername,
            'adminProfilePhoto': widget.currentUserProfilePhoto,
            'projectStyle': projectStyleUnion,
            'state': 'accepted'
          }).whenComplete(() {
            //Creation of project in senderUID
            FirebaseFirestore.instance
              .collection('users')
              .doc(senderUID)
              .collection('projects')
              .doc(projectID)
              .set({
                'context': projectContext,
                'documentUID': projectID,
                'adminUID': widget.currentUser,
                'artistProfilePhoto': widget.currentUserProfilePhoto,
                'artistUsername': widget.currentUsername,
                'artistUID': widget.currentUser,
                'fileMusicURL': fileMusicURL,
                'style': styleTrackMinuscule,
              }).whenComplete(() {
                //Create discussion
                FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.currentUser)
                  .collection('discussions')
                  .doc(projectID)
                  .set({
                    'sendByReverbsTeam': true,
                    'typeOfContent': 'text',
                    'lastFromMe': false,
                    'lastMessageContent': 'Hey guys, here is your discussion project 🚀',
                    'lastMessageIsOpened': false,
                    'lastTimestamp': _timestampMessage,
                    'recipientUID': {
                      '$senderUID': '$senderUID',
                      },
                    'senderUsername': '${widget.currentUser}',
                  }).whenComplete(() {
                    FirebaseFirestore.instance
                      .collection('users')
                      .doc(senderUID)
                      .collection('discussions')
                      .doc(projectID)
                      .set({
                        'sendByReverbsTeam': true,
                        'lastFromMe': false,
                        'lastMessageContent': 'Hey guys, here is your discussion project 🚀',
                        'lastMessageIsOpened': false,
                        'lastTimestamp': _timestampMessage,
                        'recipientUID': {
                          '${widget.currentUser}': '${widget.currentUser}',
                      },
                        'senderUsername': '$senderUID',
                        'typeOfContent': 'text',
                      }).whenComplete(() {
                        //Create message 
                        FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.currentUser)
                          .collection('discussions')
                          .doc(projectID)
                          .collection('messages')
                          .doc(_timestampMessage.toString())
                          .set({
                            'sendByReverbsTeam': true,
                            'fromMe': false,
                            'content': 'Hey guys, here is your discussion project 🚀',
                            
                          });
                        //print('Cloud Firestore : Accepted request done ');
                      });
                  });
              });
          });
      });
  }*/






}