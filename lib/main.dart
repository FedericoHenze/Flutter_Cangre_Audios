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
          child: Column(
            children: <Widget>[
              RecordButton(),
              ShareButton(),
              //ActionButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class ShareButton extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return ShareButtonState();
  }
}

class ShareButtonState extends State<ShareButton> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ActionButton(
      title: 'SHARE',
      color: Colors.orange,
      action: (){this._share();},
    );
  }

  void _share() async {
    Directory dir = await getApplicationDocumentsDirectory();
    File testFile = new File("${dir.path}/sound.m4a");
    if (!await testFile.exists()) {
      await testFile.create(recursive: true);
      testFile.writeAsStringSync("test for share documents file");
    }
    print('shared dialog open');
    ShareExtend.share(testFile.path, "file");
  }
}

class RecordButton extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return RecordButtonState();
  }
}

class RecordButtonState extends State<RecordButton> {

  var flutterSound = new FlutterSound();
  String audioPath;
  var startRecording = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ActionButton(
      title: this.startRecording ? 'RECORD' : 'STOP',
      color: this.startRecording ? Colors.green : Colors.red,
      action: this.startRecording ? (){this._recordAudio();} : (){_stopRecordingAudio();},
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
}

class ActionButton extends StatefulWidget {

  final String title;
  final VoidCallback action;
  final MaterialColor color;

  ActionButton({this.title, this.color, this.action});

  @override
  ActionButtonState createState() {
    return new ActionButtonState(this.title, this.action, this.color);
  }
}

class ActionButtonState extends State<ActionButton> {

  final String title;
  final VoidCallback action;
  final MaterialColor color;

  ActionButtonState(this.title, this.action, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
          aspectRatio: 1,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FlatButton(
              onPressed: this.action,
              child: Text(this.title,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              color: this.color,
              shape: CircleBorder(),
            ),
          )
      ),
    );
  }

}

