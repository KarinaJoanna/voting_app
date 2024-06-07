import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:voting_app/firebase_options.dart';
import 'package:voting_app/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(VotingApp());
}

class VotingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voting App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        cardTheme: CardTheme(
          margin: EdgeInsets.all(8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          color: Colors.white,
          shadowColor: Colors.black26,
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black),
        ),
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
          secondary: Colors.blueAccent,
        ),
      ),
      home: WelcomeScreen(),
    );
  }
}
