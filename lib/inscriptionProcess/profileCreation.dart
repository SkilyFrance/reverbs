import 'dart:io';
import 'package:SONOZ/inscriptionProcess/landingPage.dart';
import 'package:SONOZ/navigation.dart';
import 'package:SONOZ/permissionsHandler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileCreationProcessPage extends StatefulWidget {

  String currentUser;
  String currentUserEmail; 

  ProfileCreationProcessPage({Key key,this.currentUser, this.currentUserEmail}) : super(key: key);

  @override
  ProfileCreationProcessPageState createState() => ProfileCreationProcessPageState();
}

class ProfileCreationProcessPageState extends State<ProfileCreationProcessPage> {

  //bool for music
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

  // TextEditingController //
  TextEditingController _userNameEditingController = new TextEditingController();
  TextEditingController _linkMusicShopController = new TextEditingController();
  TextEditingController _titleTextEditingController = new TextEditingController();
  PageController _profileCreationController = new PageController(initialPage: 0, viewportFraction: 1);

  //CurrentUserVariables//
  String currentUsername;
  String shopLinkInput;

  //Bool variables
  bool iamDJ = false;
  bool iamFan = false;
  
  //ImagePicker variables
  File _image;
  File _musicBackgroundImage;
  File _music;
  String _fileMusicExtension;
  String _dateTimeForMusicUpload;
  final picker = ImagePicker();

  //CreationProfileCircular//
  bool profileInCreation = true;
  var uploadedMusicProgress;
  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.transparent,
      body: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
        child: new SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            new Container(
              height: MediaQuery.of(context).size.height*0.10,
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
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        new Container(
                          width: MediaQuery.of(context).size.width*0.05,
                          color: Colors.transparent,
                        ),
                        new Container(
                          color: Colors.transparent,
                          child: new Center(
                          child: new Text('Reverb',
                          style: new TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
                          )),
                        ),
                        new Container(
                          height: MediaQuery.of(context).size.height*0.06,
                          width: MediaQuery.of(context).size.width*0.02,
                          color: Colors.transparent,
                        ),
                        new Container(
                          height: MediaQuery.of(context).size.height*0.06,
                          color: Colors.transparent,
                          child: new Center(
                          child: new Image.asset('lib/assets/logo.png',
                          height: 30.0,
                          width: 30.0,
                          color: Colors.yellowAccent,
                          )),
                          ),
                        ],
                      ),
                  ),
                ],
              ),
            ),
           new Container(
             height: MediaQuery.of(context).size.height*0.10,
             color: Colors.transparent,
           ),
           new Container(
             height: MediaQuery.of(context).size.height*0.40,
             width: MediaQuery.of(context).size.width,
           child: new PageView(
             controller: _profileCreationController,
             physics: new NeverScrollableScrollPhysics(),
            children: [
      // UserName page
           new Container(
             height: MediaQuery.of(context).size.height*0.40,
             color: Colors.transparent,
               child: new Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                  new Container(
                    height: MediaQuery.of(context).size.height*0.40,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Container(
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                          child: new Center(
                            child: new Text('Choose an amazing name.',
                            style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      new Container(
                        height: MediaQuery.of(context).size.height*0.07,
                        width: MediaQuery.of(context).size.width*0.75,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(10.0),
                          color: Colors.grey[900]
                        ),
                        child: new Center(
                          child: new TextField(
                            style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                            controller: _userNameEditingController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            minLines: 1,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            cursorColor: Colors.yellowAccent,
                            decoration: new InputDecoration(
                              hintText: 'Your name',
                              hintStyle: new TextStyle(color: Colors.grey[700], fontSize: 15.0, fontWeight: FontWeight.bold),
                              border: new OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      new Container(
                        height: MediaQuery.of(context).size.height*0.06,
                        child: new Center(
                          child: new Text('Be creative. We love it.',
                          style: new TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ), 
                      ],
                    ),
                  ),
                 ],
               ),
             ),
    // TypeOfUser page
           new Container(
             height: MediaQuery.of(context).size.height*0.40,
             color: Colors.transparent,
               child: new Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                  new Container(
                    height: MediaQuery.of(context).size.height*0.40,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Container(
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                          child: new Center(
                            child: new Text('You are a ...',
                            style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      new Container(
                        height: MediaQuery.of(context).size.height*0.15,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //IamDj
                            new InkWell(
                              onTap: () {
                                setState(() {
                                  iamDJ = true;
                                  iamFan = false;
                                }); 
                              },
                              child: new Container(
                                height: MediaQuery.of(context).size.height*0.10,
                                width: MediaQuery.of(context).size.height*0.10,
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(5.0),
                                  color: iamDJ == false ? Colors.grey[900] : Colors.yellowAccent,
                                ),
                                child: new Center(
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      new Text('💻', style: new TextStyle(fontSize: 20.0)),
                                      new Text('DJ', style: new TextStyle(fontSize: 12.0, color: iamDJ == false ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //IamFAN
                            new InkWell(
                              onTap: () {
                                setState(() {
                                  iamDJ = false;
                                  iamFan = true;
                                });
                              },
                              child: new Container(
                                height: MediaQuery.of(context).size.height*0.10,
                                width: MediaQuery.of(context).size.height*0.10,
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(5.0),
                                  color: iamFan == false ? Colors.grey[900] : Colors.yellowAccent,
                                ),
                                child: new Center(
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      new Text('🎧', style: new TextStyle(fontSize: 20.0)),
                                      new Text('FAN', style: new TextStyle(fontSize: 12.0, color: iamFan == false ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Container(
                        height: MediaQuery.of(context).size.height*0.06,
                        child: new Center(
                          child: new Text('All DJs profiles are checked.',
                          style: new TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ), 
                      ],
                    ),
                  ),
                 ],
               ),
             ),
    // ProfilePhoto container
           new Container(
             height: MediaQuery.of(context).size.height*0.40,
             color: Colors.transparent,
               child: new Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                  new Container(
                    height: MediaQuery.of(context).size.height*0.40,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Container(
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                          child: new Center(
                            child: new Text('Add your profile photo.',
                            style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      new Container(
                        height: MediaQuery.of(context).size.height*0.15,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: new Center(
                            //ProfilePhoto
                           child: new InkWell(
                              onTap: () async {
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
                                  // final pickedFile = await picker.getImage(source: ImageSource.gallery);
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
                                    // final pickedFile = await picker.getImage(source: ImageSource.gallery);
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
                                height: MediaQuery.of(context).size.height*0.15,
                                width: MediaQuery.of(context).size.height*0.15,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[900],
                                ),
                              child: new ClipOval(
                                child: _image != null
                                ? new Image.file(_image, fit: BoxFit.cover)
                                : new Container(),
                              ),
                            ),
                           ),
                        ),
                      ),
                      new Container(
                        height: MediaQuery.of(context).size.height*0.06,
                        child: new Center(
                          child: new Text('Click on circle.',
                          style: new TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ), 
                      ],
                    ),
                  ),
                 ],
               ),
             ),
    // 1/3 Music upload container
           new Container(
             height: MediaQuery.of(context).size.height*0.40,
             color: Colors.transparent,
               child: new Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                  new Container(
                    height: MediaQuery.of(context).size.height*0.40,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Container(
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                          child: new Center(
                            child: new Text("let's talk about serious things.",
                            style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                            new Container(
                              height: MediaQuery.of(context).size.height*0.07,
                              width: MediaQuery.of(context).size.width*0.75,
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                               new InkWell(
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
                                  width: MediaQuery.of(context).size.width*0.75,
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.circular(10.0),
                                    color: _music != null ? Colors.transparent : Colors.grey[900],
                                  ),
                                  child: new Center(
                                    child: new Text(
                                      _music != null 
                                      ? 'Ok we got it buddy.'
                                      : 'Upload your first song here',
                                    style: new TextStyle(color: _music != null ? Colors.yellowAccent : Colors.white, fontSize: _music != null ? 20.0 : 15.0, fontWeight: FontWeight.bold)
                                    ),
                                  ),
                                ))
                                ],
                              ),
                            ),
                      new Container(
                        height: MediaQuery.of(context).size.height*0.06,
                        child: new Center(
                          child: new Text('1/3',
                          style: new TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ), 
                      ],
                    ),
                  ),
                 ],
               ),
             ),
    // 2/3 Music upload container
           new Container(
             height: MediaQuery.of(context).size.height*0.40,
             color: Colors.transparent,
               child: new Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                  new Container(
                    height: MediaQuery.of(context).size.height*0.40,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Container(
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                          child: new Center(
                            child: new Text("Custom your track.",
                            style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                            new Container(
                              height: MediaQuery.of(context).size.height*0.07,
                              width: MediaQuery.of(context).size.width*0.75,
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                               new InkWell(
                                  onTap: () async {
                                  if(Platform.isIOS) {
                                     var photoIOSPermission = await Permission.photos.status;
                                     if(photoIOSPermission.isGranted) {
                                       print('Accepté');
                                       FilePickerResult resultImage  = await FilePicker.platform.pickFiles(type: FileType.image);
                                       //final pickedFile = await picker.getImage(source: ImageSource.gallery);
                                          setState(() {
                                           if (resultImage != null) {
                                             _musicBackgroundImage = File(resultImage.files.single.path);
                                           } else {
                                             print('No image selected.');
                                           }
                                         });
                                     }
                                     if(photoIOSPermission.isUndetermined) {
                                       await Permission.photos.request();
                                       if(await Permission.photos.request().isGranted) {
                                         FilePickerResult resultImage  = await FilePicker.platform.pickFiles(type: FileType.image);
                                       //final pickedFile = await picker.getImage(source: ImageSource.gallery);
                                          setState(() {
                                           if (resultImage != null) {
                                             _musicBackgroundImage = File(resultImage.files.single.path);
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
                                    // final pickedFile = await picker.getImage(source: ImageSource.gallery);
                                      setState(() {
                                       if (resultImage != null) {
                                         _musicBackgroundImage = File(resultImage.files.single.path);
                                       } else {
                                         print('No image selected.');
                                       }
                                     });       
                                   }
                                   if(androidPermissions.isUndetermined) {
                                     await Permission.storage.request();
                                     if(await Permission.storage.request().isGranted) {
                                       FilePickerResult resultImage  = await FilePicker.platform.pickFiles(type: FileType.image);
                                    // final pickedFile = await picker.getImage(source: ImageSource.gallery);
                                        setState(() {
                                         if (resultImage != null) {
                                           _musicBackgroundImage = File(resultImage.files.single.path);
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
                                  width: MediaQuery.of(context).size.width*0.75,
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.circular(10.0),
                                    color: _musicBackgroundImage != null ? Colors.transparent : Colors.grey[900],
                                  ),
                                  child: new Center(
                                    child: new Text(
                                      _musicBackgroundImage != null 
                                      ? 'Ok we got it buddy.'
                                      : 'Add a cover photo',
                                    style: new TextStyle(color: _musicBackgroundImage != null ? Colors.yellowAccent : Colors.white, fontSize: _musicBackgroundImage != null ? 20.0 : 15.0, fontWeight: FontWeight.bold)
                                    ),
                                  ),
                                ))
                                ],
                              ),
                            ),
                      new Container(
                        height: MediaQuery.of(context).size.height*0.06,
                        child: new Center(
                          child: new Text('2/3',
                          style: new TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ), 
                      ],
                    ),
                  ),
                 ],
               ),
             ),
    // 3/3 Music upload container
           new Container(
             height: MediaQuery.of(context).size.height*0.40,
             color: Colors.transparent,
               child: new Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                  new Container(
                    height: MediaQuery.of(context).size.height*0.40,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Container(
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                          child: new Center(
                            child: new Text("Which style is it ?",
                            style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                            new Container(
                              height: MediaQuery.of(context).size.height*0.15,
                              width: MediaQuery.of(context).size.width,
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.10,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.transparent,
                                    child: new Container(
                                      height: MediaQuery.of(context).size.height*0.08,
                                      width: MediaQuery.of(context).size.width,
                                      child: new Center(
                                        child: new ListView(
                                          scrollDirection: Axis.horizontal,
                                          padding: EdgeInsets.only(top: 15.0,left: 20.0, right: 20.0, bottom: 15.0),
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
                                      ),
                                    ),
                                  ),
                                  new Text('Select one of these styles.',
                                  style: new TextStyle(color: Colors.grey, fontSize: 18.0, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                      new Container(
                        height: MediaQuery.of(context).size.height*0.06,
                        child: new Center(
                          child: new Text('3/3',
                          style: new TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ), 
                      ],
                    ),
                  ),
                 ],
               ),
             ),
    //Title of this song
      new Container(
        height: MediaQuery.of(context).size.height*0.40,
        width: MediaQuery.of(context).size.width*0.80,
        color: Colors.transparent,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           new Container(
             height: MediaQuery.of(context).size.height*0.40,
             width: MediaQuery.of(context).size.width,
             color: Colors.transparent,
             child: new Column(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 new Container(
                   height: MediaQuery.of(context).size.height*0.05,
                   width: MediaQuery.of(context).size.width,
                   color: Colors.transparent,
                   child: new Center(
                     child: new Text("What is the title ?",
                     style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                     ),
                   ),
                 ),
                     new Container(
                       height: MediaQuery.of(context).size.height*0.07,
                       width: MediaQuery.of(context).size.width*0.75,
                       child: new Column(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: [
                         new Container(
                           height: MediaQuery.of(context).size.height*0.07,
                           width: MediaQuery.of(context).size.width*0.75,
                           decoration: new BoxDecoration(
                             borderRadius: new BorderRadius.circular(10.0),
                             color: Colors.grey[900]
                           ),
                           child: new Center(
                             child: new TextField(
                               style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                               controller: _titleTextEditingController,
                               keyboardType: TextInputType.text,
                               textCapitalization: TextCapitalization.sentences,
                               minLines: 1,
                               maxLines: 1,
                               maxLength: 30,
                               textAlign: TextAlign.center,
                               cursorColor: Colors.yellowAccent,
                               decoration: new InputDecoration(
                                 counterText: '',
                                 hintText: "This track's title",
                                 hintStyle: new TextStyle(color: Colors.grey[700], fontSize: 15.0, fontWeight: FontWeight.bold),
                                 border: new OutlineInputBorder(
                                   borderSide: BorderSide.none,
                                 ),
                               ),
                             ),
                           ),
                         ),
                         ],
                       ),
                     ),
               new Container(
                 height: MediaQuery.of(context).size.height*0.06,
                 child: new Center(
                   child: new Text('It all starts with by a title.',
                   style: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                   ),
                 ),
               ), 
               ],
             ),
           ),
          ],
        ),
      ),
    // link a shopMusic
           new Container(
             height: MediaQuery.of(context).size.height*0.40,
             color: Colors.transparent,
               child: new Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                  new Container(
                    height: MediaQuery.of(context).size.height*0.40,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Container(
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                          child: new Center(
                            child: new Text("Link your music shop ?",
                            style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                            new Container(
                              height: MediaQuery.of(context).size.height*0.07,
                              width: MediaQuery.of(context).size.width*0.75,
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                new Container(
                                  height: MediaQuery.of(context).size.height*0.07,
                                  width: MediaQuery.of(context).size.width*0.75,
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.circular(10.0),
                                    color: Colors.grey[900]
                                  ),
                                  child: new Center(
                                    child: new TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          shopLinkInput = _linkMusicShopController.text.toString();
                                        });
                                      _linkMusicShopController.value = new TextEditingValue(
                                        text: value.toLowerCase(),
                                        selection: _linkMusicShopController.selection
                                        );
                                      },
                                      style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                      controller: _linkMusicShopController,
                                      keyboardType: TextInputType.text,
                                      textCapitalization: TextCapitalization.sentences,
                                      minLines: 1,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      cursorColor: Colors.yellowAccent,
                                      decoration: new InputDecoration(
                                        hintText: 'Paste here your link or later',
                                        hintStyle: new TextStyle(color: Colors.grey[700], fontSize: 15.0, fontWeight: FontWeight.bold),
                                        border: new OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ],
                              ),
                            ),
                      new Container(
                        height: MediaQuery.of(context).size.height*0.06,
                        child: new Center(
                          child: new Text('Your bandcamp, itunes store, beatport ...',
                          style: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ), 
                      ],
                    ),
                  ),
                 ],
               ),
             ),
    // Creation profile in progress
           new Container(
             height: MediaQuery.of(context).size.height*0.40,
             color: Colors.transparent,
               child: new Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                  new Container(
                    height: MediaQuery.of(context).size.height*0.40,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Container(
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                          child: new Center(
                            child: new Text(
                              profileInCreation == true 
                              ? "Profile in creation ..."
                              : "Profile created.",
                            style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                            new Container(
                              height: MediaQuery.of(context).size.height*0.07,
                              width: MediaQuery.of(context).size.width*0.75,
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  profileInCreation == true 
                                  ?  new LinearProgressIndicator(
                                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
                                    backgroundColor: Colors.yellowAccent.withOpacity(0.4),
                                    value: uploadedMusicProgress != null ? uploadedMusicProgress : null,
                                  )
                                  : new Container(
                                    height: MediaQuery.of(context).size.height*0.07,
                                    width: MediaQuery.of(context).size.height*0.07,
                                    child: new Center(
                                      child: new Icon(Icons.check_circle,
                                      color: Colors.greenAccent,
                                      size: 60.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      new Container(
                        height: MediaQuery.of(context).size.height*0.06,
                        child: new Center(
                          child: new Text(profileInCreation == true 
                          ? 'Please, wait few seconds buddy.'
                          : 'Perfect, you are ready to start.',
                          style: new TextStyle(color: profileInCreation == true ? Colors.grey : Colors.yellowAccent, fontSize: 16.0, fontWeight: FontWeight.bold),
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
           new Container(
             height: MediaQuery.of(context).size.height*0.25,
             color: Colors.transparent,
             child: new Column(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 //BUTTON CONTINUE
                 new InkWell(
                   onTap: () {
                     //UserName page
                     if(_profileCreationController.page == 0 && _userNameEditingController.value.text.length > 2) {
                       setState(() {currentUsername = _userNameEditingController.value.text.toString();});
                       _profileCreationController.nextPage(duration: new Duration(milliseconds: 1), curve: Curves.bounceIn).whenComplete(() => _userNameEditingController.clear());
                    //typeOfUser page
                     } else if(_profileCreationController.page == 1 && (iamDJ == true || iamFan == true)) {
                       _profileCreationController.nextPage(duration: new Duration(milliseconds: 1), curve: Curves.bounceIn);
                     } else if(_profileCreationController.page == 2 && _image != null && iamDJ == true) {
                         _profileCreationController.nextPage(duration: new Duration(milliseconds: 1), curve: Curves.bounceIn);
                     } else if(_profileCreationController.page == 2 && _image != null && iamFan == true) {
                        _profileCreationController.jumpToPage(7);
                         mainRequestStockDataForFan();
                     } else if(_profileCreationController.page == 3 && _music != null) {
                       _profileCreationController.nextPage(duration: new Duration(milliseconds: 1), curve: Curves.bounceIn);
                     } else if (_profileCreationController.page == 4 && _musicBackgroundImage != null) {
                      _profileCreationController.nextPage(duration: new Duration(milliseconds: 1), curve: Curves.bounceIn);
                      } else if(_profileCreationController.page == 5 && (edmChoosen == true || electroChoosen == true || houseChoosen == true || acidHouseChoosen == true || futureHouseChoosen == true || deepHouseChoosen == true || chillHouseChoosen == true || technoChoosen == true || tranceChoosen == true || progressiveChoosen == true || minimaleChoosen == true || dubstepChoosen == true || trapChoosen == true || dirtyDutchChoosen == true || moombathtonChoosen == true || hardstyleChoosen == true)) {
                        _profileCreationController.nextPage(duration: new Duration(milliseconds: 1), curve: Curves.bounceIn);
                      } else if(_profileCreationController.page == 6 && _titleTextEditingController.text.length >= 2) {
                        _profileCreationController.nextPage(duration: new Duration(milliseconds: 1), curve: Curves.bounceIn);
                      } else if(_profileCreationController.page == 7) {
                        _linkMusicShopController.clear();
                        _profileCreationController.nextPage(duration: new Duration(milliseconds: 1), curve: Curves.bounceIn);
                        mainRequestStockDataForDJ();
                      } else if(_profileCreationController.page == 8 && profileInCreation == false) {
                        print('Go to reverb');
                        Navigator.pushAndRemoveUntil(
                        context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
                        new NavigationPage(
                          currentUser: widget.currentUser,
                          currentUserType: iamDJ == true ? 'iamDJ' : 'iamFAN',
                          currentUserUsername: currentUsername,
                          )),
                        (route) => false);
                      }
                     },
                 child: new Container(
                   height: MediaQuery.of(context).size.height*0.08,
                   width: MediaQuery.of(context).size.width*0.8,
                   decoration: new BoxDecoration(
                     color: Colors.yellowAccent,
                     borderRadius: new BorderRadius.circular(10.0)
                   ),
                   child: new Center(
                     child: new Text('CONTINUE',
                     style: new TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
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
      ),
      ),
    );
  }


    mainRequestStockDataForFan() async {
      _dateTimeForMusicUpload = Timestamp.now().seconds.toString();
      //ProfilePhoto
      firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('${widget.currentUser}/profilePhoto');
        firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);
        await uploadTask;
        print('ProfilePhoto uploaded (Storage)');
        storageReference.getDownloadURL().then((filePhotoURL) {
          FirebaseFirestore.instance
            .collection('users')
            .doc(widget.currentUser)
            .set({
               'uid': widget.currentUser,
                'userName': currentUsername,
                'email': widget.currentUserEmail,
                'iam': iamDJ == true ? 'iamDJ' : 'iamFAN',
                'profilePhoto': filePhotoURL,
                'songsLiked': {
                  '0000000000': '0000000000',
                },
            }).whenComplete(() {
              if(this.mounted) {
                setState(() {
                    profileInCreation = false;
                    print('OK ready to start');
                });
              }
            });
        });
    }

    mainRequestStockDataForDJ() async  {
      _dateTimeForMusicUpload = Timestamp.now().seconds.toString();
      //ProfilePhoto
      firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('${widget.currentUser}/profilePhoto');
        firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);
        await uploadTask;
        print('ProfilePhoto uploaded (Storage)');
        storageReference.getDownloadURL().then((filePhotoURL) async {
          //PhotoFile
          firebase_storage.Reference storageBackgroundImage = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('${widget.currentUser}/songs/$_dateTimeForMusicUpload/$_dateTimeForMusicUpload-image');
            firebase_storage.UploadTask uploadTask = storageBackgroundImage.putFile(_musicBackgroundImage);
            await uploadTask;
            print('BackgroundImage uploaded (storage)');
            storageBackgroundImage.getDownloadURL().then((backgroundImageFile) {
              storeMusicRequest(filePhotoURL,backgroundImageFile,_dateTimeForMusicUpload);
              });
        });  
  }

  storeMusicRequest(String filePhotoURL, String backgroundImageFile, String timestamp) async {
    print('Music uploading in progress ...');
          firebase_storage.Reference storageForMusic = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('${widget.currentUser}/songs/$timestamp/$timestamp.$_fileMusicExtension');
          if(_music.existsSync()){
            firebase_storage.UploadTask uploadTaskForMusic = storageForMusic.putFile(_music);
            uploadTaskForMusic.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) { 
              setState(() {
                uploadedMusicProgress = ((snapshot.bytesTransferred/snapshot.totalBytes)).toDouble();
              });
                print('uploadedMusicProgress = $uploadedMusicProgress');
            });
            await uploadTaskForMusic;
            storageForMusic.getDownloadURL().then((fileMusicURL){
              AudioPlayer audioPlayer = new AudioPlayer();
              audioPlayer.setUrl(fileMusicURL);
              audioPlayer.getDuration().then((durationFileAudio) {
            FirebaseFirestore.instance
              .collection('users')
              .doc(widget.currentUser)
              .set({
                'uid': widget.currentUser,
                'userName': currentUsername,
                'email': widget.currentUserEmail,
                'iam': iamDJ == true ? 'iamDJ' : 'iamFAN',
                'profilePhoto': filePhotoURL,
                'songsLiked': {
                  '0000000000': '0000000000',
                },
                'subscribers': 0,
                'likes': 0,
                'shopLink': _linkMusicShopController.value.text.length > 3 ? _linkMusicShopController.value.text.toString() : null,
                'instagramLink': null,
              }).whenComplete(() {
                FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.currentUser)
                  .collection('songs')
                  .doc('$_dateTimeForMusicUpload')
                  .set({
                    'artistProfilePhoto': filePhotoURL,
                    'artistUsername': currentUsername,
                    'artistUID': widget.currentUser,
                    'timestamp': _dateTimeForMusicUpload,
                    'views': 0,
                    'likes': 0,
                    'shares': 0,
                    'comments': 0,
                    'imageSong': backgroundImageFile,
                    'fileMusicURL': fileMusicURL,
                    'fileMusicDuration': durationFileAudio,
                    'title': _titleTextEditingController.text.length >= 2 ? _titleTextEditingController.value.text : null,
                    'style': edmChoosen == true ? 'edm' : electroChoosen == true ? 'electro' : houseChoosen == true ? 'house' : acidHouseChoosen == true ? 'acidHouse' : futureHouseChoosen == true ? 'futureHouse' : deepHouseChoosen == true ? 'deepHouse' : chillHouseChoosen == true ? 'chillHouse' : technoChoosen == true ? 'techno' : tranceChoosen == true ? 'trance' : progressiveChoosen == true ? 'progressive' : minimaleChoosen == true ? 'minimale' : dubstepChoosen == true ? 'dubstep' :  trapChoosen == true ? 'trap' : dirtyDutchChoosen == true ? 'dirtyDuctch' : moombathtonChoosen == true ? 'moombathton' : hardstyleChoosen == true ? 'hardstyle' : 'edm',
                    'linkToBuy': _linkMusicShopController.value.text.length > 3 ? _linkMusicShopController.value.text.toString() : null,
                    'description': null,
                  });
              }).whenComplete(() {
                FirebaseFirestore.instance
                  .collection(edmChoosen == true ? 'edm' : electroChoosen == true ? 'electro' : houseChoosen == true ? 'house' : acidHouseChoosen == true ? 'acidHouse' : futureHouseChoosen == true ? 'futureHouse' : deepHouseChoosen == true ? 'deepHouse' : chillHouseChoosen == true ? 'chillHouse' : technoChoosen == true ? 'techno' : tranceChoosen == true ? 'trance' : progressiveChoosen == true ? 'progressive' : minimaleChoosen == true ? 'minimale' : dubstepChoosen == true ? 'dubstep' :  trapChoosen == true ? 'trap' : dirtyDutchChoosen == true ? 'dirtyDuctch' : moombathtonChoosen == true ? 'moombathton' : hardstyleChoosen == true ? 'hardstyle' : 'edm')
                  .doc(_dateTimeForMusicUpload)
                  .set({
                    'artistProfilePhoto': filePhotoURL,
                    'artistUID': widget.currentUser,
                    'artistUsername': currentUsername,
                    'timestamp': _dateTimeForMusicUpload,
                    'views': 0,
                    'likes': 0,
                    'shares': 0,
                    'comments': 0,
                    'imageSong': backgroundImageFile,
                    'fileMusicURL': fileMusicURL,
                    'fileMusicDuration': durationFileAudio,
                    'title': _titleTextEditingController.text.length >= 2 ? _titleTextEditingController.value.text : null,
                    'style': edmChoosen == true ? 'edm' : electroChoosen == true ? 'electro' : houseChoosen == true ? 'house' : acidHouseChoosen == true ? 'acidHouse' : futureHouseChoosen == true ? 'futureHouse' : deepHouseChoosen == true ? 'deepHouse' : chillHouseChoosen == true ? 'chillHouse' : technoChoosen == true ? 'techno' : tranceChoosen == true ? 'trance' : progressiveChoosen == true ? 'progressive' : minimaleChoosen == true ? 'minimale' : dubstepChoosen == true ? 'dubstep' :  trapChoosen == true ? 'trap' : dirtyDutchChoosen == true ? 'dirtyDuctch' : moombathtonChoosen == true ? 'moombathton' : hardstyleChoosen == true ? 'hardstyle' : 'edm',
                    'linkToBuy': _linkMusicShopController.value.text.length > 3 ? _linkMusicShopController.value.text.toString() : null,
                    'description': null,
                  }).whenComplete(() {
                  if(this.mounted) {
                  setState(() {
                    profileInCreation = false;
                    print('OK ready to start');
                  });
                  }
                  });
              });
              });
              });
          } else {
            print(' _music no exist');
          }
       }



}