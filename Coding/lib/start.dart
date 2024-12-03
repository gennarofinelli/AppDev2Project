import 'package:flutter/material.dart';
import 'login.dart';
import 'signUp.dart';

class start extends StatefulWidget {
  const start({super.key});

  @override
  State<start> createState() => _startState();
}

class _startState extends State<start> {

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
            SizedBox(height: 100,),
            Text("Welcome", style: TextStyle(fontSize: 25),),
            SizedBox(height: 10,),
            SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>login()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB44343),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: Colors.black, width: 3)
                    )
                ),
                child: Text("LOGIN", style: TextStyle(color: Colors.black, fontSize: 25),),
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>signUp()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB44343),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: Colors.black, width: 3)
                    )
                ),
                child: Text("SIGN UP", style: TextStyle(color: Colors.black, fontSize: 25),),
              ),
            ),
            SizedBox(height: 228,),
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
