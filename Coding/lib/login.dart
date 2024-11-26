import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';
import 'user.dart';
import 'mainScreen.dart';
import 'adminMain.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  String email = '';
  String password = '';

  final Stream<QuerySnapshot> _taskStream =
  FirebaseFirestore.instance.collection('Users').snapshots();

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  @override
  void initState(){
    super.initState();
  }

  Future<bool> _loginUser(String email, String password) async{
    QuerySnapshot usersQuery = await users
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get();

    if(usersQuery.docs.isNotEmpty){
      return true;
    } else {
      return false;
    }
  }

  Future<User?> _getUser(String email, String password) async{
    QuerySnapshot usersQuery = await users
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get();

    if(usersQuery.docs.isNotEmpty){
      var userData = usersQuery.docs.first.data() as Map<String, dynamic>;

      return User.fromMap(userData);
    } else {
      return null;
    }
  }

  bool _loginAdmin(String email, String password){
    if(email == 'admin' && password == 'admin'){
      return true;
    }else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFBF3),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFBF3),
      ),
      body: Center(
        child: Column(
          children: [
            Text("BLOOD\nLIFE", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
            SizedBox(
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: [
                    SizedBox(height: 100,),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFB44343)),
                        ),
                        filled: true,
                        fillColor: Color(0xFFFFECDE),
                      ),
                      onChanged: (value) => email = value,
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFB44343)),
                        ),
                        filled: true,
                        fillColor: Color(0xFFFFECDE),
                      ),
                      obscureText: true,
                      onChanged: (value) => password = value,
                    ),
                    SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: () async{
                        bool loginStatus = await _loginUser(email, password);
                        if(loginStatus){
                          User? user = await _getUser(email, password);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>mainScreen(user: user!, selectIndex: 0,)));
                        } else if (_loginAdmin(email, password)){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>adminMain(selectIndex: 0,)));
                        }else {
                          SnackBar(
                            content: Text('Incorrect Username or Password!', style: TextStyle(fontSize: 16),),
                            duration: Duration(seconds: 2), // Duration for Snackbar display
                          );
                        }
                      },
                      child: Text("Log In", style: TextStyle(color: Colors.black, fontSize: 25),),
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
              ),
            ),
            SizedBox(height: 154,),
            Container(
              height: 75,
              decoration: BoxDecoration(
                  color: Color(0xFFB44343)
              ),
            ),
          ],
        ),
      ),
    );
  }
}