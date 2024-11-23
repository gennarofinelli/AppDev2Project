import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'event.dart';

class adminHome extends StatefulWidget {
  late Future<Database> database;
  adminHome({required this.database});

  @override
  State<adminHome> createState() => _adminHomeState();
}

class _adminHomeState extends State<adminHome> {
  List<DateTime> eventDates = [];
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    _fetchEventDates();
    _fetchEvents();
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

  Future<void> _fetchEvents() async {
    final db = await widget.database;
    final List<Map<String, dynamic>> maps = await db.query('events');

    setState(() {
      events = List.generate(
          maps.length,
              (i) {
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
  }

  Future<void> _deleteEvent(String eventName) async{
    final db = await widget.database;

    await db.delete(
      'events',
      where: 'name = ?',
      whereArgs: [eventName]
    );
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
              itemCount: eventDates.length,
              itemBuilder: (context, index) {
                if (index >= events.length) {
                  return SizedBox(); // Return an empty widget if events list is shorter than eventDates
                }

                final eventDate = eventDates[index];
                final event = events[index];

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
                          leading: Text(eventDate.day.toString()),
                          title: Text(event.name),
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
                                        onPressed: (){
                                          _deleteEvent(event.name);
                                          Navigator.pop(context);
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
                            child: Icon(Icons.delete, color: Colors.black,),
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
