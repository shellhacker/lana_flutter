import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lana_flutter/controller/authentication_controller.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Future<void> _authenticateWithBiometrics() async {
  //   bool authenticated = await _localAuth.authenticate(
  //     localizedReason: 'Authenticate to access your account',
  //     // biometricOnly: true,
  //   );
  //   if (authenticated) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Biometric authentication successful!")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final controller =
        Provider.of<AuthenticationController>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/doctor_consultation_03.jpg'),
                  fit: BoxFit.fill)),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    const Color.fromARGB(255, 155, 189, 217),
                    Colors.grey.withOpacity(0.1),
                  ]),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        color: const Color.fromARGB(255, 5, 55, 94)),
                  ),
                  Text(
                    "Login with your google account or biometrics",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                                icon: Icon(Icons.fingerprint),
                                label: Text('Sign in with Biometrics'),
                                onPressed: () {
                                  controller.signInWithBiometrics(context);
                                })
                          ]),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: Image.asset('assets/auth_image.png',
                                height: 24),
                            label: Text('Sign in with Google'),
                            onPressed: () {
                              controller.signInWithGoogle(context);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
