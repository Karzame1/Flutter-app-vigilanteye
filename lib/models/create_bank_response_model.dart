class CreateBankModel {
  String? message;
  String? accountName;
  String? amountSent;
  int? bankId;
  bool? success;

  CreateBankModel(
      {this.message,
      this.accountName,
      this.amountSent,
      this.bankId,
      this.success});

  CreateBankModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    accountName = json['account_name'];
    amountSent = json['amount_sent'];
    bankId = json['bank_id'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['account_name'] = accountName;
    data['amount_sent'] = amountSent;
    data['bank_id'] = bankId;
    data['success'] = success;
    return data;
  }

  @override
  String toString() {
    return 'CreateBankModel{message: $message, accountName: $accountName, amountSent: $amountSent, bankId: $bankId, success: $success}';
  }
}