import 'package:flutter/material.dart';
import 'changePassword.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'user.dart';
import 'start.dart';

class profile extends StatefulWidget {
  late User user;
  profile({required this.user});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  File? cameraFile;

  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  CollectionReference registrations = FirebaseFirestore.instance.collection('Registrations');

  late String theme;
  late String lang;


  @override
  void initState() {
    super.initState();
    theme = widget.user.theme ?? 'Light';
    lang = widget.user.lang ?? 'English';
  }

  Future<void> _deleteUser(String name) async {
    try {
      var UquerySnapshot = await users.where('name', isEqualTo: name).get();
      var RquerySnapshot = await registrations.where('userName', isEqualTo: name).get();

      if (UquerySnapshot.docs.isNotEmpty) {
        var userDoc = UquerySnapshot.docs.first;
        var regDocs = RquerySnapshot.docs;
        await users.doc(userDoc.id).delete();
        for(var docs in regDocs){
          registrations.doc(docs.id).delete();
        }
      } else {
        print("User with this email does not exist.");
      }
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  selectFromCamera() async{
    ImagePicker _imagePicker = ImagePicker();
    XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        cameraFile = File(pickedFile.path);
      });
      
      await _updateUserProfile(pickedFile.path);
    } else{
      print('No image selected');
    }
  }

  Future<void> _updateUserProfile(String profile) async {
    QuerySnapshot userSnapshot = await users
        .where('email', isEqualTo: widget.user.email)
        .get();

    DocumentSnapshot user = userSnapshot.docs.first;
    String id = user.id;

    await users.doc(id).update({
      'profilePicture' : cameraFile!.path
    });
    setState(() {
      widget.user.profile = profile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 50,),
          Row(
            children: [
              SizedBox(width: 25,),
              ElevatedButton(
                onPressed: selectFromCamera,
                child: Expanded(
                  child: CircleAvatar(
                    backgroundColor: Color(0xFFFCD5D5),
                    backgroundImage: widget.user.profile == null
                        ? AssetImage("assets/profile.png")
                        : FileImage(File(widget.user.profile!)),
                    radius: 60,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(0),
                  backgroundColor: Colors.transparent,
                )
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lang=='English'?"Welcome":"Bienvenu", style: TextStyle(fontSize: 18, color: theme=='Light'?Colors.black:Colors.white),),
                  Text("${widget.user.name}", style: TextStyle(fontSize: 24, color: theme=='Light'?Colors.black:Colors.white)),
                  Text(lang=='English'?"Blood Type: ${widget.user.bloodType}":"Groupe sanguin: ${widget.user.bloodType}", style: TextStyle(fontSize: 16, color: theme=='Light'?Colors.black:Colors.white)),
                ],
              )
            ],
          ),
          SizedBox(height: 50,),
          Container(
            decoration: BoxDecoration(
              color: theme=='Light'?Color(0xFFFFECDE):Color(0xFF3E3E3E),
              border: Border(
                top: BorderSide(color: Colors.black, width: 2),
                bottom: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            child: Card(
              color: theme=='Light'?Color(0xFFFFECDE):Color(0xFF3E3E3E),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              child: ListTile(
                title: Text(lang=='English'?"Password: ":"Mot de passe: ", style: TextStyle(color: theme=='Light'?Colors.black:Colors.white),),
                trailing: ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => changePassword(user: widget.user),));
                  },
                  child: Text(lang=='English'?"Change Password":"Changer mot de passe", style: TextStyle(color: Colors.black, fontSize: 16),),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: Colors.black, width: 3)
                    ),
                    backgroundColor: Color(0xFFB44343),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 25,),
          Container(
            decoration: BoxDecoration(
              color: theme=='Light'?Color(0xFFFFECDE):Color(0xFF3E3E3E),
              border: Border(
                top: BorderSide(color: Colors.black, width: 2),
                bottom: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            child: Card(
              color: theme=='Light'?Color(0xFFFFECDE):Color(0xFF3E3E3E),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              child: ListTile(
                title: Text(lang=='English'?"Logout: ":"Déconnexion: ", style: TextStyle(color: theme=='Light'?Colors.black:Colors.white),),
                trailing: ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => start()), (Route<dynamic> route)=> false);
                  },
                  child: Text(lang=='English'?"Logout: ":"Déconnexion: ", style: TextStyle(color: Colors.black, fontSize: 16),),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: Colors.black, width: 3)
                    ),
                    backgroundColor: Color(0xFFB44343),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 125,),
          Container(
            decoration: BoxDecoration(
              color: theme=='Light'?Color(0xFFFFECDE):Color(0xFF3E3E3E),
              border: Border(
                top: BorderSide(color: Colors.black, width: 2),
                bottom: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            child: Card(
              color: theme=='Light'?Color(0xFFFFECDE):Color(0xFF3E3E3E),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              child: ListTile(
                title: ElevatedButton(
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(lang=='English'?"Delete Account":"Supprimer le compte"),
                          content: Text(lang=='English'?"Are you sure you want to delete account?":"Êtes-vous sûr de vouloir supprimer le compte?"),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: (){
                                _deleteUser(widget.user.name);
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => start()), (Route<dynamic> route)=> false);
                              },
                              child: Text(lang=='English'?"Yes":"Oui", style: TextStyle(color: Colors.black),),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    side: BorderSide(color: Colors.black, width: 3)
                                ),
                                backgroundColor: Color(0xFFB44343),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text(lang=='English'?"No":"Non", style: TextStyle(color: Colors.black),),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    side: BorderSide(color: Colors.black, width: 3)
                                ),
                                backgroundColor: Color(0xFFB44343),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(lang=='English'?"Delete Account":"Supprimer le compte", style: TextStyle(color: Colors.black, fontSize: 16),),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: Colors.black, width: 3)
                    ),
                    backgroundColor: Color(0xFFB44343),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
