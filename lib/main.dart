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
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Cangre"),
        ),
        floatingActionButton: ShareButton(),
        body: Center(
          child: Column(
            children: <Widget>[
              RecordButton(),
            ],
          ),
        ),
      ),
    );
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
  bool _isRecording = false;

  @override
  Widget build(BuildContext context) {
    return ActionButton(
      action: _isRecording ? () => _stopRecordingAudio() : () => _recordAudio(),
      icon: Icon(
        _isRecording ? Icons.stop : Icons.keyboard_voice,
        size: 200,
      ),
    );
  }

  void _recordAudio() async {
    Directory dir = await getApplicationDocumentsDirectory();
    //Start recorder
    var path = await flutterSound.startRecorder("${dir.path}/sound.m4a");
    print('startRecorder: $path');
    setState(() {
      _isRecording = true;
    });
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("Recording..."),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 1),
    ));
  }

  void _stopRecordingAudio() async {
    String result = await flutterSound.stopRecorder();
    print('stopRecorder: $result');
    this.audioPath = result;
    this.setState(() {
      _isRecording = false;
    });
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("Record stopped"),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 1),
    ));
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
    return FloatingActionButton(
      child: Icon(Icons.share),
      onPressed: () => _share(),
    );
  }

  void _share() async {
    Directory dir = await getApplicationDocumentsDirectory();
    File testFile = new File("${dir.path}/sound.m4a");
    if (await testFile.exists()) {
      print('shared dialog open');
      ShareExtend.share(testFile.path, "file");
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('No record available to share'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            );
          });
    }
  }
}

class ActionButton extends StatelessWidget {
  final VoidCallback action;
  final Icon icon;

  ActionButton({this.action, this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingActionButton(
          onPressed: action,
          child: icon,
        ),
      ),
    ));
  }
}
