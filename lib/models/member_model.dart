import 'package:flutter/foundation.dart';
import 'package:flutter_calendar/app_state/user_state.dart';
import 'package:flutter_calendar/services/service_locator.dart';

import 'contact_model.dart';

enum Role { _from, admin, member, noRole }

extension RoleExtension on Role {
  String get toShortString => describeEnum(this);
  operator [](String key) => (name) {
        switch (name) {
          case 'admin':
            return Role.admin;
          case 'member':
            return Role.member;
          default:
            return Role.noRole;
        }
      }(key);
}

class MemberModel {
  final String uid;
  final String nickname;
  final Role role;
  MemberModel({this.uid, this.nickname, this.role});

  factory MemberModel.fromMap({Map<String, dynamic> member, String uid = ''}) {
    UserState userState = locator<UserState>();
    // has the user set a nick name for the member?
    Map<String, ContactModel> userContacts = userState.customContactData;
    if (userContacts[uid] != null && userContacts[uid].nickname != '') {
      member['displayName'] = userContacts[uid].nickname;
    }
    return MemberModel(
      uid: uid,
      nickname: member['displayName'] ?? '',
      role: Role._from[member['role'] ?? ''],
    );
  }

  Map toMap() {
    return {
      uid: {
        "displayName": nickname,
        "role": role.toShortString,
      }
    };
  }
}
