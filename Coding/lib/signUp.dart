import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'user.dart';

const List<String> bloodTypes = <String>['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

class signUp extends StatefulWidget {
  late Future<Database> database;

  signUp({required this.database});

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  List<User> userList = [];

  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  String dropdownValue = bloodTypes.first;

  @override
  void initState(){
    super.initState();

    nameController = TextEditingController();
    ageController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  Future<void> _addUser(User user) async{
    final db = await widget.database;
    await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );

  }

  bool _saveUser() {
    final String name = nameController.text;
    final String age = ageController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String bloodType = dropdownValue;

    if (name.isNotEmpty && age.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      final user = User(
        name: name,
        age: int.parse(age),
        email: email,
        password: password,
        bloodType: bloodType
      );

      _addUser(user);

      setState(() {
        nameController.text = "";
        ageController.text = "";
        emailController.text = "";
        passwordController.text = "";
        dropdownValue = bloodTypes.first;
      });

      return true;
    } else {
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
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Name',
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
                        labelText: 'Age',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFB44343)),
                        ),
                        filled: true,
                        fillColor: Color(0xFFFFECDE),
                      ),
                      controller: ageController,
                    ),
                    SizedBox(height: 10,),
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
                      controller: passwordController,
                    ),
                    SizedBox(height: 10,),
                    Container(
                      color: Color(0xFFFFECDE),
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          Text("Blood Types: ", style: TextStyle(fontSize: 16),),
                          SizedBox(width: 180,),
                          DropdownButton(
                            value: dropdownValue,
                            items: bloodTypes.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: (){
                        if(!_saveUser()){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill in all fields.', style: TextStyle(fontSize: 16),),
                              duration: Duration(seconds: 2), // Duration for Snackbar display
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Text("Sign Up", style: TextStyle(color: Colors.black, fontSize: 25),),
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
            SizedBox(height: 64,),
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