import 'package:flutter/material.dart';

import 'Rec.dart';

void main() {
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Myapp',
       debugShowCheckedModeBanner: false,
       home: Audible(),

    );
  }
}


class Audible extends StatefulWidget {
  const Audible({super.key});

  @override
  State<Audible> createState() => _AudibleState();
}

class _AudibleState extends State<Audible> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Recording Audio'),
      ),
      body: Center(
        child: Container(
          child: ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>StartRec()));

          }, child: Text('GO to recorder')),
        ),
      ),
    );
  }
}
