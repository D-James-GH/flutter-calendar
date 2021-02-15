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
                    Text(
                      TimeOfDay.fromDateTime(event.startTimestamp)
                          .format(context),
                      style: _titleStyle,
                    ),
                    Text('3h', style: _textStyle),
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
                        color: Theme.of(context).primaryColor.withOpacity(0.7),
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
}
