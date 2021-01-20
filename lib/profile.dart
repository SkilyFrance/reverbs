import 'dart:io';
import 'package:SONOZ/inscriptionProcess/landingPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:SONOZ/permissionsHandler.dart';
import 'package:SONOZ/profile/myMusicDetails.dart';
import 'package:SONOZ/services/slideRoute.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home/uploadMusic.dart';

class ProfilePage extends StatefulWidget {

  String currentUser;
  String currentUserUsername;
  String currentUserPhoto;

  ProfilePage({Key key, this.currentUser, this.currentUserUsername, this.currentUserPhoto}) : super(key: key);


  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  
  //Variables
  File _image;
  TextEditingController _linkMusicShopController = new TextEditingController();
  TextEditingController _linkSpotifyController = new TextEditingController();
  TextEditingController _linkInstagramController = new TextEditingController();
  bool updatedInPublishing = false;
  int totalLikes;

  _launchURL(String link) async {
    if(await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  ScrollController songsGriViewController = new ScrollController(initialScrollOffset: 0.0);

  bool filterRecentIsChoosen = true;
  bool filterTrendIsChoosen = false;
  bool _signOutView = false;
  bool _areUSureView = false;


  //SignOutMethod
  signOut() {
    FirebaseAuth.instance.signOut().then((value) =>
        Navigator.pushAndRemoveUntil(
            context,
            new MaterialPageRoute(builder: (context) => new LandingPage()),
            (_) => false));
  }


  @override
  void initState() {
    listenIfAlreadyliked();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: new StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(widget.currentUser).snapshots(),
        builder: (BuildContext context, snapshotUser) {
          if(snapshotUser.hasError) {
            return new Center(child: new Text('Oh, an error occured buddy.', style: new TextStyle(color: Colors.yellowAccent, fontSize: 18.0, fontWeight: FontWeight.bold)));
          }
          if(!snapshotUser.hasData) {
            return new Container();
          }
          return new Container(
              color: Colors.black,
              child: new SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new Container(
                      height: MediaQuery.of(context).size.height*0.10,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                    ),
                    //Photo
                    new Container(
                        height: MediaQuery.of(context).size.height*0.12,
                        width: MediaQuery.of(context).size.height*0.12,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[900],
                        ),
                          child: new ClipOval(
                            child: snapshotUser.data.data()['profilePhoto'] != null
                            ? new Image.network(snapshotUser.data.data()['profilePhoto'], fit: BoxFit.cover)
                            : new Container()
                          ),
                        ),
                  //Name of Dj
                  new Container(
                    height: MediaQuery.of(context).size.height*0.06,
                    child: new Center(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Container(
                          child: new Text(
                            snapshotUser.data.data()['userName'] != null
                            ?'@${snapshotUser.data.data()['userName'].toString()}'
                            : '',
                          style: new TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.bold)
                          )),
                          new Container(
                            height: MediaQuery.of(context).size.height*0.06,
                            width: MediaQuery.of(context).size.width*0.03,
                          ),
                          new Container(
                            height: MediaQuery.of(context).size.height*0.06,
                            child: new Image.asset('lib/assets/checked.png',
                            height: 20.0,
                            width: 20.0,
                            color: Colors.yellowAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Stats
                  new Container(
                    height: MediaQuery.of(context).size.height*0.07,
                    width: MediaQuery.of(context).size.width*0.50,
                    color: Colors.transparent,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Container(
                          child: new Text(
                            snapshotUser.data.data()['subscribers'] != null
                            ? '${snapshotUser.data.data()['subscribers'].toString()}'
                            : '?',
                          style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        new Container(
                          child: new Text('SUBSCRIBERS',
                          style: new TextStyle(color: Colors.grey[600], fontSize: 13.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      ),
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Container(
                          child: new Text(
                            snapshotUser.data.data()['likes'] != null
                            ? '${snapshotUser.data.data()['likes'].toString()}'
                            : '?',
                          style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        new Container(
                          child: new Text('LIKES',
                          style: new TextStyle(color: Colors.grey[600], fontSize: 13.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      ),
                      ],
                    ),
                  ),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.10,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      new InkWell(
                        onTap: () {
                          showCupertinoModalBottomSheet(
                            animationCurve: Curves.decelerate,
                            context: context, 
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context, StateSetter modalSetState) {
                                  return new Material(
                                color: Colors.transparent,
                                child: new Container(
                                  height: MediaQuery.of(context).size.height*0.72,
                                  width: MediaQuery.of(context).size.width,
                                  color: Color(0xFF121212),
                                  child: 
                                  _signOutView == false 
                                  ?  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.07,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.transparent,
                                    child: new Center(
                                      child: new Text('MODIFY',
                                      style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ),
                                  //Divider
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.02,
                                    width: MediaQuery.of(context).size.width,
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
                                          color: Colors.grey[900],
                                        ),
                                        child: new Center(
                                          child: new TextField(
                                            showCursor: false,
                                            onChanged: (value) {
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
                                              hintText: 'Paste here your shop link',
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
                                  //Divider
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.02,
                                    width: MediaQuery.of(context).size.width,
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
                                          color: Colors.grey[900],
                                        ),
                                        child: new Center(
                                          child: new TextField(
                                            showCursor: false,
                                            onChanged: (value) {
                                            _linkSpotifyController.value = new TextEditingValue(
                                              text: value.toLowerCase(),
                                              selection: _linkSpotifyController.selection
                                              );
                                            },
                                            style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                            controller: _linkSpotifyController,
                                            keyboardType: TextInputType.text,
                                            textCapitalization: TextCapitalization.sentences,
                                            minLines: 1,
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            cursorColor: Colors.yellowAccent,
                                            decoration: new InputDecoration(
                                              hintText: 'Paste here your Spotify link',
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
                                  //Divider
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.02,
                                    width: MediaQuery.of(context).size.width,
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
                                            showCursor: false,
                                            onChanged: (value) {
                                            _linkInstagramController.value = new TextEditingValue(
                                              text: value.toLowerCase(),
                                              selection: _linkInstagramController.selection
                                              );
                                            },
                                            style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                            controller: _linkInstagramController,
                                            textCapitalization: TextCapitalization.sentences,
                                            minLines: 1,
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            cursorColor: Colors.yellowAccent,
                                            decoration: new InputDecoration(
                                              hintText: 'Paste here your Instagram link',
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
                                      //Divider
                                      new Container(
                                        height: MediaQuery.of(context).size.height*0.04,
                                        width: MediaQuery.of(context).size.width,
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
                        
                                        } else {
                                        var androidPermissions = await Permission.storage.status;
                                        if(androidPermissions.isGranted) {
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
                                        if(androidPermissions.isUndetermined) {
                                          await Permission.storage.request();
                                          if(await Permission.storage.request().isGranted) {
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
                                           child: new Text('Upload profile photo',
                                           style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                                           ),
                                         ),
                                       ),
                                     ),
                                   ),
                                   ),
                                      new Container(
                                        height: MediaQuery.of(context).size.height*0.15,
                                        width: MediaQuery.of(context).size.width,
                                        color: Colors.transparent,
                                        child: new Center(
                                          child: updatedInPublishing == false 
                                           ? new Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                           new InkWell(
                                            onTap: () async {
                                            if(_image != null) {
                                                modalSetState(() {
                                                updatedInPublishing = true;
                                              });
                                              firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance
                                                .ref()
                                                .child('${widget.currentUser}/profilePhoto');
                                                firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);
                                                await uploadTask;
                                                print('Photo upload (Storage)');
                                                storageReference.getDownloadURL().then((filePhotoURL) {
                                                FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(widget.currentUser)
                                                  .update({
                                                    'profilePhoto': filePhotoURL,
                                                    'shopLink': _linkMusicShopController.value.text.length > 3 ? _linkMusicShopController.value.text.toString() : snapshotUser.data.data()['shopLink'],
                                                    'spotifyLink': _linkSpotifyController.value.text.length > 3 ? _linkSpotifyController.value.text.toString() : snapshotUser.data.data()['spotifyLink'],
                                                    'instagramLink': _linkInstagramController.value.text.length > 3 ? _linkInstagramController.value.text.toString() : snapshotUser.data.data()['instagramLink'],
                                                  }).whenComplete(() {
                                                    modalSetState(() {
                                                      updatedInPublishing = false;
                                                      Navigator.pop(context);
                                                    });
                                                  });    
                                                });
                                          } else if(_linkMusicShopController.value.text.length > 3 || _linkInstagramController.value.text.length > 3 || _linkSpotifyController.value.text.length > 3) {
                                            modalSetState(() {
                                              updatedInPublishing = true;
                                            });
                                            //If user no update photo
                                            FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget.currentUser)
                                              .update({
                                                'shopLink': _linkMusicShopController.value.text.length > 3 ? _linkMusicShopController.value.text.toString() : snapshotUser.data.data()['shopLink'],
                                                'spotifyLink': _linkSpotifyController.value.text.length > 3 ? _linkSpotifyController.value.text.toString() : snapshotUser.data.data()['spotifyLink'],
                                                'instagramLink': _linkInstagramController.value.text.length > 3 ? _linkInstagramController.value.text.toString() : snapshotUser.data.data()['instagramLink'],
                                              }).whenComplete(() {
                                                modalSetState(() {
                                                  updatedInPublishing = false;
                                                  Navigator.pop(context);
                                                });
                                              });
                                          } else {
                                            print('Nothing to update');
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
                                              child: new Text('UPDATE',
                                              style: new TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        ],
                                        )
                                        : new Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            new Text('Update in progress ...',
                                            style: new TextStyle(color: Colors.yellowAccent, fontSize: 17.0, fontWeight: FontWeight.bold),
                                            ),
                                            new CircularProgressIndicator(
                                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ),
                                      new FlatButton(
                                        onPressed: () {
                                          modalSetState((){
                                            _signOutView = true;
                                          });
                                        },
                                        child: new Center(
                                          child: new Text('Sign out', style: new TextStyle(color: Colors.grey[700], fontSize: 15.0, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    ],
                                  )
                                  : new Center(
                                    child: new Container(
                                      height: MediaQuery.of(context).size.height*0.30,
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.transparent,
                                      child: new Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          new Text('Are you sure to quit ?', style: new TextStyle(color: Colors.white, fontSize: 15.0,fontWeight: FontWeight.bold)),
                                          new Container(
                                            child: new Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                //YesButton
                                                new InkWell(
                                                  onTap: () {
                                                    signOut();
                                                  },
                                                  child: new Container(
                                                    height: MediaQuery.of(context).size.height*0.06,
                                                    width: MediaQuery.of(context).size.width*0.30,
                                                    decoration: new BoxDecoration(
                                                      color: Colors.grey[900],
                                                      borderRadius: new BorderRadius.circular(10.0),
                                                    ),
                                                    child: new Center(
                                                      child: new Text('Yes',
                                                      style: new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                //NoButton
                                                new InkWell(
                                                  onTap: () {
                                                    modalSetState(() {
                                                      _signOutView = false;
                                                    });
                                                  },
                                                  child: new Container(
                                                    height: MediaQuery.of(context).size.height*0.06,
                                                    width: MediaQuery.of(context).size.width*0.30,
                                                    decoration: new BoxDecoration(
                                                      color: Colors.grey[900],
                                                      borderRadius: new BorderRadius.circular(10.0),
                                                    ),
                                                    child: new Center(
                                                      child: new Text('No buddy',
                                                      style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
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
                              });
                            }).whenComplete(() {
                              setState(() {
                                _signOutView = false;
                              });
                            });
                        }, 
                      child: new Container(
                        height: MediaQuery.of(context).size.height*0.05,
                        width: MediaQuery.of(context).size.width*0.30,
                        decoration: new BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                        child: new Center(
                        child: new Text('Modify',
                        style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        ),
                        ),
                        ),
                        //Divider
                        new Container(
                          height: MediaQuery.of(context).size.height*0.03,
                          width: MediaQuery.of(context).size.width*0.04,
                          ),
                        //InstagramLink
                        snapshotUser.data.data()['instagramLink'] != null
                        ? new InkWell(
                          onTap: () {
                             _launchURL(snapshotUser.data.data()['instagramLink'].toString());
                          },
                        child: new Container(
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.height*0.05,
                        decoration: new BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                        child: new Center(
                          child: new Image.asset('lib/assets/instagram.png',
                          height: 25.0,
                          width: 25.0,
                          color: Colors.white,
                          ),
                        ),
                        )
                        )
                        : new Container(
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.height*0.05,
                        decoration: new BoxDecoration(
                          color: Colors.grey[800].withOpacity(0.5),
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                        child: new Center(
                          child: new Image.asset('lib/assets/instagram.png',
                          height: 25.0,
                          width: 25.0,
                          color: Colors.grey.withOpacity(0.5),
                          ),
                        ),
                        ),
                        //Divider
                        new Container(
                          height: MediaQuery.of(context).size.height*0.03,
                          width: MediaQuery.of(context).size.width*0.04,
                          ),
                        //Spotify button
                        snapshotUser.data.data()['spotifyLink'] != null
                        ? new InkWell(
                          onTap: () {
                             _launchURL(snapshotUser.data.data()['spotifyLink']);
                          },
                        child: new Container(
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.height*0.05,
                        decoration: new BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: new BorderRadius.circular(4.0),
                        ),
                        child: new Center(
                          child: new Image.asset('lib/assets/spotify.png',
                          height: 25.0,
                          width: 25.0,
                          color: Colors.white,
                          ),
                        ),
                        )
                        )
                        : new Container(
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.height*0.05,
                        decoration: new BoxDecoration(
                          color: Colors.grey[800].withOpacity(0.5),
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                        child: new Center(
                          child: new Image.asset('lib/assets/spotify.png',
                          height: 25.0,
                          width: 25.0,
                          color: Colors.white.withOpacity(0.4),
                          ),
                        ),  
                        ),
                        //Divider
                        new Container(
                          height: MediaQuery.of(context).size.height*0.03,
                          width: MediaQuery.of(context).size.width*0.04,
                          ),
                        //Shop button
                        snapshotUser.data.data()['shopLink'] != null
                        ? new InkWell(
                          onTap: () {
                             _launchURL(snapshotUser.data.data()['shopLink']);
                          },
                        child: new Container(
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.height*0.05,
                        decoration: new BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                        child: new Center(
                          child: new Image.asset('lib/assets/shop.png',
                          height: 25.0,
                          width: 25.0,
                          color: Colors.white,
                          ),
                        ),
                        )
                        )
                        : new Container(
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.height*0.05,
                        decoration: new BoxDecoration(
                          color: Colors.grey[800].withOpacity(0.5),
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                        child: new Center(
                          child: new Image.asset('lib/assets/shop.png',
                          height: 25.0,
                          width: 25.0,
                          color: Colors.white.withOpacity(0.5),
                          ),
                        ),  
                        ),
                        ],
                    ),
                  ),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.03,
                    width: MediaQuery.of(context).size.width,
                  ),
                  new Container(
                  child: new StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('users').doc(widget.currentUser).collection('songs').orderBy('timestamp', descending: true).snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if(snapshot.hasError) {
                        return new Container(
                          color: Colors.black,
                          child: new Center(child: new Text('Buddy, check your internet network.', style: new TextStyle(color: Colors.yellowAccent, fontSize: 15.0, fontWeight: FontWeight.bold))));
                      }
                      if(!snapshot.hasData) {
                        return new Container();
                      }
                      if(snapshot.data.documents.isEmpty) {
                        return new Container(
                          height: MediaQuery.of(context).size.height*0.35,
                          width: MediaQuery.of(context).size.width,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                          new InkWell(
                            onTap: () {
                              Navigator.push(context, new SlideBottomRoute(page: new UploadMusicPage(
                                currentUser: widget.currentUser, 
                                currentUserUserName: widget.currentUserUsername, 
                                currentUserPhoto: widget.currentUserPhoto)));
                            },
                            child: new Container(
                              height: MediaQuery.of(context).size.height*0.07,
                              width: MediaQuery.of(context).size.width*0.70,
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.circular(10.0),
                                color: Colors.yellowAccent,
                              ),
                              child: new Center(
                                child: new Text('POST MY FIRST TRACK',
                                style: new TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold)
                                ),
                              ),
                            ),
                          ),
                          new Text('No track posted.', style: new TextStyle(color: Colors.yellow[200],fontSize: 15.0, fontWeight: FontWeight.w600)),
                          ]));
                      }
                    return new GridView.builder(
                    physics: new NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    controller: songsGriViewController,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: 1/1.5
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot ds = snapshot.data.documents[index];
                      return new InkWell(
                        onLongPress: () {
                          showCupertinoModalBottomSheet(
                            animationCurve: Curves.decelerate,
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context, StateSetter modalSecondSetState) {
                                  return new Material(
                                    color: Colors.transparent,
                                    child: new Container(
                                      height: MediaQuery.of(context).size.height*0.30,
                                      width: MediaQuery.of(context).size.width,
                                      color: Color(0xFF121212),
                                      child: updatedInPublishing == true && _areUSureView == false
                                      ? new Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          new Text('Few seconds buddy ...',
                                          style: new TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),
                                          ),
                                          new Padding(
                                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                          child: new LinearProgressIndicator(
                                            backgroundColor: Colors.yellowAccent.withOpacity(0.5),
                                            valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
                                          )),
                                        ],
                                      )
                                      : updatedInPublishing == false && _areUSureView == true
                                      ? new Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          new Container(
                                            child:new Text('Delete this post ?',
                                          style: new TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),
                                          ),
                                          ),
                                          new Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              //DeleteButton
                                             new InkWell(
                                               onTap: () {
                                                 deletePost(modalSecondSetState, ds.data()['timestamp'], ds.data()['style'], ds.data()['fileMusicURL']);
                                               },
                                               child: new Container(
                                                 height: MediaQuery.of(context).size.height*0.06,
                                                 width: MediaQuery.of(context).size.width*0.30,
                                                 decoration: new BoxDecoration(
                                                   color: Colors.grey[900],
                                                   borderRadius: new BorderRadius.circular(10.0),
                                                 ),
                                                 child: new Center(
                                                   child: new Text('Yes',
                                                   style: new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.bold),
                                                   ),
                                                 ),
                                               ),
                                             ),
                                             //No delete
                                             new InkWell(
                                               onTap: () {
                                                 modalSecondSetState(() {
                                                   _areUSureView = false;
                                                 });
                                               },
                                               child: new Container(
                                                 height: MediaQuery.of(context).size.height*0.06,
                                                 width: MediaQuery.of(context).size.width*0.30,
                                                 decoration: new BoxDecoration(
                                                   color: Colors.grey[900],
                                                   borderRadius: new BorderRadius.circular(10.0),
                                                 ),
                                                 child: new Center(
                                                   child: new Text('No',
                                                   style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                                                   ),
                                                 ),
                                               ),
                                             ),
                                            ],
                                          ),
                                        ],
                                      )
                                       : new Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          new FlatButton(
                                            onPressed: () async  {
                                              if(Platform.isIOS) {
                                                  var photoIOSPermission = await Permission.photos.status;
                                                  if(photoIOSPermission.isGranted) {
                                                    print('Accepté');
                                                    FilePickerResult resultImage  = await FilePicker.platform.pickFiles(type: FileType.image);
                                                        if (resultImage != null) {
                                                          modifyCover(modalSecondSetState, File(resultImage.files.single.path), ds.data()['timestamp'],ds.data()['style']);
                                                        } else {
                                                          print('No image selected.');
                                                      }
                                                  }
                                                  if(photoIOSPermission.isUndetermined) {
                                                    await Permission.photos.request();
                                                    if(await Permission.photos.request().isGranted) {
                                                    FilePickerResult resultImage  = await FilePicker.platform.pickFiles(type: FileType.image);
                                                        if (resultImage != null) {
                                                          modifyCover(modalSecondSetState, File(resultImage.files.single.path), ds.data()['timestamp'],ds.data()['style']);
                                                        } else {
                                                          print('No image selected.');
                                                      }
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
                                                   if (resultImage != null) {
                                                     modifyCover(modalSecondSetState, File(resultImage.files.single.path), ds.data()['timestamp'],ds.data()['style']);
                                                   } else {
                                                     print('No image selected.');
                                                 }     
                                                }
                                                if(androidPermissions.isUndetermined) {
                                                  await Permission.storage.request();
                                                  if(await Permission.storage.request().isGranted) {
                                                    FilePickerResult resultImage  = await FilePicker.platform.pickFiles(type: FileType.image);
                                                    if (resultImage != null) {
                                                      modifyCover(modalSecondSetState, File(resultImage.files.single.path), ds.data()['timestamp'],ds.data()['style']);
                                                    } else {
                                                      print('No image selected.');
                                                  }                                                  
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
                                            child: new Text('MODIFY THIS COVER',
                                            style: new TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold)
                                            ),
                                            ),
                                          new FlatButton(
                                            onPressed: () {
                                              modalSecondSetState((){
                                                _areUSureView = true;
                                              });
                                            }, 
                                            child: new Text('DELETE THIS POST',
                                            style: new TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold)
                                            ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                );
                            }
                            ).whenComplete(() {
                              setState(() {
                                _areUSureView = false;
                              });
                            });
                        },
                        onTap: () async  {
                          AudioPlayer audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
                          AudioPlayer.logEnabled = true;
                          viewRequest(ds.data()['style'], ds.data()['timestamp'], ds.data()['views'], ds.data()['artistUID']);
                          audioPlayer.play(ds.data()['fileMusicURL'], volume: 1.0).whenComplete(() {
                            Navigator.push(context, new MaterialPageRoute(builder: (context) => new MyMusicDetailsPage(
                              currentUser: widget.currentUser,
                              artistUID: ds.data()['artistUID'],
                              audioPlayerController: audioPlayer,
                              index: index,
                              currentUserUsername: widget.currentUserUsername,
                              songsLikedMap: songsLikedMap,
                              totalLikes: snapshotUser.data.data()['likes'],
                              audioPlayerControllerDuration: ds.data()['fileMusicDuration'],
                            )));
                          });
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        child: new Container(
                          color: Colors.grey.withOpacity(0.1),
                          child: new Stack(
                            children: [
                              new Positioned(
                                top: 0.0,
                                left: 0.0,
                                right: 0.0,
                                bottom: 0.0,
                                child: ds.data()['imageSong'] != null
                                  ? new Image.network(ds.data()['imageSong'], fit: BoxFit.cover)
                                  : new Container(),
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
                                height: MediaQuery.of(context).size.height*0.07,
                                color: Colors.transparent,
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    //Divider
                                    new Container(
                                      height: MediaQuery.of(context).size.height*0.03,
                                      width: MediaQuery.of(context).size.width*0.03,
                                    ),
                                    new Container(
                                      height: MediaQuery.of(context).size.height*0.05,
                                      child: new Row(
                                        children: [
                                          new Image.asset(
                                           songsLikedMap != null && songsLikedMap.containsValue(ds.data()['timestamp'])
                                            ? 'lib/assets/like.png'
                                            : 'lib/assets/likeOff.png',
                                          height: 18.0,
                                          width: 18.0,
                                          color: Colors.white,
                                          ),
                                          //Divider
                                          new Container(
                                            height: MediaQuery.of(context).size.height*0.03,
                                            width: MediaQuery.of(context).size.width*0.03,
                                          ),
                                          new Container(
                                            child: new Text(
                                              ds['likes'] != null
                                              ? '${ds.data()['likes'].toString()}'
                                              : '',
                                            style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
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
                          new Positioned(
                            top: 0.0,
                            left: 0.0,
                            right: 0.0,
                            bottom: 0.0,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                new Container(
                                  height: MediaQuery.of(context).size.height*0.07,
                                  color: Colors.transparent,
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      //Divider
                                      new Container(
                                        height: MediaQuery.of(context).size.height*0.03,
                                        width: MediaQuery.of(context).size.width*0.03,
                                      ),
                                      new Container(
                                        height: MediaQuery.of(context).size.height*0.05,
                                        child: new Row(
                                          children: [
                                            new Image.asset('lib/assets/playOff.png',
                                            height: 18.0,
                                            width: 18.0,
                                            color: Colors.white,
                                            ),
                                            //Divider
                                          new Container(
                                            height: MediaQuery.of(context).size.height*0.03,
                                            width: MediaQuery.of(context).size.width*0.03,
                                          ),
                                          new Container(
                                            child: new Text(
                                              ds.data()['views'] != null
                                              ? ds.data()['views'].toString()
                                              : '',
                                            style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
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
          );
        }),
    );
  }


  deletePost(StateSetter setModalSecond, String timeStamp, String musicStyle, String musicURL) {
    if(this.mounted) {
      setModalSecond(() {
        updatedInPublishing = true;
      });
    }
    firebase_storage.Reference storageReferenceImage = firebase_storage.FirebaseStorage.instance
      .ref()
      .child('${widget.currentUser}/songs/$timeStamp/$timeStamp-image');
      storageReferenceImage.delete().whenComplete(() {
        print('Image deleted (Storage)');
        firebase_storage.Reference storageReferenceAudio = firebase_storage.FirebaseStorage.instance
          .refFromURL(musicURL);
          storageReferenceAudio.delete().whenComplete(() {
            print('Audio deleted (Storage)');
            FirebaseFirestore.instance
              .collection('users')
              .doc(widget.currentUser)
              .collection('songs')
              .doc(timeStamp)
              .delete().whenComplete(() {
            FirebaseFirestore.instance
              .collection(musicStyle)
              .doc(timeStamp)
              .delete().whenComplete(() {
                print('all datas are deleted');
                if(this.mounted) {
                  setModalSecond(() {
                    updatedInPublishing = false;
                    _areUSureView = false;
                    Navigator.pop(context);
                  });
                }
              });
              });
          });
      });
                   
  }

  modifyCover(StateSetter setModalSecond, File filePhoto, String timeStamp, String musicStyle) async {
    if(filePhoto != null) {
      if(this.mounted) {
      setModalSecond((){
        updatedInPublishing = true;
      });
      }
      firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('${widget.currentUser}/songs/$timeStamp/$timeStamp-image');
        firebase_storage.UploadTask uploadTask = storageReference.putFile(filePhoto);
        await uploadTask;
        print('Photo uploaded (Storage)');
        storageReference.getDownloadURL().then((imageSongURL) {
          FirebaseFirestore.instance
            .collection('users')
            .doc(widget.currentUser)
            .collection('songs')
            .doc(timeStamp)
            .update({
              'imageSong': imageSongURL,
            }).whenComplete(() {
          FirebaseFirestore.instance
            .collection(musicStyle)
            .doc(timeStamp)
            .update({
              'imageSong': imageSongURL,
            }).whenComplete(() {
              print('All datas are updated');
              if(this.mounted) {
              setModalSecond((){
                updatedInPublishing = false;
              });
              }
            });
            });
        });
    }

  }

  /*updatesRequest(StateSetter setterParameters) async {
    if(_image != null) {
        setterParameters(() {
        updatedInPublishing = true;
      });
      firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('${widget.currentUser}/profilePhoto');
        firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);
        await uploadTask;
        print('Photo upload (Storage)');
        storageReference.getDownloadURL().then((filePhotoURL) {
        FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUser)
          .update({
            'profilePhoto': filePhotoURL,
            'shopLink': _linkMusicShopController.value.text.length > 3 ? _linkMusicShopController.value.text.toString() : null,
            'spotifyLink': _linkSpotifyController.value.text.length > 3 ? _linkSpotifyController.value.text.toString() : null,
            'instagramLink': _linkInstagramController.value.text.length > 3 ? _linkInstagramController.value.text.toString() : null,
          }).whenComplete(() {
            setterParameters(() {
              updatedInPublishing = false;
              Navigator.pop(context);
            });
          });    
        });
  } else if(_linkMusicShopController.value.text.length > 3 || _linkInstagramController.value.text.length > 3 || _linkSpotifyController.value.text.length > 3) {
    setterParameters(() {
      updatedInPublishing = true;
    });
    //If user no update photo
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .update({
        'shopLink': _linkMusicShopController.value.text.length > 3 ? _linkMusicShopController.value.text.toString() : null,
        'spotifyLink': _linkSpotifyController.value.text.length > 3 ? _linkSpotifyController.value.text.toString() : null,
        'instagramLink': _linkInstagramController.value.text.length > 3 ? _linkInstagramController.value.text.toString() : null,
      }).whenComplete(() {
        setterParameters(() {
          updatedInPublishing = false;
          Navigator.pop(context);
        });
      });
  } else {
    print('Nothing to update');
  }
  }*/

    viewRequest(String musicStyle, String timeStamp, int views, String artistUID) {
    FirebaseFirestore.instance
      .collection(musicStyle)
      .doc(timeStamp)
      .update({
        'views': views+1,
      }).whenComplete(() {
        FirebaseFirestore.instance
          .collection('users')
          .doc(artistUID)
          .collection('songs')
          .doc(timeStamp)
          .update({
            'views': views+1,
          }).whenComplete(() {
            print('Ok view +1 (stored)');
          });
      });
  }


  //
  Map<dynamic, dynamic> songsLikedMap;
  listenIfAlreadyliked() {
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .get().then((value) {
        if(value.exists) {
          if(this.mounted) {
            setState(() {
              songsLikedMap = value.data()['songsLiked'];
              print('songsLikedMap = $songsLikedMap');
            });
        }
      }
  });
  }

}