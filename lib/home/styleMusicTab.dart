import 'package:SONOZ/DiscoverTab/discoverTab.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StyleMusicTab extends StatefulWidget {

  String currentUserUsername;
  String currentUser;
  String style;
  Map<dynamic, dynamic> songsLikedMap;

  StyleMusicTab({Key key, this.currentUserUsername, this.currentUser, this.style, this.songsLikedMap}) : super(key: key);

  @override
  StyleMusicTabState createState() => StyleMusicTabState();
}

class StyleMusicTabState extends State<StyleMusicTab> {

  bool filterRecentIsChoosen = true;
  bool filterTrendIsChoosen = false;

  ScrollController songsGriViewController = new ScrollController();
  //Duration for widget.audioPlayerController

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: FirebaseFirestore.instance
        .collection(widget.style)
        .orderBy(filterRecentIsChoosen == true ? 'timestamp' : 'likes', descending: true)
        .snapshots(),
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
            height: MediaQuery.of(context).size.height*0.60,
            width: MediaQuery.of(context).size.width,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
             new Text('No song here yet.', style: new TextStyle(color: Colors.grey,fontSize: 20.0, fontWeight: FontWeight.bold)),
             new Text('Look another style buddy.', style: new TextStyle(color: Colors.grey[700],fontSize: 17.0, fontWeight: FontWeight.w600)),
             ]));
        }
        return new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              new Container(
                height: MediaQuery.of(context).size.height*0.02,
                color: Colors.transparent,
              ),
            new Container(
              height: MediaQuery.of(context).size.height*0.05,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //ButtonRecent
                  new InkWell(
                    onTap: (){
                      setState(() {
                        filterRecentIsChoosen = true;
                        filterTrendIsChoosen = false;
                      });
                    },
                    child: new Container(
                      height: MediaQuery.of(context).size.height*0.04,
                      width: MediaQuery.of(context).size.width*0.45,
                      decoration: new BoxDecoration(
                        color: filterRecentIsChoosen == true ? Colors.grey[900] : Colors.transparent,
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      child: new Center(
                        child: new Text('New 👶',
                        style: new TextStyle(color: filterRecentIsChoosen == true ? Colors.white : Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  new InkWell(
                    onTap: (){
                      setState(() {
                        filterRecentIsChoosen = false;
                        filterTrendIsChoosen = true;
                      });
                    },
                    child: new Container(
                      height: MediaQuery.of(context).size.height*0.04,
                      width: MediaQuery.of(context).size.width*0.45,
                      decoration: new BoxDecoration(
                        color: filterTrendIsChoosen == true ? Colors.grey[900] : Colors.transparent,
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      child: new Center(
                        child: new Text('Trendy 🔥',
                        style: new TextStyle(color: filterTrendIsChoosen == true ? Colors.white : Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              child: new GridView.builder(
                physics: new NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 15.0),
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: 1/1.5
                ),
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot ds = snapshot.data.documents[index];
                  return new InkWell(
                    onTap: () async {
                      AudioPlayer audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
                      AudioPlayer.logEnabled = true;
                      viewRequest(ds.data()['style'], ds.data()['timestamp'], ds.data()['views'], ds.data()['artistUID']);
                      audioPlayer.play(ds.data()['fileMusicURL'], volume: 1.0).whenComplete(() {
                      Navigator.push(context, new MaterialPageRoute(builder: (context) => new DiscoverTab(
                          currentUser: widget.currentUser,
                          audioPlayerController: audioPlayer,
                          index: index,
                          musicStyle: ds.data()['style'],
                          currentUserUsername: widget.currentUserUsername,
                          filterRecentIsChoosen: filterRecentIsChoosen,
                          songsLikedMap: widget.songsLikedMap,
                          audioPlayerControllerDuration: ds.data()['fileMusicDuration'],
                        ))
                        );
                      });
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    child: new Container(
                      color: Colors.grey.withOpacity(0.1),
                      child: new Stack(
                        children: [
                          //ImageSong
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
                                              widget.songsLikedMap != null && widget.songsLikedMap.containsValue(ds.data()['timestamp'])
                                              ? 'lib/assets/like.png'
                                              : 'lib/assets/likeOff.png',
                                            height: 18.0,
                                            width: 18.0,
                                            color: widget.songsLikedMap != null && widget.songsLikedMap.containsValue(ds.data()['timestamp']) ? Colors.white : Colors.white,
                                            ),
                                            //Divider
                                          new Container(
                                            height: MediaQuery.of(context).size.height*0.03,
                                            width: MediaQuery.of(context).size.width*0.03,
                                          ),
                                          new Container(
                                            child: new Text(
                                              ds.data()['likes'] != null
                                              ? ds.data()['likes'].toString()
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
          ),
        );
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