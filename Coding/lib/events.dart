import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'event.dart';
import 'register.dart';

class events extends StatefulWidget {
  late Future<Database> database;
  events({required this.database});

  @override
  State<events> createState() => _EventsState();
}

class _EventsState extends State<events> {
  List<DateTime> eventDates = [];
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    _fetchEventDates();
    _fetchEvents();
    _addEvents();
  }

  Future<void> _addEvents() async {
    final db = await widget.database;

    if(events.isEmpty){
      await db.insert(
        'events',
        {
          'name': 'Hero\'s Drive',
          'address': '11855 Av. Andre Dumas',
          'eventDate': '2024-11-21',
          'startTime': '10:00 AM',
          'endTime': '2:00 PM',
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await db.insert(
        'events',
        {
          'name': 'Donate & Glow',
          'address': '11854 Av. Andre Dumas',
          'eventDate': '2024-12-05',
          'startTime': '11:00 AM',
          'endTime': '3:00 PM',
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> _fetchEventDates() async {
    final db = await widget.database;
    final List<Map<String, dynamic>> maps = await db.query('events');

    if(events.isEmpty) {
      setState(() {
        eventDates = maps.map((event) {
          return DateTime.parse(event['eventDate']);
        }).toList();
      });
    }
  }

  Future<void> _fetchEvents() async {
    final db = await widget.database;
    final List<Map<String, dynamic>> maps = await db.query('events');

    if(events.isEmpty) {
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
  }

  DateTime _selectedDate = DateTime.now();
  final List<String> daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  void _changeMonth(int offset) {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + offset, 1);
    });
    _fetchEventDates();
  }

  String get monthYear => DateFormat.yMMMM().format(_selectedDate);

  int get daysInMonth {
    final nextMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
    return nextMonth.subtract(Duration(days: 1)).day;
  }

  int get firstWeekdayOfMonth => DateTime(_selectedDate.year, _selectedDate.month, 1).weekday % 7;

  bool _isEventDay(int day) {
    final dateToCheck = DateTime(_selectedDate.year, _selectedDate.month, day);
    return eventDates.any((eventDate) => eventDate == dateToCheck);
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
          SizedBox(height: 10,),
          Text("Upcoming Dates", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => register(event: event)));
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