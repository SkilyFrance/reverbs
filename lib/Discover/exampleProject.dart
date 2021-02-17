import 'package:flutter/material.dart';


class ExampleProjectPage extends StatefulWidget {

  String musicStyle;

  ExampleProjectPage({Key key, this.musicStyle}) : super(key: key);



  @override
  ExampleProjectPageState createState() => ExampleProjectPageState();
}


class ExampleProjectPageState extends State<ExampleProjectPage> {
  @override

  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
    new Container(
      height: MediaQuery.of(context).size.height*0.50,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Divider
          new Container(
            width: MediaQuery.of(context).size.width,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.01,
                  width: MediaQuery.of(context).size.width*0.05,
                  color: Colors.transparent,
                ),
                new Text('Future-house',
                style: new TextStyle(color: Colors.grey[700],fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          new Container(
            height: MediaQuery.of(context).size.height*0.45,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  new Container(
                    height: MediaQuery.of(context).size.height*0.45,
                    width: MediaQuery.of(context).size.width*0.04,
                  ),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.45,
                    width: MediaQuery.of(context).size.width*0.80,
                    constraints: new BoxConstraints(
                      minHeight: 400.0,
                      minWidth: 300.0,
                    ),
                    decoration: new BoxDecoration(
                      color: Colors.grey[900].withOpacity(0.5),
                      border: new Border.all(
                        width: 1.0,
                        color: Colors.grey[900]
                      ),
                      borderRadius: new BorderRadius.circular(5.0),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Container(
                          height: MediaQuery.of(context).size.height*0.07,
                          color: Colors.transparent,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              //Divider
                              new Container(
                                height: MediaQuery.of(context).size.height*0.07,
                                width: MediaQuery.of(context).size.width*0.03,
                              ),
                              new Container(
                                height: MediaQuery.of(context).size.height*0.05,
                                width: MediaQuery.of(context).size.height*0.05,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[800],
                                ),
                                child: new ClipOval(
                                  child: new Image.asset('lib/assets/userPhoto.png', fit: BoxFit.cover)
                                ),
                              ),
                              //Divider
                              new Container(
                                height: MediaQuery.of(context).size.height*0.07,
                                width: MediaQuery.of(context).size.width*0.03,
                              ),
                              new Container(
                                child: new Text('David Morillo',
                                style: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        new Container(
                          height: MediaQuery.of(context).size.height*0.13,
                          width: MediaQuery.of(context).size.width*0.80,
                          color: Colors.transparent,
                          child: new Center(
                          child: new Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: new Text("Hello to everyone, this post is an example of project post. Each project is organized by music style and can be found by all producers. It includes : Project's context, demo track, and a button to submit your profile. Create your first project now ! 🔥",
                          style: new TextStyle(color: Colors.white, fontSize: 13.0),
                          textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
                        ),
                        new Container(
                          height: MediaQuery.of(context).size.height*0.10,
                          width: MediaQuery.of(context).size.width*0.80,
                          color: Colors.transparent,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                onTap: () {
                                },
                              child: new Container(
                                height: MediaQuery.of(context).size.height*0.09,
                                width: MediaQuery.of(context).size.height*0.09,
                                decoration: new BoxDecoration(
                                  color: Colors.grey[900].withOpacity(0.8),
                                  shape: BoxShape.circle,
                                  border: new Border.all(
                                    width: 2.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                child: new Center(
                                  child: new Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40.0)
                                ),
                              ),
                              )
                            ],
                          ),
                        ),
                        new Container(
                          height: MediaQuery.of(context).size.height*0.08,
                          width: MediaQuery.of(context).size.width*0.80,
                          color: Colors.transparent,
                          child: new Center(
                            child: new Container(
                              height: MediaQuery.of(context).size.height*0.05,
                              width: MediaQuery.of(context).size.width*0.50,
                              decoration: new BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: new BorderRadius.circular(5.0),
                                border: new Border.all(
                                  width: 1.0,
                                  color: Colors.grey,
                                ),
                              ),
                              child: new Container(
                                child: new Center(
                                child: new Text('Submit',
                                style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                                ),
                                ),
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
    ),
      ],
    );
  }
}




  /*viewMusicWidget(String musicStyle, int snapshotLength, AsyncSnapshot<dynamic> snapshotCurrent, ScrollController _controller) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
    new Container(
      height: MediaQuery.of(context).size.height*0.30,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Divider
          new Container(
            width: MediaQuery.of(context).size.width,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.01,
                  width: MediaQuery.of(context).size.width*0.05,
                ),
                new Text(musicStyle,
                style: new TextStyle(color: Colors.grey[600],fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
              new Container(
                height: MediaQuery.of(context).size.height*0.25,
                color: Colors.transparent,
                child: new ListView.builder(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  physics: new ScrollPhysics(),
                  itemCount: snapshotLength,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot ds = snapshotCurrent.data.documents[index];
                    return new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        new Container(
                          height: MediaQuery.of(context).size.height*0.25,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new InkWell(
                                onTap: () {
                                },
                              child: new Container(
                                height: MediaQuery.of(context).size.height*0.18,
                                width: MediaQuery.of(context).size.height*0.18,
                                decoration: new BoxDecoration(
                                  color: Colors.grey[900].withOpacity(0.7),
                                  borderRadius: new BorderRadius.circular(5.0),
                                  border: new Border.all(
                                    width: 2.0,
                                    color: _trackChoosenToListen == ds.data()['fileMusicURL'] ? Colors.purpleAccent : Colors.transparent,
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
                                  child: ds.data()['coverImage'] != null
                                  ? new Image.network(ds.data()['coverImage'], fit: BoxFit.cover)
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
                                          child: new InkWell(
                                            onTap: () {
  
                                            },
                                          child: 
                                          _trackChoosenToListen == ds.data()['fileMusicURL'] && _audioIsOnPause == true
                                          ? new Container(
                                            decoration: new BoxDecoration(
                                              color: Colors.white.withOpacity(0.3),
                                              shape: BoxShape.circle,
                                            ),
                                            child: new Padding(
                                              padding: EdgeInsets.all(7.0),
                                              child: new IconButton(
                                                icon: new Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30.0), 
                                                onPressed: () {
                                                  setState(() {
                                                    audioPlayer.resume();
                                                    _audioIsOnPause = false;
                                                  });
                                                },
                                                ),
                                            ))
                                          : _trackChoosenToListen == ds.data()['fileMusicURL'] && _audioIsOnPause == false
                                          ? new Container(
                                           decoration: new BoxDecoration(
                                             color: Colors.white.withOpacity(0.3),
                                             shape: BoxShape.circle,
                                           ),
                                           child: new Padding(
                                             padding: EdgeInsets.all(7.0),
                                             child: new IconButton(
                                               icon: new Icon(Icons.pause, color: Colors.white, size: 30.0), 
                                               onPressed: () {
                                                 setState(() {
                                                   audioPlayer.pause();
                                                   _audioIsOnPause = true;
                                                 });
                                               },
                                               ),
                                           ),
                                         )
                                         : new Container(
                                            decoration: new BoxDecoration(
                                              color: Colors.white.withOpacity(0.3),
                                              shape: BoxShape.circle,
                                            ),
                                            child: new Padding(
                                              padding: EdgeInsets.all(7.0),
                                              child: new IconButton(
                                                icon: new Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30.0), 
                                                onPressed: () {
                                                  if(_audioLaunched == true) {
                                                   setState(() {
                                                     _trackChoosenToListen = ds.data()['fileMusicURL'];
                                                     audioPlayerControllerPosition = 0;
                                                     audioPlayerControllerDuration = ds.data()['fileMusicDuration'];
                                                     currentArtistPlayedUsername = ds.data()['artistUsername'];
                                                     currenProfilePhotoArtistPlayed = ds.data()['artistProfilePhoto'];
                                                     currentArtistUIDPlayed = ds.data()['artistUID'];
                                                     currentCoverImagePlayed = ds.data()['coverImage'];
                                                     currentTitlePlayed = ds.data()['title'];
                                                   });
                                                   audioPlayer.play(ds.data()['fileMusicURL'], volume: 1.0);
                                                  } else {
                                                    //No audio launched yet
                                                    setState(() {
                                                      _trackChoosenToListen = ds.data()['fileMusicURL'];
                                                      audioPlayerControllerDuration = ds.data()['fileMusicDuration'];
                                                      currentArtistPlayedUsername = ds.data()['artistUsername'];
                                                      currenProfilePhotoArtistPlayed = ds.data()['artistProfilePhoto'];
                                                      currentArtistUIDPlayed = ds.data()['artistUID'];
                                                      currentTitlePlayed = ds.data()['title'];
                                                      currentCoverImagePlayed = ds.data()['coverImage'];
                                                      _musicIsInitializing = true;
                                                    });
                                                    AudioPlayer.logEnabled = true;
                                                    audioPlayer.play(ds.data()['fileMusicURL'], volume: 1.0).whenComplete(() {
                                                      audioPlayer.onAudioPositionChanged.listen((event) {
                                                        setState(() {
                                                          audioPlayerControllerPosition = event.inMilliseconds;
                                                        });
                                                        if(event.inMilliseconds > 0 && event.inMilliseconds < 2000) {
                                                          setState(() {
                                                            _musicIsInitializing = false;
                                                            _audioLaunched = true;
                                                            print('ok iniatilized');
                                                          });
                                                        }
                                                      });
                                                    });
                                                  }
                                                },
                                                ),
                                            ))
                                        ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ),
                              ),
                              new Container(
                                child: new Text(ds.data()['artistUsername'] != null
                                ? ds.data()['artistUsername']
                                : '',
                                style: new TextStyle(color: Colors.white,fontSize: 12.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                              new Container(
                                child: new Text(ds.data()['title'] != null
                                ? ds.data()['title']
                                : '',
                                style: new TextStyle(color: Colors.grey,fontSize: 10.0, fontWeight: FontWeight.w500),
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
        ],
      ),
      ),
       //Divider
       new Container(
         height: MediaQuery.of(context).size.height*0.05,
         width: MediaQuery.of(context).size.width,
       ),
      ],
    );
  }*/