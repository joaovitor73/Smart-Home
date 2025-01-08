import 'package:flutter/material.dart';

Widget buildRoutineSection(
  BuildContext context, {
  required String title,
  required List<Map<String, String>> routines,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      SizedBox(height: 10),
      ...routines.map((routine) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              routine['item']!,
              style: TextStyle(fontSize: 16),
            ),
            Text(
              routine['action']!,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        );
      }).toList(),
    ],
  );
}
