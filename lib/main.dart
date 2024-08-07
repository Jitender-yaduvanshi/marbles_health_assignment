import 'package:flutter/material.dart';
import 'package:marbles_intern_assignment/homescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Marbles Health Assignment',
      home: HomeScreen(),
    );
  }
}
