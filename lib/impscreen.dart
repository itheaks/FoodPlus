import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodmanager/register.dart' as reg; // Use prefix 'reg' for register.dart

import 'signin.dart';

class ImpScreen extends StatefulWidget {
  final User user;

  ImpScreen(this.user);

  @override
  _ImpScreenState createState() => _ImpScreenState();
}

class _ImpScreenState extends State<ImpScreen> {
  String name = '';
  String address = '';
  String phoneNumber = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  _fetchUserData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference usersCollection = firestore.collection('users');
    String userUID = widget.user.uid;

    try {
      DocumentSnapshot snapshot = await usersCollection.doc(userUID).get();

      if (snapshot.exists) {
        setState(() {
          name = snapshot.get('name');
          address = snapshot.get('address');
          phoneNumber = snapshot.get('phoneNumber');
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Important Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to the RegisterScreen with the ability to edit the data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => reg.RegisterScreen(widget.user, isEditMode: true),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Hello $name (${widget.user.email ?? ''})',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Address: $address', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Phone Number: $phoneNumber', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
