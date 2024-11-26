import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'event.dart';

class adminEvent extends StatefulWidget {
  const adminEvent({super.key});

  @override
  State<adminEvent> createState() => _adminEventState();
}

class _adminEventState extends State<adminEvent> {
  CollectionReference eventsCollection = FirebaseFirestore.instance.collection('Events');

  List<DateTime> eventDates = [];
  List<Map<String, dynamic>> eventData = [];

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
    await eventsCollection.add({
      'name' : name,
      'address' : address,
      'date' : date,
      'startTime' : start,
      'endTime' : end,
    });
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
