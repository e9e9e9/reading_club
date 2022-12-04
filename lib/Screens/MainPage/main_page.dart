import 'package:flutter/material.dart';
import 'package:reading_club/components/bottom_naviagation.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNaviagation(index: 0),
      body: Column(
        children: [Text('main page')],
      ),
    );
  }
}
