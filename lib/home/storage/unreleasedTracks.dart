import 'dart:io';
import 'dart:ui';
import 'package:SONOZ/permissionsHandler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:permission_handler/permission_handler.dart';


class UnreleasedTracksPage extends StatefulWidget {


  String currentUser;
  String currentUserPhoto;
  String currentUserUsername;



  UnreleasedTracksPage({
    Key key, 
    this.currentUser, 
    this.currentUserPhoto,
    this.currentUserUsername,
    }) : super(key: key);


  @override
  UnreleasedTracksPageState createState() => UnreleasedTracksPageState();
}

class UnreleasedTracksPageState extends State<UnreleasedTracksPage> {



  ScrollController _unReleasedTracks = new ScrollController();
  TextEditingController _titleTextEditingController = new TextEditingController();

  int musicStyleSelectedValue;
  //Variables for new track uploaded //
  File _music;
  File _image;
  String _fileMusicExtension;
  bool _publishingInProgress = false;
  var trackUploadingProgress;
  AudioPlayer audioPlayerForDuration;
  ////////////////////////////////////

  @override
  void initState() {
    print('UID : ' + widget.currentUser);
    print('Username : ' + widget.currentUserUsername);
    print('userPhotoURL : ' + widget.currentUserPhoto);
    _unReleasedTracks = new ScrollController();
    _titleTextEditingController = new TextEditingController();
    audioPlayerForDuration = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
    super.initState();
  }

  @override
  void dispose() {
    audioPlayerForDuration.dispose();
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
              actionsForegroundColor: Colors.lightBlue,
              previousPageTitle: 'Home',
              automaticallyImplyTitle: true,
              automaticallyImplyLeading: true,
              transitionBetweenRoutes: true,
              backgroundColor: Colors.black.withOpacity(0.7),
              largeTitle: new Text('Unreleased tracks',
                  style: new TextStyle(color: Colors.white),
                  ),
              trailing: new Material(
                color: Colors.transparent, 
                child: new IconButton(
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                icon: new Icon(Icons.add_circle_outline_rounded, color: Colors.lightBlue, size: 25.0),
                onPressed: () {
                  showBarModalBottomSheet(
                    context: context, 
                    builder: (context){
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter modalSetState) {
                         return new Container(
                         height: MediaQuery.of(context).size.height*0.92,
                         width: MediaQuery.of(context).size.width,
                         color: Color(0xFF181818),
                         child: 
                         _publishingInProgress == true
                         ? new Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             new Container(
                               child: new Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children: [
                                   new Container(
                                     height: MediaQuery.of(context).size.height*0.04,
                                     width: MediaQuery.of(context).size.width,
                                     color: Colors.transparent,
                                   ),
                                   new Container(
                                     child: new Center(
                                      child: new Text('Store a new unreleased track',
                                      style: new TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16.0, fontWeight: FontWeight.bold),
                                      ),
                                     ),
                                   ),
                                   new Container(
                                     height: MediaQuery.of(context).size.height*0.70,
                                     width: MediaQuery.of(context).size.width,
                                     child: new Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         new Container(
                                           height: MediaQuery.of(context).size.height*0.20,
                                           width: MediaQuery.of(context).size.width,
                                           child: new Column(
                                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                             children: [
                                               new Text('Uploading in progress',
                                               style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                                               ),
                                               new Text('This track could not be played by others producers.',
                                               style: new TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.normal),
                                               ),
                                                new Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  child: new LinearProgressIndicator(
                                                    backgroundColor: Colors.grey[900],
                                                    minHeight: 6.0,
                                                    value: trackUploadingProgress != null ? trackUploadingProgress : null,
                                                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.purpleAccent,
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
                             ),
                           ],
                         )
                         : new Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                              new Container(
                               child: new Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children: [
                             new Container(
                               height: MediaQuery.of(context).size.height*0.04,
                               width: MediaQuery.of(context).size.width,
                               color: Colors.transparent,
                             ),
                             new Container(
                               child: new Center(
                                 child: new Text('Store a new unreleased track',
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
                               height: MediaQuery.of(context).size.height*0.04,
                               width: MediaQuery.of(context).size.width,
                               color: Colors.transparent,
                             ),
                             new Container(
                               child: new Center(
                                 child: new Text('Audio file',
                                 style: new TextStyle(color: Colors.grey[700], fontSize: 16.0, fontWeight: FontWeight.bold),
                                 ),
                               ),
                             ),
                             new Container(
                               height: MediaQuery.of(context).size.height*0.02,
                               width: MediaQuery.of(context).size.width,
                               color: Colors.transparent,
                             ),
                             _music != null 
                             ? new Container(
                               height: MediaQuery.of(context).size.height*0.05,
                               width: MediaQuery.of(context).size.width*0.49,
                               decoration: new BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: new BorderRadius.circular(5.0),
                               ),
                               child: new Center(
                                 child: new Text('Audio uploaded.',
                                 style: new TextStyle(color: Colors.purpleAccent, fontSize: 14.0, fontWeight: FontWeight.bold),
                                 ),
                               ),
                             )
                             : new InkWell(
                               onTap: () async {
                                var mediaLibraryIOSPermission = await Permission.mediaLibrary.status;
                                if(mediaLibraryIOSPermission.isGranted) {
                                  print('MediaLibraryPermission is already granted');
                                  FilePickerResult result  = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['mp3','wav', 'aiff']);
                                  if(result != null) {
                                    modalSetState(() {
                                      _music = new File(result.files.single.path);
                                      _music.absolute.existsSync();
                                      _fileMusicExtension = result.files.single.extension;
                                      print('_fileMusicExtension = $_fileMusicExtension');
                                    });
                                  } else {
                                    print('No sound selected');
                                  }
                                }
                                if(mediaLibraryIOSPermission.isUndetermined) {
                                  await Permission.mediaLibrary.request();
                                  if(await Permission.mediaLibrary.request().isGranted) {
                                    FilePickerResult result  = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['mp3','wav', 'aiff']);
                                    if(result != null) {
                                    modalSetState(() {
                                      _music = new File(result.files.single.path);
                                      _music.absolute.existsSync();
                                      _fileMusicExtension = result.files.single.extension;
                                      print('_fileMusicExtension = $_fileMusicExtension');
                                    }); 
                                    } else {
                                      print('No sound selected');
                                    }
                                  }
                
                                  if(await Permission.mediaLibrary.request().isDenied) {
                                    PermissionDemandClass().iosDialogFile(context);
                                  }
                                  if(await Permission.mediaLibrary.request().isPermanentlyDenied) {
                                    PermissionDemandClass().iosDialogFile(context);
                                  }
                                }
                                if(mediaLibraryIOSPermission.isDenied || mediaLibraryIOSPermission.isPermanentlyDenied) {
                                  PermissionDemandClass().iosDialogFile(context);
                                }
                               },
                             child: new Container(
                               height: MediaQuery.of(context).size.height*0.05,
                               width: MediaQuery.of(context).size.width*0.49,
                               decoration: new BoxDecoration(
                                 color: Colors.grey[900],
                                 border: new Border.all(
                                   width: 2.0,
                                   color: Colors.lightBlue.withOpacity(0.5),
                                 ),
                                 borderRadius: new BorderRadius.circular(5.0),
                               ),
                               child: new Center(
                                 child: new Text('Tap to upload',
                                 style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
                                 ),
                               ),
                             ),
                             ),
                             new Container(
                               height: MediaQuery.of(context).size.height*0.04,
                               width: MediaQuery.of(context).size.width,
                               color: Colors.transparent,
                             ),
                             new Container(
                               child: new Center(
                                 child: new Text('Cover image',
                                 style: new TextStyle(color: Colors.grey[700], fontSize: 16.0, fontWeight: FontWeight.bold),
                                 ),
                               ),
                             ),
                             new Container(
                               height: MediaQuery.of(context).size.height*0.02,
                               width: MediaQuery.of(context).size.width,
                               color: Colors.transparent,
                             ),
                             _image != null
                             ? new Container(
                               height: MediaQuery.of(context).size.height*0.05,
                               width: MediaQuery.of(context).size.width*0.49,
                               decoration: new BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: new BorderRadius.circular(5.0),
                               ),
                               child: new Center(
                                 child: new Text('Cover uploaded.',
                                 style: new TextStyle(color: Colors.purpleAccent, fontSize: 14.0, fontWeight: FontWeight.bold),
                                 ),
                               ),
                             )
                             : new InkWell(
                               onTap: () async {
                     var photoIOSPermission = await Permission.photos.status;
                     if(photoIOSPermission.isGranted) {
                       print('Accepté');
                       FilePickerResult resultImage  = await FilePicker.platform.pickFiles(type: FileType.image);
                       //final pickedFile = await picker.getImage(source: ImageSource.gallery);
                          modalSetState(() {
                           if (resultImage != null) {
                             _image = File(resultImage.files.single.path);
                           } else {
                             print('No image selected.');
                           }
                         });
                     }
                     if(photoIOSPermission.isUndetermined) {
                       await Permission.photos.request();
                       if(await Permission.photos.request().isGranted) {
                       //final pickedFile = await picker.getImage(source: ImageSource.gallery);
                       FilePickerResult resultImage  = await FilePicker.platform.pickFiles(type: FileType.image);
                          modalSetState(() {
                           if (resultImage != null) {
                             _image = File(resultImage.files.single.path);
                           } else {
                             print('No image selected.');
                           }
                         });
                       }
                       if(await Permission.photos.request().isDenied) {
                         PermissionDemandClass().iosDialogImage(context);
                       }
                       if(await Permission.photos.request().isPermanentlyDenied) {
                         PermissionDemandClass().iosDialogImage(context);
                       }
                     }
                     if(photoIOSPermission.isDenied || photoIOSPermission.isPermanentlyDenied) {
                       PermissionDemandClass().iosDialogImage(context);
                     }
                               },
                             child: new Container(
                               height: MediaQuery.of(context).size.height*0.05,
                               width: MediaQuery.of(context).size.width*0.49,
                               decoration: new BoxDecoration(
                                 color: Colors.grey[900],
                                 border: new Border.all(
                                   width: 2.0,
                                   color: Colors.lightBlue.withOpacity(0.5),
                                 ),
                                 borderRadius: new BorderRadius.circular(5.0),
                               ),
                               child: new Center(
                                 child: new Text('Tap to upload',
                                 style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
                                 ),
                               ),
                             ),
                             ),
                             new Container(
                               height: MediaQuery.of(context).size.height*0.04,
                               width: MediaQuery.of(context).size.width,
                               color: Colors.transparent,
                             ),
                             new Container(
                               child: new Center(
                                 child: new Text('Title',
                                 style: new TextStyle(color: Colors.grey[700], fontSize: 16.0, fontWeight: FontWeight.bold),
                                 ),
                               ),
                             ),
                             new Container(
                               height: MediaQuery.of(context).size.height*0.02,
                               width: MediaQuery.of(context).size.width,
                               color: Colors.transparent,
                             ),
                             new Container(
                               height: MediaQuery.of(context).size.height*0.05,
                               width: MediaQuery.of(context).size.width,
                               decoration: new BoxDecoration(
                                 color: Colors.grey[900].withOpacity(0.5),
                                 borderRadius: new BorderRadius.circular(0.0),
                               ),
                               child: new Center(
                               child: new CupertinoTextField(
                                 textAlign: TextAlign.center,
                                 controller: _titleTextEditingController,
                                 cursorColor: Colors.lightBlue,
                                 padding: EdgeInsets.only(left: 20.0),
                                 minLines: 1,
                                 maxLines: 1,
                                 keyboardType: TextInputType.text,
                                 decoration: new BoxDecoration(
                                   color: Colors.grey[900].withOpacity(0.5),
                                 ),
                                 style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
                               ),
                              ),
                             ),
                             new Container(
                               height: MediaQuery.of(context).size.height*0.04,
                               width: MediaQuery.of(context).size.width,
                               color: Colors.transparent,
                             ),
                             new Container(
                               child: new Center(
                                 child: new Text('Style',
                                 style: new TextStyle(color: Colors.grey[700], fontSize: 16.0, fontWeight: FontWeight.bold),
                                 ),
                               ),
                             ),
                             new Container(
                               height: MediaQuery.of(context).size.height*0.02,
                               width: MediaQuery.of(context).size.width,
                               color: Colors.transparent,
                             ),
                             new Container(
                               height: MediaQuery.of(context).size.height*0.10,
                               decoration: new BoxDecoration(
                                 color: Colors.grey[900].withOpacity(0.0),
                                 borderRadius: new BorderRadius.circular(10.0),
                               ),
                               child: new Padding(
                                 padding: EdgeInsets.all(0.0),
                               child: new CupertinoPicker(
                                 backgroundColor: Colors.transparent,
                                 itemExtent: 50.0, 
                                 onSelectedItemChanged: (value) {
                                   modalSetState(() {
                                     musicStyleSelectedValue = value;
                                     print(musicStyleSelectedValue);
                                   });
                                 }, 
                                 children: [
                                   new Center(
                                   child: new Text('Future-House',
                                   style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                                   )),
                                   new Center(
                                   child: new Text('Progressive-House',
                                   style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                                   )),
                                   new Center(
                                   child: new Text('Deep-House',
                                   style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                                   )),
                                   new Center(
                                   child: new Text('Acid-House',
                                   style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                                   )),
                                   new Center(
                                   child: new Text('Chill-House',
                                   style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                                   )),
                                   new Center(
                                   child: new Text('Trap',
                                   style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                                   )),
                                   new Center(
                                   child: new Text('Dubstep',
                                   style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                                   )),
                                   new Center(
                                   child: new Text('Dirty-Dutch',
                                   style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                                   )),
                                   new Center(
                                   child: new Text('Techno',
                                   style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                                   )),
                                   new Center(
                                   child: new Text('Trance',
                                   style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                                   )),
                                   new Center(
                                   child: new Text('Hardstyle',
                                   style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                                   )),
                                 ],
                                 ),
                               ),
                               ),
                             new Container(
                               height: MediaQuery.of(context).size.height*0.06,
                               width: MediaQuery.of(context).size.width,
                               color: Colors.transparent,
                              ),
                               ],
                               ),
                               ),
                             new Container(
                               height: MediaQuery.of(context).size.height*0.03,
                               width: MediaQuery.of(context).size.width,
                               color: Colors.transparent,
                              ),
                              new Container(
                                width: MediaQuery.of(context).size.width*0.70,
                              child: new CupertinoButton(
                                onPressed: () async {
                                  modalSetState((){
                                    _publishingInProgress = true;
                                  });
                                  String _timestampUpload = DateTime.now().microsecondsSinceEpoch.toString();
                                  firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance
                                    .ref()
                                    .child('${widget.currentUser}/songs/$_timestampUpload/$_timestampUpload-image');
                                    firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);
                                    await uploadTask;
                                    print('Firebase storage : Cover image uploaded.');
                                    storageReference.getDownloadURL().then((fileImageUrl) async {
                                      print('Firebase storage : Music uploading in progress ...');
                                      firebase_storage.Reference musicStorage = firebase_storage.FirebaseStorage.instance
                                        .ref()
                                        .child('${widget.currentUser}/songs/$_timestampUpload/$_timestampUpload.$_fileMusicExtension');
                                        if(_music.existsSync()) {
                                          firebase_storage.UploadTask uploadMusicTask = musicStorage.putFile(_music);
                                          uploadMusicTask.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) { 
                                            modalSetState((){
                                              trackUploadingProgress = ((snapshot.bytesTransferred/snapshot.totalBytes)).toDouble();
                                            });
                                            print('Firebase storage : Music uploaded at = $trackUploadingProgress');
                                          });
                                          await uploadMusicTask;
                                          musicStorage.getDownloadURL().then((fileMusicUrl) {
                                            audioPlayerForDuration.play(fileMusicUrl, volume: 0).whenComplete(() async {
                                              await Future.delayed(new Duration(milliseconds: 2000), () =>
                                              audioPlayerForDuration.getDuration()).then((durationFileAudio) {
                                                audioPlayerForDuration.stop();
                                                //Cloud firestore request //
                                                FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(widget.currentUser)
                                                  .collection('unreleasedTracks')
                                                  .doc(_timestampUpload+widget.currentUser)
                                                  .set({
                                                    'songLocked': true,
                                                    'title': _titleTextEditingController.text.length >= 2 ? _titleTextEditingController.value.text : null,
                                                    'artistProfilePhoto': widget.currentUserPhoto,
                                                    'artistUsername': widget.currentUserUsername,
                                                    'artistUID': widget.currentUser,
                                                    'timestamp': _timestampUpload,
                                                    'coverImage': fileImageUrl,
                                                    'fileMusicURL': fileMusicUrl,
                                                    'fileMusicDuration': durationFileAudio,
                                                    'style': 
                                                    musicStyleSelectedValue == 0 ? 'futureHouse' 
                                                    : musicStyleSelectedValue == 1 ? 'progressiveHouse' 
                                                    : musicStyleSelectedValue == 2 ? 'deepHouse' 
                                                    : musicStyleSelectedValue == 3 ? 'acidHouse'
                                                    : musicStyleSelectedValue == 4 ? 'chillHouse'
                                                    : musicStyleSelectedValue == 5 ? 'trap'
                                                    : musicStyleSelectedValue == 6 ? 'dubstep'
                                                    : musicStyleSelectedValue == 7 ? 'dirtyDutch'
                                                    : musicStyleSelectedValue == 8 ? 'techno'
                                                    : musicStyleSelectedValue == 9 ? 'trance'
                                                    : musicStyleSelectedValue == 10 ? 'hardstyle'
                                                    : 'futureHouse',
                                                  }).whenComplete(() {
                                                    print('Cloud Firestore : Metadatas are stored.');
                                                    modalSetState((){
                                                      _publishingInProgress = false;
                                                    });
                                                    _titleTextEditingController.clear();
                                                    Navigator.pop(context);
                                                  });
                                              });
                                            });
                                          });
                                        } else {
                                          print('MusicExistSync : Error.');
                                        }
                                    });
                                },
                                color: Colors.lightBlue,
                                child: new Center(
                                  child: new Text('UPLOAD'),
                                ),
                                ),
                              ),
                             ],
                            ),
                         );
                        },
                      );
                    }).whenComplete(() {
                      setState(() {
                        _music = null;
                        _image = null;
                      });
                    });
                },
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
                child: new Text('These tracks can not be played by others users.',
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
                      child: new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('users').doc(widget.currentUser).collection('unreleasedTracks').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                          return new Container(
                          height: MediaQuery.of(context).size.height*0.50,
                          width: MediaQuery.of(context).size.width,
                            color: Colors.black,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Center(child: new Text('Fetching datas', style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold))),
                                new Padding(
                                  padding: EdgeInsets.only(top: 40.0),
                                  child: new CupertinoActivityIndicator(
                                    animating: true,
                                    radius: 15.0,
                                  ),
                            )]));
                          } 
                        if(snapshot.hasError) {
                          return new Container(
                          height: MediaQuery.of(context).size.height*0.50,
                          width: MediaQuery.of(context).size.width,
                            color: Colors.black,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Center(child: new Text('Please, check your network connection.', style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold))),
                                new Padding(
                                  padding: EdgeInsets.only(top: 30.0),
                                child: new Icon(Icons.network_check_outlined, color: Colors.white,size: 40.0))]));
                        }
                        if(!snapshot.hasData) {
                          return new Container(
                          height: MediaQuery.of(context).size.height*0.50,
                          width: MediaQuery.of(context).size.width,
                            color: Colors.black,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Center(child: new Text('Store safetly your unreleased tracks here.', style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold))),
                                new Padding(padding: EdgeInsets.only(top: 30.0),
                                child: new Center(child: new Text('Only you have the access.', style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.bold))),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(top: 30.0),
                                child: new Icon(Icons.lock_outline_rounded, color: Colors.white,size: 40.0)),
                              ],
                            ),
                          );
                        }
                        if(snapshot.data.documents.isEmpty) {
                          return new Container(
                          height: MediaQuery.of(context).size.height*0.50,
                          width: MediaQuery.of(context).size.width,
                            color: Colors.black,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Center(child: new Text('Store safetly your unreleased tracks here.', style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold))),
                                new Padding(padding: EdgeInsets.only(top: 30.0),
                                child: new Center(child: new Text('Only you have the access.', style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.bold))),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(top: 30.0),
                                child: new Icon(Icons.lock_outline_rounded, color: Colors.white,size: 40.0)),
                              ],
                            ),
                          );
                        }
                        return new Container(
                        child: new ListView.builder(
                        shrinkWrap: true,
                        physics: new NeverScrollableScrollPhysics(),
                        controller: _unReleasedTracks,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot ds = snapshot.data.documents[index];
                        return new Container(
                          height: MediaQuery.of(context).size.height*0.10,
                          width: MediaQuery.of(context).size.width,
                          child: new ListTile(
                            leading: new Container(
                            height: MediaQuery.of(context).size.height*0.05,
                            width: MediaQuery.of(context).size.height*0.05,
                            child: new ClipOval(
                              child: ds.data()['coverImage'] != null ?
                              new Image.network(ds.data()['coverImage'], fit: BoxFit.cover)
                              : new Container(),
                          )),
                          title: new Text(ds.data()['artistUsername'] != null ?
                          ds.data()['artistUsername'] : '',
                          style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          subtitle: new Text( ds.data()['title'] != null ?
                          ds.data()['title'] : '',
                          style: new TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.normal),
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
                                    child: new Text('Move to released'),
                                    onPressed: () {
                                      print('pressed');
                                    },
                                  ),
                                  new CupertinoActionSheetAction(
                                    child: new Text('Modify cover'),
                                    onPressed: () {
                                      print('pressed');
                                    },
                                  ),
                                  new CupertinoActionSheetAction(
                                    child: new Text('Modify title'),
                                    onPressed: () {
                                      print('pressed');
                                    },
                                  ),
                                  new CupertinoActionSheetAction(
                                    child: new Text('Download'),
                                    onPressed: () {
                                      print('pressed');
                                    },
                                  ),
                                  new CupertinoActionSheetAction(
                                    child: new Text('Delete', style: new TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      showDialog(
                                      context: context,
                                      builder: (BuildContext context) => 
                                      new CupertinoAlertDialog(
                                        title: new Text("Delete this track ?",
                                        style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                                        ),
                                        content: new Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                          child: new Text("Be careful, this track will not stored on Reverbs anymore.",
                                          style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.normal),
                                        )),
                                        actions: <Widget>[
                                          new CupertinoDialogAction(
                                            child: new Text("Delete", style: new TextStyle(color: Colors.red, fontSize: 13.0, fontWeight: FontWeight.normal)),
                                            onPressed: () {Navigator.pop(context);},
                                          ),
                                          new CupertinoDialogAction(
                                            child: Text("No, thanks", style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal)),
                                            onPressed: () {Navigator.pop(context);},
                                          )
                                        ],
                                      )
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
                        );
                        },
                        ),
                    ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}