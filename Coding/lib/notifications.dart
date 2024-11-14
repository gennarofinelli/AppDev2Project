import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'event.dart';
import 'register.dart';

class notifications extends StatefulWidget {
  late Future<Database> database;
  notifications({required this.database});

  @override
  State<notifications> createState() => _notificationsState();
}

class _notificationsState extends State<notifications> {
  List<DateTime> eventDates = [];
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final db = await widget.database;
    final List<Map<String, dynamic>> maps = await db.query('events');

    setState(() {
      events = List.generate(
          maps.length,
              (i){
            return Event(
                date: maps[i]['eventDate'],
                name: maps[i]['name'],
                address: maps[i]['address'],
                startTime: maps[i]['startTime'],
                endTime: maps[i]['endTime']
            );
          }
      );
    });

    _fetchEventDates();
  }

  Future<void> _fetchEventDates() async {
    final db = await widget.database;
    final List<Map<String, dynamic>> maps = await db.query('events');

    setState(() {
      eventDates = maps.map((event) {
        return DateTime.parse(event['eventDate']);
      }).toList();
    });
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
              itemCount: eventDates.length,
              itemBuilder: (context, index) {
                if (index >= events.length) {
                  return SizedBox(); // Return an empty widget if events list is shorter than eventDates
                }

                final eventDate = eventDates[index];
                final event = events[index];
                final monthName = DateFormat('MMMM').format(eventDate);

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
                            SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                children: [
                                  Text("Blood Drive taking place at ${event.address} on the ${eventDate.day} of ${monthName}"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => register(event: event)));
                                        },
                                        child: Text("Register", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFFB44343),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25),
                                                side: BorderSide(color: Colors.black, width: 3)
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10,),
                            Icon(Icons.image, size: 100,),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
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
