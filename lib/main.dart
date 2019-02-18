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
        body: Center(
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
      title: _isRecording ? 'STOP' : 'RECORD',
      color: _isRecording ? Colors.red : Colors.green,
      action: _isRecording ? () => _stopRecordingAudio() : () => _recordAudio(),
      isVisible: true,
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
  }

  void _stopRecordingAudio() async {
    String result = await flutterSound.stopRecorder();
    print('stopRecorder: $result');
    this.audioPath = result;
    this.setState(() {
      _isRecording = false;
    });
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
      action: () {
        this._share();
      },
      isVisible: true,
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
  final String title;
  final VoidCallback action;
  final MaterialColor color;
  final bool isVisible;

  ActionButton({this.title, this.color, this.action, this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: this.isVisible,
      child: Expanded(
        child: AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FlatButton(
                onPressed: this.action,
                child: Text(
                  this.title,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                color: this.color,
                shape: CircleBorder(),
              ),
            )),
      ),
    );
  }
}
