class Bank {
  final int id;
  final String name;
  final String code;

  Bank({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }

  @override
  String toString() => 'Bank(id: $id, name: $name, code: $code)';
}

class BankResponse {
  final bool status;
  final String message;
  final List<Bank> data;

  BankResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BankResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<Bank> banks = dataList.map((i) => Bank.fromJson(i)).toList();

    return BankResponse(
      status: json['status'],
      message: json['message'],
      data: banks,
    );
  }
}