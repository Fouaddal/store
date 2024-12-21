import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'User.dart';
import 'HomeScreen.dart';

class AccountScreen extends StatefulWidget {
  final Map<String, dynamic>? user;

  AccountScreen({this.user});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isEditing = true;  // Variable to track if the user is editing

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _firstNameController.text = widget.user!['first_name'] ?? '';
      _lastNameController.text = widget.user!['last_name'] ?? '';
      _emailController.text = widget.user!['email'] ?? '';
    }
  }

  Future<void> _uploadData() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    User user = User(
      phoneNumber: widget.user?['phone_number'] ?? '',
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
    );

    final uri = Uri.parse('http://10.0.2.2:8000/api/users');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'users': [user.toJson()]}),
    );

    if (response.statusCode == 201) {
      print('Data uploaded successfully: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User data saved successfully')),
      );
      setState(() {
        _isEditing = false;  // Switch to view mode
      });
    } else {
      print('Failed to upload data: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save user data')),
      );
    }
  }

  void _editData() {
    setState(() {
      _isEditing = true;  // Switch to edit mode
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Screen'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: _editData,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            if (widget.user?['phone_number'] != null)
              Text(
                'Phone Number: ${widget.user!['phone_number']}',
                style: TextStyle(fontSize: 20),
              ),
            SizedBox(height: 16.0),
            _isEditing
                ? Column(
              children: [
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _uploadData,
                  child: Text('Save'),
                ),
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'First Name: ${_firstNameController.text}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Last Name: ${_lastNameController.text}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Email: ${_emailController.text}',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
