import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


class StoragePage extends StatefulWidget {
  @override
  StoragePageState createState() => StoragePageState();

}


  class StoragePageState extends State<StoragePage> {


    ScrollController _releasedTracks = new ScrollController(initialScrollOffset: 0);
    ScrollController _unReleasedTracks = new ScrollController(initialScrollOffset: 0);

    int sharedValue = 0;
    int sharedModalValue = 0;
    int selectedValue;


    @override
  void initState() {
    _releasedTracks = new ScrollController();
    _unReleasedTracks = new ScrollController();
    super.initState();
  }



    @override
    Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget> [
            new CupertinoSliverNavigationBar(
              backgroundColor: Colors.black.withOpacity(0.7),
              largeTitle: new Text('Storage',
                  style: new TextStyle(color: Colors.white),
                  ),
              trailing: new IconButton(
                icon: new Icon(Icons.add_circle_outline_rounded, color: Colors.purpleAccent, size: 25.0),
                onPressed: () {
                  showBarModalBottomSheet(
                    context: context, 
                    builder: (context){
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter modalSetState) {
                         return new Container(
                         height: MediaQuery.of(context).size.height*0.85,
                         width: MediaQuery.of(context).size.width,
                         color: Color(0xFF181818),
                         child: new Column(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                 child: new Text('Store a new track',
                                 style: new TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16.0, fontWeight: FontWeight.bold),
                                 ),
                               ),
                             ),
                             new Container(
                               height: MediaQuery.of(context).size.height*0.03,
                               width: MediaQuery.of(context).size.width,
                               color: Colors.transparent,
                             ),
                             new CupertinoSlidingSegmentedControl(
                               backgroundColor: Colors.grey[900],
                               children: <int, Widget>{
                                 0: new Padding(
                                   padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                                 child: new Container(
                                   child: new Text("Released",
                                   style: new TextStyle(color: sharedModalValue == 0 ? Colors.black : Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w700),
                                   ),
                                 ),
                                 ),
                                 1: new Padding(
                                   padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                                   child: new Container(
                                   child:  new Text("Unreleased",
                                   style: new TextStyle(color: sharedModalValue == 1 ? Colors.black : Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w700),
                                   ),
                                 ),
                                 ),
                               },
                               groupValue: sharedModalValue,
                               onValueChanged: (value) {
                                 modalSetState(() {
                                 sharedModalValue = value;
                                 });
                             }),
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
                             new InkWell(
                               onTap: () {},
                             child: new Container(
                               height: MediaQuery.of(context).size.height*0.05,
                               width: MediaQuery.of(context).size.width*0.49,
                               decoration: new BoxDecoration(
                                 color: Colors.grey[900],
                                 border: new Border.all(
                                   width: 1.0,
                                   color: Colors.yellowAccent.withOpacity(0.5),
                                 ),
                                 borderRadius: new BorderRadius.circular(10.0),
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
                             new InkWell(
                               onTap: () {},
                             child: new Container(
                               height: MediaQuery.of(context).size.height*0.05,
                               width: MediaQuery.of(context).size.width*0.49,
                               decoration: new BoxDecoration(
                                 color: Colors.grey[900],
                                 border: new Border.all(
                                   width: 1.0,
                                   color: Colors.yellowAccent.withOpacity(0.5),
                                 ),
                                 borderRadius: new BorderRadius.circular(10.0),
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
                                 cursorColor: Colors.yellowAccent,
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
                                     selectedValue = value;
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
                               ],
                               ),
                               ),
                               new InkWell(
                                 onTap: (){},
                                 child: new Container(
                                   height: MediaQuery.of(context).size.height*0.12,
                                   width: MediaQuery.of(context).size.width,
                                   color: Colors.yellowAccent.withOpacity(0.3),
                                   child: new Center(
                                     child: new Text('UPLOAD',
                                     style: new TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                                     ),
                                   ),
                                 ),
                               ),
                             ],
                            ),
                         );
                        },
                      );
                    });
                },
                ),
            ),
          ];
        }, 
        body: new SingleChildScrollView(
          child: new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.02,
                  width: MediaQuery.of(context).size.width,
                ),
                new CupertinoSlidingSegmentedControl(
                  backgroundColor: Colors.grey[900],
                  children: <int, Widget>{
                    0: new Padding(
                      padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                    child: new Container(
                      child: new Text("Released",
                      style: new TextStyle(color: sharedValue == 0 ? Colors.white : Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w700),
                      ),
                    ),
                    ),
                    1: new Padding(
                      padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                      child: new Container(
                      child:  new Text("Unreleased",
                      style: new TextStyle(color: sharedValue == 1 ? Colors.white : Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w700),
                      ),
                    ),
                    ),
                  },
                  groupValue: sharedValue,
                  onValueChanged: (value) {
                    setState(() {
                    sharedValue = value;
                    });
                }),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.04,
                  width: MediaQuery.of(context).size.width,
                ),
                sharedValue == 0
                ? new Container(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    new Container(
                      child: new Text('Others users can listen to these tracks.',
                      style: new TextStyle(color: Colors.grey[700], fontSize: 13.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    //Divider
                    new Container(
                      height: MediaQuery.of(context).size.height*0.02,
                      width: MediaQuery.of(context).size.width,
                    ),
                    new IconButton(
                      onPressed: () {},
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      icon: new Icon(Icons.lock_open_rounded, color: Colors.grey, size: 50.0),
                    ),
                    //Divider
                    new Container(
                      height: MediaQuery.of(context).size.height*0.02,
                      width: MediaQuery.of(context).size.width,
                    ),
                    new Container(
                      width: MediaQuery.of(context).size.width,
                      child: new ListView.builder(
                        shrinkWrap: true,
                        physics: new NeverScrollableScrollPhysics(),
                        controller: _releasedTracks,
                        scrollDirection: Axis.vertical,
                        itemCount: 8,
                        itemBuilder: (BuildContext context, int item) {
                        return new Container(
                          height: MediaQuery.of(context).size.height*0.10,
                          width: MediaQuery.of(context).size.width,
                          child: new ListTile(
                            leading: new Container(
                            height: MediaQuery.of(context).size.height*0.05,
                            width: MediaQuery.of(context).size.height*0.05,
                            child: new ClipOval(child: new Image.asset('lib/assets/background.jpg', fit: BoxFit.cover),
                          )),
                          title: new Text('Aldos',
                          style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          subtitle: new Text('Something about you',
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
                                    child: new Text('Move to unreleased'),
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
                                        style: new TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                                        ),
                                        content: new Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                          child: new Text("Be careful, this track will not stored on Reverbs.",
                                          style: new TextStyle(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.normal),
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
                    ),
                  ],
                  ),
                )
                : new Container(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    new Container(
                      child: new Text('Others users can not listen to these tracks.',
                      style: new TextStyle(color: Colors.grey[700], fontSize: 13.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    //Divider
                    new Container(
                      height: MediaQuery.of(context).size.height*0.02,
                      width: MediaQuery.of(context).size.width,
                    ),
                    new IconButton(
                      onPressed: () {},
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      icon: new Icon(Icons.lock_rounded, color: Colors.grey, size: 50.0),
                    ),
                    //Divider
                    new Container(
                      height: MediaQuery.of(context).size.height*0.02,
                      width: MediaQuery.of(context).size.width,
                    ),
                    new Container(
                      width: MediaQuery.of(context).size.width,
                      child: new ListView.builder(
                        shrinkWrap: true,
                        physics: new NeverScrollableScrollPhysics(),
                        controller: _unReleasedTracks,
                        scrollDirection: Axis.vertical,
                        itemCount: 8,
                        itemBuilder: (BuildContext context, int item) {
                        return new Container(
                          height: MediaQuery.of(context).size.height*0.10,
                          width: MediaQuery.of(context).size.width,
                          child: new ListTile(
                            leading: new Container(
                            height: MediaQuery.of(context).size.height*0.05,
                            width: MediaQuery.of(context).size.height*0.05,
                            child: new ClipOval(child: new Image.asset('lib/assets/background.jpg', fit: BoxFit.cover),
                          )),
                          title: new Text('Aldos',
                          style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          subtitle: new Text('Right for you',
                          style: new TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.normal),
                          ),
                          trailing: new IconButton(
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: new Icon(Icons.more_horiz_rounded, color: Colors.white, size: 20.0,), 
                            onPressed: () {

                            },
                            ),
                          ),
                        );
                        }),
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
    
  }