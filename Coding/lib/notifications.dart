import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'event.dart';
import 'register.dart';
import 'user.dart';

class notifications extends StatefulWidget {
  late User user;

  notifications({required this.user});

  @override
  State<notifications> createState() => _notificationsState();
}

class _notificationsState extends State<notifications> {
  CollectionReference eventsCollection = FirebaseFirestore.instance.collection('Events');

  List<DateTime> eventDates = [];
  List<Map<String, dynamic>> eventData = [];

  @override
  void initState() {
    super.initState();
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
    return Center(
      child: Column(
        children: [
          SizedBox(height: 10,),
          Text("Notifications", style: TextStyle(fontSize: 24)),
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
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Blood Drive taking place at ${event.address} on the ${eventDate.day} of ${monthName}",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => register(event: event, user: widget.user,),
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
                            Icon(Icons.image, size: 100), // Placeholder for event image
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
