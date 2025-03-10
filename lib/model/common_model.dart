class ApiResponseCommonModel {
  final String message;
  final dynamic data;
  final bool status;

  ApiResponseCommonModel(
      {required this.message, this.data, required this.status});
}
