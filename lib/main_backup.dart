import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late DatabaseReference _counterRef;
  late DatabaseReference _messagesRef;
  late StreamSubscription<DatabaseEvent> _counterSubscription;
  late StreamSubscription<DatabaseEvent> _messagesSubscription;
  bool _anchorToBottom = false;

  String _kTestKey = 'Hello';
  String _kTestValue = 'world!';
  FirebaseException? _error;
  bool initialized = false;
  final databaseReference = FirebaseDatabase.instance.ref();

  late CollectionReference _usersRef;
  late StreamSubscription<DatabaseEvent> _usersSubscription;
  List<dynamic> _users = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    _counterRef = FirebaseDatabase.instance.ref('counter');
    _usersRef = FirebaseFirestore.instance.collection('users');
    final database = FirebaseDatabase.instance;

    _messagesRef = database.ref('messages');

    database.setLoggingEnabled(false);

    if (!kIsWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }

    if (!kIsWeb) {
      await _counterRef.keepSynced(true);
    }

    setState(() {
      initialized = true;
    });

    try {
      final counterSnapshot = await _counterRef.get();
      final usersSnapshot = FirebaseFirestore.instance
          .collection('users')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map(
                (e) => e.data(),
              )
              .toList());

      print('Connected to directly configured database and read '
          '${counterSnapshot.value}'
          '${FirebaseFirestore.instance.collection('users')}'
          // '${usersSnapshot.value}',
          );
    } catch (err) {
      print(err);
    }
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      print(event.docs.first.data());
    });
    _counterSubscription = _counterRef.onValue.listen(
      (DatabaseEvent event) {
        setState(() {
          _error = null;
          _counter = (event.snapshot.value ?? 0) as int;
        });
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        setState(() {
          _error = error;
        });
      },
    );

    // _usersSubscription = _usersRef.onValue.listen(
    //   (DatabaseEvent event) {
    //     setState(() {
    //       _error = null;
    //       _users = (event.snapshot.value ??
    //           [
    //             {'name': 'default'}
    //           ]) as List<dynamic>;
    //     });
    //   },
    //   onError: (Object o) {
    //     final error = o as FirebaseException;
    //     setState(() {
    //       _error = error;
    //     });
    //   },
    // );

    final messagesQuery = _messagesRef.limitToLast(10);

    _messagesSubscription = messagesQuery.onChildAdded.listen(
      (DatabaseEvent event) {
        print('Child added: ${event.snapshot.value}');
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        print('Error: ${error.code} ${error.message}');
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _messagesSubscription.cancel();
    _counterSubscription.cancel();
  }

  Future<void> _increment() async {
    print('_increment pressed');
    // await _counterRef.set(ServerValue.increment(1));
    print('increment');
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc('5FgugKcFy0FmmZQ99U8T');
    final json = {'age': 10};

    print('update');
    docUser
        .update(json)
        .then((value) => print('success'))
        .onError((error, stackTrace) {
      print('error is occured');
      print(error);
    });

    await _messagesRef
        .push()
        .set(<String, String>{_kTestKey: '$_kTestValue $_counter'});
  }

  Future<void> _incrementAsTransaction() async {
    // try {
    //   final transactionResult = await _counterRef.runTransaction((mutableData) {
    //     return Transaction.success((mutableData as int? ?? 0) + 1);
    //   });

    //   if (transactionResult.committed) {
    //     final newMessageRef = _messagesRef.push();
    //     await newMessageRef.set(<String, String>{
    //       _kTestKey: '$_kTestValue ${transactionResult.snapshot.value}'
    //     });
    //   }
    // } on FirebaseException catch (e) {
    //   print(e.message);
    // }
  }

  Future<void> _deleteMessage(DataSnapshot snapshot) async {
    final messageRef = _messagesRef.child(snapshot.key!);
    await messageRef.remove();
  }

  void _setAnchorToBottom(bool? value) {
    if (value == null) {
      return;
    }

    setState(() {
      _anchorToBottom = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) return Container();

    //   return Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Flutter Database Example'),
    //     ),
    //     body: Column(
    //       children: [
    //         Flexible(
    //           child: Center(
    //             child: _error == null
    //                 ? Text(
    //                     'Button tapped $_counter time${_counter == 1 ? '' : 's'}.\n\n'
    //                     'user name is ${_users.isNotEmpty ? _users[0]["name"] : 'unknown'}.\n\n'
    //                     'This includes all devices, ever.',
    //                   )
    //                 : Text(
    //                     'Error retrieving button tap count:\n${_error!.message}',
    //                   ),
    //           ),
    //         ),
    //         ElevatedButton(
    //           onPressed: _incrementAsTransaction,
    //           child: const Text('Increment as transaction'),
    //         ),
    //         ListTile(
    //           leading: Checkbox(
    //             onChanged: _setAnchorToBottom,
    //             value: _anchorToBottom,
    //           ),
    //           title: const Text('Anchor to bottom'),
    //         ),
    //         Flexible(
    //           child: FirebaseAnimatedList(
    //             key: ValueKey<bool>(_anchorToBottom),
    //             query: _messagesRef,
    //             reverse: _anchorToBottom,
    //             itemBuilder: (context, snapshot, animation, index) {
    //               return SizeTransition(
    //                 sizeFactor: animation,
    //                 child: ListTile(
    //                   trailing: IconButton(
    //                     onPressed: () => _deleteMessage(snapshot),
    //                     icon: const Icon(Icons.delete),
    //                   ),
    //                   title: Text('$index: ${snapshot.value.toString()}'),
    //                 ),
    //               );
    //             },
    //           ),
    //         ),
    //       ],
    //     ),
    //     floatingActionButton: FloatingActionButton(
    //       onPressed: _increment,
    //       tooltip: 'Increment',
    //       child: const Icon(Icons.add),
    //     ),
    //   );
    // }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('images/main.jpeg')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            TextButton(
              onPressed: () {
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => MyHomePage(
                                title: 'hi',
                              )));
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            Text('New User? Create Account')
          ],
        ),
      ),
    );
  }
}
