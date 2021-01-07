import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';

class PermissionDemandClass {

   iosDialogCamera(BuildContext context) {
    return showDialog(
      context: context, 
      builder: (_) => new CupertinoAlertDialog(
        content: new Text("Choose an image ?",
        style: new TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          new CupertinoDialogAction(
            onPressed: (){
              Navigator.pop(context);
            },
            child: new Text('No.',
            ),
            ),
            new CupertinoDialogAction(
              onPressed: (){
                openAppSettings();
              },
              child: new Text('Yes, thanks.',
              ),
              ),
        ],
      ),
    );
  }

   iosDialogFile(BuildContext context) {
    return showDialog(
      context: context, 
      builder: (_) => new CupertinoAlertDialog(
        content: new Text("Choose an audio ?",
        style: new TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          new CupertinoDialogAction(
            onPressed: (){
              Navigator.pop(context);
            },
            child: new Text('No.',
            ),
            ),
            new CupertinoDialogAction(
              onPressed: (){
                openAppSettings();
              },
              child: new Text('Yes, thanks.',
              ),
              ),
        ],
      ),
    );
  }


   iosDialogMicro(BuildContext context) {
    return showDialog(
      context: context, 
      builder: (_) => new CupertinoAlertDialog(
        content: new Text("Record Screen ?",
        style: new TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          new CupertinoDialogAction(
            onPressed: (){
              Navigator.pop(context);
            },
            child: new Text('No.',
            ),
            ),
            new CupertinoDialogAction(
              onPressed: (){
                openAppSettings();
              },
              child: new Text('Yes, thanks.',
              ),
              ),
        ],
      ),
    );
  }


  androidDialogCamera(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        content: new Text("Choose an image ?",
        style: new TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: new Text('No.'),
            ),
          new FlatButton(
            onPressed: (){
              openAppSettings();
            }, 
            child: new Text('Yes, thanks',
            ),
            ),
        ],
      ),
      );
  }
  androidDialogFile(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        content: new Text("Choose an audio ?",
        style: new TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: new Text('No.'),
            ),
          new FlatButton(
            onPressed: (){
              openAppSettings();
            }, 
            child: new Text('Yes, thanks',
            ),
            ),
        ],
      ),
      );
  }

}


