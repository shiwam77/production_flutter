import 'package:flutter/material.dart';


class MyHeaderDrawer extends StatefulWidget{

  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();

}

class _MyHeaderDrawerState extends State<MyHeaderDrawer>{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[700],
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 60.0),
      child: Column(children: [
        Container(
          margin: EdgeInsets.only(bottom: 10),
          height: 70,
          decoration: BoxDecoration( 
            shape:BoxShape.circle,
            image: DecorationImage(image: AssetImage('image/userlogo.png'),
            ),
            ),
        ),
        Text(
          "Sajil Maharjan",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        Text(
          "sajil.maarjan@gmail.com",
          style: TextStyle(
            color: Colors.grey[200],
            fontSize: 14,
          ),
        ),
      ],
      ),
    );
  }
}