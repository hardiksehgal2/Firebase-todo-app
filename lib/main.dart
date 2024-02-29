import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core

import 'HomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDdxo2Q4aiB0VTDd8NMbFrG9z_MgOK4nf0",
        authDomain: "todo-app-94afc.firebaseapp.com",
        projectId: "todo-app-94afc",
        storageBucket: "todo-app-94afc.appspot.com",
        messagingSenderId: "655353966926",
        appId: "1:655353966926:web:e169ee6001de14eddfae1f"
    ),
  ); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
