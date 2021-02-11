import 'dart:io';
import 'package:SONOZ/inscriptionProcess/landingPage.dart';
import 'package:SONOZ/inscriptionProcess/onboarding.dart';
import 'package:SONOZ/navigation.dart';
import 'package:SONOZ/permissionsHandler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
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

  // TextEditingController //
  TextEditingController _userNameEditingController = new TextEditingController();
  PageController _profileCreationController = new PageController(initialPage: 0, viewportFraction: 1);

  //CurrentUserVariables//
  String currentUsername;

  
  //ImagePicker variables
  File _image;
  String _photoTimeStamp;
  final picker = ImagePicker();


  //CreationProfileCircular//
  bool profileInCreation = true;

  @override
  void initState() {
    super.initState();
  }
  

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
                          child: new Text('Reverbs.',
                          style: new TextStyle(color: Colors.grey[800], fontSize: 30.0, fontWeight: FontWeight.bold),
                          )),
                        ),
                        new Container(
                          height: MediaQuery.of(context).size.height*0.06,
                          width: MediaQuery.of(context).size.width*0.02,
                          color: Colors.transparent,
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
                            child: new Text('Your producer name.',
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
                            cursorColor: Colors.lightBlue,
                            decoration: new InputDecoration(
                              hintText: 'Enter here',
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
                          child: new Text('',
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
                            child: new Text(profileInCreation == false ? 'Profile created.' : 'Creation in progress',
                            style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        profileInCreation == false
                         ? new Container(
                           width: MediaQuery.of(context).size.width,
                           color: Colors.transparent,
                           child: new Icon(Icons.verified_user_rounded,
                           color: Colors.white,
                           size: 60.0,
                           ),
                          )
                         : new Container(
                           height: MediaQuery.of(context).size.height*0.04,
                           width: MediaQuery.of(context).size.height*0.04,
                           child: new CupertinoActivityIndicator(
                             animating: true,
                             radius: 20.0,
                           ),
                           /*child: new CircularProgressIndicator(
                             valueColor: new AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                           ),*/
                         ),
                      ]
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
                       setState(() {
                         currentUsername = _userNameEditingController.value.text.toString();
                         });
                       _profileCreationController.nextPage(duration: new Duration(milliseconds: 1), curve: Curves.bounceIn).whenComplete(() => _userNameEditingController.clear());
                    //typeOfUser page
                     } else if(_profileCreationController.page == 1 && _image != null) {
                       setState(() {
                         profileInCreation = true;
                       });
                       _profileCreationController.nextPage(duration: new Duration(milliseconds: 1), curve: Curves.bounceIn);
                        mainRequestStockDataForDJ();
                     } else if(_profileCreationController.page == 2) {
                      Navigator.pushAndRemoveUntil(
                      context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
                      new OnboardingPage(
                        currentUser: widget.currentUser,
                        currentUserUsername: _userNameEditingController.value.text,
                      )),
                      (route) => false);
                     }
                     },
                 child: new Container(
                   height: MediaQuery.of(context).size.height*0.08,
                   width: MediaQuery.of(context).size.width*0.8,
                   decoration: new BoxDecoration(
                     color: Colors.transparent,
                     border: new Border.all(
                       width: 2.0,
                       color: Colors.yellowAccent,
                     ),
                     borderRadius: new BorderRadius.circular(10.0)
                   ),
                   child: new Center(
                     child: new Text('CONTINUE',
                     style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
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


    /*mainRequestStockDataForFan() async {
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
    }*/

    mainRequestStockDataForDJ() async  {
      //ProfilePhoto
      firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('${widget.currentUser}/profilePhoto');
        firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);
        await uploadTask;
        print('ProfilePhoto uploaded (Storage)');
        storageReference.getDownloadURL().then((filePhotoURL) async {
            FirebaseFirestore.instance
              .collection('users')
              .doc(widget.currentUser)
              .set({
                'uid': widget.currentUser,
                'userName': currentUsername,
                'email': widget.currentUserEmail,
                'iam': 'iamDJ',
                'profilePhoto': filePhotoURL,
                'songsLiked': {
                  '0000000000': '0000000000',
                },
                'subscribers': 0,
                'likes': 0,
                'instagramLink': null,
                'spotifyLink': null,
              }).whenComplete(() {
                print('profile created (Cloud firestore)');
                if(this.mounted) {
                  setState(() {
                    profileInCreation = false;
                  });
                }
              });
        });  
  }

  /*storeMusicRequest(String filePhotoURL) async {
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
                'spotifyLink': null,
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
              }*/
}