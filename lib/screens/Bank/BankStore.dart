import 'package:fieldmanager_hrms_flutter/main.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../models/bank_list_model.dart';

part 'BankStore.g.dart';

class Bankstore = BankStoreBase with _$Bankstore;

abstract class BankStoreBase with Store {
  @observable
  bool isLoading = false;

  @observable
  String bankId = '';

  @observable
  String amountSent = '';

  @observable
  ObservableList<Bank> banks = ObservableList<Bank>();

  Future<void> fetchBanks() async {
    isLoading = true;
    try {
      final response = await apiRepo.getBanks();
      log("bank list found is :${response?.data}");
      if (response != null && response.status) {
        final data = response.data as List;
        runInAction(() {
          banks.clear();
          banks.addAll(data.map((item) => Bank.fromJson(item)));
        });
      }
    } catch (e) {
      log('Error fetching banks: $e');
      toast('Failed to load banks');
    } finally {
      isLoading = false;
    }
  }
  Future<void> createBank(String bankCode, String accountNumber) async {
    isLoading = true;
    Map req = {"bank_code": bankCode, "account_number": accountNumber};
    var result = await apiRepo.createBank(req);
    log(result.toString());

    toast(result!.message);

    if (result.success!) {
      bankId = result.bankId.toString();
      amountSent = result.amountSent ?? '';
    }
    // if (result != null) {
    //   bankId = result.bankId.toString();
    //   amountSent = result.amountSent ?? '';
    //   toast(result.message);
    // } else {
    //   toast('Unable to create bank');
    // }
    isLoading = false;
  }

  Future<void> verifyBank() async {
    isLoading = true;
    Map req = {"bank_id": bankId, "amount_received": amountSent};    
    await apiRepo.verifyBank(req);
  }
}
