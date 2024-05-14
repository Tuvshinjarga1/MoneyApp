import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money/Register_Login/HereglegchBurtgel.dart';
import 'package:money/UndsenNuur/home.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _phoneNumberController.text + "@gmail.com", // Use email as phone number
        password: _passwordController.text,
      );
      String userId = userCredential.user!.uid;

      // Check if the user is a vendor or a user
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection("User").doc(userId).get();

      if (userSnapshot.exists) {
        // Navigate to main page
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MoneyControlApp(userId: userId)));
      }
    } catch (e) {
      // Handle login errors
      print("Error signing in: $e");
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to sign in. Please check your credentials."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/oway.png',
          height: 100,
          width: 100,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Нэвтрэх",
                    style: TextStyle(
                        fontSize: 26,
                        color: Colors.cyan,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey, width: 1.0),
                  ),
                  child: TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Утасны дугаар",
                      prefixIcon: Icon(Icons.phone),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey, width: 1.0),
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Нууц үг",
                      prefixIcon: Icon(Icons.lock),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Burtgel()));
                      },
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 18)),
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.transparent;
                            }
                            return null;
                          },
                        ),
                      ),
                      child: Text("Бүртгүүлэх"),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text("Нэвтрэх", style: TextStyle(fontSize: 21)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    fixedSize: MaterialStateProperty.all<Size>(Size.fromHeight(50)),
                  ),
                  onPressed: _signInWithEmailAndPassword,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text("Буцах", style: TextStyle(fontSize: 21)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    fixedSize: MaterialStateProperty.all<Size>(Size.fromHeight(50)),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MoneyControlApp(userId: '')));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
