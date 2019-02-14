import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:share_extend/share_extend.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cangre Audios',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Audio"),
        ),
        body:Center(
          child:  RoundButton(),
        ),
      ),
    );
  }
}

class RoundButton extends StatefulWidget {

  @override
  RoundButtonState createState() {
    return new RoundButtonState();
  }
}

class RoundButtonState extends State<RoundButton> {

  var flutterSound = new FlutterSound();
  String audioPath;
  var isRecording = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AspectRatio(
      aspectRatio: 1,
      child: Column(
        children: <Widget>[
          Expanded (
            child: FittedBox(
              fit: BoxFit.fill,
              child: FlatButton(
                shape: CircleBorder(),
                onPressed: () => this._recordAudio(),
                color: Colors.red,
                child: Text(
                  'Record',
                  style: TextStyle(
                    fontSize: 8,
                  ),
                ),

              ),
            ),
          ),
          Expanded (
            child: FittedBox(
              fit: BoxFit.fill,
              child: FlatButton(
                shape: CircleBorder(),
                onPressed: () => this._stopRecordingAudio(),
                color: Colors.green,
                child: Text(
                  'Stop',
                  style: TextStyle(
                    fontSize: 8,
                  ),
                ),
              ),
            ),
          ),
          Expanded (
            child: FittedBox(
              fit: BoxFit.fill,
              child: FlatButton(
                shape: CircleBorder(),
                onPressed: () => this.share(),
                color: Colors.orange,
                child: Text(
                  'Share',
                  style: TextStyle(
                    fontSize: 8,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _recordAudio() async {
    Directory dir = await getApplicationDocumentsDirectory();
    //Start recorder
    var path = await flutterSound.startRecorder("${dir.path}/sound.m4a");
    print('startRecorder: $path');
  }

  void _stopRecordingAudio() async {
    String result = await flutterSound.stopRecorder();
    print('stopRecorder: $result');
    this.audioPath = result;
  }

  void share() async {
    Directory dir = await getApplicationDocumentsDirectory();
    File testFile = new File("${dir.path}/sound.m4a");
    if (!await testFile.exists()) {
      await testFile.create(recursive: true);
      testFile.writeAsStringSync("test for share documents file");
    }
    ShareExtend.share(testFile.path, "file");
  }

}
