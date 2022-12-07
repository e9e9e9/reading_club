import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:reading_club/Model/club.dart';
import 'package:reading_club/Model/user.dart' as AppUser;
import 'package:reading_club/Model/user.dart';
import 'package:reading_club/constants.dart';
import 'package:intl/intl.dart';
import 'package:reading_club/globals.dart';

class Clubs extends StatefulWidget {
  const Clubs({Key? key}) : super(key: key);

  @override
  _ClubsState createState() => _ClubsState();
}

class _ClubsState extends State<Clubs> {
  List<dynamic> clubs = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('clubs').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        print('snapshot updated');
        if (snapshot.hasData) {
          clubs = snapshot.data.docs.map((doc) {
            print(doc.data());
            return Club.fromJson(doc.data());
          }).toList();
          return getClubList(clubs);
        } else {
          return Text('데이터를 로드하지 못했습니다.');
        }
      },
    );
  }

  getClubList(List<dynamic> clubs) {
    final f = DateFormat('yyyy-MM-dd hh:mm');

    return Column(
      children: [
        Expanded(
            child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  Club club = clubs[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: kPrimaryLightColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                Text(
                                  club.clubName,
                                  style: cardTitleStyle,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                Text(
                                  club.desc,
                                  style: TextStyle(),
                                ),
                              ],
                            ),
                          ),
                          Card(
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        '모임장',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        club.owner,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Icon(Icons.location_on)),
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        club.loc,
                                        style: TextStyle(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Icon(Icons.calendar_month)),
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        f.format(club.time),
                                        style: TextStyle(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 1, child: Icon(Icons.person)),
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        '${club.members.length.toString()}명',
                                        style: TextStyle(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                          getAttandButton(club),
                        ]),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemCount: clubs.length))
      ],
    );
  }

  getAttandButton(Club club) {
    print('currentUser?.email : ${currentUser?.email}');
    print('club.members : ${club.members}');

    bool isMember = false;

    for (User member in club.members) {
      if (member.email == currentUser?.email) {
        isMember = true;
        break;
      }
    }

    if (club.owner == currentUser?.email) {
      return ElevatedButton(
        onPressed: () async {
          final docRef =
              FirebaseFirestore.instance.collection('clubs').doc(club.id);

          await docRef.delete();
        },
        child: Text('모임 삭제'),
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.red)),
      );
    }
    if (isMember) {
      return ElevatedButton(
        onPressed: () async {
          final docRef =
              FirebaseFirestore.instance.collection('clubs').doc(club.id);

          await docRef.update({
            'members': FieldValue.arrayRemove([currentUser?.email])
          });
        },
        child: Text('참석 취소'),
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.red)),
      );
    } else {
      return ElevatedButton(
          onPressed: () async {
            Club? updatedClub;
            final docRef =
                FirebaseFirestore.instance.collection('clubs').doc(club.id);

            await docRef.update({
              'members': FieldValue.arrayUnion([currentUser?.email])
            });
            // setState(() {});
          },
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(kPrimaryColor)),
          child: Text('참석'));
    }
  }
}
