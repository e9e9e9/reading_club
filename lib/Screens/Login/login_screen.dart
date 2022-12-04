import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_club/Screens/MainPage/main_page.dart';
import 'package:reading_club/Screens/Welcome/welcome_screen.dart';
import 'package:reading_club/main_backup.dart';
import 'package:reading_club/responsive.dart';

import '../../components/background.dart';
import 'components/login_form.dart';
import 'components/login_screen_top_image.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileLoginScreen(),
          desktop: Row(
            children: [
              const Expanded(
                child: LoginScreenTopImage(),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 450,
                      child: LoginForm(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: <Widget>[
    //     const LoginScreenTopImage(),
    //     Row(
    //       children: const [
    //         Spacer(),
    //         Expanded(
    //           flex: 8,
    //           child: LoginForm(),
    //         ),
    //         Spacer(),
    //       ],
    //     ),
    //   ],
    // );
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          Future.delayed(
              const Duration(microseconds: 500),
              () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                    (Route<dynamic> route) => false,
                  ));

          return Column();
          // return MainPage();
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const LoginScreenTopImage(),
              Row(
                children: const [
                  Spacer(),
                  Expanded(
                    flex: 8,
                    child: LoginForm(),
                  ),
                  Spacer(),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}
