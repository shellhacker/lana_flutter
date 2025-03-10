import 'dart:async'; // Correct import for Timer
import 'package:flutter/material.dart';
import 'package:lana_flutter/controller/authentication_controller.dart'; // Assuming you have this controller

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      final auth = AuthenticationController();
      auth.checkUserLogined(context);
    });

    return Scaffold(body: Center(child: Icon(Icons.ac_unit_sharp, size: 80)));
  }
}
