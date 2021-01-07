import 'package:SONOZ/profile/myMusicDetails.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilDetailsPage extends StatefulWidget {

  String currentUser;
  String currentUserUsername;
  //ArtistDatas injections
  String artistUID;
  String artistUsername;
  String artistProfilePhoto;


  ProfilDetailsPage({
    Key key, 
    this.currentUser,
    this.currentUserUsername,
    this.artistUID,
    this.artistUsername,
    this.artistProfilePhoto,
    }) : super(key: key);


  @override
  ProfilDetailsPageState createState() => ProfilDetailsPageState();
}

class ProfilDetailsPageState extends State<ProfilDetailsPage> {

  _launchURL(String link) async {
    if(await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }



  //
  bool alreadySubscribe;
  listenIfUserAlreadyFollowed() {
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .collection('following')
      .doc(widget.artistUID)
      .get().then((value) {
        if(value.exists) {
          if(this.mounted) {
            setState(() {
              alreadySubscribe = true;
            });
          }
        } else {
          //Noexist
          if(this.mounted) {
          setState(() {
            alreadySubscribe = false; 
          });
          }
        }
      });
  }


  var artistsongs = new List<int>.generate(50, (i) => i + 1);
  ScrollController songsGriViewController = new ScrollController(initialScrollOffset: 0.0);

  @override
  void initState() {
    listenIfAlreadyliked();
    listenIfUserAlreadyFollowed();
    //listenArtistDatas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
      ),
      body: new StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').doc(widget.artistUID).snapshots(),
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
                height: MediaQuery.of(context).size.height*0.02,
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
                      child: widget.artistProfilePhoto != null
                      ? new Image.network(widget.artistProfilePhoto, fit: BoxFit.cover)
                      : new Container(),
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
                      widget.artistUsername != null
                      ? '@${widget.artistUsername}'
                      : '@username',
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
                      ? snapshotUser.data.data()['subscribers'].toString()
                      : '',
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
                      ? snapshotUser.data.data()['likes'].toString()
                      : '',
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
            new StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').doc(widget.artistUID).collection('songs').orderBy('timestamp', descending: true).snapshots(),
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
                    new Text('No track posted.', style: new TextStyle(color: Colors.yellow[200],fontSize: 18.0, fontWeight: FontWeight.w600)),
                    ]));
                }
                return new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  new Container(
                    height: MediaQuery.of(context).size.height*0.10,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       new InkWell(
                        onTap: () {
                          if(alreadySubscribe == false) {
                            followRequest(snapshotUser.data.data()['subscribers']);
                          } else {
                            unFollowRequest(snapshotUser.data.data()['subscribers']);
                          }
                        }, 
                      child: new Container(
                        height: MediaQuery.of(context).size.height*0.05,
                        width: MediaQuery.of(context).size.width*0.30,
                        decoration: new BoxDecoration(
                          color: alreadySubscribe == false ? Colors.yellowAccent : Colors.grey[800],
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                        child: new Center(
                        child: new Text(alreadySubscribe == false ? 'Follow' : 'Unfollow',
                        style: new TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        ),
                        ),
                        ),
                        snapshotUser.data.data()['instagramLink'] != null
                        ? new Padding(
                          padding: EdgeInsets.only(left: 20.0),
                        child: new InkWell(
                          onTap: () {
                            _launchURL(snapshotUser.data.data()['instagramLink']);
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
                        )))
                        : new Container(),
                        //ArtistShopLink
                            snapshotUser.data.data()['shopLink'] != null
                            ? new Padding(
                          padding: EdgeInsets.only(left: 20.0),
                            child: new InkWell(
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
                          ))
                          : new Container(),
                         ],
                    ),
                  ),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.03,
                    width: MediaQuery.of(context).size.width,
                  ),
                    new Container(
                    child: new GridView.builder(
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
                          onTap: () async  {
                            AudioPlayer audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
                            AudioPlayer.logEnabled = true;
                            viewRequest(ds.data()['style'], ds.data()['timestamp'], ds.data()['views'], ds.data()['artistUID']);
                            audioPlayer.play(ds.data()['fileMusicURL'], volume: 1.0).whenComplete(() {
                              Navigator.push(context, new MaterialPageRoute(builder: (context) => new MyMusicDetailsPage(
                                currentUser: widget.currentUser,
                                currentUserUsername: widget.currentUserUsername,
                                audioPlayerController: audioPlayer,
                                index: index,
                                artistUID: ds.data()['artistUID'],
                                totalLikes: snapshotUser.data.data()['likes'],
                                songsLikedMap: songsLikedMap,
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
                                  child: new ClipRRect(
                                    child: ds.data()['imageSong'] != null
                                    ? new Image.network(ds.data()['imageSong'], fit: BoxFit.cover)
                                    : new Container(),
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
                      ),
                    ),
                  ],
                );
              },
            ),
            ],
          ),
        ),
        );
          },
      ),
    );
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

  followRequest(int subscribers) {
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .collection('following')
      .doc(widget.artistUID)
      .set({
        'artistProfilePhoto': widget.artistProfilePhoto,
        'artistUsername': widget.artistUsername,
        'artistUID': widget.artistUID,
      }).whenComplete(() {
        FirebaseFirestore.instance
          .collection('users')
          .doc(widget.artistUID)
          .update({
            'subscribers': subscribers+1,
          }).whenComplete(() {
          if(this.mounted) {
            setState(() {
              alreadySubscribe = true;
            });
            print('follow done');
          }
          });
      });
  }

  unFollowRequest(int subscribers) {
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .collection('following')
      .doc(widget.artistUID)
      .delete().whenComplete(() {
        FirebaseFirestore.instance
          .collection('users')
          .doc(widget.artistUID)
          .update({
            'subscribers': subscribers-1,
          }).whenComplete(() {
          if(this.mounted) {
            setState(() {
              alreadySubscribe = false;
            });
          }
        print('Unfollow done');
          });
      });
  }


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




}