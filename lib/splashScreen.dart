import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/reminder.dart';
// import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() => runApp(SplashScreen());

class SplashScreen extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      // title: 'Propecia',

      // Application theme data, you can set the
      // colors for the application as
      // you want
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // A widget which will be started on application startup
      home: AnimatedSplashScreen(
        splash: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Reminders1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // splash: 'assets/images/Reminders1.jpg',
        nextScreen: const ReminderPageState(),
        splashTransition: SplashTransition.fadeTransition,
        // fullScreen: true,
      ),
    );
  }
}
