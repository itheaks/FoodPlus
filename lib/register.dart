import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'impscreen.dart';


class RegisterScreen extends StatefulWidget {
  final User user;
  final bool isEditMode;

  RegisterScreen(this.user, {this.isEditMode = false});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  _fetchUserData() async {
    if (widget.isEditMode) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference usersCollection = firestore.collection('users');
      String userUID = widget.user.uid;

      try {
        DocumentSnapshot snapshot = await usersCollection.doc(userUID).get();

        if (snapshot.exists) {
          String name = snapshot.get('name');
          String address = snapshot.get('address');
          String phoneNumber = snapshot.get('phoneNumber');

          nameController.text = name;
          addressController.text = address;
          phoneNumberController.text = phoneNumber;
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  void _submitUserData() async {
    String name = nameController.text.trim();
    String address = addressController.text.trim();
    String phoneNumber = phoneNumberController.text.trim();

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference usersCollection = firestore.collection('users');
    String userUID = widget.user.uid;

    try {
      await usersCollection.doc(userUID).set({
        'name': name,
        'address': address,
        'phoneNumber': phoneNumber,
        'email': widget.user.email,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ImpScreen(widget.user),
        ),
      );
    } catch (e) {
      print("Error storing user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? 'Edit Details' : 'Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            ElevatedButton(
              onPressed: _submitUserData,
              child: Text(widget.isEditMode ? 'Update' : 'Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
