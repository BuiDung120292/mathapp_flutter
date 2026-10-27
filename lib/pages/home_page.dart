import 'package:flutter/material.dart';

import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int num1 = 0;
  int num2 = 0;
  int sum = 0;
  int score = 0;
  bool isStarted = false;

  void _rightButtonPressed() {
    setState(() {
      if (num1 + num2 == sum) {
        score++;
      } else {
        score--;
      }
      num1 = Random().nextInt(10);
      num2 = Random().nextInt(10);
      sum = Random().nextInt(11) + 10;
    });
  }

  void _wrongButtonPressed() {
    setState(() {
      if (num1 + num2 != sum) {
        score++;
      } else {
        score--;
      }
      num1 = Random().nextInt(10);
      num2 = Random().nextInt(10);
      sum = Random().nextInt(11) + 10;
    });
  }

  void _startButtonPressed() {
    setState(() {
      isStarted = true;
      num1 = Random().nextInt(10);
      num2 = Random().nextInt(10);
      sum = Random().nextInt(11) + 10;
    });
  }

  void _resetButtonPressed() {
    setState(() {
      isStarted = false;
      num1 = 0;
      num2 = 0;
      sum = 0;
      score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'The Magical Addition',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '$num1 + $num2 = $sum',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(height: 20),
            isStarted == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: _rightButtonPressed,
                        child: const Text(
                          'Right',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: _wrongButtonPressed,
                        child: const Text(
                          'Wrong',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            SizedBox(height: 20),
            Text(
              'Score: $score',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: _startButtonPressed,
                  child: const Text(
                    'Start',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  onPressed: _resetButtonPressed,
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
