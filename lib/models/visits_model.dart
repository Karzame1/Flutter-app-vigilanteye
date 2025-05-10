class VisitsModel {
  int? id;
  int? attendanceId;
  String? remarks;
  String? imgUrl;
  String? latitude;
  String? longitude;
  dynamic address;
  int? createdById;
  dynamic updatedById;
  String? status;
  dynamic approvedById;
  dynamic approverRemarks;
  dynamic approvedAmount;
  dynamic approvedAt;
  String? createdAt;
  String? updatedAt;
  int? alertId;
  Alert? alert;

  VisitsModel(
      {this.id,
      this.attendanceId,
      this.remarks,
      this.imgUrl,
      this.latitude,
      this.longitude,
      this.address,
      this.createdById,
      this.updatedById,
      this.status,
      this.approvedById,
      this.approverRemarks,
      this.approvedAmount,
      this.approvedAt,
      this.createdAt,
      this.updatedAt,
      this.alertId,
      this.alert});

  VisitsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attendanceId = json['attendance_id'];
    remarks = json['remarks'];
    imgUrl = json['img_url'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    createdById = json['created_by_id'];
    updatedById = json['updated_by_id'];
    status = json['status'];
    approvedById = json['approved_by_id'];
    approverRemarks = json['approver_remarks'];
    approvedAmount = json['approved_amount'];
    approvedAt = json['approved_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    alertId = json['alert_id'];
    alert = json['alert'] != null ? Alert.fromJson(json['alert']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['attendance_id'] = attendanceId;
    data['remarks'] = remarks;
    data['img_url'] = imgUrl;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['created_by_id'] = createdById;
    data['updated_by_id'] = updatedById;
    data['status'] = status;
    data['approved_by_id'] = approvedById;
    data['approver_remarks'] = approverRemarks;
    data['approved_amount'] = approvedAmount;
    data['approved_at'] = approvedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['alert_id'] = alertId;
    if (alert != null) {
      data['alert'] = alert!.toJson();
    }
    return data;
  }
}

class Alert {
  int? id;
  String? karzameUserId;
  String? address;
  String? createdAt;
  String? updatedAt;
  String? latitude;
  String? longitude;
  String? city;
  String? state;
  String? message;
  String? date;
  String? userImage;
  dynamic buildingImage;
  dynamic buildingAddress;
  dynamic buildingState;
  dynamic buildingLga;
  dynamic buildingCommunity;
  String? userName;
  String? userPhone;
  String? type;
  String? rawRequest;
  int? isRead;
  int? roleType;
  int? status;

  Alert(
      {this.id,
      this.karzameUserId,
      this.address,
      this.createdAt,
      this.updatedAt,
      this.latitude,
      this.longitude,
      this.city,
      this.state,
      this.message,
      this.date,
      this.userImage,
      this.buildingImage,
      this.buildingAddress,
      this.buildingState,
      this.buildingLga,
      this.buildingCommunity,
      this.userName,
      this.userPhone,
      this.type,
      this.rawRequest,
      this.isRead,
      this.roleType,
      this.status});

  Alert.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    karzameUserId = json['karzame_user_id'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    city = json['city'];
    state = json['state'];
    message = json['message'];
    date = json['date'];
    userImage = json['user_image'];
    buildingImage = json['building_image'];
    buildingAddress = json['building_address'];
    buildingState = json['building_state'];
    buildingLga = json['building_lga'];
    buildingCommunity = json['building_community'];
    userName = json['user_name'];
    userPhone = json['user_phone'];
    type = json['type'];
    rawRequest = json['raw_request'];
    isRead = json['is_read'];
    roleType = json['role_type'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['karzame_user_id'] = karzameUserId;
    data['address'] = address;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['city'] = city;
    data['state'] = state;
    data['message'] = message;
    data['date'] = date;
    data['user_image'] = userImage;
    data['building_image'] = buildingImage;
    data['building_address'] = buildingAddress;
    data['building_state'] = buildingState;
    data['building_lga'] = buildingLga;
    data['building_community'] = buildingCommunity;
    data['user_name'] = userName;
    data['user_phone'] = userPhone;
    data['type'] = type;
    data['raw_request'] = rawRequest;
    data['is_read'] = isRead;
    data['role_type'] = roleType;
    data['status'] = status;
    return data;
  }
}