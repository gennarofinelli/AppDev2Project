import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'user.dart';
import 'home.dart';
import 'events.dart';
import 'notifications.dart';
import 'profile.dart';
import 'register.dart';
import 'start.dart';
import 'changePassword.dart';
import 'settings.dart';

class mainScreen extends StatefulWidget {
  late User user;
  int? selectIndex = 0;

  mainScreen({required this.user, this.selectIndex});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  late List<Widget> _widgetOptions;
  late String theme;
  late String lang;

  File? cameraFile;

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  @override
  void initState() {
    super.initState();
    theme = widget.user.theme ?? 'Light';
    lang = widget.user.lang ?? 'English';
    _widgetOptions = [
      home(user: widget.user,),
      events(user: widget.user),
      notifications(user: widget.user,),
      profile(user: widget.user,),
    ];
  }

  void _onItemTapped(int index){
    setState(() {
      widget.selectIndex=index;
    });
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
    return Scaffold(
      backgroundColor: theme == 'Light'
          ? Color(0xFFFFFBF3)
          : Color(0xFF373737),
      appBar: AppBar(
        title: Text("BloodLife", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Color(0xFFB44343),
      ),
      body: IndexedStack(
        index: widget.selectIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home),
            label:lang=='English'?"Home":"Maison",
            backgroundColor: Color(0xFFB44343),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today),
            label:lang=='English'?"Events":"Événements",
            backgroundColor: Color(0xFFB44343),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.notifications),
            label:lang=='English'?"Notifications":"Notifications",
            backgroundColor: Color(0xFFB44343),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person),
            label:lang=='English'?"Profile":"Profil",
            backgroundColor: Color(0xFFB44343),
          )
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: widget.selectIndex!,
        selectedItemColor: Colors.black,
        iconSize: 40,
        onTap: _onItemTapped,
        elevation: 5,
      ),
      drawer: Drawer(
        backgroundColor: theme=='Light'?Color(0xFFFFECDE):Color(0xFF3E3E3E),
        child: ListView(
          //important: remove any padding from the ListView
          padding: EdgeInsets.zero,
          children: [
            Expanded(
              child: Container(
                color: Color(0xFFB44343),
                child: Column(
                  children: [
                    SizedBox(height: 50,),
                    ElevatedButton(
                        onPressed: selectFromCamera,
                        child: Expanded(
                          child: CircleAvatar(
                            backgroundColor: Color(0xFFFCD5D5),
                            backgroundImage: widget.user.profile == null
                                ? AssetImage("assets/profile.png")
                                : FileImage(File(widget.user.profile!)),
                            radius: 100,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(0),
                          backgroundColor: Colors.transparent,
                        )
                    ),
                    Text(widget.user.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: theme=='Light'?Colors.black:Colors.white),
              title: Text(lang=='English'?"Settings":"Paramètres", style: TextStyle(color: theme=='Light'?Colors.black:Colors.white),),
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=> settings(user: widget.user,)));
              },
              trailing: Icon(Icons.arrow_right, color: theme=='Light'?Colors.black:Colors.white),
            ),
            ListTile(
              leading: Icon(Icons.lock, color: theme=='Light'?Colors.black:Colors.white),
              title: Text(lang=='English'?"Logout":"Déconnexion", style: TextStyle(color: theme=='Light'?Colors.black:Colors.white),),
              onTap: (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => start()), (Route<dynamic> route)=> false);
              },
              trailing: Icon(Icons.arrow_right, color: theme=='Light'?Colors.black:Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
