import 'package:store1/HomeScreen.dart';
import 'package:store1/SignInScreen.dart';
import 'package:flutter/material.dart';
import 'SignInScreen.dart';
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
      home:
      HomeScreen(addToCart: (CartItem ) {  }, user: {}, phoneNumber: '', ),
      debugShowCheckedModeBanner: false,
    );
  }
}