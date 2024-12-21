import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'HomeScreen.dart'; // Import HomeScreen

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String phoneNumber = "";
  String otp = "";
  bool codeSent = false;

  Future<void> sendSms() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/send-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'phoneNumber': phoneNumber}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Message sent successfully: ${jsonResponse['message']}');
        setState(() {
          codeSent = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Message sent successfully!')),
        );
      } else {
        print('Failed to send message: ${response.statusCode} - ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: $e')),
      );
    }
  }

  Future<void> verifyOtp() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/verify-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'phoneNumber': phoneNumber, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('OTP verified successfully: ${jsonResponse['message']}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              phoneNumber: phoneNumber, addToCart: (CartItem ) {  },
            ),
          ),
        );
      } else {
        print('Failed to verify OTP: ${response.statusCode} - ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to verify OTP: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying OTP: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                setState(() {
                  phoneNumber = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Phone Number',
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.0),
            if (codeSent)
              TextField(
                onChanged: (value) {
                  setState(() {
                    otp = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'OTP',
                ),
                keyboardType: TextInputType.number,
              ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: codeSent ? verifyOtp : sendSms,
              child: Text(codeSent ? 'Verify OTP' : 'Send SMS'),
            ),
          ],
        ),
      ),
    );
  }
}
