import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'HomeScreen.dart';
import 'SignUp.dart';

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
              phoneNumber: phoneNumber,
              addToCart: (item) {},
              user: {
                'phone_number': phoneNumber,
              },
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Welcome Back',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Merriweather' ,
            fontSize: 30,
          ) ,
        ),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/730_generated.jpg',
              height: 200,
            ),
            Text(
              'Sign In to your account',
              style: TextStyle(
                fontFamily: 'Merriweather',
                fontSize: 15,
              ),
            ),
            SizedBox(height: 20.0,),
            TextField(
              onChanged: (value) {
                setState(() {
                  phoneNumber = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Phone Number',
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Merriweather' ,
                  fontSize: 20,
                ),
                prefixIcon: Icon(Icons.phone,color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),

                ),
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
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Merriweather' ,
                    fontSize: 20,
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),

                keyboardType: TextInputType.number,
              ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: codeSent ? verifyOtp : sendSms,
              child: Text(codeSent ? 'Verify OTP  ' : 'Send SMS'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                textStyle: TextStyle(
                  fontFamily: 'Merriweather',
                  fontSize: 18,
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account?'),
                TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>SignUpScreen()),
                    );
                  },
                  child: Text('Sing Up') ,
                )
              ],
            ),

          ],
        ),
      ),
    );

  }
}