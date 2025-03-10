import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lana_flutter/controller/booking_controller.dart';
import 'package:provider/provider.dart';

export 'package:provider/provider.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  _BookingListScreenState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  void _showBookingBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const BookingForm(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingController>(builder: (context, controller, _) {
      return Scaffold(
        appBar: AppBar(
            title: const Text("Bookings",
                style: TextStyle(fontWeight: FontWeight.bold))),
        body: controller.bookingList.isEmpty
            ? const Center(
                child: Text("No bookings yet",
                    style: TextStyle(fontSize: 16, color: Colors.grey)))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.bookingList.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      title: Text(controller.bookingList[index].name ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        "📅 ${controller.bookingList[index].date}  |  🕒 ${controller.bookingList[index].time}\n📞 ${controller.bookingList[index].contact}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: Chip(
                          label:
                              Text(controller.bookingList[index].gender ?? "")),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showBookingBottomSheet,
          icon: const Icon(Icons.add),
          label: const Text("Add Booking"),
        ),
      );
    });
  }
}

class BookingForm extends StatefulWidget {
  const BookingForm({super.key});

  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<BookingController>(builder: (context, controller, _) {
          return SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Add Booking",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        _buildTextField(controller.nameController, "Name"),
                        _buildTextField(controller.emailController, "Email",
                            TextInputType.emailAddress),
                        _buildTextField(controller.contactController, "Contact",
                            TextInputType.phone),
                        _buildDropdownField(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextFormField(
                              controller: controller.dateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: "Date",
                                suffixIcon: IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    onPressed: () {
                                      controller.selectDate(context);
                                    }),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? "Select Date" : null),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextFormField(
                              controller: controller.timeController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: "Time",
                                suffixIcon: IconButton(
                                    icon: Icon(Icons.access_time),
                                    onPressed: () {
                                      controller.selectTime(context);
                                    }),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? "Select Date" : null),
                        ),
                        // _buildDateTimeField(controller.timeController, "Time",
                        //     Icons.access_time, controller.selectTime(context)),
                        _buildTextField(controller.enquireController, "Enquiry",
                            TextInputType.multiline, 3),
                        const SizedBox(height: 20),
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    controller.submitForm();
                                    Navigator.pop(
                                        context); // Close the bottom sheet
                                  } else {}
                                },
                                icon: const Icon(Icons.check),
                                label: const Text("Submit Booking")))
                      ])));
        }));
  }

  Widget _buildTextField(TextEditingController? controller, String label,
      [TextInputType? keyboardType, int maxLines = 1]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
            labelText: label,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        validator: (value) => value!.isEmpty ? "Enter $label" : null,
      ),
    );
  }

  Widget _buildDropdownField() {
    final controller = Provider.of<BookingController>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: controller.selectedGender,
        items: ["Male", "Female", "Other"].map((String category) {
          return DropdownMenuItem(value: category, child: Text(category));
        }).toList(),
        onChanged: (value) =>
            setState(() => controller.selectedGender = value!),
        decoration: InputDecoration(
          labelText: "Gender",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildDateTimeField(TextEditingController controller, String label,
      IconData icon, Function() onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(icon: Icon(icon), onPressed: onTap),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) => value!.isEmpty ? "Select $label" : null,
      ),
    );
  }
}
