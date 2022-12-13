import 'package:eticaret_project/pages/adminPages/admin_home.dart';
import 'package:eticaret_project/pages/splashPages/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  //firebase bağlantısı için main kısmı bu şekilde olmalı
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
//firebase instance kodları (firebase nağlantısı)
  late FirebaseAuth auth;
  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;

//oturum açma ve kapatma da stream olarak tetiklenir
//uygulama ilk açıldığı anda ve oturum sonlandığında tetiklenir
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint('User oturum kapalı!');
      } else {
        debugPrint(
            'User oturum açık ${user.email} ve email durumu ${user.emailVerified}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const AdminHomePage(),
    );
  }
}
