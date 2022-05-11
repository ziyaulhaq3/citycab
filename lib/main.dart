
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gettaxiii/pages/home/home.dart';
import 'package:gettaxiii/repositories/user_repository.dart';
import 'package:gettaxiii/ui/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    UserRepository.instance.signInCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'City Cab',
      theme: CityTheme.theme,
      home: HomePage(),
    );
  }
}
