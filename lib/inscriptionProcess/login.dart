import 'package:SONOZ/inscriptionProcess/landingPage.dart';
import 'package:SONOZ/inscriptionProcess/profileCreation.dart';
import 'package:SONOZ/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  //TextEditing Controller
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _firstNumberCodeController = new TextEditingController();
  TextEditingController _secondNumberCodeController = new TextEditingController();
  TextEditingController _thirdNumberCodeController = new TextEditingController();
  TextEditingController _fourthNumberCodeController = new TextEditingController();
  TextEditingController _fithNumberCodeController = new TextEditingController();
  TextEditingController _sixthNumberCodeController = new TextEditingController();

  bool passwordShowed = true;
  bool errorIsOccurred = false;
  String currentUserPassword;


    snackBarFunction(String text) {
    return new SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: new Duration(seconds: 3),
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
      content: new Text('Email or password wrong buddy',
      textAlign: TextAlign.center,
      style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
      ),                                                         
    backgroundColor: Colors.black);
    }

  @override
  Widget build(BuildContext context) {
    /////
    final _firstFieldFocus = new FocusNode();
    final _secondFieldFocus = new FocusNode();
    final _thirdFieldFocus = new FocusNode();
    final _fourthFieldFocus = new FocusNode();
    final _fithFieldFocus = new FocusNode();
    final _sixthFieldFocus = new FocusNode();
    /////
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
                          child: new Text('Reverbs',
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
                          child: new Center(
                            child: new Text('Connect with your email.',
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
                          child: new TextField(
                            onChanged: (value) {
                              _emailEditingController.value = new TextEditingValue(
                                text: value.toLowerCase(),
                                selection: _emailEditingController.selection
                                );
                            },
                            style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                            controller: _emailEditingController,
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.words,
                            minLines: 1,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            cursorColor: Colors.cyan,
                            decoration: new InputDecoration(
                            errorBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                              borderSide: new BorderSide(
                                color: Colors.yellowAccent,
                              ),
                            ),
                              hintText: 'example@gmail.com',
                              hintStyle: new TextStyle(color: Colors.grey[700], fontSize: 15.0, fontWeight: FontWeight.bold),
                              border: new OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        new Container(
                          height: MediaQuery.of(context).size.height*0.05,
                          child: new Center(
                            child: new Text('Enter your password.',
                            style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                       new Container(
                         height: MediaQuery.of(context).size.height*0.07,
                         width: MediaQuery.of(context).size.width,
                         child: new Row(
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           children: [
                             //1stNumber
                           new Container(
                             height: MediaQuery.of(context).size.height*0.07,
                             width: MediaQuery.of(context).size.width*0.12,
                             decoration: new BoxDecoration(
                               borderRadius: new BorderRadius.circular(10.0),
                               color: Colors.grey[900]
                             ),
                             child: new Center(
                               child: new TextField(
                                 enableInteractiveSelection: _firstFieldFocus.hasFocus ? true : false,
                                 focusNode: _firstFieldFocus,
                                 onChanged: (value) {
                                   if(value.isEmpty) {
                                     FocusScope.of(context).requestFocus(_firstFieldFocus);
                                   } else {
                                     _firstFieldFocus.unfocus();
                                     FocusScope.of(context).requestFocus(_secondFieldFocus);
                                   }
                                 },
                                 maxLength: 1,
                                 autofocus: true,
                                 obscureText: passwordShowed == false ? false : true,
                                 style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                 controller: _firstNumberCodeController,
                                 keyboardType: TextInputType.text,
                                 textCapitalization: TextCapitalization.words,
                                 minLines: 1,
                                 maxLines: 1,
                                 textAlign: TextAlign.center,
                                 cursorColor: Colors.transparent,
                                 cursorHeight: 0.0,
                                 decoration: new InputDecoration(
                                   counterText: '',
                                   hintText: '0',
                                   hintStyle: new TextStyle(color: Colors.grey[700], fontSize: 15.0, fontWeight: FontWeight.bold),
                                   border: new OutlineInputBorder(
                                     borderSide: BorderSide.none,
                                   ),
                                 ),
                               ),
                             ),
                           ),
                           //2ndContainer
                           new Container(
                             height: MediaQuery.of(context).size.height*0.07,
                             width: MediaQuery.of(context).size.width*0.12,
                             decoration: new BoxDecoration(
                               borderRadius: new BorderRadius.circular(10.0),
                               color: Colors.grey[900]
                             ),
                             child: new Center(
                               child: new TextField(
                                 onChanged: (value) {
                                   if(value.isEmpty) {
                                     _secondFieldFocus.unfocus();
                                     FocusScope.of(context).requestFocus(_firstFieldFocus);
                                   } else {
                                     _secondFieldFocus.unfocus();
                                     FocusScope.of(context).requestFocus(_thirdFieldFocus);
                                   }
                                 },
                                 autofocus: true,
                                 obscureText: passwordShowed == false ? false : true,
                                 enableInteractiveSelection: _secondFieldFocus.hasFocus ? true : false,
                                 focusNode: _secondFieldFocus,
                                 maxLength: 1,
                                 style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                 controller: _secondNumberCodeController,
                                 keyboardType: TextInputType.text,
                                 textCapitalization: TextCapitalization.words,
                                 minLines: 1,
                                 maxLines: 1,
                                 textAlign: TextAlign.center,
                                 cursorColor: Colors.transparent,
                                 cursorHeight: 0.0,
                                 decoration: new InputDecoration(
                                   counterText: '',
                                   hintText: '0',
                                   hintStyle: new TextStyle(color: Colors.grey[700], fontSize: 15.0, fontWeight: FontWeight.bold),
                                   border: new OutlineInputBorder(
                                     borderSide: BorderSide.none,
                                   ),
                                 ),
                               ),
                             ),
                           ),
                           //ThirdContainer
                           new Container(
                             height: MediaQuery.of(context).size.height*0.07,
                             width: MediaQuery.of(context).size.width*0.12,
                             decoration: new BoxDecoration(
                               borderRadius: new BorderRadius.circular(10.0),
                               color: Colors.grey[900]
                             ),
                             child: new Center(
                               child: new TextField(
                                 onChanged: (value) {
                                   if(value.isEmpty) {
                                     _thirdFieldFocus.unfocus();
                                     FocusScope.of(context).requestFocus(_secondFieldFocus);
                                   } else {
                                     _thirdFieldFocus.unfocus();
                                     FocusScope.of(context).requestFocus(_fourthFieldFocus);
                                   }
                                 },
                                 autofocus: true,
                                 obscureText: passwordShowed == false ? false : true,
                                 enableInteractiveSelection: _thirdFieldFocus.hasFocus ? true : false,
                                 focusNode: _thirdFieldFocus,
                                 maxLength: 1,
                                 style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                 controller: _thirdNumberCodeController,
                                 keyboardType: TextInputType.text,
                                 textCapitalization: TextCapitalization.words,
                                 minLines: 1,
                                 maxLines: 1,
                                 cursorHeight: 0.0,
                                 textAlign: TextAlign.center,
                                 cursorColor: Colors.transparent,
                                 decoration: new InputDecoration(
                                   counterText: '',
                                   hintText: '0',
                                   hintStyle: new TextStyle(color: Colors.grey[700], fontSize: 15.0, fontWeight: FontWeight.bold),
                                   border: new OutlineInputBorder(
                                     borderSide: BorderSide.none,
                                   ),
                                 ),
                               ),
                             ),
                           ),
                           //FourthContainer
                           new Container(
                             height: MediaQuery.of(context).size.height*0.07,
                             width: MediaQuery.of(context).size.width*0.12,
                             decoration: new BoxDecoration(
                               borderRadius: new BorderRadius.circular(10.0),
                               color: Colors.grey[900]
                             ),
                             child: new Center(
                               child: new TextField(
                                 onChanged: (value) {
                                   if(value.isEmpty) {
                                     _fourthFieldFocus.unfocus();
                                     FocusScope.of(context).requestFocus(_thirdFieldFocus);
                                   } else {
                                     _fourthFieldFocus.unfocus();
                                     FocusScope.of(context).requestFocus(_fithFieldFocus);
                                   }
                                 },
                                 autofocus: true,
                                 obscureText: passwordShowed == false ? false : true,
                                 enableInteractiveSelection: _fourthFieldFocus.hasFocus ? true : false,
                                 focusNode: _fourthFieldFocus,
                                 maxLength: 1,
                                 style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                 controller: _fourthNumberCodeController,
                                 keyboardType: TextInputType.text,
                                 textCapitalization: TextCapitalization.words,
                                 minLines: 1,
                                 maxLines: 1,
                                 textAlign: TextAlign.center,
                                 cursorHeight: 0.0,
                                 cursorColor: Colors.transparent,
                                 decoration: new InputDecoration(
                                   counterText: '',
                                   hintText: '0',
                                   hintStyle: new TextStyle(color: Colors.grey[700], fontSize: 15.0, fontWeight: FontWeight.bold),
                                   border: new OutlineInputBorder(
                                     borderSide: BorderSide.none,
                                   ),
                                 ),
                               ),
                             ),
                           ),
                           //FithContainer
                           new Container(
                             height: MediaQuery.of(context).size.height*0.07,
                             width: MediaQuery.of(context).size.width*0.12,
                             decoration: new BoxDecoration(
                               borderRadius: new BorderRadius.circular(10.0),
                               color: Colors.grey[900]
                             ),
                             child: new Center(
                               child: new TextField(
                                 onChanged: (value) {
                                   if(value.isEmpty) {
                                     _fithFieldFocus.unfocus();
                                     FocusScope.of(context).requestFocus(_fourthFieldFocus);
                                   } else {
                                     _fithFieldFocus.unfocus();
                                     FocusScope.of(context).requestFocus(_sixthFieldFocus);
                                   }
                                 },
                                 autofocus: true,
                                 obscureText: passwordShowed == false ? false : true,
                                 enableInteractiveSelection: _fithFieldFocus.hasFocus ? true : false,
                                 focusNode: _fithFieldFocus,
                                 maxLength: 1,
                                 style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                 controller: _fithNumberCodeController,
                                 keyboardType: TextInputType.text,
                                 textCapitalization: TextCapitalization.words,
                                 minLines: 1,
                                 maxLines: 1,
                                 textAlign: TextAlign.center,
                                 cursorHeight: 0.0,
                                 cursorColor: Colors.transparent,
                                 decoration: new InputDecoration(
                                   counterText: '',
                                   hintText: '0',
                                   hintStyle: new TextStyle(color: Colors.grey[700], fontSize: 15.0, fontWeight: FontWeight.bold),
                                   border: new OutlineInputBorder(
                                     borderSide: BorderSide.none,
                                   ),
                                 ),
                               ),
                             ),
                           ),
                           //SixthContainer
                           new Container(
                             height: MediaQuery.of(context).size.height*0.07,
                             width: MediaQuery.of(context).size.width*0.12,
                             decoration: new BoxDecoration(
                               borderRadius: new BorderRadius.circular(10.0),
                               color: Colors.grey[900]
                             ),
                             child: new Center(
                               child: new TextField(
                                 onChanged: (value) {
                                   if(value.isEmpty) {
                                     _sixthFieldFocus.unfocus();
                                     FocusScope.of(context).requestFocus(_fithFieldFocus);
                                   } else {
                                   setState(() {
                                     currentUserPassword = (_firstNumberCodeController.value.text.toString() + _secondNumberCodeController.value.text.toString() + _thirdNumberCodeController.value.text.toString()+ _fourthNumberCodeController.value.text.toString() + _fithNumberCodeController.value.text.toString() + _sixthNumberCodeController.value.text.toString());
                                   });
                                   }
                                 },
                                 autofocus: true,
                                 obscureText: passwordShowed == false ? false : true,
                                 enableInteractiveSelection: _sixthFieldFocus.hasFocus ? true : false,
                                 focusNode: _sixthFieldFocus,
                                 maxLength: 1,
                                 style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                 controller: _sixthNumberCodeController,
                                 keyboardType: TextInputType.text,
                                 textCapitalization: TextCapitalization.words,
                                 minLines: 1,
                                 maxLines: 1,
                                 textAlign: TextAlign.center,
                                 cursorHeight: 0.0,
                                 cursorColor: Colors.transparent,
                                 decoration: new InputDecoration(
                                   counterText: '',
                                   hintText: '0',
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
                         height: MediaQuery.of(context).size.height*0.05,
                         width: MediaQuery.of(context).size.width,
                         color: Colors.transparent,
                         child: new Center(
                           child: new IconButton(
                             color: Colors.white,
                             icon: passwordShowed == false ? new Icon(Icons.visibility) : new Icon(Icons.visibility_off),
                             onPressed: () {
                               setState(() {
                                 passwordShowed =! passwordShowed;
                               });
                             }),
                         ),
                       ),
                      ],
                    ),
                  ),
                 ],
               ),
             ),
            errorIsOccurred == true 
            ? new Container(
              height: MediaQuery.of(context).size.height*0.05,
              width: MediaQuery.of(context).size.width,
              child: new Center(
              child: new Text('Email or password wrong. Try again',
              style: new TextStyle(color: Colors.redAccent[700], fontSize: 15.0, fontWeight: FontWeight.bold),
              ))
            )
            : new Container(),
           new Container(
             height: MediaQuery.of(context).size.height*0.18,
             color: Colors.transparent,
             child: new Column(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 //START
                 new InkWell(
                   onTap: () {
                     if(_emailEditingController.value.text.length > 4  
                     && _firstNumberCodeController.value.text != null
                     && _secondNumberCodeController.value.text != null
                     && _thirdNumberCodeController.value.text != null
                     && _fourthNumberCodeController.value.text != null
                     && _fithNumberCodeController.value.text != null
                     && _sixthNumberCodeController.value.text != null) {
                       FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                          email: _emailEditingController.text, 
                          password: _firstNumberCodeController.value.text.toString()
                          +_secondNumberCodeController.value.text.toString()
                          +_thirdNumberCodeController.value.text.toString()
                          +_fourthNumberCodeController.value.text.toString()
                          +_fithNumberCodeController.value.text.toString()
                          +_sixthNumberCodeController.value.text.toString())
                        .then((authResult) {
                          FirebaseFirestore.instance
                            .collection('users')
                            .doc(authResult.user.uid)
                            .get()
                            .then((value) {
                              if(value.exists) {
                                  Navigator.pushAndRemoveUntil(context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
                                  new NavigationPage(
                                  currentUser: authResult.user.uid, 
                                  currentUserType: value.data()['iam'],
                                  currentUserUsername: value.data()['userName'],
                                  currentUserPhoto: value.data()['profilePhoto'])), 
                                  (route) => false);
                              } else {
                                //ValueNoExist
                                  Navigator.pushAndRemoveUntil(context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
                                  new ProfileCreationProcessPage(
                                  currentUser: authResult.user.uid, 
                                  currentUserEmail: authResult.user.email)), 
                                  (route) => false);
                              }
                            });
                        }).catchError((error){
                              print(error.code);
                              switch (error.code) {
                                case 'user-not-found': setState(() {errorIsOccurred = true;});
                                  break;
                                case 'error_wrong_password': setState(() {errorIsOccurred = true;});
                              }
                            
                            });
                       
                     } else {

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
                     child: new Text('START',
                     style: new TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                     ),
                   ),
                 ),
                 ),
                 new FlatButton(
                   splashColor: Colors.transparent,
                   hoverColor: Colors.transparent,
                   onPressed: () {
                    Navigator.pushAndRemoveUntil(
                    context, new PageRouteBuilder(pageBuilder: (_,__,___) => new LandingPage()),
                    (route) => false);
                   }, 
                   child: new Text("DON'T HAVE AN ACCOUNT",
                   style: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
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
}