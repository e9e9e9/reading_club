import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_club/Model/user.dart';

class ClubField {
  static const String id = 'id';
  static const String clubName = 'clubName';
  static const String desc = 'desc';
  static const String loc = 'loc';
  static const String time = 'time';
  static const String owner = 'owner';
  static const String members = 'members';
}

class Club {
  String id;
  String clubName;
  String desc;
  String loc;
  DateTime time;
  String owner;
  List<User> members;

  Club({
    required this.id,
    required this.clubName,
    required this.desc,
    required this.loc,
    required this.time,
    required this.owner,
    required this.members,
  });

  Map<String, Object?> toJson() => {
        ClubField.id: id,
        ClubField.clubName: clubName,
        ClubField.desc: desc,
        ClubField.loc: loc,
        ClubField.time: time,
        ClubField.owner: owner,
        ClubField.members: members,
      };

  static Club fromJson(Map<String, Object?> json) {
    Timestamp t = json[ClubField.time] as Timestamp;
    print('obj : ${t}');
    return Club(
      id: json[ClubField.id] as String,
      clubName: json[ClubField.clubName] as String,
      desc: json[ClubField.desc] as String,
      loc: json[ClubField.loc] as String,
      time: t.toDate(),
      owner: json[ClubField.owner] as String,
      members: List<User>.from(json[ClubField.members]
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .split(',')
          .map((e) => User(email: e))),
    );
  }
}
