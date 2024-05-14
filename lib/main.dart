import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money/Register_Login/login.dart' as loginPage;
import 'package:money/UndsenNuur/home.dart' as homePage;
import 'package:money/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MoneyControlApp());
}

class MoneyControlApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'register',
      debugShowCheckedModeBanner: false,
      routes: {
        'home': (context) => homePage.MainPage(userId: '',),
        'register': (context) => loginPage.Login(),
      },
    );
  }
}
