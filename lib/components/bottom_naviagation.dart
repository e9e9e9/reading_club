import 'package:flutter/material.dart';
import 'package:reading_club/Screens/Profile/profile.dart';

import '../Screens/MainPage/main_page.dart';

class BottomNaviagation extends StatelessWidget {
  final int index;
  final onPressed;

  const BottomNaviagation({
    Key? key,
    required this.index,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(
            fontSize: 8,
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontFamily: "Montserrat"),
        unselectedLabelStyle: TextStyle(
            fontSize: 8, color: Colors.black, fontFamily: "Montserrat"),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, size: 22),
            // activeIcon: Utils().getImage("images/ic_32_main_home_selected.png",
            //     width: rm.size(32), height: rm.size(32)),
            label: "모임 확인",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined, size: 22),
            // activeIcon: Utils().getImage(
            //     "images/ic_32_main_location_selected.png",
            //     width: rm.size(32),
            //     height: rm.size(32)),
            label: "모임 만들기",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 22),

            // activeIcon: Utils().getImage(
            //     "images/ic_32_main_history_selected.png",
            //     width: rm.size(32),
            //     height: rm.size(32)),
            label: "프로필",
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
                (Route<dynamic> route) => false,
              );
              break;
            case 1:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
                (Route<dynamic> route) => false,
              );
              break;
            case 2:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
                (Route<dynamic> route) => false,
              );
              break;
            default:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
                (Route<dynamic> route) => false,
              );
          }
        });
  }
}
