class ApiResponseModel {
  int? statusCode;
  String? status;
  dynamic data;
  dynamic message;

  ApiResponseModel({this.statusCode, this.status, this.data, this.message});

  ApiResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    data = json['data'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['status'] = status;
    data['data'] = data;
    data['message'] = data;
    return data;
  }
}
