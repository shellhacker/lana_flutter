import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:lana_flutter/const/dailog_widgets.dart';
import 'package:lana_flutter/const/error_handler.dart';
import 'package:lana_flutter/model/common_model.dart';

import '../model/booking/add_booking_model.dart';

class BookingServices {
  Dio dio = Dio();
  ErrorCode errorCode = ErrorCode();

  Future<dynamic> getBookingListData(String uid) async {
    var headers = {
      'Content-Type': 'application/json',
    };
    var data = json.encode({"uid": uid});
    try {
      var response = await dio.request(
          'http://localhost:3000/user/getBookingList',
          data: data,
          options: Options(method: 'GET', headers: headers));
      // log(response.data['data']);
      print(response);
      if (response.statusCode == 200) {
        return ApiResponseCommonModel(
            message: response.data['message'],
            data: response.data['data'],
            status: true);
      }
    } on DioException catch (e) {
      errorCode.status401(e);

      return ApiResponseCommonModel(
          status: false, message: e.message.toString(), data: []);
    } catch (e) {
      AppDialogBoxes.showPopup('Error Founded');

      // ApiResponseCommonModel(message: 'try agin', data: [], status: false);
    }
    return null;
  }

  addService(AddBookingModel data) async {
    var headers = {
      'Content-Type': 'application/json',
    };
    try {
      var response = await dio.request(
          "http://localhost:3000/user/addNewBooking",
          data: data.toJson(),
          options: Options(method: 'POST', headers: headers));
      log(response.data);

      if (response.statusCode == 200) {
        return ApiResponseCommonModel(
            message: response.data['message'],
            data: response.data['data'],
            status: true);
      }
    } on DioException catch (e) {
      log("cathch error$e");
      errorCode.status401(e);

      return ApiResponseCommonModel(
          status: false, message: e.message.toString(), data: []);
    } catch (e) {
      AppDialogBoxes.showPopup('Error Founded');

      // ApiResponseCommonModel(message: 'try agin', data: [], status: false);
    }
    return null;
  }
}
