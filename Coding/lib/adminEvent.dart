import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'event.dart';

class adminEvent extends StatefulWidget {
  late Future<Database> database;
  adminEvent({required this.database});

  @override
  State<adminEvent> createState() => _adminEventState();
}

class _adminEventState extends State<adminEvent> {
  List<DateTime> eventDates = [];
  List<Event> events = [];
  late TextEditingController nameController;
  late TextEditingController addressController;
  DateTime? selectedDate;

  final List<String> timeOptions = [
    "12:00 AM",
    "01:00 AM",
    "02:00 AM",
    "03:00 AM",
    "04:00 AM",
    "05:00 AM",
    "06:00 AM",
    "07:00 AM",
    "08:00 AM",
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "01:00 PM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM",
    "05:00 PM",
    "06:00 PM",
    "07:00 PM",
    "08:00 PM",
    "09:00 PM",
    "10:00 PM",
    "11:00 PM",
  ];

  String? startTime;
  String? endTime;

  @override
  void initState(){
    super.initState();

    nameController = TextEditingController();
    addressController = TextEditingController();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _addEvent(String name, String address, String date, String start, String end) async {
    final db = await widget.database;
    await db.insert(
      'events',
      {
        'name': name,
        'address': address,
        'eventDate': date,
        'startTime': start,
        'endTime': end,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    _fetchEvents();
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 10,),
          Text('Add Event', style: TextStyle(fontSize: 24)),
          SizedBox(height: 10,),
          Container(
            alignment: AlignmentDirectional.topStart,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Event Name',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFB44343)),
                      ),
                      filled: true,
                      fillColor: Color(0xFFFFECDE),
                    ),
                    controller: nameController,
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Event Address',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFB44343)),
                      ),
                      filled: true,
                      fillColor: Color(0xFFFFECDE),
                    ),
                    controller: addressController,
                  ),
                  SizedBox(height: 10,),
                  Container(
                    color: Color(0xFFFFECDE),
                    child: Row(
                      children: [
                        SizedBox(width: 15,),
                        Expanded(
                          child: Text(
                            selectedDate == null
                                ? 'Select A Date'
                                : "Selected Date: ${selectedDate!.toLocal().year}-${selectedDate!.toLocal().month}-${selectedDate!.toLocal().day}",
                          ),
                        ),
                        TextButton(
                          onPressed: () => _pickDate(context),
                          child: const Text('Pick a Date', style: TextStyle(color: Colors.black),),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                              side: BorderSide(color: Colors.black, width: 3),
                            ),
                            backgroundColor: Color(0xFFB44343),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    color: Color(0xFFFFECDE),
                    child: Row(
                      children: [
                        SizedBox(width: 15,),
                        Expanded(
                          child: Text("Start Time: "),
                        ),
                        DropdownButton<String>(
                          value: startTime,
                          hint: const Text("Select Start Time"),
                          items: timeOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              startTime = newValue!;
                            });
                          },
                          elevation: 0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    color: Color(0xFFFFECDE),
                    child: Row(
                      children: [
                        SizedBox(width: 15,),
                        Expanded(
                          child: Text("Start Time: "),
                        ),
                        DropdownButton<String>(
                          value: endTime,
                          hint: const Text("Select End Time"),
                          items: timeOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              endTime = newValue!;
                            });
                          },
                          elevation: 0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 175,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          setState(() {
                            _addEvent(nameController.text, addressController.text, selectedDate.toString(), startTime.toString(), endTime.toString());
                          });
                        },
                        child: Text("Add Event", style: TextStyle(color: Colors.black, fontSize: 18),),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: BorderSide(color: Colors.black, width: 3),
                          ),
                          backgroundColor: Color(0xFFB44343),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}
