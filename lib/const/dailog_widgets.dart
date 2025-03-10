import 'package:flutter/material.dart';
import 'package:lana_flutter/const/routes.dart';

class AppDialogBoxes {
  static final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // TO SHOW POPUP
  static showPopup(
    String messege, {
    Color color = Colors.white,
    int milliSec = 2000,
    Color textColor = Colors.red,
  }) {
    rootScaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          messege,
          style: const TextStyle(
              fontFamily: "Gotham",
              fontSize: 16,
              color: Color.fromARGB(255, 178, 121, 67)),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // TO SHOW DIALOG BOX
  static Future<void> showDialogBox({
    required String title,
    required String messege,
    required BuildContext ctx,
    VoidCallback? action,
    VoidCallback? backbuttonAction,
    String denyText = 'No',
    String allowText = 'Yes',
    bool isPopup = false,
    VoidCallback? onAllow,
  }) async {
    // rootScaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    await showDialog(
      context: ctx,
      builder: (ctx) => AlertDialog(
        title: Text(
          title,
        ),
        titleTextStyle: const TextStyle(fontSize: 24, color: Colors.black),
        content: Text(messege),
        contentTextStyle: const TextStyle(fontSize: 18, color: Colors.black),
        actions: [
          TextButton(
            onPressed: backbuttonAction,
            child: Text(
              denyText,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          if (isPopup == false)
            TextButton(
              onPressed: action,
              child: Text(
                allowText,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
        ],
      ),
    );
  }

  // TO SHOW ERROR DIALOG BOX
  static Future<void> showErrorBox({
    String title = 'ERROR !!',
    required String messege,
  }) async {
    await showDialog(
      context: Routes.navigatorKey.currentContext!,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        titleTextStyle: const TextStyle(fontSize: 24, color: Colors.black),
        content: Text(messege),
        contentTextStyle: const TextStyle(fontSize: 18, color: Colors.black),
        actions: [
          TextButton(
            onPressed: () {
              Routes.back();
            },
            child: const Text(
              'OK',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// void showPopup(BuildContext ctx, String msg,
//     {Color clr = Colors.red, int seconds = 2}) {
//   ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
//   ScaffoldMessenger.of(ctx).showSnackBar(
//     SnackBar(
//       key: UniqueKey(),
//       content: Text(msg),
//       duration: Duration(seconds: seconds),
//       backgroundColor: clr,
//       behavior: SnackBarBehavior.floating,
//     ),
//   );
// }
