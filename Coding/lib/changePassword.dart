import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';

class changePassword extends StatefulWidget {
  late User user;
  changePassword({super.key, required this.user});

  @override
  State<changePassword> createState() => _changePasswordState();
}

class _changePasswordState extends State<changePassword> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? currentPassword; // Store the user's current password

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  late String theme;

  @override
  void initState() {
    super.initState();
    theme = widget.user.theme ?? 'Light';
    _fetchCurrentPassword(); // Fetch the current password on screen initialization
  }

  Future<void> _fetchCurrentPassword() async {
    try {
      // Fetch the user's document by ID
      DocumentSnapshot userDoc = await users.doc(widget.user.id).get();

      if (userDoc.exists) {
        setState(() {
          currentPassword = userDoc['password']; // Store the current password
        });
      } else {
        print('User document not found!');
      }
    } catch (e) {
      print('Error fetching current password: $e');
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      // Update the password in the Firestore document
      await users.doc(widget.user.id).update({
        'password': newPassword,
      });

      // Update the current password stored in the state
      setState(() {
        currentPassword = newPassword;
      });
    } catch (e) {
      print('Error updating password: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme == 'Light'
          ? Color(0xFFFFFBF3)
          : Color(0xFF373737),
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
                labelStyle: TextStyle(color: theme=='Light'?Colors.black:Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFB44343)),
                ),
                filled: true,
                fillColor: theme=='Light'?Color(0xFFFFECDE):Color(0xFF3E3E3E),
              ),
              obscureText: true,
              controller: newPasswordController,
            ),
            SizedBox(height: 20,),
            TextField(
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: TextStyle(color: theme=='Light'?Colors.black:Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFB44343)),
                ),
                filled: true,
                fillColor: theme=='Light'?Color(0xFFFFECDE):Color(0xFF3E3E3E),
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
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB44343),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(color: Colors.black, width: 3)
                  )
              ),
              child: Text("Change Password", style: TextStyle(color: Colors.black, fontSize: 25),),
            ),
          ],
        ),
      ),
    );
  }
}