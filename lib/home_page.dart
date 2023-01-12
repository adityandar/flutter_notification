import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.withOpacity(0.2),
      appBar: AppBar(
        title: Text('Pomodoro Timer'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Start to Work',
                style: titleTextStyle,
              ),
              SizedBox(height: 32),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 32),
                color: Colors.red.withOpacity(0.4),
                child: Center(
                  child: Text(
                    '00:05', // set to dynamic current timer
                    style: timerTextStyle,
                  ),
                ),
              ),
              SizedBox(height: 32),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add trigger notification start
                  },
                  child: Text(
                    'START!',
                    style: TextStyle(color: Colors.white),
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

TextStyle get timerTextStyle => TextStyle(
      fontSize: 64,
      fontWeight: FontWeight.bold,
    );

TextStyle get titleTextStyle => TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

String getReadableDuration(Duration duration) {
  String strDigits(int n) => n.toString().padLeft(2, '0');
  final days = strDigits(duration.inDays);
  // Step 7
  final hours = strDigits(duration.inHours.remainder(24));
  final minutes = strDigits(duration.inMinutes.remainder(60));
  final seconds = strDigits(duration.inSeconds.remainder(60));

  return '$hours:$minutes';
}
