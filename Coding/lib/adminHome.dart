import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'event.dart';

class adminHome extends StatefulWidget {
  const adminHome({super.key});

  @override
  State<adminHome> createState() => _adminHomeState();
}

class _adminHomeState extends State<adminHome> {
  CollectionReference eventsCollection = FirebaseFirestore.instance.collection(
      'Events');

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


  Future<void> _deleteEvent(String name) async {
    try {
      var querySnapshot = await eventsCollection.where('name', isEqualTo: name).get();

      if (querySnapshot.docs.isNotEmpty) {
        var eventDoc = querySnapshot.docs.first;
        await eventsCollection.doc(eventDoc.id).delete();
      } else {
        print("Event with this name does not exist.");
      }
    } catch (e) {
      print("Error deleting event: $e");
    }
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
                final eventName = event['name'];
                final eventAddress = event['address'];
                final eventStartTime = event['startTime'];
                final eventEndTime = event['endTime'];

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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        child: ListTile(
                          leading: Text(DateFormat('dd').format(eventDate)),
                          title: Text(eventName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(DateFormat('yyyy-MM-dd').format(eventDate)),
                              Text("Location: $eventAddress"),
                              Text("Start Time: $eventStartTime"),
                              Text("End Time: $eventEndTime"),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Delete Event"),
                                    content: Text(
                                        "Are you sure you want to delete this event?"),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          _deleteEvent(event['name']);
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                25),
                                            side: BorderSide(
                                                color: Colors.black, width: 3),
                                          ),
                                          backgroundColor: Color(0xFFB44343),
                                        ),
                                        child: Text("Yes", style: TextStyle(
                                            color: Colors.black)),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                25),
                                            side: BorderSide(
                                                color: Colors.black, width: 3),
                                          ),
                                          backgroundColor: Color(0xFFB44343),
                                        ),
                                        child: Text("No", style: TextStyle(
                                            color: Colors.black)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side: BorderSide(color: Colors.black, width: 3),
                              ),
                              backgroundColor: Color(0xFFB44343),
                            ),
                            child: Icon(Icons.delete, color: Colors.black),
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