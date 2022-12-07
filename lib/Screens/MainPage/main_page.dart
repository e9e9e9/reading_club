import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_club/Screens/Clubs/clubs.dart';
import 'package:reading_club/Screens/Create/create_screen.dart';
import 'package:reading_club/Screens/Profile/profile.dart';
import 'package:reading_club/components/bottom_naviagation.dart';
import 'package:reading_club/globals.dart';
import 'package:reading_club/Model/user.dart' as AppUser;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      currentUser = AppUser.User(
          email: FirebaseAuth.instance.currentUser!.email.toString());
    } else {
      currentUser = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.purple[100],
      ),
      bottomNavigationBar:
          BottomNaviagation(index: index, callback: setIndexState),
      body: getContent(index),
    );
  }

  getContent(int index) {
    print(FirebaseAuth.instance.currentUser?.email);

    switch (index) {
      case 0:
        return Clubs();
      case 1:
        return CreateScreen();
      case 2:
        return Profile();
      default:
        break;
    }
  }

  setIndexState(int indexParam) {
    setState(() {
      index = indexParam;
    });
  }
}
