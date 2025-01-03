import 'package:connect/SignInScreen.dart';
import 'package:flutter/material.dart';
import 'HomeScreen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Store',
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignInScreen(),  // Set the LoginScreen as the initial screen
      debugShowCheckedModeBanner: false,
    );
  }
}