import 'dart:async';
import 'package:finalproject/notification/notification.dart';
import 'package:flutter/material.dart';
import 'start.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();

  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDsAuYR7OwfbuD0nqdIytvjpE8jAmR89Bw",
          appId: "946819205577",
          messagingSenderId: "1:946819205577:android:afe0564b5e89083d760018",
          projectId: "finalproject-5da98"
      )
  );
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
    Timer(Duration(seconds: 5), (){
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

