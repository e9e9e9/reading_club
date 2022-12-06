import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_club/main.dart';
import 'package:reading_club/constants.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        Text(
          FirebaseAuth.instance.currentUser!.email ?? "환영합니다!",
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: kPrimaryColor),
        ),
        const SizedBox(height: defaultPadding),
        Container(
          child: ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
                (Route<dynamic> route) => false,
              );
            },
            child: Text('로그아웃'),
          ),
        ),
      ],
    );
  }
}
