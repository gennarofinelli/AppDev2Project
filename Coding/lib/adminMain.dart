import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'user.dart';
import 'adminHome.dart';
import 'adminEvent.dart';

class adminMain extends StatefulWidget {
  late Future<Database> database;
  int? selectIndex = 0;

  adminMain({this.selectIndex, required this.database});

  @override
  State<adminMain> createState() => _adminMainState();
}

class _adminMainState extends State<adminMain> {
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    _widgetOptions = [
      adminHome(database: widget.database,),
      adminEvent(database: widget.database,),
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
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: widget.selectIndex!,
        selectedItemColor: Colors.black,
        iconSize: 40,
        onTap: _onItemTapped,
        elevation: 5,
      ),
    );
  }
}
