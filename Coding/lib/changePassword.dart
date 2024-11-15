import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'user.dart';
import 'start.dart';

class changePassword extends StatefulWidget {
  late Future<Database> database;
  late User user;
  changePassword({required this.database, required this.user});

  @override
  State<changePassword> createState() => _changePasswordState();
}

class _changePasswordState extends State<changePassword> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? currentPassword; // Store the user's current password

  @override
  void initState() {
    super.initState();
    _fetchCurrentPassword(); // Fetch the current password on screen initialization
  }

  Future<void> _fetchCurrentPassword() async {
    final db = await widget.database;

    // Retrieve the user's current password from the database using their ID
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      columns: ['password'],
      where: 'id = ?', // Filter by the user ID
      whereArgs: [widget.user.id],
    );

    if (result.isNotEmpty) {
      setState(() {
        currentPassword = result.first['password']; // Store the current password
      });
    }
  }


  @override
  Widget build(BuildContext context) {
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
            SizedBox(
              height: 200,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'New Password',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFB44343)),
                ),
                filled: true,
                fillColor: Color(0xFFFFECDE),
              ),
              obscureText: true,
              controller: newPasswordController,
            ),
            SizedBox(height: 20,),
            TextField(
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFB44343)),
                ),
                filled: true,
                fillColor: Color(0xFFFFECDE),
              ),
              obscureText: true,
              controller: confirmPasswordController,
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async{
                String newPassword = newPasswordController.text.trim();
                String confirmPassword = confirmPasswordController.text.trim();


                if (newPassword.isEmpty || confirmPassword.isEmpty) {
                  // Show a message if fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in both password fields.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                // Check if both passwords match
                if (newPassword != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Passwords do not match.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                // Check if the new password is the same as the current password
                if (currentPassword != null && newPassword == currentPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('New password cannot be the same as the current password.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                // Update password in the database
                try {
                  await updatePassword(newPassword);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password changed successfully!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update password. Please try again.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }

              },
              child: Text("Change Password", style: TextStyle(color: Colors.black, fontSize: 25),),
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
    );
  }
  Future<void> updatePassword(String newPassword) async {
    final db = await widget.database;

    // Assuming you have an 'id' field in the user table to identify the user
    await db.update(
      'users', // Your user table name
      {'password': newPassword}, // Update the password field
      where: 'id = ?', // Filter condition
      whereArgs: [widget.user.id], // Replace with actual user ID
    );

    // Update the current password stored in the state to the new one
    setState(() {
      currentPassword = newPassword;
    });
  }
}