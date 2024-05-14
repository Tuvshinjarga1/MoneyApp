import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String userId;

  ProfilePage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while fetching data
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text('User not found'); // Handle case where user data is not available
        }
        var userData = snapshot.data!.data() as Map<String, dynamic>; // Get user data
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Profile Page',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text('Name: ${userData['name']}'),
              Text('Email: ${userData['email']}'),
              // Add more user information here
            ],
          ),
        );
      },
    );
  }
}
