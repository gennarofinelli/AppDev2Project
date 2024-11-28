import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'user.dart';
import 'mainScreen.dart';
import 'event.dart';

class home extends StatefulWidget {
  late User user;

  home({required this.user});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  CollectionReference eventsCollection = FirebaseFirestore.instance.collection('Events');
  List<DateTime> eventDates = [];
  List<Map<String, dynamic>> eventData = [];

  late String theme;

  @override
  void initState() {
    super.initState();
    theme = widget.user.theme ?? 'Light';
    _fetchEventDates();
  }

  Future<void> _fetchEventDates() async {
    try {
      QuerySnapshot querySnapshot = await eventsCollection.get();
      List<DateTime> fetchedEventDates = [];
      List<Map<String, dynamic>> fetchedEventData = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String id = doc.id; // Firestore document ID

        // Convert event data to Event object
        Event event = Event.fromMapWithID(data, id);
        fetchedEventData.add(event.toMap());

        // Parse the date string to DateTime
        DateTime eventDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(
            event.date);
        fetchedEventDates.add(eventDate);
      }

      setState(() {
        eventDates = fetchedEventDates; // Update the list of event dates
        eventData = fetchedEventData; // Update the list of event data
      });
    } catch (e) {
      print('Error fetching event dates: $e');
    }
  }

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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: theme=='Light'?Colors.black:Colors.white,),
          ),
          SizedBox(height: 10,),
          ElevatedButton(
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>mainScreen(user: widget.user, selectIndex: 1)));
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
            color: theme=='Light'?Colors.black:Colors.white,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("News & Updates:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme=='Light'?Colors.black:Colors.white,),)
            ],
          ),
          Container(
            height: 175,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: eventData.length,
              itemBuilder: (context, index){
                final eventMap = eventData[index];
                final event = Event.fromMap(eventMap);
                final DateTime eventDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(event.date);
                final String formattedDate = DateFormat('yyyy-MM-dd').format(eventDate);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: theme=='Light'?Color(0xFFFCD5D5):Color(0xFF5D5252),
                      border: Border.all(color: theme=='Light'?Colors.black:Colors.white, width: 2)
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 5,),
                        Expanded(child: Image(image: FileImage(File(event.imagePath)), width: double.infinity, fit: BoxFit.fill,),),
                        Divider(
                          thickness: 2,
                          color: theme=='Light'?Colors.black:Colors.white,
                        ),
                        SizedBox(height: 5,),
                        Text("${event.name}", style: TextStyle(color: theme=='Light'?Colors.black:Colors.white,), textAlign: TextAlign.center,),
                        Text("${formattedDate}", style: TextStyle(color: theme=='Light'?Colors.black:Colors.white,), textAlign: TextAlign.center,),
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
          Divider(
            thickness: 1,
            color: theme=='Light'?Colors.black:Colors.white,
          ),
          SizedBox(height: 5,),
          Text("Contact Us!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: theme=='Light'?Colors.black:Colors.white,),),
          SizedBox(height: 10,),
          Row(
            children: [
              Image.asset("assets/instagram.png", height: 35, color: theme=='Light'?Colors.black:Colors.white,),
              Text(" @bloodLifeInc.", style: TextStyle(fontSize: 15, color: theme=='Light'?Colors.black:Colors.white,),),
              SizedBox(width: 30,),
              Icon(Icons.phone, color: theme=='Light'?Colors.black:Colors.white, size: 35,),
              Text(" (514) 813-1452", style: TextStyle(fontSize: 15, color: theme=='Light'?Colors.black:Colors.white,),)
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Image.asset("assets/twitter.png", height: 35, color: theme=='Light'?Colors.black:Colors.white,),
              Text(" @bloodLifeMobile", style: TextStyle(fontSize: 15, color: theme=='Light'?Colors.black:Colors.white,),),
              SizedBox(width: 10,),
              Icon(Icons.email_outlined, color: theme=='Light'?Colors.black:Colors.white, size: 35,),
              Text(" contact@bloodlife.ca", style: TextStyle(fontSize: 15, color: theme=='Light'?Colors.black:Colors.white,),)
            ],
          ),
        ],
      ),
    );
  }
}
