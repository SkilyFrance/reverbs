import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../permissionsHandler.dart';


class UploadMusicPage extends StatefulWidget {

  String currentUser;
  String currentUserUserName;
  String currentUserPhoto;

  UploadMusicPage({Key key, this.currentUser, this.currentUserUserName, this.currentUserPhoto}) : super(key: key);
  


  @override
  UploadMusicPageState createState() => UploadMusicPageState();
}

class UploadMusicPageState extends State<UploadMusicPage> {

  //Others bools
  bool newSongInPublishing = false;
  bool _flagFieldEmpty =  false;
  File _image;
  File _music;
  int _durationOfMusicFile;
  String _fileMusicExtension;
  //String _dateTimeForMusicUpload;
  final picker = new ImagePicker();
  var uploadedMusicProgress;

  //ListView flatButton//
  bool edmChoosen = false;
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

  TextEditingController _descriptionTextEditingController = new TextEditingController();
  TextEditingController _titleTextEditingController = new TextEditingController();
  AudioPlayer audioPlayerForDuration;
  String descriptionMusicUpload;
  String titleMusicUpload;



  @override
  void initState() {
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
      child: new Container(
        color: Colors.black,
        child: new SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Divider
              new Container(
                height: MediaQuery.of(context).size.height*0.05,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
              //Navigator pop
              new Container(
                height: MediaQuery.of(context).size.height*0.06,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: new Center(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Container(
                        height: MediaQuery.of(context).size.height*0.06,
                        width: MediaQuery.of(context).size.width*0.08,
                      ),
                      new InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: new Image.asset('lib/assets/close.png',
                        color: Colors.white,
                        height: 20.0,
                        width: 20.0,
                        ),
                      ),
                    ],
                    ),
                ),
              ),
              new Container(
                height: MediaQuery.of(context).size.height*0.10,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: new Center(
                  child: new Text('Post your new song here.',
                  style: new TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              new Container(
                height: MediaQuery.of(context).size.height*0.06,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  new Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  width: MediaQuery.of(context).size.width*0.07,  
                  ),
                  new RichText(
                    text: new TextSpan(
                      text: 'Add your audio file',
                      style: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                      children: [
                        new TextSpan(
                          text: ' * ',
                          style: new TextStyle(color: Colors.yellowAccent, fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        new TextSpan(
                          text: '(.wav, .aiff, .mp3 ...)',
                          style: new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    ),
                    ],
                  ),
              ),
              _music != null
              ? new Container(
                height: MediaQuery.of(context).size.height*0.07,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: new Center(
                  child: new Text('Uploaded with success.',
                  style: new TextStyle(color: Colors.yellowAccent, fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
              )
              : new InkWell(
                onTap: () async {
               if(Platform.isIOS) {
                 var mediaLibraryIOSPermission = await Permission.mediaLibrary.status;
                 if(mediaLibraryIOSPermission.isGranted) {
                   print('MediaLibraryPermission is already granted');
                   FilePickerResult result  = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['mp3','wav', 'aiff']);
                   if(result != null) {
                     setState(() {
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
                     setState(() {
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
                 //Platform is Android or other
               } else {
                var mediaLibraryAndroidPermission = await Permission.storage.status;
                if(mediaLibraryAndroidPermission.isGranted) {
                  print('MediaLibraryPermission is already granted');
                  FilePickerResult result  = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['mp3','wav', 'aiff']);
                  if(result != null) {
                    setState(() {
                      _music = new File(result.files.single.path);
                      _music.absolute.existsSync();
                      _fileMusicExtension = result.files.single.extension;
                    });
                  } else {
                    print('No sound selected');
                  }
                } else if(mediaLibraryAndroidPermission.isUndetermined) {
                  await Permission.storage.request();
                  if(await Permission.storage.request().isGranted) {
                  FilePickerResult result  = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['mp3','wav', 'aiff']);
                  if(result != null) {
                    setState(() {
                      _music = new File(result.files.single.path);
                      _music.absolute.existsSync();
                      _fileMusicExtension = result.files.single.extension;
                    });
                  } else {
                    print('No sound selected');
                  }
                  } else if(await Permission.storage.request().isDenied) {
                    //Go to system
                    PermissionDemandClass().androidDialogFile(context);
                  } else if(await Permission.storage.request().isPermanentlyDenied) {
                    //Go to system
                    PermissionDemandClass().androidDialogFile(context);
                  }

                } else if(mediaLibraryAndroidPermission.isDenied||mediaLibraryAndroidPermission.isPermanentlyDenied) {
                  //Go to system
                  PermissionDemandClass().androidDialogFile(context);
                }
               }
                },
              child: new Container(
                height: MediaQuery.of(context).size.height*0.07,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: new Center(
                  child: new Container(
                    height: MediaQuery.of(context).size.height*0.07,
                    width: MediaQuery.of(context).size.width*0.6,
                    decoration: new BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: new BorderRadius.circular(10.0)
                    ),
                    child: new Center(
                      child: new Text('Click to upload.',
                      style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              ),
              //Divider
              new Container(
                height: MediaQuery.of(context).size.height*0.02,
                width: MediaQuery.of(context).size.width,
              ),
              new Container(
                height: MediaQuery.of(context).size.height*0.06,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  new Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  width: MediaQuery.of(context).size.width*0.07,  
                  ),
                  new RichText(
                    text: new TextSpan(
                      text: 'Background image (story format)',
                      style: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                      children: [
                        new TextSpan(
                          text: ' *',
                          style: new TextStyle(color: Colors.yellowAccent, fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    ),
                    ],
                  ),
              ),
              _image != null
              ? new Container(
                height: MediaQuery.of(context).size.height*0.07,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: new Center(
                  child: new Text('Uploaded with success.',
                  style: new TextStyle(color: Colors.yellowAccent, fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
              )
              : new InkWell(
                onTap: () async {
                  print('go to upload');
                  if(Platform.isIOS) {
                     var photoIOSPermission = await Permission.photos.status;
                     if(photoIOSPermission.isGranted) {
                       print('Accepté');
                       FilePickerResult resultImage  = await FilePicker.platform.pickFiles(type: FileType.image);
                       //final pickedFile = await picker.getImage(source: ImageSource.gallery);
                          setState(() {
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
                          setState(() {
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

                   } else {
                   var androidPermissions = await Permission.storage.status;
                   if(androidPermissions.isGranted) {
                     FilePickerResult resultImage  = await FilePicker.platform.pickFiles(type: FileType.image);
                   //final pickedFile = await picker.getImage(source: ImageSource.gallery);
                      setState(() {
                       if (resultImage != null) {
                         _image = File(resultImage.files.single.path);
                       } else {
                         print('No image selected.');
                       }
                     });       
                   }
                   if(androidPermissions.isUndetermined) {
                     await Permission.storage.request();
                     if(await Permission.storage.request().isGranted) {
                       FilePickerResult resultImage  = await FilePicker.platform.pickFiles(type: FileType.image);
                     //final pickedFile = await picker.getImage(source: ImageSource.gallery);
                        setState(() {
                         if (resultImage != null) {
                           _image = File(resultImage.files.single.path);
                         } else {
                           print('No image selected.');
                         }
                       });
                     }
                   if(await Permission.storage.request().isDenied) {
                       PermissionDemandClass().androidDialogImage(context);
                   }
                   if(await Permission.storage.request().isPermanentlyDenied) {
                       PermissionDemandClass().androidDialogImage(context);
                   }
                   }
                   if(androidPermissions.isPermanentlyDenied || androidPermissions.isDenied) {
                       PermissionDemandClass().androidDialogImage(context);
                   }
                   } 
                },
              child: new Container(
                height: MediaQuery.of(context).size.height*0.07,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: new Center(
                  child: new Container(
                    height: MediaQuery.of(context).size.height*0.07,
                    width: MediaQuery.of(context).size.width*0.6,
                    decoration: new BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: new BorderRadius.circular(10.0)
                    ),
                    child: new Center(
                      child: new Text('Click to upload.',
                      style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              ),
              //Divider
              new Container(
                height: MediaQuery.of(context).size.height*0.02,
                width: MediaQuery.of(context).size.width,
              ),
              new Container(
                height: MediaQuery.of(context).size.height*0.06,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  new Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  width: MediaQuery.of(context).size.width*0.07,  
                  ),
                  new RichText(
                    text: new TextSpan(
                      text: 'Choose style of this song',
                      style: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                      children: [
                        new TextSpan(
                          text: ' *',
                          style: new TextStyle(color: Colors.yellowAccent, fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    ),
                    ],
                  ),
              ),
              new Container(
                height: MediaQuery.of(context).size.height*0.05,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
            child: new Container(
              height: MediaQuery.of(context).size.height*0.05,
              color: Colors.transparent,
              child: new Center(
                child: new ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(top: 3.0,left: 10.0, right: 20.0, bottom: 3.0),
                  children: [
                    //EDM
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: edmChoosen == true ? Colors.yellowAccent :  Colors.grey[900],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
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
                       style: new TextStyle(color: edmChoosen == true ? Colors.black : Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                       ))),
                    //ELECTRO
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: electroChoosen == true ? Colors.yellowAccent :  Colors.grey[900],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
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
                       style: new TextStyle(color: electroChoosen == true ? Colors.black : Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                       ))),
                    //HOUSE
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: houseChoosen == true ? Colors.yellowAccent :  Colors.grey[900],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
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
                       style: new TextStyle(color: houseChoosen == true ? Colors.black : Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                       ))),
                    //ACID-HOUSE
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: acidHouseChoosen == true ? Colors.yellowAccent :  Colors.grey[900],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
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
                       style: new TextStyle(color: acidHouseChoosen == true ? Colors.black : Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                       ))),
                    //FUTURE-HOUSE
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: futureHouseChoosen == true ? Colors.yellowAccent : Colors.grey[900],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
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
                       style: new TextStyle(color: futureHouseChoosen == true ? Colors.black : Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                       ))),
                    //DEEPHOUSE
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: deepHouseChoosen == true ? Colors.yellowAccent : Colors.grey[900],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
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
                       style: new TextStyle(color: deepHouseChoosen == true ? Colors.black : Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                       ))),
                    //CHILL-HOUSE
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: chillHouseChoosen == true ? Colors.yellowAccent : Colors.grey[900],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
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
                       style: new TextStyle(color: chillHouseChoosen == true ? Colors.black : Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                       ))),
                    //TECHNO
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: technoChoosen == true ? Colors.yellowAccent : Colors.grey[900],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
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
                       style: new TextStyle(color: technoChoosen == true ? Colors.black : Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                       ))),
                    //TRANCE
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: tranceChoosen == true ? Colors.yellowAccent : Colors.grey[900],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
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
                       style: new TextStyle(color: tranceChoosen == true ? Colors.black : Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                       ))),
                    //PROGRESSIVE
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: progressiveChoosen == true ? Colors.yellowAccent : Colors.grey[900],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
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
                       style: new TextStyle(color: progressiveChoosen == true ? Colors.black : Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                       ))),
                    //MINIMALE
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: minimaleChoosen == true ? Colors.yellowAccent : Colors.grey[900],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
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
                       style: new TextStyle(color: minimaleChoosen == true ? Colors.black : Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                       ))),
                    //DUBSTEP
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: dubstepChoosen == true ? Colors.yellowAccent : Colors.grey[900],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
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
                       style: new TextStyle(color: dubstepChoosen == true ? Colors.black : Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                       ))),
                    //Trap
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: trapChoosen == true ? Colors.yellowAccent : Colors.grey[900],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
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
                       style: new TextStyle(color: trapChoosen == true ? Colors.black : Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                       ))),
                    //DIRTY DUTCH
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: dirtyDutchChoosen == true ? Colors.yellowAccent : Colors.grey[900],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
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
                       style: new TextStyle(color: dirtyDutchChoosen == true ? Colors.black : Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                       ))),
                    //MOOMBAHTON
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: moombathtonChoosen == true ? Colors.yellowAccent : Colors.grey[900],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
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
                       style: new TextStyle(color: moombathtonChoosen == true ? Colors.black : Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                       ))),
                    //HARDSTYLE
                    new Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    child: new FlatButton(
                      color: hardstyleChoosen == true ? Colors.yellowAccent : Colors.grey[900],
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
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
                       style: new TextStyle(color: hardstyleChoosen == true ? Colors.black : Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                       ))),
                  ],
                ),
              )),
              ),
              //Divider
              new Container(
                height: MediaQuery.of(context).size.height*0.02,
                width: MediaQuery.of(context).size.width,
              ),
              //Title
              new Container(
                height: MediaQuery.of(context).size.height*0.06,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  new Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  width: MediaQuery.of(context).size.width*0.07,  
                  ),
                  new RichText(
                    text: new TextSpan(
                      text: "Song's title",
                      style: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                      children: [
                        new TextSpan(
                          text: ' *',
                          style: new TextStyle(color: Colors.yellowAccent, fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    ),
                    ],
                  ),
              ),
              new Container(
                height: MediaQuery.of(context).size.height*0.07,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: new Center(
                  child: new Container(
                    height: MediaQuery.of(context).size.height*0.06,
                    width: MediaQuery.of(context).size.width*0.8,
                    decoration: new BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: new BorderRadius.circular(10.0)
                    ),
                    child: new Center(
                          child: new Padding(
                            padding: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
                          child: new TextField(
                            textAlignVertical: TextAlignVertical.center,
                            style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
                            controller: _titleTextEditingController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            minLines: 1,
                            maxLines: 1,
                            maxLength: 30,
                            textAlign: TextAlign.center,
                            cursorColor: Colors.yellowAccent,
                            decoration: new InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              counterText: '',
                              hintText: 'Title',
                              hintStyle: new TextStyle(color: Colors.grey[700], fontSize: 12.0, fontWeight: FontWeight.bold),
                              border: new OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
                ),
              ),
              //Divider
              new Container(
                height: MediaQuery.of(context).size.height*0.02,
                width: MediaQuery.of(context).size.width,
              ),
              new Container(
                height: MediaQuery.of(context).size.height*0.06,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  new Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  width: MediaQuery.of(context).size.width*0.07,  
                  ),
                  new Text('Add a description (optional) ',
                  style: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    ],
                  ),
              ),
              new Container(
                height: MediaQuery.of(context).size.height*0.17,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: new Center(
                  child: new Container(
                    height: MediaQuery.of(context).size.height*0.15,
                    width: MediaQuery.of(context).size.width*0.8,
                    decoration: new BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: new BorderRadius.circular(10.0)
                    ),
                    child: new Center(
                          child: new Padding(
                            padding: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
                          child: new TextField(
                            textAlignVertical: TextAlignVertical.center,
                            style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
                            controller: _descriptionTextEditingController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            minLines: 1,
                            maxLines: 10,
                            maxLength: 150,
                            textAlign: TextAlign.center,
                            cursorColor: Colors.yellowAccent,
                            decoration: new InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              counterText: '',
                              hintText: 'Explain your project (150 max)',
                              hintStyle: new TextStyle(color: Colors.grey[700], fontSize: 12.0, fontWeight: FontWeight.bold),
                              border: new OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
                ),
              ),
              //Divider
              new Container(
                height: MediaQuery.of(context).size.height*0.03,
                width: MediaQuery.of(context).size.width,
              ),
              new Container(
                height: MediaQuery.of(context).size.height*0.15,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: new Center(
                  child: newSongInPublishing == false 
                   ? new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                   new InkWell(
                    onTap: () {
                      if(_music != null && _image != null && _titleTextEditingController.text.length >= 2 && (edmChoosen == true || electroChoosen == true || houseChoosen == true || acidHouseChoosen ==  true || futureHouseChoosen == true ||
                      deepHouseChoosen == true || chillHouseChoosen == true || technoChoosen == true || tranceChoosen == true || progressiveChoosen == true ||
                      minimaleChoosen == true || dubstepChoosen == true || trapChoosen == true || dirtyDutchChoosen == true|| moombathtonChoosen == true ||hardstyleChoosen == true)) {
                      puslishRequest();
                      } else {
                        setState(() {
                          _flagFieldEmpty = true;
                        });
                      }
                    },
                  child: new Container(
                    height: MediaQuery.of(context).size.height*0.07,
                    width: MediaQuery.of(context).size.width*0.70,
                    decoration: new BoxDecoration(
                      color: Colors.yellowAccent,
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: new Center(
                      child: new Text('PUBLISH',
                      style: new TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                _flagFieldEmpty == true
                ? new RichText(
                  text: new TextSpan(
                    text: 'Be careful, all fields with',
                    style: new TextStyle(color: Colors.redAccent, fontSize: 14.0, fontWeight: FontWeight.bold),
                    children: [
                      new TextSpan(
                        text: " * ",
                        style: new TextStyle(color: Colors.yellowAccent, fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                      new TextSpan(
                        text: 'could not be empty.',
                        style: new TextStyle(color: Colors.redAccent, fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                    ]
                  ),
                )
                : new Container(),
                ],
                )
                : new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new Text(
                      uploadedMusicProgress != null && uploadedMusicProgress < 0.1 
                      ? 'Amazing, publishing in progress ..'
                      : uploadedMusicProgress != null && uploadedMusicProgress > 0.10 &&  uploadedMusicProgress < 0.40 ? 'Huge track buddy ...'
                      : uploadedMusicProgress != null && uploadedMusicProgress > 0.41 &&  uploadedMusicProgress < 0.61 ? 'Great things make time ...'
                      : uploadedMusicProgress != null && uploadedMusicProgress > 0.62 && uploadedMusicProgress < 0.81 ? 'Quality is the key ...'
                      : uploadedMusicProgress != null && uploadedMusicProgress > 0.82 && uploadedMusicProgress < 0.90 ? 'End is soon ...'
                      : uploadedMusicProgress != null && uploadedMusicProgress > 0.91 && uploadedMusicProgress <= 1.0 ? 'On the home stretch ...'
                      : 'Amazing, publishing in progress ..',
                    style: new TextStyle(color: Colors.yellowAccent, fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new LinearProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
                      backgroundColor: Colors.yellowAccent.withOpacity(0.4),
                      value: uploadedMusicProgress != null ? uploadedMusicProgress : null,
                    ),
                    ),
                  ],
                ),
              ),
              ),
              new Container(
                height: MediaQuery.of(context).size.height*0.07,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }



    puslishRequest() async  {
      setState(() {
        newSongInPublishing = true;
        _flagFieldEmpty = false;
      });
      String _dateTimeForMusicUpload = DateTime.now().microsecondsSinceEpoch.toString();
      firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('${widget.currentUser}/songs/$_dateTimeForMusicUpload/$_dateTimeForMusicUpload-image');
        firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);
        await uploadTask;
        print('Photo upload (Storage)');
        storageReference.getDownloadURL().then((filePhotoURL) {
          storeMusicRequest(filePhotoURL,_dateTimeForMusicUpload);
          });
        }

    storeMusicRequest(String filePhotoURL, String dataTime) async {
      print('Music uploading in progress ...');
          firebase_storage.Reference storageForMusic = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('${widget.currentUser}/songs/$dataTime/$dataTime.$_fileMusicExtension');
            if(_music.existsSync()) {
            firebase_storage.UploadTask uploadTaskForMusic = storageForMusic.putFile(_music);
            uploadTaskForMusic.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) { 
              setState(() {
                uploadedMusicProgress = ((snapshot.bytesTransferred/snapshot.totalBytes)).toDouble();
              });
                print('uploadedMusicProgress = $uploadedMusicProgress');
            });
            await uploadTaskForMusic;
            storageForMusic.getDownloadURL().then((fileMusicURL) {
                audioPlayerForDuration.play(fileMusicURL, volume: 0).whenComplete(() async {
                await Future.delayed(new Duration(milliseconds: 2000), () => 
                audioPlayerForDuration.getDuration()).then((durationFileAudio) {
                audioPlayerForDuration.stop();
                FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.currentUser)
                  .collection('songs')
                  .doc('$dataTime')
                  .set({
                    'artistProfilePhoto': widget.currentUserPhoto,
                    'artistUsername': widget.currentUserUserName,
                    'artistUID': widget.currentUser,
                    'timestamp': dataTime,
                    'views': 0,
                    'likes': 0,
                    'shares': 0,
                    'comments': 0,
                    'imageSong': filePhotoURL,
                    'fileMusicURL': fileMusicURL,
                    'fileMusicDuration': durationFileAudio,
                    'style': edmChoosen == true ? 'edm' : electroChoosen == true ? 'electro' : houseChoosen == true ? 'house' : acidHouseChoosen == true ? 'acidHouse' : futureHouseChoosen == true ? 'futureHouse' : deepHouseChoosen == true ? 'deepHouse' : chillHouseChoosen == true ? 'chillHouse' : technoChoosen == true ? 'techno' : tranceChoosen == true ? 'trance' : progressiveChoosen == true ? 'progressive' : minimaleChoosen == true ? 'minimale' : dubstepChoosen == true ? 'dubstep' :  trapChoosen == true ? 'trap' : dirtyDutchChoosen == true ? 'dirtyDuctch' : moombathtonChoosen == true ? 'moombathton' : hardstyleChoosen == true ? 'hardstyle' : 'edm',
                    'description': _descriptionTextEditingController.text.length > 3 ? _descriptionTextEditingController.value.text : null,
                    'title': _titleTextEditingController.text.length >= 2 ? _titleTextEditingController.value.text : null,
                  }).whenComplete(() {
                FirebaseFirestore.instance
                  .collection(edmChoosen == true ? 'edm' : electroChoosen == true ? 'electro' : houseChoosen == true ? 'house' : acidHouseChoosen == true ? 'acidHouse' : futureHouseChoosen == true ? 'futureHouse' : deepHouseChoosen == true ? 'deepHouse' : chillHouseChoosen == true ? 'chillHouse' : technoChoosen == true ? 'techno' : tranceChoosen == true ? 'trance' : progressiveChoosen == true ? 'progressive' : minimaleChoosen == true ? 'minimale' : dubstepChoosen == true ? 'dubstep' :  trapChoosen == true ? 'trap' : dirtyDutchChoosen == true ? 'dirtyDuctch' : moombathtonChoosen == true ? 'moombathton' : hardstyleChoosen == true ? 'hardstyle' : 'edm')
                  .doc(dataTime)
                  .set({
                    'artistProfilePhoto': widget.currentUserPhoto,
                    'artistUID': widget.currentUser,
                    'artistUsername': widget.currentUserUserName,
                    'timestamp': dataTime,
                    'views': 0,
                    'likes': 0,
                    'shares': 0,
                    'comments': 0,
                    'imageSong': filePhotoURL,
                    'fileMusicURL': fileMusicURL,
                    'fileMusicDuration': durationFileAudio,
                    'style': edmChoosen == true ? 'edm' : electroChoosen == true ? 'electro' : houseChoosen == true ? 'house' : acidHouseChoosen == true ? 'acidHouse' : futureHouseChoosen == true ? 'futureHouse' : deepHouseChoosen == true ? 'deepHouse' : chillHouseChoosen == true ? 'chillHouse' : technoChoosen == true ? 'techno' : tranceChoosen == true ? 'trance' : progressiveChoosen == true ? 'progressive' : minimaleChoosen == true ? 'minimale' : dubstepChoosen == true ? 'dubstep' :  trapChoosen == true ? 'trap' : dirtyDutchChoosen == true ? 'dirtyDuctch' : moombathtonChoosen == true ? 'moombathton' : hardstyleChoosen == true ? 'hardstyle' : 'edm',
                    'description': _descriptionTextEditingController.text.length > 3 ? _descriptionTextEditingController.value.text.toString() : null,
                    'title': _titleTextEditingController.text.length >= 2 ? _titleTextEditingController.value.text : null,
                  }).whenComplete(() {
                    print('all datas has been stores (Storage + Firestore)');
                    setState(() {
                      newSongInPublishing = false;
                    });
                     _titleTextEditingController.clear();
                     _descriptionTextEditingController.clear();
                    Navigator.pop(context);
                  });
                  });
                });
              
                });
            });
        } else {
          print('music no exist now');
        }
   }

  } 
