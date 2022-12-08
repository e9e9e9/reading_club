import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reading_club/globals.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';

import 'package:uuid/uuid.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CreateForm extends StatefulWidget {
  final String? restorationId;

  const CreateForm({Key? key, this.restorationId}) : super(key: key);

  @override
  State<CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> with RestorationMixin {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final locController = TextEditingController();
  final timeController = TextEditingController();

  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime(2022, 12, 18));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      print('onPresent');
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );
  bool isDateSelected = false;
  bool isTimeSelected = false;
  bool isValidatedValue = false;
  int hour = 0;
  int minute = 0;
  DateTime? confirmedDate;
  final DateFormat formatter = DateFormat('HH:mm');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.addListener(() {
      isValidated();
    });
    descController.addListener(() {
      isValidated();
    });
    locController.addListener(() {
      isValidated();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
            child: TextFormField(
              controller: nameController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onChanged: (changed) {
                isValidated();
              },
              onFieldSubmitted: (data) {
                print('onFieldSubmitted');
                setState(() {});
              },
              onEditingComplete: () {
                print('onEditingComplete');
                setState(() {});
              },
              onSaved: (data) {
                print('onSaved');
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: "모임명",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.group),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: descController,
              cursorColor: kPrimaryColor,
              onSaved: (data) {
                print('onSaved');
                setState(() {});
              },
              onChanged: (changed) {
                isValidated();
              },
              decoration: InputDecoration(
                hintText: "모임 설명",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.description),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: locController,
              cursorColor: kPrimaryColor,
              onChanged: (changed) {
                isValidated();
              },
              onSaved: (data) {
                print('onSaved');
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: "위치",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.location_on),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
            child: TextFormField(
              onTap: () => _restorableDatePickerRouteFuture.present(),
              readOnly: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: isDateSelected
                    ? '${_selectedDate.value.year}/${_selectedDate.value.month}/${_selectedDate.value.day}'
                    : "모임 날짜",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.calendar_month),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
            child: TextFormField(
              onTap: isDateSelected
                  ? () => DatePicker.showTimePicker(context,
                          showTitleActions: true,
                          showSecondsColumn: false, onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        isTimeSelected = true;
                        hour = date.hour;
                        minute = date.minute;
                        if (isDateSelected && isTimeSelected) {
                          confirmedDate = DateTime(
                              _selectedDate.value.year,
                              _selectedDate.value.month,
                              _selectedDate.value.day,
                              date.hour,
                              date.minute);
                        }
                        setState(() {});
                        print('confirm $confirmedDate');
                      }, currentTime: DateTime.now(), locale: LocaleType.ko)
                  : () {},
              readOnly: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: confirmedDate != null
                    ? formatter.format(confirmedDate!)
                    : "모임 시간",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.timer),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          getCreateButton(),
          const SizedBox(height: defaultPadding),
        ],
      ),
    );
  }

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    print('_datePickerRoute');
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2020),
          lastDate: DateTime(2025),
        );
      },
    );
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        isDateSelected = true;
        _selectedDate.value = newSelectedDate;
        if (isDateSelected && isTimeSelected) {
          confirmedDate = DateTime(_selectedDate.value.year,
              _selectedDate.value.month, _selectedDate.value.day, hour, minute);
        }
        print('confirmedDate : $confirmedDate');
      });
    }
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // TODO: implement restoreState
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  getCreateButton() {
    if (isValidated()) {
      return ElevatedButton(
        onPressed: () async {
          String uuidValue = Uuid().v4();
          final json = {
            'id': uuidValue,
            'clubName': nameController.text.trim(),
            'desc': descController.text.trim(),
            'loc': locController.text.trim(),
            'members': FieldValue.arrayUnion([currentUser?.email]),
            'owner': currentUser?.email,
            'time': confirmedDate
          };
          try {
            final docRef =
                FirebaseFirestore.instance.collection('clubs').doc(uuidValue);
            await docRef.set(json);
            nameController.text = '';
            descController.text = '';
            locController.text = '';
            isDateSelected = false;
            confirmedDate = null;
            setState(() {});

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('모임이 정상적으로 만들어졌습니다!'),
            ));
          } catch (e) {
            print(e);
          }
        },
        child: Text("모임 만들기".toUpperCase()),
      );
    } else {
      return ElevatedButton(
        onPressed: () {},
        child: Text("모임 만들기".toUpperCase()),
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.grey)),
      );
    }
  }

  bool isValidated() {
    // print("""
    // isDateSelected : $isDateSelected,
    // isTimeSelected : $isTimeSelected,
    // nameController.text.trim() : ${nameController.text.trim()},
    // descController.text.trim() : ${descController.text.trim()},
    // locController.text.trim() : ${locController.text.trim()},
    // """);

    if (isDateSelected &&
        isTimeSelected &&
        nameController.text.trim() != "" &&
        descController.text.trim() != "" &&
        locController.text.trim() != "") {
      if (!isValidatedValue) {
        setState(() {});
      }
      isValidatedValue = true;
      return true;
    }
    if (isValidatedValue) {
      setState(() {});
    }
    isValidatedValue = false;
    return false;
  }
}
