import 'package:SONOZ/navigation.dart';
import 'package:flutter/material.dart';



class OnboardingPage extends StatefulWidget {


  String currentUser;
  String currentUserUsername;

  OnboardingPage({
    Key key,
    this.currentUser,
    this.currentUserUsername,
    }) : super(key: key);




  @override
  OnboardingPageState createState() => OnboardingPageState();
}


class OnboardingPageState extends State<OnboardingPage> {

  PageController _onboardingPageViewController = new PageController(viewportFraction: 1, initialPage: 0);

  bool _firstPage = true;
  bool _secondPage = false;
  bool _thirdPage = false;
  bool _fourthPage = false;

  @override
  void initState() {
    _onboardingPageViewController.addListener(() {
      if(_onboardingPageViewController.page == 0) {
        setState(() {
          _firstPage = true;
          _secondPage = false;
          _thirdPage = false;
          _fourthPage = false;
        });
      } else if(_onboardingPageViewController.page == 1) {
        setState(() {
          _firstPage = false;
          _secondPage = true;
          _thirdPage = false;
          _fourthPage = false;
        });
      } else if(_onboardingPageViewController.page == 2) {
        setState(() {
          _firstPage = false;
          _secondPage = false;
          _thirdPage = true;
          _fourthPage = false;
        });
      } else if(_onboardingPageViewController.page == 3) {
        setState(() {
          _firstPage = false;
          _secondPage = false;
          _thirdPage = false;
          _fourthPage = true;
        });
      }
     });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: new SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              new Container(
                height: MediaQuery.of(context).size.height*0.87,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              child: new PageView(
                controller: _onboardingPageViewController,
                physics: new ScrollPhysics(),
                children: [
                  //1stContainer
                  new Container(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      //Divider
                      new Container(
                        height: MediaQuery.of(context).size.height*0.15,
                        width: MediaQuery.of(context).size.width,
                      ),
                      new Container(
                        width: MediaQuery.of(context).size.width,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Divider
                            new Container(
                              height: MediaQuery.of(context).size.height*0.02,
                              width: MediaQuery.of(context).size.width*0.05,
                            ),
                            new Text('Access to collaborative',
                            style: new TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
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
                        width: MediaQuery.of(context).size.width,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Divider
                            new Container(
                              height: MediaQuery.of(context).size.height*0.02,
                              width: MediaQuery.of(context).size.width*0.05,
                            ),
                            new Text('electronic music',
                            style: new TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
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
                        width: MediaQuery.of(context).size.width,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Divider
                            new Container(
                              height: MediaQuery.of(context).size.height*0.02,
                              width: MediaQuery.of(context).size.width*0.05,
                            ),
                            new Text('projects.',
                            style: new TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      //Divider
                      new Container(
                        height: MediaQuery.of(context).size.height*0.03,
                        width: MediaQuery.of(context).size.width,
                      ),
                      new Container(
                        width: MediaQuery.of(context).size.width,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Divider
                            new Container(
                              height: MediaQuery.of(context).size.height*0.02,
                              width: MediaQuery.of(context).size.width*0.05,
                            ),
                            new Text('Organized by electronic',
                            style: new TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),
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
                        width: MediaQuery.of(context).size.width,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Divider
                            new Container(
                              height: MediaQuery.of(context).size.height*0.02,
                              width: MediaQuery.of(context).size.width*0.05,
                            ),
                            new Text('music style.',
                            style: new TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      //Divider
                      new Container(
                        height: MediaQuery.of(context).size.height*0.04,
                        width: MediaQuery.of(context).size.width,
                      ),
                      new Container(
                        height: MediaQuery.of(context).size.height*0.45,
                        width: MediaQuery.of(context).size.width*0.95,
                        color: Colors.transparent,
                        child: new Stack(
                          children: [
                            new Positioned(
                              top: 0.0,
                              left: 0.0,
                              right: 0.0,
                              bottom: 0.0,
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  //Divider
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.06,
                                    width: MediaQuery.of(context).size.width*0.95,
                                  ),
                                  //Divider
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.39,
                                    width: MediaQuery.of(context).size.width*0.95,
                                    decoration: new BoxDecoration(
                                      color: Colors.grey[900].withOpacity(0.5),
                                      borderRadius: new BorderRadius.circular(10.0),
                                    ),
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        new Container(
                                          height: MediaQuery.of(context).size.height*0.05,
                                          width: MediaQuery.of(context).size.width*0.95,
                                          color: Colors.transparent,
                                        ),
                                        new Container(
                                          width: MediaQuery.of(context).size.width*0.95,
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              new Container(
                                                height: MediaQuery.of(context).size.height*0.15,
                                                width: MediaQuery.of(context).size.width*0.40,
                                                decoration: new BoxDecoration(
                                                  color: Colors.grey[900],
                                                  borderRadius: new BorderRadius.circular(10.0),
                                                ),
                                                child: new Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    //Divider
                                                    new Container(
                                                      height: MediaQuery.of(context).size.height*0.02,
                                                      width: MediaQuery.of(context).size.width*0.02,
                                                      color: Colors.transparent,
                                                    ),
                                                    new Text('Contibutors',
                                                    style: new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.bold),
                                                    ),
                                                    //Divider
                                                    new Container(
                                                      height: MediaQuery.of(context).size.height*0.03,
                                                      width: MediaQuery.of(context).size.width*0.02,
                                                      color: Colors.transparent,
                                                    ),
                                                    new Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        new Container(
                                                          height: MediaQuery.of(context).size.height*0.04,
                                                          width: MediaQuery.of(context).size.height*0.04,
                                                          decoration: new BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.grey[900],
                                                          ),
                                                          child: new ClipOval(
                                                            child: new Image.asset('lib/assets/userPhoto.png',
                                                            fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        new Container(
                                                          height: MediaQuery.of(context).size.height*0.04,
                                                          width: MediaQuery.of(context).size.height*0.04,
                                                          decoration: new BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.grey[900],
                                                          ),
                                                          child: new ClipOval(
                                                            child: new Image.asset('lib/assets/user2.jpg',
                                                            fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              new Container(
                                                height: MediaQuery.of(context).size.height*0.15,
                                                width: MediaQuery.of(context).size.width*0.40,
                                                decoration: new BoxDecoration(
                                                  color: Colors.grey[900],
                                                  borderRadius: new BorderRadius.circular(10.0),
                                                ),
                                                child: new Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    //Divider
                                                    new Container(
                                                      height: MediaQuery.of(context).size.height*0.02,
                                                      width: MediaQuery.of(context).size.width*0.02,
                                                      color: Colors.transparent,
                                                    ),
                                                    new Text('Demo',
                                                    style: new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.bold),
                                                    ),
                                                    //Divider
                                                    new Container(
                                                      height: MediaQuery.of(context).size.height*0.03,
                                                      width: MediaQuery.of(context).size.width*0.02,
                                                      color: Colors.transparent,
                                                    ),
                                                    new Container(
                                                      height: MediaQuery.of(context).size.height*0.05,
                                                      width: MediaQuery.of(context).size.height*0.05,
                                                      decoration: new BoxDecoration(
                                                      gradient: new LinearGradient(
                                                        begin: Alignment.centerLeft,
                                                        end: Alignment.centerRight,
                                                        colors: [Colors.lightBlue, Colors.deepPurpleAccent]
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: new Center(
                                                        child: new Icon(Icons.play_arrow_rounded,
                                                        color: Colors.white,
                                                        size: 30.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        //Divider
                                        new Container(
                                          height: MediaQuery.of(context).size.height*0.02,
                                          width: MediaQuery.of(context).size.width*0.95,
                                          color: Colors.transparent,
                                        ),
                                        new Container(
                                          height: MediaQuery.of(context).size.height*0.15,
                                          width: MediaQuery.of(context).size.width*0.85,
                                          decoration: new BoxDecoration(
                                            color: Colors.grey[900],
                                            borderRadius: new BorderRadius.circular(10.0),
                                          ),
                                          child: new Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              //Divider
                                              new Container(
                                                height: MediaQuery.of(context).size.height*0.02,
                                                width: MediaQuery.of(context).size.width*0.02,
                                                color: Colors.transparent,
                                              ),
                                              new Text('Project context',
                                              style: new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.bold),
                                              ),
                                              //Divider
                                              new Container(
                                                height: MediaQuery.of(context).size.height*0.02,
                                                width: MediaQuery.of(context).size.width*0.02,
                                                color: Colors.transparent,
                                              ),
                                             new Padding(
                                                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                                              child: new Text('Hey guys, We are two producers in trap, and would like to create a record between these two styles. We already have created a part of the track but need help on Future-House part 🙌.',
                                              textAlign: TextAlign.justify,
                                              style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w500),
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
                                    height: MediaQuery.of(context).size.height*0.01,
                                    width: MediaQuery.of(context).size.width*0.90,
                                  ),
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.08,
                                    width: MediaQuery.of(context).size.height*0.08,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[900],
                                    ),
                                    child: new ClipOval(
                                      child: new Image.asset('lib/assets/userPhoto.png',
                                      fit: BoxFit.cover,
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
                  //2nd container
                  new Container(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      //Divider
                      new Container(
                        height: MediaQuery.of(context).size.height*0.15,
                        width: MediaQuery.of(context).size.width,
                      ),
                      new Container(
                        width: MediaQuery.of(context).size.width,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Divider
                            new Container(
                              height: MediaQuery.of(context).size.height*0.02,
                              width: MediaQuery.of(context).size.width*0.05,
                            ),
                            new Text('Discover new electronic',
                            style: new TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
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
                        width: MediaQuery.of(context).size.width,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Divider
                            new Container(
                              height: MediaQuery.of(context).size.height*0.02,
                              width: MediaQuery.of(context).size.width*0.05,
                            ),
                            new Text('music producers by',
                            style: new TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
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
                        width: MediaQuery.of(context).size.width,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Divider
                            new Container(
                              height: MediaQuery.of(context).size.height*0.02,
                              width: MediaQuery.of(context).size.width*0.05,
                            ),
                            new Text('their musics.',
                            style: new TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      //Divider
                      new Container(
                        height: MediaQuery.of(context).size.height*0.03,
                        width: MediaQuery.of(context).size.width,
                      ),
                      new Container(
                        width: MediaQuery.of(context).size.width,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Divider
                            new Container(
                              height: MediaQuery.of(context).size.height*0.02,
                              width: MediaQuery.of(context).size.width*0.05,
                            ),
                            new Text('Organized by electronic',
                            style: new TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),
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
                        width: MediaQuery.of(context).size.width,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Divider
                            new Container(
                              height: MediaQuery.of(context).size.height*0.02,
                              width: MediaQuery.of(context).size.width*0.05,
                            ),
                            new Text('music style.',
                            style: new TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      new Container(
                        height: MediaQuery.of(context).size.height*0.07,
                        width: MediaQuery.of(context).size.width,
                      ),
                      new Container(
                        height: MediaQuery.of(context).size.height*0.37,
                        width: MediaQuery.of(context).size.width*0.90,
                        color: Colors.transparent,
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            new Container(
                              height: MediaQuery.of(context).size.height*0.25,
                              width: MediaQuery.of(context).size.height*0.25,
                              decoration: new BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              child: new Stack(
                                children: [
                                  new Positioned(
                                    top: 0.0,
                                    left: 0.0,
                                    right: 0.0,
                                    bottom: 0.0,
                                    child: new ClipRRect(
                                      borderRadius: new BorderRadius.circular(10.0),
                                      child: new Image.asset('lib/assets/background.jpg',
                                      fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  new Positioned(
                                    top: 0.0,
                                    left: 0.0,
                                    right: 0.0,
                                    bottom: 0.0,
                                    child: new Center(
                                      child: new Container(
                                        height: MediaQuery.of(context).size.height*0.07,
                                        width: MediaQuery.of(context).size.height*0.07,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.3),
                                        ),
                                        child: new Center(
                                          child: new Icon(Icons.play_arrow_rounded, color: Colors.white, size: 35.0),
                                        ),
                                      ),
                                    ),
                                    ),
                                ],
                              ),
                            ),
                            new Text('Aldos',
                            style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
                            ),
                            new Text('Something about you',
                            style: new TextStyle(color: Colors.grey[600], fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      ],
                    ),
                  ),
                  //4th Container
                  new Container(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      //Divider
                      new Container(
                        height: MediaQuery.of(context).size.height*0.15,
                        width: MediaQuery.of(context).size.width,
                      ),
                      new Container(
                        width: MediaQuery.of(context).size.width,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Divider
                            new Container(
                              height: MediaQuery.of(context).size.height*0.02,
                              width: MediaQuery.of(context).size.width*0.05,
                            ),
                            new Text('Take advantage of a',
                            style: new TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
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
                        width: MediaQuery.of(context).size.width,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Divider
                            new Container(
                              height: MediaQuery.of(context).size.height*0.02,
                              width: MediaQuery.of(context).size.width*0.05,
                            ),
                            new Text('collaborative messaging',
                            style: new TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
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
                        width: MediaQuery.of(context).size.width,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Divider
                            new Container(
                              height: MediaQuery.of(context).size.height*0.02,
                              width: MediaQuery.of(context).size.width*0.05,
                            ),
                            new Text('tool.',
                            style: new TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      //Divider
                      new Container(
                        height: MediaQuery.of(context).size.height*0.03,
                        width: MediaQuery.of(context).size.width,
                      ),
                      new Container(
                        width: MediaQuery.of(context).size.width,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Divider
                            new Container(
                              height: MediaQuery.of(context).size.height*0.02,
                              width: MediaQuery.of(context).size.width*0.05,
                            ),
                            new Text('Organized by projects',
                            style: new TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      //Divider
                      new Container(
                        height: MediaQuery.of(context).size.height*0.10,
                        width: MediaQuery.of(context).size.width,
                      ),
                      new Container(
                        height: MediaQuery.of(context).size.height*0.40,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            new Container(
                              child: new ListTile(
                                leading: new Container(
                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.height*0.05,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: new ClipOval(
                                  child: new Image.asset('lib/assets/userPhoto.png',
                                  fit: BoxFit.cover,
                                  ),
                                  ),
                                ),
                                subtitle: new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    new Container(
                                      child: new Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          new Text('Aldos',
                                          style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    new Padding(
                                      padding: EdgeInsets.only(top: 5.0,bottom: 10.0),
                                    child: new Container(
                                      child: new Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          new Text('Hey Alice, just below you will find the last version. 🔥',
                                          style: new TextStyle(color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            new Container(
                              child: new ListTile(
                                leading: new Container(
                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.height*0.05,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: new ClipOval(
                                  child: new Image.asset('lib/assets/user2.jpg',
                                  fit: BoxFit.cover,
                                  ),
                                  ),
                                ),
                                subtitle: new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    new Container(
                                      child: new Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          new Text('Alice romera',
                                          style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    new Padding(
                                      padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                                    child: new Container(
                                      child: new Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          new Text("Can't wait to play it on festival, come with us 🥶",
                                          style: new TextStyle(color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            new Container(
                              height: MediaQuery.of(context).size.height*0.06,
                              width: MediaQuery.of(context).size.width*0.80,
                              decoration: new BoxDecoration(
                                color: Colors.grey[900].withOpacity(0.8),
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  new Padding(
                                    padding: EdgeInsets.only(left: 30.0),
                                    child: new Text('Your message',
                                    style: new TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.bold),
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
                  //5th Container
                  new Container(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      //Divider
                      new Container(
                        height: MediaQuery.of(context).size.height*0.15,
                        width: MediaQuery.of(context).size.width,
                      ),
                      new Container(
                        width: MediaQuery.of(context).size.width,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Divider
                            new Container(
                              height: MediaQuery.of(context).size.height*0.02,
                              width: MediaQuery.of(context).size.width*0.05,
                            ),
                            new Text('Enjoy a secure storage',
                            style: new TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
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
                        width: MediaQuery.of(context).size.width,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Divider
                            new Container(
                              height: MediaQuery.of(context).size.height*0.02,
                              width: MediaQuery.of(context).size.width*0.05,
                            ),
                            new Text('of your tracks.',
                            style: new TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      //Divider
                      new Container(
                        height: MediaQuery.of(context).size.height*0.03,
                        width: MediaQuery.of(context).size.width,
                      ),
                      new Container(
                        width: MediaQuery.of(context).size.width,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Divider
                            new Container(
                              height: MediaQuery.of(context).size.height*0.02,
                              width: MediaQuery.of(context).size.width*0.05,
                            ),
                            new Text('You fully manage',
                            style: new TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),
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
                        width: MediaQuery.of(context).size.width,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Divider
                            new Container(
                              height: MediaQuery.of(context).size.height*0.01,
                              width: MediaQuery.of(context).size.width*0.05,
                            ),
                            new Text('the access.',
                            style: new TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      //Divider
                      new Container(
                        height: MediaQuery.of(context).size.height*0.07,
                        width: MediaQuery.of(context).size.width,
                      ),
                      new Container(
                        height: MediaQuery.of(context).size.height*0.30,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            new Container(
                              height: MediaQuery.of(context).size.height*0.30,
                              width: MediaQuery.of(context).size.width*0.40,
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  new Icon(Icons.lock_open_rounded, color: Colors.grey, size: 50.0),
                                  new Text('Released',
                                  style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            new Container(
                              height: MediaQuery.of(context).size.height*0.30,
                              width: MediaQuery.of(context).size.width*0.40,
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  new Icon(Icons.lock_rounded, color: Colors.yellowAccent, size: 50.0),
                                  new Text('Unreleased',
                                  style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
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
              new Container(
                height: MediaQuery.of(context).size.height*0.02,
                width: MediaQuery.of(context).size.width*0.80,
              ),
              _fourthPage == false ?
              new Container(
                width: MediaQuery.of(context).size.width*0.70,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new Container(
                      height: 10.0,
                      width: 10.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: _firstPage == true ? Colors.white : Colors.grey[800],
                      ),
                    ),
                    new Container(
                      height: 10.0,
                      width: 10.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: _secondPage == true ? Colors.white : Colors.grey[800],
                      ),
                    ),
                    new Container(
                      height: 10.0,
                      width: 10.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: _thirdPage == true ? Colors.white : Colors.grey[800],
                      ),
                    ),
                    new Container(
                      height: 10.0,
                      width: 10.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: _fourthPage == true ? Colors.white : Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              )
              : new InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
                    new NavigationPage(
                      currentUser: widget.currentUser,
                      currentUserUsername: widget.currentUserUsername,
                    )),
                    (route) => false);
                },
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: new Text('START',
                style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}