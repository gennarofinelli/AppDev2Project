import 'dart:async';
import 'package:flutter/material.dart';
import 'start.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class splash extends StatefulWidget {
  const splash({super.key});

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {

  @override
  void initState() {
    Timer(Duration(seconds: 2), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>start()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 250,),
            Image.asset("assets/BloodLife.png", scale: 0.5,),
            SizedBox(height: 250,),
            Text("©BloodLife Inc. 2024", style: TextStyle(fontSize: 20),),
          ],
        ),
      ),
    );
  }
}

