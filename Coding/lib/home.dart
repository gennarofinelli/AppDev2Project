import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'user.dart';
import 'mainScreen.dart';

class home extends StatefulWidget {
  late Future<Database> database;
  late User user;

  home({required this.user, required this.database});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          SizedBox(height: 10,),
          Text(
            "BloodLife is a blood donation company dedicated to connecting donors with patients in need. Our app makes donating simple, safe, and rewarding, while tracking the impact of each donation. We work to ensure a steady blood supply for hospitals and emergencies. Join us in saving lives, one donation at a time!",
            textAlign: TextAlign.justify,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(height: 10,),
          ElevatedButton(
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>mainScreen(user: widget.user, selectIndex: 1, database: widget.database,)));
            },
            child: Text("DONATE NOW", style: TextStyle(color: Colors.black, fontSize: 30),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE44949),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: Colors.black, width: 3)
              )
            ),
          ),
          SizedBox(height: 5,),
          Divider(
            thickness: 1,
            color: Colors.black,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("News & Updates:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
            ],
          ),
          Container(
            height: 175,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: Color(0xFFFCD5D5),
                      border: Border.all(color: Colors.black, width: 2)
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 15,),
                        Icon(Icons.image, size: 75,),
                        Divider(
                          thickness: 2,
                          color: Colors.black,
                        ),
                        SizedBox(height: 5,),
                        Text("Event Info")
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.black,
          ),
          SizedBox(height: 5,),
          Text("Contact Us!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          SizedBox(height: 10,),
          Row(
            children: [
              Image.asset("assets/instagram.png", height: 35,),
              Text(" @bloodLifeInc.", style: TextStyle(fontSize: 15),),
              SizedBox(width: 30,),
              Icon(Icons.phone, color: Colors.black, size: 35,),
              Text(" (514) 813-1452", style: TextStyle(fontSize: 15),)
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Image.asset("assets/twitter.png", height: 35,),
              Text(" @bloodLifeMobile", style: TextStyle(fontSize: 15),),
              SizedBox(width: 10,),
              Icon(Icons.email_outlined, color: Colors.black, size: 35,),
              Text(" contact@bloodlife.ca", style: TextStyle(fontSize: 15),)
            ],
          ),
        ],
      ),
    );
  }
}
