import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mainScreen.dart';
import 'user.dart';

const List<String> languages = <String>['English', 'French'];
const List<String> languagesFR = <String>['Anglais', 'Francais'];
const List<String> appearance = <String>['Light', 'Dark'];
const List<String> appearanceFR = <String>['Lumiere', 'Sombre'];


class settings extends StatefulWidget {
  late User user;
  settings({required this.user});

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  late String theme;
  late String lang;
  late String langDropdownValue;
  late String appearDropdownValue;


  @override
  void initState() {
    theme = widget.user.theme ?? 'Light';
    lang = widget.user.lang ?? 'English';
    langDropdownValue = languages.contains(widget.user.lang)? widget.user.lang! : languages.first;
    appearDropdownValue = appearance.contains(widget.user.theme) ? widget.user.theme! : appearance.first;
  }

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> _updateUserLang(String updatedLang) async {
    QuerySnapshot userSnapshot = await users
        .where('email', isEqualTo: widget.user.email)
        .get();

    DocumentSnapshot user = userSnapshot.docs.first;
    String id = user.id;

    await users.doc(id).update({
      'lang' : updatedLang
    });
    setState(() {
      widget.user.lang = updatedLang;
      lang = updatedLang;
    });
  }

  Future<void> _updateUserTheme(String updatedTheme) async {
    QuerySnapshot userSnapshot = await users
        .where('email', isEqualTo: widget.user.email)
        .get();

    DocumentSnapshot user = userSnapshot.docs.first;
    String id = user.id;

    await users.doc(id).update({
      'theme' : updatedTheme
    });
    setState(() {
      widget.user.theme = updatedTheme;
      theme = updatedTheme;
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
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            title: Text(
              lang=='English'
                  ? 'General'
                  : 'Général',
              style: TextStyle(color: Color(0xFFB44343)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.language, color: theme=='Light'?Colors.black:Colors.white,),
            title: Text(
              lang=='English'
                  ? 'Language'
                  : 'Langue',
              style: TextStyle(color: theme=='Light'?Colors.black:Colors.white,),
            ),
            //subtitle: Text("English"),
            trailing: DropdownButton(
              value: langDropdownValue,
              items: languages.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: theme=='Light'?Colors.black:Colors.white,),),
                );
              }).toList(),
              dropdownColor: theme == 'Light' ? Colors.white : Colors.black,
              onChanged: (String? value) async{
                setState(() {
                  langDropdownValue = value!;
                });
                await _updateUserLang(langDropdownValue);
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => mainScreen(selectIndex: 0, user: widget.user)), (Route<dynamic> route)=> false);
              },
            ),
          ),
          SizedBox(
            height: 25,
          ),
          ListTile(
            leading: Icon(Icons.sunny, color: theme=='Light'?Colors.black:Colors.white,),
            title: Text(
              lang=='English'
                  ? 'Appearance'
                  : 'Apparance',
              style: TextStyle(color: theme=='Light'?Colors.black:Colors.white,),
            ),
            trailing: DropdownButton(
              value: appearDropdownValue,
              items: appearance.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: theme=='Light'?Colors.black:Colors.white,),),
                );
              }).toList(),
              dropdownColor: theme == 'Light' ? Colors.white : Colors.black,
              onChanged: (String? value) async{
                setState(() {
                  appearDropdownValue = value!;
                });
                await _updateUserTheme(appearDropdownValue);
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => mainScreen(selectIndex: 0, user: widget.user)), (Route<dynamic> route)=> false);
              },
            ),
            //onTap: (){},
          ),
          const Divider(
            color: Colors.black45,
            height: 1,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
