import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'SignInScreen.dart';
import 'User.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';



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
  bool _isEditing = true;

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

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'users': [user.toJson()]}),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User data saved successfully')),
        );
        setState(() {
          _isEditing = false;
        });
        // Update the text controllers with saved data
        setState(() {
          _firstNameController.text = user.firstName;
          _lastNameController.text = user.lastName;
          _emailController.text = user.email;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save user data: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }

  void _editData() {
    setState(() {
      _isEditing = true;
    });
  }

  File? image; // Variable to store the selected image
  Future<void> pickImageFromGallery() async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return; // If no image selected, exit

      setState(() {
        image = File(pickedImage.path); // Update the image and UI
      });
    } catch (e) {
      print('Failed to pick image: $e'); // Error handling
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title:
        Text(
          'Change Your Details',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Merriweather',
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: _editData,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Center(
            child: Container(
              height: 100.0,
              width: 100.0,
              child: FloatingActionButton(onPressed: pickImageFromGallery,
                child:image != null
                    ? ClipOval(child: Image.file(image!, height: double.infinity, width: double.infinity, fit: BoxFit.cover))
                    :Icon(Icons.add_a_photo,color: Colors.blue),
                backgroundColor: image !=null ? Colors.transparent:Colors.white,
                shape: CircleBorder() ,
              ),
            ),
          ),
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
                  prefixIcon: Icon(Icons.person,
                    color: Colors.blue,
                  ),
                  hintText: 'First Name',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Merriweather',
                    fontSize: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.tag,
                    color: Colors.blue,
                  ),
                  hintText: 'Last Name',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Merriweather',
                    fontSize: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_city,
                    color: Colors.blue,
                  ),
                  hintText: 'Location',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Merriweather',
                    fontSize: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _uploadData();
                },
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontFamily: 'Merriweather',
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'First Name: ${_firstNameController.text}',
                style: TextStyle(
                    fontFamily: 'Merriweather',
                    fontSize: 20),
              ),
              SizedBox(height: 16.0),
              Text(
                'Last Name: ${_lastNameController.text}',
                style: TextStyle(
                    fontFamily: 'Merriweather',
                    fontSize: 20),
              ),
              SizedBox(height: 16.0),
              Text(
                'Email: ${_emailController.text}',
                style: TextStyle(fontFamily: 'Merriweather',
                    fontSize: 20),
              ),
            ],
          ),
          Column(
            children: [
              ElevatedButton(onPressed:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              }, child: Text('Log out'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  textStyle: TextStyle(
                    fontFamily: 'Merriweather',
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          )
        ],
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