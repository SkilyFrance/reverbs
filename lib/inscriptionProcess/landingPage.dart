import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:SONOZ/inscriptionProcess/login.dart';
import 'package:SONOZ/inscriptionProcess/register.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class LandingPage extends StatefulWidget {
  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {




  PageController _inscriptionPageController = new PageController(initialPage: 0,viewportFraction: 1);

  int _numberOfControllerPage = 0;
  //TextEditingController for verification email
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _firstNumberCodeController = new TextEditingController();
  TextEditingController _secondNumberCodeController = new TextEditingController();
  TextEditingController _thirdNumberCodeController = new TextEditingController();
  TextEditingController _fourthNumberCodeController = new TextEditingController();
  TextEditingController _fithNumberCodeController = new TextEditingController();
  TextEditingController _sixthNumberCodeController = new TextEditingController();


  TextEditingController _userNameEditingController = new TextEditingController();

  
  // bool variables
  bool iamDJ = false;
  bool iamFan = false;
  bool passwordShowed = false;
  bool numberOkInPassword = false;
  int minNumber = 0;
  int maxNumber = 9;

  //ImagePicker variables
  File _image;
  File _music;
  final picker = ImagePicker();
  bool iosPhotoPermissionDenied = false;
  bool iosMediaPermissionDenied = false;


  


  switchMethodVerifyNumberInPassword(String textEditingController1, String textEditingController2, String textEditingController3, String textEditingController4, String textEditingController5, String textEditingController6) {
    if(textEditingController1 == '0' || textEditingController2 == '0' || textEditingController3 == '0' || textEditingController4 == '0' || textEditingController5 == '0' || textEditingController6 == '0') {
    setState(() {numberOkInPassword = true;});
    } else if(textEditingController1 == '1' || textEditingController2 == '1' || textEditingController3 == '1' || textEditingController4 == '1' || textEditingController5 == '1' || textEditingController6 == '1') {
    setState(() {numberOkInPassword = true;});
    } else if(textEditingController1 == '2' || textEditingController2 == '2' || textEditingController3 == '2' || textEditingController4 == '2' || textEditingController5 == '2' || textEditingController6 == '2') {
    setState(() {numberOkInPassword = true;});
    } else if(textEditingController1 == '3' || textEditingController2 == '3' || textEditingController3 == '3' || textEditingController4 == '3' || textEditingController5 == '3' || textEditingController6 == '3') {
    setState(() {numberOkInPassword = true;});
    } else if(textEditingController1 == '4' || textEditingController2 == '4' || textEditingController3 == '4' || textEditingController4 == '4' || textEditingController5 == '4' || textEditingController6 == '4') {
    setState(() {numberOkInPassword = true;});
    } else if(textEditingController1 == '5' || textEditingController2 == '5' || textEditingController3 == '5' || textEditingController4 == '5' || textEditingController5 == '5' || textEditingController6 == '5') {
    setState(() {numberOkInPassword = true;});
    } else if(textEditingController1 == '6' || textEditingController2 == '6' || textEditingController3 == '6' || textEditingController4 == '6' || textEditingController5 == '6' || textEditingController6 == '6') {
    setState(() {numberOkInPassword = true;});
    } else if(textEditingController1 == '7' || textEditingController2 == '7' || textEditingController3 == '7' || textEditingController4 == '7' || textEditingController5 == '7' || textEditingController6 == '7') {
    setState(() {numberOkInPassword = true;});
    } else if(textEditingController1 == '8' || textEditingController2 == '8' || textEditingController3 == '8' || textEditingController4 == '8' || textEditingController5 == '8' || textEditingController6 == '8') {
    setState(() {numberOkInPassword = true;});
    } else if(textEditingController1 == '9' || textEditingController2 == '9' || textEditingController3 == '9' || textEditingController4 == '9' || textEditingController5 == '9' || textEditingController6 == '9') {
      setState(() {numberOkInPassword = true;});
    } else {
      setState(() {numberOkInPassword = false;});
    }
  }
  
  //Firebase auth //
  String currentUserEmail;
  String currentUserPassword;
  FirebaseAuth _auth;
  User currentUser;
  bool emailVerified;

    checkUserEmail() async  {
    FirebaseAuth.instance.currentUser..reload();
    var user = FirebaseAuth.instance.currentUser;
    if(user.emailVerified) {
      print('VERIFIED');
      setState(() {
        emailVerified = user.emailVerified;
      });
    } else {
      print('NO VERIFIED');
    }

  }




  //
  bool mailIsValid;

  registerUser(String userEmail, String userPassword) async  {
    FirebaseAuth.instance
      .createUserWithEmailAndPassword
      (email: userEmail, 
      password: userPassword).then((authResult) {
        setState(() {
          currentUser = authResult.user;
          mailIsValid = true;
        });
      }).catchError((error) {
        print(error.code);
        if(error.code == 'email-already-in-use') {
          print('Mail already in user');
          setState(() {
            mailIsValid = false;
          });
        }
      });
  }


  
  
  /////////////////

  //Variables for code confirmations//
  Random random = new Random();
  String confirmationCodeReceived;
  String codeEnterByUser;
  int max = 9000;



  void codeGeneratorFunction() {
    var rn = new Random();
    confirmationCodeReceived = (1000 + rn.nextInt(9000 - 1000)).toString();
    print('confirmationCodeReceived = $confirmationCodeReceived');
}


Timer _timer;
int _start = 10;
bool musicIsUploading = false;
bool musicIsEmpty = false;

  //Pause animation //
  double uploadMusicOpacity = 0.0;


void _uploadMusicIndicator() {
  const oneSec = const Duration(seconds: 1);
  _timer = new Timer.periodic(
    oneSec,
    (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          musicIsUploading = false;
          musicIsEmpty = true;
          _start = 10;
        });
      } else {
        setState(() {
          musicIsUploading = true;
          _start--;
        });
      }
    },
  );
}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      
    final _firstFieldFocus = new FocusNode();
    final _secondFieldFocus = new FocusNode();
    final _thirdFieldFocus = new FocusNode();
    final _fourthFieldFocus = new FocusNode();
    final _fithFieldFocus = new FocusNode();
    final _sixthFieldFocus = new FocusNode();

    return new Scaffold(
      body: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
             height: MediaQuery.of(context).size.height*0.15,
             color: Colors.transparent,
           ),
           new Container(
             height: MediaQuery.of(context).size.height*0.32,
             color: Colors.transparent,
               child: new Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                  new Container(
                    height: MediaQuery.of(context).size.height*0.20,
                    color: Colors.transparent,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Text('Find & Propel',
                        style: new TextStyle(color: Colors.white, fontSize: 38.0, fontWeight: FontWeight.bold),
                        ),
                        new Text('new DJs.',
                        style: new TextStyle(color: Colors.grey, fontSize: 35.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.10,
                    color: Colors.transparent,
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
                 //BUTTON : SIGN UP
                 new InkWell(
                   onTap: () {
                    Navigator.pushAndRemoveUntil(
                    context, new PageRouteBuilder(pageBuilder: (_,__,___) => new RegisterPage()),
                    (route) => false);
                     },
                 child: new Container(
                   height: MediaQuery.of(context).size.height*0.08,
                   width: MediaQuery.of(context).size.width*0.8,
                   decoration: new BoxDecoration(
                     color: Colors.yellowAccent,
                     borderRadius: new BorderRadius.circular(10.0)
                   ),
                   child: new Center(
                     child: new Text('SIGN UP',
                     style: new TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                     ),
                   ),
                 ),
                 ),
                 //BUTTON : SIGN IN
                    new InkWell(
                      onTap: () {
                    Navigator.pushAndRemoveUntil(
                    context, new PageRouteBuilder(pageBuilder: (_,__,___) => new LoginPage()),
                    (route) => false);
                      },
                      child:  new Container(
                        height: MediaQuery.of(context).size.height*0.08,
                        width: MediaQuery.of(context).size.width*0.8,
                        decoration: new BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: new BorderRadius.circular(10.0)
                        ),
                        child: new Center(
                          child: new Text('SIGN IN',
                          style: new TextStyle(color: Colors.yellowAccent, fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ),
                  ],
                ),
                ),
               ],
             ),
           ),
      ),
    );
  }
}



