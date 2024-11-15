import 'package:flutter/material.dart';

const List<String> languages = <String>['English', 'French'];
const List<String> appearance = <String>['Light', 'Dark'];


class settings extends StatefulWidget {
  const settings({super.key});

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  String langDropdownValue = languages.first;
  String appearDropdownValue = appearance.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFBF3),
      appBar: AppBar(
        title: Text("BloodLife", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Color(0xFFB44343),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            title: const Text(
              "General",
              style: TextStyle(color: Color(0xFFB44343)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: const Text(
                "Language"
            ),
            //subtitle: Text("English"),
            trailing: DropdownButton(
              value: langDropdownValue,
              items: languages.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  langDropdownValue = value!;
                });
              },
            ),
            //onTap: (){},
          ),
          SizedBox(
            height: 25,
          ),
          ListTile(
            leading: Icon(Icons.sunny),
            title: const Text(
                "Appearance"
            ),
            trailing: DropdownButton(
              value: appearDropdownValue,
              items: appearance.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  appearDropdownValue = value!;
                });
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
