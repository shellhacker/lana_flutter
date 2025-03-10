class BookingResponseModel {
  String name, email, contact, date, time, gender, qurie;
  String? id;
  BookingResponseModel(
      {required this.name,
      required this.email,
      required this.contact,
      required this.date,
      required this.time,
      required this.gender,
      required this.qurie,
      this.id});
}
