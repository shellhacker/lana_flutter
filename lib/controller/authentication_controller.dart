import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lana_flutter/const/dailog_widgets.dart';
import 'package:lana_flutter/const/routes.dart';
import 'package:lana_flutter/view/auth/login_screen.dart';
import 'package:lana_flutter/view/booking/booking_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'booking_controller.dart';

class AuthenticationController extends ChangeNotifier {
  bool isLogin = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final LocalAuthentication _localAuth = LocalAuthentication();
  checkUserLogined(context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final bool isLogin = prefs.getBool("login") ?? false;
    if (isLogin) {
      final controller = Provider.of<BookingController>(context, listen: false);
      controller.getBookingList();
      Routes.pushreplace(screen: BookingListScreen());
    } else {
      Routes.pushreplace(screen: AuthScreen());
    }
  }

  Future<void> signInWithBiometrics(BuildContext context) async {
    try {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        if (context.mounted) {
          AppDialogBoxes.showPopup(
              "Biometric authentication is not available.");
        }
        return;
      }

      List<BiometricType> availableBiometrics =
          await _localAuth.getAvailableBiometrics();
      print("Available Biometrics: $availableBiometrics");

      bool hasStrongBiometric =
          availableBiometrics.contains(BiometricType.strong);
      bool hasWeakBiometric = availableBiometrics.contains(BiometricType.weak);

      if (!hasStrongBiometric && !hasWeakBiometric) {
        if (context.mounted) {
          AppDialogBoxes.showPopup(
              "No supported biometric authentication found.");
        }
        return;
      }

      String authMethod = hasStrongBiometric
          ? "Strong Biometric (Face ID / Fingerprint)"
          : hasWeakBiometric
              ? "Weak Biometric (Pattern / PIN Backup)"
              : "No supported biometric";

      // Perform biometric authentication
      bool isAuthenticated = await _localAuth.authenticate(
        localizedReason: "Use $authMethod to authenticate",
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      if (isAuthenticated) {
        print("✅ Biometric authentication successful!");
        if (context.mounted) {
          AppDialogBoxes.showPopup("Authentication Successful!");
          showLoginDialog(context);
        }
      } else {
        print("Biometric authentication failed.");
        if (context.mounted) {
          AppDialogBoxes.showPopup("Authentication failed. Try again.");
        }
      }
    } catch (e) {
      print("Error in biometric authentication: $e");
      if (context.mounted) {
        AppDialogBoxes.showPopup("Error: ${e.toString()}");
      }
    }
  }

  void showLoginDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remainder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TextField(
              //   controller: emailController,
              //   decoration: InputDecoration(labelText: 'Email'),
              // ),
              // TextField(
              //   controller: passwordController,
              //   obscureText: true,
              //   decoration: InputDecoration(labelText: 'Password'),
              // ),

              Text('You need to login with your email and password.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Handle login logic here
                String email = emailController.text;
                String password = passwordController.text;
                print('Email: $email, Password: $password');
                Navigator.of(context).pop();
              },
              child: Text('Login'),
            ),
            // TextButton(
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            //   child: Text('Cancel'),
            // ),
          ],
        );
      },
    );
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    isLogin = true;
    notifyListeners();
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print("Google User: $googleUser");

      if (googleUser == null) {
        _showErrorDialog(context, "Login Cancelled. Please Try Again!");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        prefs.setBool("login", true);
        prefs.setString("userId", user.uid);
        Routes.pushreplace(screen: BookingListScreen());
      } else {
        _showErrorDialog(context, "Authentication Failed. Try Again.");
      }
    } catch (e) {
      print("Error: $e");
      _showErrorDialog(context, "Error: ${e.toString()}");
    }
    isLogin = false;
  }

// Helper function to show an error popup
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
