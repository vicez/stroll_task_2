import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'ProximaNova',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Hello World!'),     
        ),
      ),
    );
  }
}
