import 'dart:async';
import 'dart:convert';
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

StreamSubscription<Amplitude>? _amplitudeSub;
Amplitude? _amplitude;
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
  bool isRecording = false;

  Future<String> getFilePath() async {
    final Directory directory = await getTemporaryDirectory();
    return '${directory.path}/recording_${DateTime
        .now()
        .millisecondsSinceEpoch}.wav';
  }





//   Future<void> startRec() async {
// // Check and request permission
//
//     if (await record.hasPermission()) {
//       String path = await getFilePath();
//       // Start recording
//       while(isRecording){
//         await record.start(
//           path: path,
//           encoder: AudioEncoder.aacLc, // by default
//           bitRate: 128000, // by default
//           samplingRate: 44100, // by default
//         );
//
//
//         // Record For one min
//         await Future.delayed(Duration(seconds: 5));
//
//         // Stop recording
//         await record.stop();
//         // Reset the recording file path for the next recording
//         // path = '';
//
//         // Wait for a short period before starting the next recording
//         await Future.delayed(const Duration(seconds: 1));
//       }
//     }
//   }


  Future<void> startRec() async {
// Check and request permission
    if (await record.hasPermission()) {
      String path = await getFilePath();

      isRecording=true;
      // Start recording
      DateTime.now().millisecondsSinceEpoch;
      print(DateTime.now().millisecondsSinceEpoch);
        await record.start(
          path: path,
          encoder: AudioEncoder.wav, // by default
          bitRate: 128000, // by default
          samplingRate: 44100, // by default

        );

      }
  }

  ///////////////////////////////////////////////////////json//////

  void printJsonData() {
    // Example data
    String question = "What is your name?";
    DateTime startTime = DateTime.now();
    DateTime endTime = startTime.add(Duration(seconds: 10));

    // Create JSON data
    Map<String, dynamic> jsonData = {
      'question': question,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
    };

    // Convert JSON data to string
    String jsonString = jsonEncode(jsonData);

    // Print the JSON string
    print(jsonString);
  }


  void amplitude(){
    final _audioRecorder = Record();

    /// Get the amplitude of the audio
    _amplitudeSub = _audioRecorder
        .onAmplitudeChanged(const Duration(seconds: 1
    ))
        .listen((amp) {
      setState(() => _amplitude = amp);
    });
  }


  /////////////////////////////////////////////////////////json/////



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recording Audio'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () {
                startRec();
                amplitude();
              }, child: Text('Start')),
              ElevatedButton(onPressed: () {
                DateTime.now().millisecondsSinceEpoch;
                print(DateTime.now().millisecondsSinceEpoch);
                printJsonData();
              }, child: Text('Next')),

              ElevatedButton(onPressed: () {
                DateTime.now().millisecondsSinceEpoch;
                print(DateTime.now().millisecondsSinceEpoch);
                stoprec();
              }, child: Text('End')),

            ],
          ),

          const SizedBox(height: 16),
          if (_amplitude != null) ...[
            const SizedBox(height: 40),
            Text('Current: ${_amplitude?.current ?? 0.0}'),
            Text('Max: ${_amplitude?.max ?? 0.0}'),
          ],
        ],
      ),
    );
  }

  Future<void> stoprec() async {
    isRecording = false;
    await record.stop();
  }

}
