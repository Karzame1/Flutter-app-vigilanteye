class SosAlertModel {

  /*
  {
    "latitude": 31.554492,
    "longitude": 74.3634996,
    "date": "March 28, 2024, 10:24:02 PM",
    "emergency": "A user needs emergency service",
    "user_Img": "https://firebasestorage.googleapis.com/v0/b/karzame-f00a9.appspot.com/o/UserPics%2Ffile%3A%2Fstorage%2Femulated%2F0%2FAndroid%2Fdata%2Fcom.karzamee.app%2Ffiles%2FPictures%2F708036d3-7196-4704-96ca-c0ad244a9602_1691814505538.jpg?alt=media&token=cb4b0ad3-6ab5-48e2-90b8-d1401c501499",
    "user_Name": "karzame",
    "user_Phone": "+18166026983"
  }
*/

  int? id;
  String? latitude;
  String? longitude;
  String? userName;
  String? userPhone;
  String? message;
  String? userImage;
  String? type;
  String? createdAt;

  SosAlertModel(
      {this.id,
      this.latitude,
      this.longitude,
      this.userName,
      this.userPhone,
      this.message,
      this.userImage,
      this.type,
      this.createdAt});

  SosAlertModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    userName = json['userName'];
    userPhone = json['userPhone'];
    message = json['message'];
    userImage = json['userImage'];
    type = json['type'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['userName'] = userName;
    data['userPhone'] = userPhone;
    data['message'] = message;
    data['userImage'] = userImage;
    data['type'] = type;
    data['createdAt'] = createdAt;
    return data;
  }
}

class SosAlertModel1 {
    SosAlertModel1({
        required this.nxm4ATj0GxhXu0FdTh,
    });

    final Nxm4ATj0GxhXu0FdTh? nxm4ATj0GxhXu0FdTh;

    factory SosAlertModel1.fromJson(Map<String, dynamic> json){
        return SosAlertModel1(
            nxm4ATj0GxhXu0FdTh: json["-Nxm4aTJ0-gxhXu0FDTh"] == null ? null : Nxm4ATj0GxhXu0FdTh.fromJson(json["-Nxm4aTJ0-gxhXu0FDTh"]),
        );
    }

}

class Nxm4ATj0GxhXu0FdTh {
    Nxm4ATj0GxhXu0FdTh({
        required this.date,
        required this.emergency,
        required this.latitude,
        required this.longitude,
        required this.userName,
        required this.city,
        required this.isRead,
        required this.state,
        required this.userImg,
        required this.nxm4ATj0GxhXu0FdThUserName,
        required this.userPhone,
    });

    final String? date;
    final String? emergency;
    final double? latitude;
    final double? longitude;
    final String? userName;
    final String? city;
    final bool? isRead;
    final String? state;
    final String? userImg;
    final String? nxm4ATj0GxhXu0FdThUserName;
    final String? userPhone;

    factory Nxm4ATj0GxhXu0FdTh.fromJson(Map<String, dynamic> json){
        return Nxm4ATj0GxhXu0FdTh(
            date: json["Date"],
            emergency: json["Emergency"],
            latitude: json["Latitude"],
            longitude: json["Longitude"],
            userName: json["UserName"],
            city: json["city"],
            isRead: json["isRead"],
            state: json["state"],
            userImg: json["user_Img"],
            nxm4ATj0GxhXu0FdThUserName: json["user_Name"],
            userPhone: json["user_Phone"],
        );
    }

}
