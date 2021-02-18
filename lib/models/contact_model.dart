// class ContactsListModel {
//   final List<ContactModel> contacts;
//
//   ContactsListModel({this.contacts});
//
//   factory ContactsListModel.fromMap(Map<String, dynamic> contactDoc) {
//     List<ContactModel> contacts = [];
//     contactDoc.forEach(
//         (key, value) => contacts.add(ContactModel.fromMap({key: value})));
//     return ContactsListModel(contacts: contacts);
//   }
//   Map<String, dynamic> toMap() {
//     Map<String, dynamic> output = {};
//     contacts.forEach((element) {
//       output[element.userID] = {
//         'nickname': element.nickname,
//       };
//     });
//     return output;
//   }
// }

class ContactModel {
  final String userID;
  final String nickname;

  ContactModel({this.userID, this.nickname = ''});

  Map<String, dynamic> toMap() {
    return {
      userID: {
        'nickname': nickname,
      }
    };
  }
}
