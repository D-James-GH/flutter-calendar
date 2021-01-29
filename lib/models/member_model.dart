import 'package:flutter/foundation.dart';

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
  final String displayName;
  final Role role;
  MemberModel({this.uid, this.displayName, this.role});

  factory MemberModel.fromMap({Map<String, dynamic> member, String uid = ''}) {
    return MemberModel(
      uid: uid,
      displayName: member['displayName'] ?? '',
      role: Role._from[member['role'] ?? ''],
    );
  }

  Map toMap() {
    return {
      uid: {
        "displayName": displayName,
        "role": role.toShortString,
      }
    };
  }
}
