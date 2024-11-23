import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'changePassword.dart';
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

  Future<void> _deleteUser() async{
    final db = await widget.database;
    await db.delete(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [widget.user.email, widget.user.password]
    );
  }

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
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => start()), (Route<dynamic> route)=> false);
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Delete Account"),
                          content: Text("Are you sure you want to delete account?"),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: (){
                                _deleteUser();
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => start()), (Route<dynamic> route)=> false);
                              },
                              child: Text("Yes", style: TextStyle(color: Colors.black),),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    side: BorderSide(color: Colors.black, width: 3)
                                ),
                                backgroundColor: Color(0xFFB44343),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text("No", style: TextStyle(color: Colors.black),),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    side: BorderSide(color: Colors.black, width: 3)
                                ),
                                backgroundColor: Color(0xFFB44343),
                              ),
                            ),
                          ],
                        );
                      },
                    );
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
