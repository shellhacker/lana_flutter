import 'package:dio/dio.dart';
import 'package:lana_flutter/const/dailog_widgets.dart';

class ErrorCode {
  status401(e) {
    print('dio error$e');
    if (e.response?.statusCode == 401) {
      AppDialogBoxes.showPopup('Server Not Founded');
    } else if (e.type == DioErrorType.connectionTimeout) {
      AppDialogBoxes.showPopup('Connection Time out');
    } else if (e.type == DioErrorType.receiveTimeout) {
      AppDialogBoxes.showPopup('Timeout Error');
    } else if (e.type == DioErrorType.unknown) {
      AppDialogBoxes.showPopup('Network Error');
    } else if (e.response?.statusCode == 403) {
      AppDialogBoxes.showPopup('To explore more login your account');
      // Routes.push(screen: LoginScreen());
    }
  }
}
