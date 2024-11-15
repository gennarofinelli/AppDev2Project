import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:project/changePassword.dart';
import 'package:sqflite/sqflite.dart';
import 'user.dart';
import 'start.dart';

class profile extends StatefulWidget {
  late Future<Database> database;
  late User user;
  profile({required this.database, required this.user});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFBF3),
      appBar: AppBar(
        title: Text(
          "BloodLife", style: TextStyle(fontSize: 30, fontWeight: FontWeight
            .bold),),
        centerTitle: true,
        backgroundColor: Color(0xFFB44343),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),

            SizedBox(height: 20,),

            SizedBox(height: 20,),

          ],
        ),
      ),
    );
  }
}