import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'event.dart';
import 'register.dart';

class events extends StatefulWidget {
  const events({super.key});

  @override
  State<events> createState() => _EventsState();
}

class _EventsState extends State<events> {
  CollectionReference eventsCollection = FirebaseFirestore.instance.collection('Events');

  DateTime _selectedDate = DateTime.now();
  final List<String> daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
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



  void _changeMonth(int offset) {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + offset, 1);
    });
  }

  String get monthYear => DateFormat.yMMMM().format(_selectedDate);

  int get daysInMonth {
    final nextMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
    return nextMonth.subtract(Duration(days: 1)).day;
  }

  int get firstWeekdayOfMonth => DateTime(_selectedDate.year, _selectedDate.month, 1).weekday % 7;

  bool _isEventDay(int day) {
    final dateToCheck = DateTime(_selectedDate.year, _selectedDate.month, day);
    return eventDates.any((eventDate) =>
    eventDate.year == dateToCheck.year &&
        eventDate.month == dateToCheck.month &&
        eventDate.day == dateToCheck.day);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left, color: Colors.black, size: 30),
                onPressed: () => _changeMonth(-1),
              ),
              Text(monthYear, style: TextStyle(fontSize: 24)),
              IconButton(
                icon: Icon(Icons.arrow_right, color: Colors.black, size: 30),
                onPressed: () => _changeMonth(1),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            color: Color(0xFFFFECDE),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: daysOfWeek
                      .map((day) => Expanded(
                      child: Center(
                          child: Text(day,
                              style: TextStyle(fontWeight: FontWeight.bold)))))
                      .toList(),
                ),
                SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: firstWeekdayOfMonth + daysInMonth,
                  itemBuilder: (context, index) {
                    if (index < firstWeekdayOfMonth) {
                      return Container();
                    }
                    int day = index - firstWeekdayOfMonth + 1;
                    bool isToday = _selectedDate.month == DateTime.now().month &&
                        _selectedDate.year == DateTime.now().year &&
                        day == DateTime.now().day;
                    bool isEventDay = _isEventDay(day);

                    return Container(
                      decoration: BoxDecoration(
                        color: isEventDay ? Colors.redAccent : Colors.transparent,
                        shape: BoxShape.circle,
                        border: isToday ? Border.all(color: Colors.blue, width: 2) : null,
                      ),
                      child: Center(
                        child: Text(
                          '$day',
                          style: TextStyle(
                            color: isEventDay ? Colors.white : Colors.black,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text("Upcoming Dates", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: eventData.length,
              itemBuilder: (context, index) {
                final event = eventData[index]; // Get the Event object
                final DateTime eventDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(event['date']);
                final String formattedDate = DateFormat('dd').format(eventDate);

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
                          leading: Text(formattedDate), // Display event date
                          title: Text(event['name']),  // Display event name
                          subtitle: Text(event['address']), // Display event address
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => register(event: Event.fromMap(event)), // Pass the Event object
                                ),
                              );
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
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
          )
        ],
      ),
    );
  }
}
