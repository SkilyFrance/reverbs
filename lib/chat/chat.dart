import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {

  final String heroTag;

  ChatPage({Key key, this.heroTag}) : super(key: key);


  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {

  ScrollController _messagesListViewBuilder = new ScrollController(initialScrollOffset: 0.0);
  TextEditingController _messageTextController = new TextEditingController();
  FocusNode _textFieldFocusNode = new FocusNode();

  //List booleans
  bool _textFieldDeploy = false;
  bool _textFieldOnChanged = false;

  @override
  void initState() {
    _messagesListViewBuilder = new ScrollController(initialScrollOffset: 0);
    _textFieldFocusNode = new FocusNode();
    _messageTextController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: new CupertinoNavigationBar(
        heroTag: widget.heroTag,
        transitionBetweenRoutes: false,
        backgroundColor: Colors.black.withOpacity(0.5),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios_rounded, color: Colors.grey, size: 25.0),
          onPressed: () {Navigator.pop(context);}),
          middle: new Text('Festival',
          style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
          ),
            ),
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
      child: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: new Stack(
          children: [
            new Positioned(
              top: 0.0,
              right: 0.0,
              left: 0.0,
              bottom: 0.0,
              child: new Container(
                color: Colors.transparent,
                child: new ListView.builder(
                  padding: EdgeInsets.only(top: 50.0, bottom: 110.0),
                  shrinkWrap: true,
                  controller: _messagesListViewBuilder,
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int item) {
                    return new Container(
                    child: new ListTile(
                        contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 0.0),
                        leading: new Container(
                        height: MediaQuery.of(context).size.height*0.03,
                        width: MediaQuery.of(context).size.height*0.03,
                        child: new ClipOval(child: new Image.asset('lib/assets/userPhoto.png', fit: BoxFit.cover),
                      )),
                      subtitle: new Container(
                        decoration: new BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: new BorderRadius.circular(20.0)
                        ),
                      child: new Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 15.0, 10.0, 15.0),
                      child: new Text('Of course, we do it again, when you want ! But may be we can do it',
                      textAlign: TextAlign.left,
                      style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w500),
                      ))),
                    ),
                    );
                  },
                ),
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
                      width: MediaQuery.of(context).size.width,
                       constraints: new BoxConstraints(
                         minHeight: MediaQuery.of(context).size.height*0.08,
                         //maxHeight: MediaQuery.of(context).size.height*0.08,
                       ),
                      color: Colors.black.withOpacity(0.9),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        //Divider
                        new Container(
                          height: MediaQuery.of(context).size.height*0.01,
                          width: MediaQuery.of(context).size.width,
                        ),
                        new Padding(
                          padding: EdgeInsets.all(10.0),
                        child: new Container(
                          width: MediaQuery.of(context).size.width,
                          constraints: new BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height*0.05,
                            //maxHeight: MediaQuery.of(context).size.height*0.11,
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new Container(
                                width: _textFieldOnChanged == false ? MediaQuery.of(context).size.width*0.60 : MediaQuery.of(context).size.width*0.80, 
                                constraints: new BoxConstraints(
                                  minHeight: MediaQuery.of(context).size.height*0.05,
                                  maxHeight: MediaQuery.of(context).size.height*0.11,
                                ),
                                child: new CupertinoTextField(
                                  placeholder: 'Aa',
                                  placeholderStyle: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                                  keyboardAppearance: Brightness.dark,
                                  suffix: new Padding(
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: new Text('SENT',
                                  style: new TextStyle(color: _textFieldOnChanged == true ? Colors.deepPurpleAccent : Colors.grey, fontSize: 12.0, fontWeight: FontWeight.bold),
                                  )),
                                  controller: _messageTextController,
                                  autocorrect: true,
                                  scrollPhysics: new ScrollPhysics(),
                                  onChanged: (value) {
                                    if(_messageTextController.text.length > 0 && _messageTextController.text.length == 1) {
                                      setState(() {
                                        _textFieldOnChanged = true;
                                      });
                                    } else if (_messageTextController.text.length == 0) {
                                      setState(() {
                                        _textFieldOnChanged = false;
                                      });
                                    }
                                  },
                                  onTap: () {
                                  },
                                focusNode: _textFieldFocusNode,
                                expands: true,
                                cursorColor: Colors.white,
                                padding: EdgeInsets.all(15.0),
                                minLines: null,
                                maxLines: null,
                                keyboardType: TextInputType.text,
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(30.0),
                                  color: Colors.grey[900],
                                ),
                                style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w500),
                                ),
                              ),
                              _textFieldOnChanged == false ?
                              new Container(
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    new IconButton(
                                      icon: new Icon(Icons.file_copy_rounded, color: Colors.deepPurpleAccent, size: 25.0), 
                                      onPressed: () {},
                                      ),
                                    new IconButton(
                                      icon: new Icon(Icons.music_note_outlined, color: Colors.deepPurpleAccent, size: 25.0), 
                                      onPressed: () {},
                                      ),
                                    new IconButton(
                                      icon: new Icon(Icons.image_rounded, color: Colors.deepPurpleAccent, size: 25.0), 
                                      onPressed: () {},
                                      ),
                                  ],
                                ),
                              )
                              : new Container(),
                            ],
                          ),
                         )),
                      ],
                     ),
                    ),
                    _textFieldFocusNode.hasFocus == true
                    ? new Container()
                    : new Container(
                      height: MediaQuery.of(context).size.height*0.03,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black.withOpacity(0.9),
                    ),
                  ],
                  ),
                ),
             /*child: new ListTile(
                contentPadding: EdgeInsets.fromLTRB(15.0, 20.0, 10.0, 0.0),
                leading: new Container(
                height: MediaQuery.of(context).size.height*0.03,
                width: MediaQuery.of(context).size.height*0.03,
                child: new ClipOval(child: new Image.asset('lib/assets/userPhoto.png', fit: BoxFit.cover),
              )),
              subtitle: new Container(
                decoration: new BoxDecoration(
                  color: Colors.grey[900].withOpacity(0.6),
                  borderRadius: new BorderRadius.circular(20.0)
                ),
              child: new Padding(
                padding: EdgeInsets.all(15.0),
              child: new Text('Of course, we do it again, when you want !',
              textAlign: TextAlign.left,
              style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
              ))),
              trailing: new Text('12:00',
              style: new TextStyle(color: Colors.grey, fontSize: 10.0, fontWeight: FontWeight.normal),
            ),
             ),*/
            
           /* return new Container(
              height: MediaQuery.of(context).size.height*0.10,
              width: MediaQuery.of(context).size.width,
             child: new ListTile(
                contentPadding: EdgeInsets.fromLTRB(15.0, 20.0, 10.0, 0.0),
                leading: new Container(
                height: MediaQuery.of(context).size.height*0.03,
                width: MediaQuery.of(context).size.height*0.03,
                child: new ClipOval(child: new Image.asset('lib/assets/userPhoto.png', fit: BoxFit.cover),
              )),
              subtitle: new Container(
                decoration: new BoxDecoration(
                  color: Colors.grey[900].withOpacity(0.6),
                  borderRadius: new BorderRadius.circular(20.0)
                ),
              child: new Padding(
                padding: EdgeInsets.all(15.0),
              child: new Text('Of course, we do it again, when you want !',
              textAlign: TextAlign.left,
              style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
              ))),
              trailing: new Text('12:00',
              style: new TextStyle(color: Colors.grey, fontSize: 10.0, fontWeight: FontWeight.normal),
            ),
             ),
            );*/
          ],
        ),
        ),
      ),
    );
  }
}