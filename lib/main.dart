import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lanka_go/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LankaGO',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: const Wrapper(),
    );
  }
}
