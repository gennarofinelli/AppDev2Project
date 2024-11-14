import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'home.dart';
import 'user.dart';
import 'mainScreen.dart';

class login extends StatefulWidget {
  late Future<Database> database;

  login({required this.database});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  List<User> userList = [];

  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState(){
    super.initState();

    emailController = TextEditingController();
    passwordController = TextEditingController();

    _fetchUsers();
  }

  Future<void> _fetchUsers() async{
    final db = await widget.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    setState(() {
      userList = List.generate(
          maps.length,
              (i) {
            return User(
              id: maps[i]['id'],
              name: maps[i]['name'],
              age: maps[i]['age'],
              email: maps[i]['email'],
              password: maps[i]['password'],
              bloodType: maps[i]['bloodType']
            );
          }
      );
    });
  }

  Future<bool>_loginUser(String email, String password) async{
    final db=await widget.database;
    final List<Map<String, dynamic>>result = await db.query(
      'users',
      where: 'email = ? AND password=?',
      whereArgs: [email,password],
    );
    if(result.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }

  Future<User> _getUser(String email, String password) async{
    final db=await widget.database;
    final List<Map<String, dynamic>>result = await db.query(
      'users',
      where: 'email = ? AND password=?',
      whereArgs: [email,password],
    );

    return User.fromMap(result.first);
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
                      controller: emailController,
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
                      controller: passwordController,
                    ),
                    SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: () async{
                        String email = emailController.text;
                        String password = passwordController.text;
                        bool loginStatus = await _loginUser(email, password);
                        User user = await _getUser(email, password);
                        if(loginStatus){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>mainScreen(user: user, selectIndex: 0, database: widget.database,)));
                        } else {
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