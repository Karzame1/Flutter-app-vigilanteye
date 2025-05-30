class AppSettingsModel {
  String? appVersion;
  String? locationUpdateIntervalType;
  num? locationUpdateInterval;
  String? currency;
  String? currencySymbol;
  String? privacyPolicyUrl;
  String? distanceUnit;
  String? countryPhoneCode;
  AppSettingsModel(
      {this.appVersion,
      this.locationUpdateIntervalType,
      this.locationUpdateInterval,
      this.currency,
      this.currencySymbol,
      this.distanceUnit,
      this.privacyPolicyUrl,
      this.countryPhoneCode});

  AppSettingsModel.fromJson(Map<String, dynamic> json) {
    appVersion = json['appVersion'];
    locationUpdateIntervalType = json['locationUpdateIntervalType'];
    locationUpdateInterval = num.parse(json['locationUpdateInterval'].toString());/// error showing because of flutter modification now locationUpdateInterval is a int
    currency = json['currency'];
    currencySymbol = json['currencySymbol'];
    privacyPolicyUrl = json['privacyPolicyUrl'];
    distanceUnit = json['distanceUnit'];
    countryPhoneCode = json['countryPhoneCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appVersion'] = appVersion;
    data['locationUpdateIntervalType'] = locationUpdateIntervalType;
    data['locationUpdateInterval'] = locationUpdateInterval;
    data['privacyPolicyUrl'] = privacyPolicyUrl;
    return data;
  }
}
