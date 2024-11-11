import 'package:flutter/material.dart';

class events extends StatefulWidget {
  const events({super.key});

  @override
  State<events> createState() => _eventsState();
}

class _eventsState extends State<events> {
  String _month = "November";
  int _monthIndex = 0;

  void _getMonth(int index){
    setState(() {
      switch(index){
        case 0:
          _month = "January";
          break;
        case 1:
          _month = "February";
          break;
        case 2:
          _month = "March";
          break;
        case 3:
          _month = "April";
          break;
        case 4:
          _month = "May";
          break;
        case 5:
          _month = "June";
          break;
        case 6:
          _month = "July";
          break;
        case 7:
          _month = "August";
          break;
        case 8:
          _month = "September";
          break;
        case 9:
          _month = "October";
          break;
        case 11:
          _month = "November";
          break;
        case 12:
          _month = "December";
          break;

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 50,
                child: ElevatedButton(
                  onPressed: (){
                    setState(() {
                      _monthIndex--;
                      if(_monthIndex<0){
                        _monthIndex = 12;
                      }
                      _getMonth(_monthIndex);
                    });
                  },
                  child: Icon(Icons.arrow_left, color: Colors.black, size: 50,),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Color(0xFFFFFBF3),
                  ),
                ),
              ),
              SizedBox(width: 90,),
              Text(_month, style: TextStyle(fontSize: 24),),
              SizedBox(width: 90,),
              SizedBox(
                width: 50,
                child: ElevatedButton(
                  onPressed: (){
                    setState(() {
                      _monthIndex++;
                      if(_monthIndex>12){
                        _monthIndex = 0;
                      }
                      _getMonth(_monthIndex);
                    });
                  },
                  child: Icon(Icons.arrow_right, color: Colors.black, size: 50,),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Color(0xFFFFFBF3),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
