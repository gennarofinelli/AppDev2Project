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
    return Center(
      child: Column(
        children: [
          SizedBox(height: 50,),
          Row(
            children: [
              SizedBox(width: 25,),
              CircleAvatar(
                backgroundColor: Color(0xFFFCD5D5),
                backgroundImage: AssetImage("assets/profile.png"),
                radius: 60,
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome", style: TextStyle(fontSize: 18),),
                  Text("${widget.user.name}", style: TextStyle(fontSize: 24),),
                  Text("Blood Type: ${widget.user.bloodType}", style: TextStyle(fontSize: 16),),
                ],
              )
            ],
          ),
          SizedBox(height: 50,),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFECDE),
              border: Border(
                top: BorderSide(color: Colors.black, width: 2),
                bottom: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            child: Card(
              color: Color(0xFFFFECDE),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              child: ListTile(
                title: Text("Password: "),
                trailing: ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => changePassword(database: widget.database, user: widget.user),));
                  },
                  child: Text("Change Password", style: TextStyle(color: Colors.black, fontSize: 16),),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: Colors.black, width: 3)
                    ),
                    backgroundColor: Color(0xFFB44343),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 25,),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFECDE),
              border: Border(
                top: BorderSide(color: Colors.black, width: 2),
                bottom: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            child: Card(
              color: Color(0xFFFFECDE),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              child: ListTile(
                title: Text("Logout: "),
                trailing: ElevatedButton(
                  onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => start()));
                  },
                  child: Text("Logout", style: TextStyle(color: Colors.black, fontSize: 16),),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: Colors.black, width: 3)
                    ),
                    backgroundColor: Color(0xFFB44343),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 125,),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFECDE),
              border: Border(
                top: BorderSide(color: Colors.black, width: 2),
                bottom: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            child: Card(
              color: Color(0xFFFFECDE),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              child: ListTile(
                title: ElevatedButton(
                  onPressed: (){
                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>start()));
                  },
                  child: Text("Delete Account", style: TextStyle(color: Colors.black, fontSize: 16),),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: Colors.black, width: 3)
                    ),
                    backgroundColor: Color(0xFFB44343),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
