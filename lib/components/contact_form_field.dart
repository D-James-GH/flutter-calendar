import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/list_member_avatars.dart';
import 'package:flutter_calendar/models/models.dart';
import 'package:flutter_calendar/screens/screens.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactSelectFormField extends FormField<List<MemberModel>> {
  ContactSelectFormField({
    Key key,
    @required List<MemberModel> initialValue,
    FormFieldSetter<List<MemberModel>> onSaved,
  }) : super(
            key: key,
            onSaved: onSaved,
            initialValue: initialValue,
            builder: (FormFieldState<List<MemberModel>> state) {
              return (state as _ContactSelectFormFieldState)._constructWidget();
            });
  @override
  FormFieldState<List<MemberModel>> createState() {
    return _ContactSelectFormFieldState();
  }
}

class _ContactSelectFormFieldState extends FormFieldState<List<MemberModel>> {
  List<MemberModel> _members;

  @override
  void initState() {
    super.initState();
    _members = widget.initialValue;
  }

  Widget _constructWidget() {
    return Row(
      children: [
        ListMemberAvatars(
          members: _members,
          showNames: true,
          maxNum: 5,
        ),
        Expanded(
          child: Text(''),
        ),
        RaisedButton(
          shape: CircleBorder(),
          color: Theme.of(context).primaryColor,
          child: Icon(
            FontAwesomeIcons.plus,
            color: Colors.white,
            size: 20,
          ),
          onPressed: _inviteMember,
        ),
      ],
    );
  }

  _addToMembers(UserModel contact) {
    var member = MemberModel(
      displayName: contact.displayName,
      uid: contact.uid,
      role: Role.member,
    );

    if (_contains(_members, member) == true) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Contact already invited')));
    } else {
      _members.add(member);
      this.didChange(_members);
    }
  }

  bool _contains(List<MemberModel> list, MemberModel member) {
    for (MemberModel m in list) {
      if (m.uid == member.uid) return true;
    }
    return false;
  }

  void _inviteMember() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        settings: RouteSettings(name: '/createChat'),
        builder: (_) => PickContactScreen(
          onTapContactFunction: _addToMembers,
        ),
      ),
    );
  }
}
