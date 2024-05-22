import 'dart:async';
import 'package:flutter/material.dart';
import 'CirclePaint.dart'; // Correct the import path if necessary

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double progressValue = 0; // Initial progress value
  Timer? _timer;

  void _onTapDown(TapDownDetails details) {
    _timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      setState(() {
        if (progressValue < 100) {
          progressValue += 1;
        }else{
          if(progressValue==100){
            _timer?.cancel();
           Future.delayed(Duration(seconds: 1), () {
             setState(() {
               progressValue = 0;
             });
           },);
          }
          print(progressValue);
        }
      });
    });
  }

  void _onTapUp(TapUpDetails details) {
    _timer?.cancel();
    setState(() {
      progressValue = 0; // Reset progress
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double normalizedValue = progressValue / 100; // Normalize to 0.0 - 1.0

    return Scaffold(
      appBar: AppBar(
        title: const Text('Circular Progress Button'),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: () {
            _timer?.cancel();
            setState(() {
              progressValue = 0; // Reset progress
            });
          },
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.pinkAccent,
                width: 4,
              ),
            ),
            child: CustomPaint(
              painter: CirclePaint(normalizedValue),
            ),
          ),
        ),
      ),
    );
  }
}
