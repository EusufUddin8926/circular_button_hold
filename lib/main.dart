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
  bool isTextShow = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      isTextShow = false;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      setState(() {
        if (progressValue < 100) {
          progressValue += 1;
        } else {
          if (progressValue == 100) {
            _timer?.cancel();
            Future.delayed(Duration(seconds: 1), () {
              setState(() {
                isTextShow = true;
                progressValue = 0;
              });
            });
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
      isTextShow = true;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double normalizedValue = progressValue / 100;

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
              isTextShow = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
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
              AnimatedOpacity(
                opacity: isTextShow ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: Text(
                  'Tap to Hold',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
