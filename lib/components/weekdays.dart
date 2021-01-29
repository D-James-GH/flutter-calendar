import 'package:flutter/material.dart';

class Weekdays extends StatelessWidget {
  final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildWeekdays(),
    );
  }

  List<Widget> _buildWeekdays() {
    return daysOfWeek
        .map((day) => Container(
              margin: EdgeInsets.all(2),
              height: 20,
              width: 40,
              child: Center(
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ))
        .toList();
  }
}
