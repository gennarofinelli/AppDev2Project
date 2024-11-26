import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'event.dart';

class adminHome extends StatefulWidget {
  const adminHome({super.key});

  @override
  State<adminHome> createState() => _adminHomeState();
}

class _adminHomeState extends State<adminHome> {
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

        // Convert event data to Event object and add to fetchedEventData
        Event event = Event.fromMap(data);
        fetchedEventData.add(event.toMap());

        // Parse the date field and add it to fetchedEventDates
        DateTime eventDate = DateTime.parse(event.date);
        fetchedEventDates.add(eventDate);
      }

      setState(() {
        eventDates = fetchedEventDates; // Update the list of event dates
        eventData = fetchedEventData;   // Update the list of event data
      });
    } catch (e) {
      print('Error fetching event dates: $e');
    }
  }

  Future<void> _deleteEvent(String id) async{
    await eventsCollection.doc(id).delete();
    _fetchEventDates();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 10,),
          Text('Events', style: TextStyle(fontSize: 24)),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: eventData.length,
              itemBuilder: (context, index) {
                final event = eventData[index];
                final eventDate = eventDates[index];
                final eventName = event['name']; // Adjust this based on your event data structure

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
                        child: ListTile(
                          leading: Text(DateFormat('dd').format(eventDate)), // Display day of the month
                          title: Text(eventName),
                          subtitle: Text(DateFormat('yyyy-MM-dd').format(eventDate)), // Display the event date
                          trailing: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Delete Event"),
                                    content: Text("Are you sure you want to delete this event?"),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          _deleteEvent(event['id']); // Assuming 'id' is the identifier
                                          Navigator.pop(context);
                                        },
                                        child: Text("Yes", style: TextStyle(color: Colors.black)),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25),
                                            side: BorderSide(color: Colors.black, width: 3),
                                          ),
                                          backgroundColor: Color(0xFFB44343),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("No", style: TextStyle(color: Colors.black)),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25),
                                            side: BorderSide(color: Colors.black, width: 3),
                                          ),
                                          backgroundColor: Color(0xFFB44343),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Icon(Icons.delete, color: Colors.black),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side: BorderSide(color: Colors.black, width: 3),
                              ),
                              backgroundColor: Color(0xFFB44343),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
