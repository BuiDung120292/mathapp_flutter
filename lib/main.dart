import 'package:flutter/material.dart';
import 'package:mathapp/pages/quiz_demo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math App',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const QuizDemoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
