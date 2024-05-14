import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import "package:flutter/material.dart";
import 'package:money/Models/User.dart'
    as local_user; // Renamed your custom User class to local_user

class Burtgel extends StatefulWidget {
  @override
  State<Burtgel> createState() => _BurtgelState();
}

class _BurtgelState extends State<Burtgel> {
  // Controllers for the TextFormFields
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  // Regex pattern for password validation
  String passwordRegex =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

  // Regex pattern for phone number validation
  String phoneRegex = r'^\+?[0-9]{10,}$';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Бүртгүүлэх хэсэг"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/registerpro.png",
                height: 150,
                width: 150,
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius as needed
                  border: Border.all(
                    color: Colors.grey, // Border color
                    width: 1.0, // Border width
                  ),
                ),
                child: TextFormField(
                  controller: lastNameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Овог",
                    border: InputBorder.none, // Remove the default border
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0), // Adjust padding as needed
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius as needed
                  border: Border.all(
                    color: Colors.grey, // Border color
                    width: 1.0, // Border width
                  ),
                ),
                child: TextFormField(
                  controller: firstNameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Нэр",
                    border: InputBorder.none, // Remove the default border
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0), // Adjust padding as needed
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius as needed
                  border: Border.all(
                    color: Colors.grey, // Border color
                    width: 1.0, // Border width
                  ),
                ),
                child: TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Утасны дугаар",
                    prefixIcon: Icon(Icons.phone),
                    border: InputBorder.none, // Remove the default border
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0), // Adjust padding as needed
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Phone number is required';
                    }
                    if (!RegExp(phoneRegex).hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius as needed
                  border: Border.all(
                    color: Colors.grey, // Border color
                    width: 1.0, // Border width
                  ),
                ),
                child: TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true, // Hide password
                  decoration: InputDecoration(
                    labelText: "Нууц үг",
                    prefixIcon:
                        Icon(Icons.lock), // Changed icon to lock for password
                    border: InputBorder.none, // Remove the default border
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0), // Adjust padding as needed
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Нууц үгээ оруулна уу';
                    }
                    if (value.length < 8) {
                      return 'Таны нууц үг хамгийн багадаа 8 оронтой байх ёстой.';
                    }
                    if (!RegExp(passwordRegex).hasMatch(value)) {
                      return 'Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character.';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius as needed
                  border: Border.all(
                    color: Colors.grey, // Border color
                    width: 1.0, // Border width
                  ),
                ),
                child: TextFormField(
                  controller: confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Нууц үгээ давтан оруулна уу.",
                    prefixIcon: Icon(Icons.lock),
                    border: InputBorder.none, // Remove the default border
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0), // Adjust padding as needed
                  ),
                  validator: (value) {
                    if (value != passwordController.text) {
                      return 'Таны нууц үг таарахгүй байна';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                child: Text(
                  "Бүртгүүлэх",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.cyan),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  fixedSize:
                      MaterialStateProperty.all<Size>(Size.fromHeight(50)),
                ),
                onPressed: () {
                  if (passwordController.text ==
                      confirmPasswordController.text) {
                    final surname = lastNameController.text;
                    final name = firstNameController.text;
                    final phone = phoneController.text;
                    final password = passwordController.text;
                    createUser(
                      surname: surname,
                      name: name,
                      phone: phone,
                      password: password,
                    );
                    print("Амжилттай бүртгэгдлээ");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(phone +
                              ' дугаартай хэрэглэгч амжилттай бүртгэгдлээ.')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password таарахгүй байна.')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future createUser({
    required String surname,
    required String name,
    required String phone,
    required String password,
  }) async {
    try {
      final firebase_auth.UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: phoneController.text.trim() + "@gmail.com",
        password: passwordController.text.trim(),
      );

      // Get the document reference for the new user
      final docUser = FirebaseFirestore.instance
          .collection('User')
          .doc(userCredential.user!.uid);

      final local_user.User user = local_user.User(
        id: userCredential
            .user!.uid, // Assign the user's credential ID as the document ID
        surname: surname,
        name: name,
        phone: phone,
        password: password,
      );
      final json = user.toJson();

      await docUser.set(json);

      print(
          "User successfully created and registered: ${userCredential.user!.uid}");
    } catch (e) {
      print("Error creating user: $e");
    }
  }

  // Function to validate all form fields
  bool validateInputs() {
    if (lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Овог нэрээ оруулна уу.')),
      );
      return false;
    }
    if (firstNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Нэрээ оруулна уу.')),
      );
      return false;
    }
    if (phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Утасны дугаар оруулна уу.')),
      );
      return false;
    }
    if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password оруулна уу.')),
      );
      return false;
    }
    if (confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password баталгаажуулна уу,')),
      );
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password таарахгүй байна.')),
      );
      return false;
    }
    return true;
  }
}
