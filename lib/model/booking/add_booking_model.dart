class AddBookingModel {
  String? name, email, contact, date, time, gender, qurie;
  String? id;
  AddBookingModel(
      {required this.name,
      required this.email,
      required this.contact,
      required this.date,
      required this.time,
      required this.gender,
      required this.qurie,
      required this.id});
  factory AddBookingModel.fromJson(Map<String, dynamic> json) =>
      AddBookingModel(
          name: json["name"],
          email: json["email"],
          contact: json["phone"],
          date: json["date"],
          time: json["time"],
          qurie: json["content"],
          id: json["uid"],
          gender: json['gender']);

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": contact,
        "date": date,
        "time": time,
        "content": qurie,
        "uid": id,
      };
}
