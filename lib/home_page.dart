import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_notification/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _countdownTimer;
  Duration _podomoroDuration = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
  }

  /// Timer related methods ///
  // Step 3
  void startTimer() {
    _countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  // Step 4
  void stopTimer() {
    setState(() => _countdownTimer!.cancel());
  }

  // Step 5
  void resetTimer() {
    stopTimer();
    setState(() => _podomoroDuration = Duration(seconds: 5));
  }

  // Step 6
  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = _podomoroDuration.inSeconds - reduceSecondsBy;
      if (seconds < 1) {
        _triggerEndPodomoroNotification();
      }
      if (seconds < 0) {
        _countdownTimer!.cancel();
        resetTimer();
      } else {
        _podomoroDuration = Duration(seconds: seconds);
      }
    });
  }

  void _triggerEndPodomoroNotification() {
    NotificationService().addNotification(
      title: 'Let\'s get a break!',
      body: 'Don\'t forget to drink.',
      endTime: DateTime.now().millisecondsSinceEpoch + 1000,
      channelId: 'work-end',
      channelName: 'work-end',
    );
  }

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
                (_countdownTimer?.isActive ?? false)
                    ? 'Good luck'
                    : 'Start to Work',
                style: titleTextStyle,
              ),
              SizedBox(height: 32),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 32),
                color: Colors.red.withOpacity(0.4),
                child: Center(
                  child: Text(
                    _podomoroDuration.inSeconds.toString(),
                    style: timerTextStyle,
                  ),
                ),
              ),
              SizedBox(height: 32),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_countdownTimer?.isActive ?? false)
                      ? null
                      : () {
                          NotificationService().addNotification(
                            title: 'Start Podomoro!',
                            body: 'Let\'s focus!',
                            endTime:
                                DateTime.now().millisecondsSinceEpoch + 1000,
                            channelId: 'work-start',
                            channelName: 'work-start',
                          );
                          startTimer();
                        },
                  child: Text(
                    (_countdownTimer?.isActive ?? false)
                        ? 'GO WORK!'
                        : 'START!',
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
