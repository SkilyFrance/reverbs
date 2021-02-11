import 'package:SONOZ/inscriptionProcess/landingPage.dart';
import 'package:SONOZ/inscriptionProcess/login.dart';
import 'package:SONOZ/inscriptionProcess/profileCreation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {


  //Variables for register
  String currentUserEmail;
  String currentUserPassword;

  //TextEditing Controller
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _passwordEditingController = new TextEditingController();
  //Bool
  bool passwordShowed = true;
  bool mailIsValid = true; 


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
              color: Colors.transparent,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                          child: new Text('Create your',
                          style: new TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),
                          )),
                        ),
                        ],
                      ),
                  ),
                  //Divider
                  new Container(
                    height: MediaQuery.of(context).size.height*0.01,
                    width: MediaQuery.of(context).size.width,
                  ),
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
                          child: new Text('account.',
                          style: new TextStyle(color: Colors.grey, fontSize: 35.0, fontWeight: FontWeight.bold),
                          )),
                        ),
                        ],
                      ),
                  ),
                ],
              ),
            ),
           new Container(
             height: MediaQuery.of(context).size.height*0.08,
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
                            child: new Text('Enter your email.',
                            style: new TextStyle(color: Colors.grey[800], fontSize: 20.0, fontWeight: FontWeight.bold),
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
                            keyboardAppearance: Brightness.dark,
                            onChanged: (value) {
                              if(value.isEmpty) {
                                setState(() {
                                  mailIsValid = true;
                                });
                              }
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
                        mailIsValid == false 
                        ? new Container(
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.width,
                          child: new Center(
                          child: new Text('This email already exists.',
                          style: new TextStyle(color: Colors.redAccent[700], fontSize: 15.0, fontWeight: FontWeight.bold),
                          ))
                        )
                        : new Container(),
                        new Container(
                          height: MediaQuery.of(context).size.height*0.05,
                          child: new Center(
                            child: new Text('Enter a password.',
                            style: new TextStyle(color: Colors.grey[800], fontSize: 20.0, fontWeight: FontWeight.bold),
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
                            keyboardAppearance: Brightness.dark,
                            obscureText: passwordShowed,
                            style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                            controller: _passwordEditingController,
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
                              hintText: 'password',
                              hintStyle: new TextStyle(color: Colors.grey[700], fontSize: 15.0, fontWeight: FontWeight.bold),
                              border: new OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
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
           new Container(
             height: MediaQuery.of(context).size.height*0.25,
             color: Colors.transparent,
             child: new Column(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 //START
                 new InkWell(
                   onTap: () {
                     if(_emailEditingController.value.text.length > 4 && _passwordEditingController.value.text.length > 3) {
                      FirebaseAuth.instance
                        .createUserWithEmailAndPassword(email: _emailEditingController.value.text, password: _passwordEditingController.value.text).then((authResult) {
                          print('authResult = $authResult');
                        //Go to creationProcess
                        Navigator.pushAndRemoveUntil(
                        context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
                        new ProfileCreationProcessPage(currentUser: authResult.user.uid, currentUserEmail: _emailEditingController.value.text)),
                        (route) => false);
                        }).catchError((error) {
                          print(error.code);
                          if(error.code == 'email-already-in-use') {
                            setState(() {
                              mailIsValid = false;
                            });
                          }
                        });
                     } else {

                     }
                     },
                 child: new Container(
                   height: MediaQuery.of(context).size.height*0.08,
                   width: MediaQuery.of(context).size.width*0.8,
                   decoration: new BoxDecoration(
                     color: Colors.transparent,
                     border: new Border.all(
                       width: 2.0,
                       color: Colors.deepPurpleAccent,
                     ),
                     borderRadius: new BorderRadius.circular(10.0)
                   ),
                   child: new Center(
                     child: new Text('SIGN UP',
                     style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                     ),
                   ),
                 ),
                 ),
                 new FlatButton(
                   splashColor: Colors.transparent,
                   hoverColor: Colors.transparent,
                   onPressed: () {
                    Navigator.pushAndRemoveUntil(
                    context, new PageRouteBuilder(pageBuilder: (_,__,___) => new LoginPage()),
                    (route) => false);
                   }, 
                   child: new Text('I ALREADY HAVE AN ACCOUNT',
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