import 'package:store1/HomeScreen.dart';
import 'package:store1/SignInScreen.dart';
import 'package:flutter/material.dart';
import 'package:store1/notificantions.dart';
import 'SignInScreen.dart';
import 'HomeScreen.dart';
import 'notificantions.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
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