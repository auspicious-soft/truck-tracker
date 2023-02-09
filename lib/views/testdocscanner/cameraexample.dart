import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraAccess extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CameraAccessState();
  }
}

class CameraAccessState extends State<CameraAccess> {
  XFile? cameraFile;
  String code = '';


  @override
  Widget build(BuildContext context) {
    //display image selected from gallery
    selectFromCamera() async {
      cameraFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        // maxHeight: 50.0,
        // maxWidth: 50.0,
      );

      setState(() {});
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Camera Access"),
        backgroundColor: Colors.green,
        actions: <Widget>[
          Text(
            "GFG",
            textScaleFactor: 3,
          )
        ],
      ),
      body: new Builder(
        builder: (BuildContext context) {
          return Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new TextButton(
                    child: new Text('Select Image from Camera'),
                    onPressed: selectFromCamera),
                SizedBox(
                  height: 200.0,
                  width: 300.0,
                  child: cameraFile == null
                      ? Center(child: new Text('Sorry nothing selected!!'))
                      : Center(child: new Image.file(File(cameraFile!.path))),
                ),
                Text('Code: $code')
              ],
            ),
          );
        },
      ),
    );
  }
}
