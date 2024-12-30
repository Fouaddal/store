import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'HomeScreen.dart'; // Import HomeScreen
import 'AccountScreen.dart'; // Import AccountScreen
import 'SignInScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _codeSent = false;
  bool _otpVerified = false;

  Future<void> sendSms() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/send-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'phoneNumber': _phoneNumberController.text}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Message sent successfully: ${jsonResponse['message']}');
        setState(() {
          _codeSent = true;
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
        body: jsonEncode({
          'phoneNumber': _phoneNumberController.text,
          'otp': _otpController.text
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('OTP verified successfully: ${jsonResponse['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP verified successfully!')),
        );
        setState(() {
          _otpVerified = true;
        });
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

  Future<void> signUp() async {
    if (_nameController.text.isEmpty ||
        _nicknameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    // Create a user map
    Map<String, dynamic> user = {
      'first_name': _nameController.text,
      'last_name': _nicknameController.text,
      'email': _emailController.text,
      'phone_number': _phoneNumberController.text,
    };

    print('User data: ${jsonEncode(user)}'); // Debugging line

    // Navigate to HomeScreen with the user data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          phoneNumber: _phoneNumberController.text,
          addToCart: (item) {}, // Placeholder for addToCart function
          user: user, // Pass user data to HomeScreen
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text(
          'Sign Up',
          style: TextStyle(
            fontFamily: 'Merriweather',
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Name',
              hintStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'Merriweather',
                fontSize: 20,
              ),
              prefixIcon: Icon(Icons.person, color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _nicknameController,
            decoration: InputDecoration(
              hintText: 'Nickname',
              hintStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'Merriweather',
                fontSize: 20,
              ),
              prefixIcon: Icon(Icons.tag, color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'Email',
              hintStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'Merriweather',
                fontSize: 20,
              ),
              prefixIcon: Icon(Icons.email, color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _phoneNumberController,
            decoration: InputDecoration(
              hintText: 'Phone Number',
              hintStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'Merriweather',
                fontSize: 20,
              ),
              prefixIcon: Icon(Icons.phone, color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16.0),
          if (_codeSent)
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                hintText: 'OTP',
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Merriweather',
                  fontSize: 20,
                ),
                prefixIcon: Icon(Icons.lock, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 5.0),
            child: ElevatedButton(
              onPressed: _codeSent ? verifyOtp : sendSms,
              child: Text(_codeSent ? 'Verify OTP' : 'Send SMS'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                textStyle: TextStyle(
                  fontFamily: 'Merriweather',
                  fontSize: 18,
                ),
              ),
            ),
          ),
          if (_otpVerified)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 5.0),
              child: ElevatedButton(
                onPressed: signUp,
                child: Text('Sign Up'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontFamily: 'Merriweather',
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already have an account?'),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                },
                child: Text('Sign In'),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}
