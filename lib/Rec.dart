import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class StartRec extends StatefulWidget {
  const StartRec({super.key});

  @override
  State<StartRec> createState() => _StartRecState();
}

class _StartRecState extends State<StartRec> {


  void checkPermission() async {
    PermissionStatus status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        // Permission denied, handle accordingly
        return;
      }
    }

    // Permission granted, start audio recording
    // ...
  }

  final record = Record();

  Future<String> getFilePath() async {
    final Directory directory = await getTemporaryDirectory();
    return '${directory.path}/recording_${DateTime
        .now()
        .millisecondsSinceEpoch}.wav';
  }



  Future<void> startRec() async {
// Check and request permission

    if (await record.hasPermission()) {
      String path = await getFilePath();
      // Start recording
      await record.start(
        path: path,
        encoder: AudioEncoder.aacLc, // by default
        bitRate: 128000, // by default
        samplingRate: 44100, // by default
      );


      // Record For one min
      await Future.delayed(Duration(seconds: 10));

      // Stop recording
      await record.stop();
      // Reset the recording file path for the next recording
      path = '';

      // Wait for a short period before starting the next recording
      await Future.delayed(const Duration(seconds: 1));


    }
    else{
      Permission.microphone.request();
      startRec();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recording Audio'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(onPressed: () {
            startRec();
          }, child: Text('Start')),
          ElevatedButton(onPressed: () {
            stoprec();
          }, child: Text('End')),

        ],
      ),
    );
  }

  Future<void> stoprec() async {
    await record.stop();
  }

}
