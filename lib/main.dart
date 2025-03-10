import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:lana_flutter/const/routes.dart';
import 'package:lana_flutter/controller/booking_controller.dart';
import 'package:lana_flutter/firebase_options.dart';
import 'package:lana_flutter/view/auth/splash_screen.dart';
import 'controller/authentication_controller.dart';
import 'view/auth/login_screen.dart';
import 'view/booking/booking_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => BookingController()),
          ChangeNotifierProvider(
              create: (context) => AuthenticationController()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
                useMaterial3: true),
            navigatorKey: Routes.navigatorKey,
            home: SplashScreen()));
  }
}
