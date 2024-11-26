import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'event.dart';
import 'user.dart';

class register extends StatefulWidget {
  late Event event;
  late User user;

  register({required this.event, required this.user});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  final Stream<QuerySnapshot> _taskStream =
  FirebaseFirestore.instance.collection('Registrations').snapshots();

  CollectionReference registrations = FirebaseFirestore.instance.collection('Registrations');

  bool agreed = false;

  Future<void> _addRegistration() async{
    await registrations.add({
      'eventName' : widget.event.name,
      'userName' : widget.user.name,
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMMM dd, yyyy').format(DateTime.parse(widget.event.date));

    return Scaffold(
      backgroundColor: Color(0xFFFFFBF3),
      appBar: AppBar(
        title: Text("BloodLife", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Color(0xFFB44343),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Text("Registration", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(widget.event.name, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Address: ${widget.event.address}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Date: ${formattedDate}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Start Time: ${widget.event.startTime}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("End Time: ${widget.event.endTime}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
            Container(
              color: Color(0xFFFFECDE),
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
                        color: Color(0xFFFFECDE),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        child: Row(
                          children: [
                            SizedBox(width: 15,),
                            Icon(Icons.flag_circle_rounded, size: 50,),
                            SizedBox(width: 15,),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "By checking the box below, you agree to arrive to the drive listed above on the described date and the correct time period.",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
              color: Color(0xFFFFECDE),
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
                        color: Color(0xFFFFECDE),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("I Agree", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
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
                onPressed: (){
                  if(agreed){
                    _addRegistration();
                    Navigator.of(context).pop();
                  } else {
                    SnackBar(
                      content: Text('Agree to the terms before registering!', style: TextStyle(fontSize: 16),),
                      duration: Duration(seconds: 2), // Duration for Snackbar display
                    );
                  }
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
