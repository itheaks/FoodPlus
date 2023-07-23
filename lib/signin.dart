import 'package:flutter/material.dart';
import 'package:foodmanager/impscreen.dart';
import 'package:foodmanager/register.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkIfUserRegistered();
  }

  Future<User?> _handleSignIn() async {
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        return userCredential.user;
      }
    } catch (error) {
      print("Error signing in with Google: $error");
    }
    return null;
  }

  _checkIfUserRegistered() async {
    User? user = await _handleSignIn();
    if (user != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference usersCollection = firestore.collection('users');
      String userUID = user.uid;

      try {
        DocumentSnapshot snapshot = await usersCollection.doc(userUID).get();

        if (snapshot.exists) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ImpScreen(user),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterScreen(user),
            ),
          );
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign-In and Registration'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            User? user = await _handleSignIn();
            if (user != null) {
              FirebaseFirestore firestore = FirebaseFirestore.instance;
              CollectionReference usersCollection = firestore.collection('users');
              String userUID = user.uid;

              try {
                DocumentSnapshot snapshot = await usersCollection.doc(userUID).get();

                if (snapshot.exists) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImpScreen(user),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterScreen(user),
                    ),
                  );
                }
              } catch (e) {
                print("Error fetching user data: $e");
              }
            }
          },
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}
