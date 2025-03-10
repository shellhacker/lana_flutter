import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lana_flutter/const/dailog_widgets.dart';
import 'package:lana_flutter/service/booking_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/booking/add_booking_model.dart';
import '../model/common_model.dart';

class BookingController extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController enquireController = TextEditingController();
  final serviceClass = BookingServices();
  String selectedGender = "Male";
  List<AddBookingModel> bookingList = [];
  Future<void> selectDate(context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> selectTime(context) async {
    TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      timeController.text = picked.format(context);
    }
  }

  clearController() {
    nameController.clear();
    emailController.clear();
    contactController.clear();
    dateController.clear();
    timeController.clear();
    enquireController.clear();
  }

  void submitForm() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final uid = prefs.getString("userId");
    print(uid ?? "uid is null");
    if (uid != null) {
      AddBookingModel data = AddBookingModel(
          id: uid,
          qurie: enquireController.text,
          name: nameController.text,
          email: emailController.text,
          contact: contactController.text,
          date: dateController.text,
          time: timeController.text,
          gender: selectedGender);

      final reponse = await serviceClass.addService(data);
      if (reponse != null && reponse is ApiResponseCommonModel) {
        if (reponse.status) {
          AppDialogBoxes.showPopup(reponse.message);
          bookingList.add(data);
          notifyListeners();
          clearController();
          getBookingList();
        } else {
          AppDialogBoxes.showPopup(reponse.message);
        }
      }
    }
  }

  getBookingList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final uid = prefs.getString("userId");
    if (uid != null) {
      final result = await serviceClass.getBookingListData(uid);

      if (result != null && result is ApiResponseCommonModel) {
        if (result.status) {
          dynamic temp = result.data;
          bookingList = temp.map<AddBookingModel>((e) {
            return AddBookingModel.fromJson(e);
          }).toList();
          notifyListeners();
        } else {
          AppDialogBoxes.showPopup(result.message);
        }
      }
    }
  }
}
