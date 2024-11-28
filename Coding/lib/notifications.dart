import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'event.dart';
import 'register.dart';
import 'user.dart';
import 'registration.dart';

class notifications extends StatefulWidget {
  late User user;

  notifications({required this.user});

  @override
  State<notifications> createState() => _notificationsState();
}

class _notificationsState extends State<notifications> {
  CollectionReference eventsCollection = FirebaseFirestore.instance.collection('Events');
  CollectionReference registrations = FirebaseFirestore.instance.collection('Registrations');

  List<DateTime> eventDates = [];
  List<Map<String, dynamic>> eventData = [];
  List<Map<String, dynamic>> registeredData = [];

  late String theme;

  @override
  void initState() {
    super.initState();
    theme = widget.user.theme ?? 'Light';
    _fetchEventDates();
    _fetchRegistrationsForUser(widget.user.name);
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

  Future<void> _fetchRegistrationsForUser(String username) async {
    try {
      // Debugging: print username
      print('Fetching registrations for user: $username');

      QuerySnapshot querySnapshot = await registrations
          .where('userName', isEqualTo: username)
          .get();

      print('Number of registrations found: ${querySnapshot.docs.length}');

      List<Map<String, dynamic>> fetchedRegistrationData = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Debugging: print document data
        print('Document data: $data');

        Registration registration = Registration.fromMap(data);
        fetchedRegistrationData.add(registration.toMap());
      }

      // Debugging: print fetched registration data
      print('Fetched registrations: $fetchedRegistrationData');

      setState(() {
        registeredData = fetchedRegistrationData;
      });
    } catch (e) {
      print('Error fetching registered events: $e');
    }
  }

  Future<void> _deleteRegistration(String name) async {
    try {
      var querySnapshot = await registrations.where('userName', isEqualTo: name).get();

      if (querySnapshot.docs.isNotEmpty) {
        var registrationDoc = querySnapshot.docs.first;
        await registrations.doc(registrationDoc.id).delete();
      } else {
        print("Registration for this user doesn't exist!");
      }
    } catch (e) {
      print("Error deleting user: $e");
    }

    _fetchRegistrationsForUser(name);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 10,),
          Text("Notifications", style: TextStyle(fontSize: 24, color: theme=='Light'?Colors.black:Colors.white)),
          SizedBox(height: 10,),
          Divider(height: 1, thickness: 2, color: theme=='Light'?Colors.black:Colors.white),
          SizedBox(height: 10,),
          Text("Upcoming Drives", style: TextStyle(fontSize: 24, color: theme=='Light'?Colors.black:Colors.white)),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: eventData.length, // Use eventData length
              itemBuilder: (context, index) {
                final eventMap = eventData[index]; // Access event data as a map
                final event = Event.fromMap(eventMap); // Convert map to Event instance
                final eventDate = DateTime.parse(event.date); // Parse the date
                final monthName = DateFormat('MMMM').format(eventDate); // Get month name

                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: theme=='Light'?Color(0xFFFFECDE):Color(0xFF3E3E3E),
                        border: Border(
                          top: BorderSide(color: theme=='Light'?Colors.black:Colors.white, width: 2),
                          bottom: BorderSide(color: theme=='Light'?Colors.black:Colors.white, width: 2),
                        ),
                      ),
                      child: Card(
                        color: theme=='Light'?Color(0xFFFFECDE):Color(0xFF3E3E3E),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Blood Drive taking place at ${event.address} on the ${eventDate.day} of ${monthName}",
                                    style: TextStyle(fontSize: 16, color: theme=='Light'?Colors.black:Colors.white),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => register(event: event, user: widget.user, index: 2,),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Register",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFFB44343),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25),
                                            side: BorderSide(color: Colors.black, width: 3),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Image(image: FileImage(File(event.imagePath)), width: 100),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 10,),
          Text("Registered Drives", style: TextStyle(fontSize: 24, color: theme=='Light'?Colors.black:Colors.white)),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: registeredData.length, // Use eventData length
              itemBuilder: (context, index) {
                final registerMap = registeredData[index]; // Access event data as a map
                final registration = Registration.fromMap(registerMap); // Convert map to Event instance

                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: theme=='Light'?Color(0xFFFFECDE):Color(0xFF3E3E3E),
                        border: Border(
                          top: BorderSide(color: theme=='Light'?Colors.black:Colors.white, width: 2),
                          bottom: BorderSide(color: theme=='Light'?Colors.black:Colors.white, width: 2),
                        ),
                      ),
                      child: Card(
                        color: theme=='Light'?Color(0xFFFFECDE):Color(0xFF3E3E3E),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "You're registered for ${registration.eventName}!",
                                    style: TextStyle(fontSize: 16, color: theme=='Light'?Colors.black:Colors.white),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Cancel Registration"),
                                                content: Text("Are you sure you want to cancel registration?"),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                    onPressed: (){
                                                      _deleteRegistration(widget.user.name);
                                                      Navigator.of(context).pop();
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
                                        child: Text(
                                          "Cancel Registration",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFFB44343),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25),
                                            side: BorderSide(color: Colors.black, width: 3),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.star, size: 100), // Placeholder for event image
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
