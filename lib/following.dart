import 'dart:io';
import 'package:SONOZ/DiscoverTab/profileDetails.dart';
import 'package:SONOZ/permissionsHandler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

import 'inscriptionProcess/landingPage.dart';

class FollowingPage extends StatefulWidget {

  String currentUser;
  String currentUserUsername;
  String currentUserType;

  FollowingPage({Key key, this.currentUser, this.currentUserUsername, this.currentUserType}) : super(key: key);

  @override
  FollowingPageState createState() => FollowingPageState();
}

class FollowingPageState extends State<FollowingPage> {

  var songsList = new List<int>.generate(50, (i) => i + 1);
  ScrollController songsGriViewController = new ScrollController(initialScrollOffset: 0.0);

  bool filterRecentIsChoosen = true;
  bool filterTrendIsChoosen = false;
  bool _signOutView = false;
  bool updatedInPublishing = false;
  File _image;

  String profilePhotoUserTypeFan;


  requestProfilePhoto() {
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .get().then((value) {
        if(value.exists) {
          if(this.mounted) {
            setState(() {
              profilePhotoUserTypeFan = value.data()['profilePhoto'];
            });
          }
        }
      });
  }

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
    if(widget.currentUserType == 'iamFAN') {
      requestProfilePhoto();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new Container(
        color: Colors.black,
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
              height: MediaQuery.of(context).size.height*0.06,
              child:
              widget.currentUserType == 'iamDJ'
               ? new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                new Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  width: MediaQuery.of(context).size.width*0.04,
                  color: Colors.transparent,
                ),
                new Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  color: Colors.transparent,
                  child: new Text('Following',
                  style: new TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ),
                ],
              )
              : new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                new Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  width: MediaQuery.of(context).size.width*0.04,
                  color: Colors.transparent,
                ),
                  new Container(
                    color: Colors.transparent,
                    child: new Text('Following',
                    style: new TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.06,
                    width: MediaQuery.of(context).size.width*0.40,
                  ),
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
                                  height: MediaQuery.of(context).size.height*0.40,
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
                                                  setState(() {
                                                    _image = File(resultImage.files.single.path);
                                                  });
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
                                           child: new Text('Upload new photo',
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
                                                  }).whenComplete(() {
                                                    modalSetState(() {
                                                      updatedInPublishing = false;
                                                      Navigator.pop(context);
                                                    });
                                                  });    
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
                    height: MediaQuery.of(context).size.height*0.04,
                    width: MediaQuery.of(context).size.height*0.04,
                    decoration: new BoxDecoration(
                      color: Colors.grey[900],
                      shape: BoxShape.circle,
                    ),
                    child: new ClipOval(
                    child: profilePhotoUserTypeFan != null 
                    ? new Image.network(profilePhotoUserTypeFan, fit: BoxFit.cover)
                    : new Container(),
                  ))),
                ],
              ),
            ),
            new Container(
              child: new StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').doc(widget.currentUser).collection('following').snapshots(),
                builder: (BuildContext context, snapshot) {
                  if(!snapshot.hasData) {
                    return new Container();
                  }
                  if(snapshot.data.documents.isEmpty) {
                    return new Container(
                      height: MediaQuery.of(context).size.height*0.70,
                      child: new Center(
                        child: new Container(
                          height: MediaQuery.of(context).size.height*0.40,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          new Container(
                            child: new Text('No following yet',
                            style: new TextStyle(color: Colors.yellowAccent, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          new Container(
                            child: new Text('Go to discover buddy',
                            style: new TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        ),
                        ),
                      ),
                    );
                  }
                  return new Container(
                    child: new GridView.builder(
                      itemCount: snapshot.data.documents.length,
                      physics: new NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      shrinkWrap: true,
                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 5.0,
                      childAspectRatio: 1/1.5
                      ), 
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot ds = snapshot.data.documents[index];
                        return new InkWell(
                          onTap: () {
                            //Navigate to profileDetails
                            Navigator.push(
                              context, new MaterialPageRoute(builder: (context) => 
                              new ProfilDetailsPage(
                                currentUser: widget.currentUser,
                                currentUserUsername: widget.currentUserUsername,
                                artistUID: ds.data()['artistUID'],
                                artistUsername: ds.data()['artistUsername'],
                                artistProfilePhoto: ds.data()['artistProfilePhoto'],
                              )));
                          },
                        child: new Container(
                          color: Colors.transparent,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new Container(
                                height: MediaQuery.of(context).size.height*0.10,
                                width: MediaQuery.of(context).size.height*0.10,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[900],
                                ),
                                child: new ClipOval(
                                  child: ds['artistProfilePhoto'] != null
                                  ? new Image.network(ds['artistProfilePhoto'], fit: BoxFit.cover)
                                  : new Container(),
                                ),
                              ),
                              //ArtistUsername
                              new Container(
                                child: new Text(
                                  ds['artistUsername'] != null
                                  ? ds['artistUsername']
                                  : '',
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ));
                      },
                  ));
                }),
            ),
            /*new Container(
              height: MediaQuery.of(context).size.height*0.10,
              color: Colors.transparent,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new InkWell(
                    onTap: () {
                      setState(() {
                        filterRecentIsChoosen = true;
                        filterTrendIsChoosen = false;
                      });
                    }, 
                    child: new Container(
                    height: MediaQuery.of(context).size.height*0.05,
                    width: MediaQuery.of(context).size.width*0.30,
                    decoration: new BoxDecoration(
                      color: filterRecentIsChoosen == true ?  Colors.yellowAccent :  Colors.grey[900],
                      borderRadius: new BorderRadius.circular(5.0),
                    ),
                    child: new Center(
                      child: new Text('Recent',
                      style: new TextStyle(color: filterRecentIsChoosen == true ? Colors.black : Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.05,
                    width: MediaQuery.of(context).size.width*0.04,
                  ),
                  new InkWell(
                    onTap: () {
                      setState(() {
                        filterRecentIsChoosen = false;
                        filterTrendIsChoosen = true;
                      });
                    },
                  child: new Container(
                    height: MediaQuery.of(context).size.height*0.05,
                    width: MediaQuery.of(context).size.width*0.30,
                    decoration: new BoxDecoration(
                      color: filterTrendIsChoosen == true ? Colors.yellowAccent : Colors.grey[900],
                      borderRadius: new BorderRadius.circular(5.0),
                    ),
                    child: new Center(
                      child: new Text('Trend',
                      style: new TextStyle(color: filterTrendIsChoosen == true ? Colors.black : Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
                ],
              ),
            ),
            new Container(
              height: MediaQuery.of(context).size.height*0.02,
              color: Colors.transparent,
            ),
            new Container(
              height: MediaQuery.of(context).size.height*0.05,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                new Container(
                  height: MediaQuery.of(context).size.height*0.05,
                  width: MediaQuery.of(context).size.width*0.04,
                  color: Colors.transparent,
                ),
                new Container(
                  child: new Text("Last song of each following",
                  style: new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.bold)
                  ),
                ),
                ],
              ),
            ),
            new Container(
            child: new GridView.builder(
              physics: new NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 4.0),
              shrinkWrap: true,
              itemCount: songsList.length,
              controller: songsGriViewController,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 5.0,
              childAspectRatio: 1/1.5
              ),
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  child: new Container(
                    color: Colors.grey.withOpacity(0.1),
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
                                    new Image.asset('lib/assets/likeOff.png',
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
                                      child: new Text('1,5K',
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
                );
              },
              ),
            ),*/
          ],
        ),
      )
      ),
    );
  }

}