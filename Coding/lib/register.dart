import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mainScreen.dart';
import 'event.dart';
import 'user.dart';
import 'notification/notification.dart';
import 'package:timezone/timezone.dart' as tz;

class register extends StatefulWidget {
  late Event event;
  late User user;
  late int? index;

  register({required this.event, required this.user, this.index});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  final Stream<QuerySnapshot> _taskStream =
  FirebaseFirestore.instance.collection('Registrations').snapshots();

  CollectionReference registrations = FirebaseFirestore.instance.collection('Registrations');

  bool agreed = false;
  late String theme;
  late String lang;

  // Initialize FlutterLocalNotificationsPlugin
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize the notification plugin
  void _initializeNotifications() async {
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher'); // icon for Android
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

// Function to schedule a notification
  Future<void> _scheduleNotification(DateTime eventDate, String eventName) async {
    // Calculate the date for the notification (1 day before the event)
    final dayBeforeEvent = tz.TZDateTime.from(
      eventDate.subtract(Duration(days: 1)),
      tz.local,
    );

    var androidDetails = AndroidNotificationDetails(
      'presentation_channel', // Channel ID
      'Event Notifications', // Channel name
      channelDescription: 'Notifications for scheduled events',
      importance: Importance.high,
      priority: Priority.high,
    );

    var notificationDetails = NotificationDetails(android: androidDetails);

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      lang == 'English' ? 'Reminder' : 'Rappel', // Notification title
      lang == 'English'
          ? 'Don’t forget your event: $eventName tomorrow!'
          : 'N’oubliez pas votre événement: $eventName demain!', // Notification body
      tz.TZDateTime.from(dayBeforeEvent, tz.local), // Schedule date in local timezone
      notificationDetails,
      //androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exact, // Required parameter
    );
  }

  @override
  void initState() {
    theme = widget.user.theme ?? 'Light';
    lang = widget.user.lang ?? 'English';

    _initializeNotifications();
  }

  Future<bool> _addRegistration() async{
    QuerySnapshot querySnapshot = await registrations
        .where('userName', isEqualTo: widget.user.name)
        .where('eventName', isEqualTo: widget.event.name)
        .get();

    if(querySnapshot.docs.isEmpty){
      await registrations.add({
        'eventName' : widget.event.name,
        'userName' : widget.user.name,
      });
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMMM dd, yyyy').format(DateTime.parse(widget.event.date));

    return Scaffold(
      backgroundColor: theme == 'Light'
          ? Color(0xFFFFFBF3)
          : Color(0xFF373737),
      appBar: AppBar(
        title: Text("BloodLife", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Color(0xFFB44343),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Text(lang=='English'?"Registration":"Inscription", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme=='Light'?Colors.black:Colors.white),),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(widget.event.name, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: theme=='Light'?Colors.black:Colors.white),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(lang=='English'?"Address: ${widget.event.address}":"Adresse: ${widget.event.address}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme=='Light'?Colors.black:Colors.white),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(lang=='English'?"Date: ${formattedDate}":"Date: ${formattedDate}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme=='Light'?Colors.black:Colors.white),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(lang=='English'?"Start Time: ${widget.event.startTime}":"Heure de début: ${widget.event.startTime}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme=='Light'?Colors.black:Colors.white),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(lang=='English'?"End Time: ${widget.event.endTime}":"Heure de fin: ${widget.event.endTime}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme=='Light'?Colors.black:Colors.white),),
                    ],
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
            Container(
              color: theme=='Light'?Color(0xFFFFECDE):Color(0xFF3E3E3E),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                      child: Card(
                        shadowColor: Colors.transparent,
                        color: theme=='Light'?Color(0xFFFFECDE):Color(0xFF3E3E3E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        child: Row(
                          children: [
                            SizedBox(width: 15,),
                            Icon(Icons.flag_circle_rounded, size: 50, color: theme=='Light'?Colors.black:Colors.white),
                            SizedBox(width: 15,),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    lang=='English'?
                                    "By checking the box below, you agree to arrive to the drive listed above on the described date and the correct time period.":
                                    "En cochant la case ci-dessous, vous vous engagez à arriver au trajet indiqué ci-dessus à la date et à l'heure indiquées.",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: theme=='Light'?Colors.black:Colors.white),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 15,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: theme=='Light'?Color(0xFFFFECDE):Color(0xFF3E3E3E),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                      child: Card(
                        shadowColor: Colors.transparent,
                        color: theme=='Light'?Color(0xFFFFECDE):Color(0xFF3E3E3E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(lang=='English'?"I Agree":"Je suis d'accord", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme=='Light'?Colors.black:Colors.white),),
                            Checkbox(
                              fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                return Color(0xFFB44343);
                              }),
                              value: agreed,
                              onChanged: (bool? value){
                                setState(() {
                                  agreed = value!;
                                });
                              },
                            ),
                            SizedBox(width: 15,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 140,),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () async{
                  if(agreed){
                    bool result = await _addRegistration();
                    if(result){
                      // Schedule notification
                      DateTime eventDate = DateTime.parse(widget.event.date);
                      //await _scheduleNotification(eventDate, widget.event.name);
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => mainScreen(user: widget.user, selectIndex: widget.index,)), (Route<dynamic> route)=> false);
                    } else {
                      await ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            lang=='English'?
                            'You\'re already registered for this drive!':
                            'Vous êtes déjà inscrit pour ce collecte!',
                            style: TextStyle(fontSize: 16),
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          lang=='English'?
                          'Agree to the terms before registering!':
                          'Acceptez les conditions avant de vous inscrire !',
                          style: TextStyle(fontSize: 16),
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Text(lang=='English'?"Register":"Registre", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB44343),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: Colors.black, width: 3)
                    )
                ),
              ),
            ),
            SizedBox(height: 8,),
            Container(
              height: 75,
              decoration: BoxDecoration(
                  color: Color(0xFFB44343)
              ),
            )
          ],
        ),
      ),
    );
  }
}
