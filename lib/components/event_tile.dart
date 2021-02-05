import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_calendar/components/list_member_avatars.dart';
import 'package:flutter_calendar/models/models.dart';

class EventTile extends StatelessWidget {
  final Function gotoEvent;
  final EventModel event;

  const EventTile({Key key, this.gotoEvent, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _titleStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
    final _textStyle = TextStyle(fontSize: 13);
    return InkWell(
      onTap: gotoEvent,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // time
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TimeOfDay.fromDateTime(event.timestamp).format(context),
                    style: _titleStyle,
                  ),
                  Text('3h', style: _textStyle),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.title,
                        style: _titleStyle, textAlign: TextAlign.left),
                    Text(event.notes,
                        style: _textStyle, textAlign: TextAlign.left),
                  ],
                ),
              ),
            ),
            Container(
              width: 75,
              height: double.infinity,
              child: ListMemberAvatars(
                members: event.memberRoles,
                maxNum: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
