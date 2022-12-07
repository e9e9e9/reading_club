import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_club/constants.dart';
import 'package:reading_club/responsive.dart';
import '../../components/background.dart';
import '../MainPage/main_page.dart';
import 'components/create_top_image.dart';
import 'components/create.dart';
import 'components/socal_create.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const CreateScreenTopImage(),
        Row(
          children: const [
            Spacer(),
            Expanded(
              flex: 8,
              child: CreateForm(
                restorationId: 'create_screen',
              ),
            ),
            Spacer(),
          ],
        ),
        // const SocalCreate()
      ],
    );
  }
}
