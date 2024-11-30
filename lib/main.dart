import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_2/pages/login.dart';
import 'package:flutter_application_2/pages/scanner.dart';


void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Garante a inicialização antes de rodar o app
  await Firebase.initializeApp(); // Inicializa o Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.orange,
      ),
      home: Home(),
    );
  }
}

