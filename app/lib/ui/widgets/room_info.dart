import 'package:flutter/material.dart';

class RoomInfo extends StatelessWidget {
  final String roomName;
  final IconData icon;

  RoomInfo({required this.roomName, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 20, 0, 20),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Color.fromARGB(141, 0, 0, 0)),
          SizedBox(width: 10),
          Text(
            roomName,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
