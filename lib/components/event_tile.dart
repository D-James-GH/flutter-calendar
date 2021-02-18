import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_calendar/components/list_member_avatars.dart';
import 'package:flutter_calendar/models/models.dart';

class EventTile extends StatelessWidget {
  final Function gotoEvent;
  final EventModel event;
  final bool isLight;
  final bool showDate;
  const EventTile(
      {Key key,
      this.isLight = false,
      this.showDate = false,
      this.gotoEvent,
      this.event})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _titleStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: isLight ? Colors.white : Theme.of(context).primaryColor,
    );
    final _textStyle = TextStyle(
        fontSize: 13,
        color: isLight ? Colors.white : Theme.of(context).primaryColor);
    return InkWell(
      onTap: gotoEvent,
      child: SizedBox(
        height: 80,
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.only(top: 2),
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
                    showDate
                        ? Text(DateFormat.yMMMd().format(event.startTimestamp),
                            style: TextStyle(color: Colors.white))
                        : Container(),
                    Text(
                      TimeOfDay.fromDateTime(event.startTimestamp)
                          .format(context),
                      style: _titleStyle,
                    ),
                    Text(
                        _eventTimeDuration(
                            event.startTimestamp, event.endTimestamp),
                        style: _textStyle),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 60,
                  ),
                  padding: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isLight
                            ? Colors.white.withOpacity(0.4)
                            : Theme.of(context).primaryColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(right: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.title,
                                  style: _titleStyle,
                                  textAlign: TextAlign.left),
                              Text(
                                event.notes,
                                style: _textStyle,
                                maxLines: 3,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 75,
                        height: double.infinity,
                        child: ListMemberAvatars(
                          isLight: isLight,
                          members: event.memberRoles,
                          maxNum: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _eventTimeDuration(DateTime start, DateTime end) {
    Duration dur = end.difference(start);
    if (dur.inHours >= 24) {
      return dur.inDays.toString() + " days";
    }
    if (dur.inHours <= 1) {
      return dur.inMinutes.toString() + " mins";
    }
    return dur.inHours.toString() + " h";
  }
}
