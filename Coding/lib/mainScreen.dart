import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'user.dart';
import 'home.dart';
import 'events.dart';
import 'notifications.dart';
import 'profile.dart';
import 'register.dart';
import 'start.dart';

class mainScreen extends StatefulWidget {
  late Future<Database> database;
  late User user;
  int? selectIndex = 0;

  mainScreen({required this.user, this.selectIndex, required this.database});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    _widgetOptions = [
      home(user: widget.user, database: widget.database,),
      events(database: widget.database,),
      notifications(),
      profile(),
    ];
  }

  void _onItemTapped(int index){
    setState(() {
      widget.selectIndex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFBF3),
      appBar: AppBar(
        title: Text("BloodLife", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Color(0xFFB44343),
      ),
      body: IndexedStack(
        index: widget.selectIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home),
            label:"Home",
            backgroundColor: Color(0xFFB44343),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today),
            label:"Events",
            backgroundColor: Color(0xFFB44343),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.notifications),
            label:"Notifications",
            backgroundColor: Color(0xFFB44343),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person),
            label:"Profile",
            backgroundColor: Color(0xFFB44343),
          )
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: widget.selectIndex!,
        selectedItemColor: Colors.black,
        iconSize: 40,
        onTap: _onItemTapped,
        elevation: 5,
      ),
      drawer: Drawer(
        child: ListView(
          //important: remove any padding from the ListView
          padding: EdgeInsets.zero,
          children: [
            Expanded(
              child: Container(
                color: Color(0xFFB44343),
                child: Column(
                  children: [
                    SizedBox(height: 50,),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage("assets/profile.png"),
                      radius: 100,
                    ),
                    Text(widget.user.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: (){
                // Navigator.push(context,MaterialPageRoute(builder:
                //     (context)=> Settings()));
              },
              trailing: Icon(Icons.arrow_right),
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text("Logout"),
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>start()));
              },
              trailing: Icon(Icons.arrow_right),
            ),
          ],
        ),
      ),
    );
  }
}
