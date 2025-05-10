import 'dart:convert';

import 'package:fieldmanager_hrms_flutter/Utils/app_constants.dart';
import 'package:fieldmanager_hrms_flutter/models/Client/client_model.dart';
import 'package:fieldmanager_hrms_flutter/models/Client/client_model_skip_take.dart';
import 'package:fieldmanager_hrms_flutter/models/Expense/expense_request_model.dart';
import 'package:fieldmanager_hrms_flutter/models/Expense/expense_type_model.dart';
import 'package:fieldmanager_hrms_flutter/models/Settings/app_settings_model.dart';
import 'package:fieldmanager_hrms_flutter/models/chat_response.dart';
import 'package:fieldmanager_hrms_flutter/models/create_bank_response_model.dart';
import 'package:fieldmanager_hrms_flutter/models/dashboard_model.dart';
import 'package:fieldmanager_hrms_flutter/models/status/status_response.dart';
import 'package:fieldmanager_hrms_flutter/models/user_profile_model.dart';
import 'package:fieldmanager_hrms_flutter/models/visits_model.dart';
import 'package:fieldmanager_hrms_flutter/network/result.dart';
import 'package:fieldmanager_hrms_flutter/service/SharedHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/api_response_model.dart';
import '../models/bank_list_model.dart';
import '../models/leave_request_model.dart';
import '../models/leave_type_model.dart';
import '../models/schedule_model.dart';
import '../models/sos_model.dart';
import 'api_routes.dart';
import 'network_utils.dart';

class ApiService {
  //Alerts
  SharedHelper sharedHelper = SharedHelper();
  Future setAlertAsRead(String id) async {
    var response = await handleResponse(
        await postRequest(APIRoutes.setAlertRead, {"alertId": id}));
    return checkSuccessCase(response);
  }

  //update alert status
  Future updateAlertStatus(String id, String status) async {
    debugPrint(
        "h aaaya h--->$id ----------------- ${sharedHelper.getUserId()}");
    var response = await handleResponse(await postRequest(
        APIRoutes.updateAlertStatus, {
      'alert_id': id,
      'status': status,
      'user_id': sharedHelper.getUserId()
    }));
    debugPrint("response aaya-->$response");
    return checkSuccessCase(response);
  }

  Future<List<SosAlertModel>> getAlerts() async {
    var response = await handleResponse(await getRequest(APIRoutes.getAlerts));
    if (!checkSuccessCase(response)) {
      return [];
    }
    Iterable list = response?.data;
    return list.map((m) => SosAlertModel.fromJson(m)).toList();
  }

  //Visits
  Future<bool> createVisit(Map<String, String> req, String filePath) async {
    var result =
        await multipartRequestWithData(APIRoutes.createVisitURL, filePath, req);
    log("response submit new-->$result");
    if (result.statusCode == 200) {
      return true;
    }

    return false;
  }

  //Settings
  Future<AppSettingsModel?> getAppSettings() async {
    var result =
        await handleResponse(await getRequest(APIRoutes.getAppSettings));
    if (!checkSuccessCase(result)) return null;
    return AppSettingsModel.fromJson(result!.data!);
  }

  //SignBoard
  Future<bool> sendSignBoardRequest(Map req) async {
    var result = await handleResponse(
        await postRequest(APIRoutes.addSignBoardRequest, req));
    return checkSuccessCase(result);
  }

  //Clients
  Future<List<ClientModel>> getClients() async {
    var response = await handleResponse(await getRequest(APIRoutes.getClients));
    if (!checkSuccessCase(response)) return [];

    Iterable list = response?.data;

    return list.map((m) => ClientModel.fromJson(m)).toList();
  }

  //get user profile model
  Future<User?> getUserProfile(String id) async {
    var response = await handleResponse(
        await postRequest(APIRoutes.profileURL, {'id': id}));
    debugPrint("users data --> ${response?.data}");
    if (!checkSuccessCase(response)) return null;
    var user = User.fromJson(response?.data['user']);
    return user;
  }

  Future<ClientModelSkipTake?> getClientsWithSkipTake(
      int skip, int take) async {
    Map<String, String> fQuery = {
      "skip": skip.toString(),
      "take": take.toString()
    };
    var param = Uri(queryParameters: fQuery).query;
    var response = await handleResponse(
        await getRequestWithQuery(APIRoutes.getClients, param));
    if (!checkSuccessCase(response)) return null;

    return ClientModelSkipTake.fromJson(response!.data);
  }

  Future<List<ClientModel>> searchClients(String query) async {
    Map<String, String> fQuery = {"query": query.trim()};
    var param = Uri(queryParameters: fQuery).query;
    var response = await handleResponse(
        await getRequestWithQuery(APIRoutes.clientsSearch, param));
    if (!checkSuccessCase(response)) return [];

    Iterable list = response?.data;
    return list.map((m) => ClientModel.fromJson(m)).toList();
  }

  Future<bool> createClient(Map req) async {
    var response =
        await handleResponse(await postRequest(APIRoutes.addClient, req));
    return checkSuccessCase(response, showError: true);
  }

  //Chat
  Future<bool> postChat(String message) async {
    var response =
        await handleResponse(await postRequest(APIRoutes.postChat, message));
    return checkSuccessCase(response, showError: true);
  }

  Future<ChatResponse?> getChats() async {
    var response = await handleResponse(await getRequest(APIRoutes.getChats));
    if (!checkSuccessCase(response)) {
      return null;
    }
    return ChatResponse.fromJson(response!.data);
  }

  //Attendance
  Future<Result> checkInOut(Map req) async {
    Result res = Result();
    var result =
        await handleResponse(await postRequest(APIRoutes.checkInOut, req));
    if (!checkSuccessCase(result)) {
      res.message = result!.data;
      return res;
    }
    res.isSuccess = true;
    return res;
  }

  //Live-Location
  Future<Result> checkStatus(Map req) async {
    Result res = Result();
    var result = await handleResponse(
        await postRequest(APIRoutes.updateUserStatus, req));
    res.message = result!.message;
    return res;
  }

  //Expense
  Future<List<ExpenseTypeModel>> getExpenseTypes() async {
    var response =
        await handleResponse(await getRequest(APIRoutes.getExpenseTypes));
    if (!checkSuccessCase(response)) return [];
    log("expenses type are-->${response?.data.toString()}");
    Iterable list = response?.data;
    return list.map((m) => ExpenseTypeModel.fromJson(m)).toList();
  }

  Future<List<ExpenseRequestModel>> getExpenseRequests() async {
    var response =
        await handleResponse(await getRequest(APIRoutes.getExpenseRequest));
    if (!checkSuccessCase(response)) return [];

    Iterable list = response?.data;
    return list.map((m) => ExpenseRequestModel.fromJson(m)).toList();
  }

  Future<bool> sendExpenseRequest(Map req) async {
    var result = await handleResponse(
        await postRequest(APIRoutes.addExpenseRequest, req));
    return checkSuccessCase(result);
  }

  Future<bool> uploadExpenseDocument(String filePath) async {
    var result =
        await multipartRequest(APIRoutes.uploadExpenseDocument, filePath);
    return result;
  }

  Future<bool> deleteExpenseRequest(int id) async {
    var result = await handleResponse(
        await postRequest(APIRoutes.deleteExpenseRequest, id));
    return checkSuccessCase(result);
  }

/*  Future<List<LeaveRequestModel>?> getLeaveRequests() async {
    var result =
        await handleResponse(await getRequest(APIRoutes.GetLeaveRequests));
    if (!checkSuccessCase(result)) {
      return null;
    }
    Iterable list = result?.data;

    return list.map((model) => LeaveRequestModel.fromJson(model)).toList();
  }*/

  //Leave
  Future<List<LeaveTypeModel>> getLeaveTypes() async {
    var result =
        await handleResponse(await getRequest(APIRoutes.getLeaveTypesURL));
    if (!checkSuccessCase(result)) {
      return [];
    }
    Iterable list = result?.data;

    return list.map((model) => LeaveTypeModel.fromJson(model)).toList();
  }

  Future<bool> sendLeaveRequest(Map req) async {
    var result =
        await handleResponse(await postRequest(APIRoutes.addLeaveRequest, req));
    return checkSuccessCase(result);
  }

  Future<bool> uploadLeaveDocument(String filePath) async {
    var result =
        await multipartRequest(APIRoutes.uploadLeaveDocument, filePath);
    return result;
  }

  Future<List<LeaveRequestModel>?> getLeaveRequests() async {
    var result =
        await handleResponse(await getRequest(APIRoutes.getLeaveRequests));
    if (!checkSuccessCase(result)) {
      return null;
    }
    Iterable list = result?.data;

    return list.map((model) => LeaveRequestModel.fromJson(model)).toList();
  }

  Future<bool> deleteLeaveRequest(int id) async {
    var result = await handleResponse(
        await postRequest(APIRoutes.deleteLeaveRequest, id));
    return checkSuccessCase(result);
  }

  Future<DashboardModel?> getDashboardInfo() async {
    var result =
        await handleResponse(await getRequest(APIRoutes.getDashboardData));
    if (!checkSuccessCase(result)) {
      return null;
    }
    return DashboardModel.fromJson(result!.data);
  }

//Device

  Future updateDeviceStatus(Map req) async {
    await handleResponse(await postRequest(APIRoutes.updateDeviceStatus, req));
  }

  Future updateAttendanceStatus(Map req) async {
    await handleResponse(
        await postRequest(APIRoutes.updateAttendanceStatus, req));
  }

  Future<StatusResponse?> checkAttendanceStatus() async {
    var response =
        await handleResponse(await getRequest(APIRoutes.checkAttendanceStatus));

    if (!checkSuccessCase(response)) return null;

    var status = StatusResponse.fromJson(response?.data);
    log("response Status--->${response?.data}");
    return status;
  }

  Future<bool> registerDevice(Map req) async {
    var result =
        await handleResponse(await postRequest(APIRoutes.registerDevice, req));
    return checkSuccessCase(result);
  }

  Future<bool> resetPassword(Map req) async {
    var result = await handleResponse(
        await postRequest(APIRoutes.resetPasswordURL, req));
    return checkSuccessCase(result);
  }

  Future<String?> checkDevice(String deviceType, String deviceId) async {
    Map<String, String> query = {
      'deviceType': deviceType,
      'deviceId': deviceId
    };

    debugPrint("device para: $query");

    var param = Uri(queryParameters: query).query;

    try {
      var result = await handleResponse(
          await getRequestWithQuery(APIRoutes.checkDevice, param));
      debugPrint("device_status..response$result");
      if (result == null) {
        return null;
      }
      debugPrint("device_status..response${result.data}");
      return result.data.toString();
    } on Exception catch (e) {
      toast(e.toString());
      return null;
    }
  }

  Future<bool> forgotPassword(String number) async {
    var result = await handleResponse(
        await postRequest(APIRoutes.forgotPasswordURL, number));
    return checkSuccessCase(result);
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    var payload = {"oldPassword": oldPassword, "newPassword": newPassword};
    var response = await handleResponse(
        await postRequest(APIRoutes.changePasswordURL, payload));
    return checkSuccessCase(response, showError: true);
  }

  Future<bool> checkValidPhoneNumber(String phoneNumber) async {
    var response = await handleResponse(
        await postRequest(APIRoutes.phoneNumberCheckURL, phoneNumber));

    return checkSuccessCase(response);
  }

  Future<bool> checkValidEmployeeId(String employeeId) async {
    var response = await handleResponse(await postRequest(
        APIRoutes.userNameCheckURL, {'user_name': employeeId}));

    return checkSuccessCase(response);
  }

  Future<bool> verifyOTP(String phoneNumber, String otp) async {
    var payload = {"PhoneNumber": phoneNumber, "OTP": otp};
    var response = await handleResponse(
        await postRequest(APIRoutes.verifyOTPURL, payload));
    return checkSuccessCase(response);
  }

  Future<ScheduleModel?> getSchedules() async {
    var response =
        await handleResponse(await getRequest(APIRoutes.getScheduleURL));

    if (!checkSuccessCase(response)) {
      return null;
    }
    var schedule = ScheduleModel.fromJson(response?.data);
    return schedule;
  }

  Future addFirebaseToken(String deviceType, String token) async {
    var payload = {"DeviceType": deviceType, "Token": token};

    var response = await handleResponse(
        await postRequest(APIRoutes.addMessagingTokenURL, payload));

    if (!checkSuccessCase(response)) {
      toast("Unable to send firebase token to server");
    }
  }

  Future<List<Bank>?> getBanks() async {
    log("Getting called here");

    var response = await handleResponse(await getRequest(APIRoutes.bankList));
    log("API response handler ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ${response.toString()}");
    if (!checkSuccessCase(response)) {
      return null;
    }
    log("------------------true------------------");

    List<Bank> banks = [];

    response!.data.forEach((element) {
      log("decoding=====================================");
      //log(json.decode(element));
      Bank b = Bank.fromJson(element);
      // log("code is ${b.code}");
      banks.add(b);
    });

    return banks;
  }

  Future<List<VisitsModel>?> getVisits(String status) async {
    var response = await handleResponse(
        await getRequest('${APIRoutes.getVisitsURL}?status=$status'));
    if (!checkSuccessCase(response)) {
      return null;
    }

    List<VisitsModel> visits = [];

    response!.data.forEach((element) {
      VisitsModel v = VisitsModel.fromJson(element);
      visits.add(v);
    });

    return visits;
  }

  Future<String?> getWalletBalance() async {
    // var response = await handleResponse(await getRequest(APIRoutes.getWalletBalance));
    // if (!checkSuccessCase(response)) return null;
    // return response?.data.toString();

    var response = await getRequest(APIRoutes.getWalletBalance);
    if (response.statusCode == 200) {
      log("response body ${response.body}");
      log("response status code ${response.statusCode}");

      var data = json.decode(response.body);
      return data['balance'].toString();
    } else {
      return null;
    }
  }

  Future<CreateBankModel?> createBank(Map req) async {
    //var response = await handleResponse(await postRequest(APIRoutes.createBank, req));
    var response = await postRequest(APIRoutes.createBank, req);
    //if (!checkSuccessCase(response)) return null;

    return CreateBankModel.fromJson(json.decode(response.body));
  }

  Future<void> verifyBank(Map req) async {
    //var response = await handleResponse(await postRequest(APIRoutes.createBank, req));
    var response =
        await handleResponse(await postRequest(APIRoutes.verifyBank, req));
    log(response!.message!);
    toast(response.message);
  }

  bool checkSuccessCase(ApiResponseModel? response, {bool showError = false}) {
    if (!showError) {
      return response != null &&
          response.statusCode == 200 &&
          response.status?.toLowerCase() == 'success';
    } else {
      if (response == null) return false;
      if (response.statusCode == 400 && showError) {
        toast(response.data.toString());
        return false;
      } else {
        return response.statusCode == 200 &&
            response.status?.toLowerCase() == 'success';
      }
    }
  }
}
