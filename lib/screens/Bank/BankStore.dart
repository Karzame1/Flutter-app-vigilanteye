import 'package:fieldmanager_hrms_flutter/main.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../models/bank_list_model.dart';

part 'BankStore.g.dart';

class Bankstore = BankStoreBase with _$Bankstore;

abstract class BankStoreBase with Store {
  @observable
  bool isVerifyBankLoading = false;

  @observable
  bool isCreateBankLoading = false;

  @observable
  bool isFetchBankLoading = false;

  @observable
  String bankId = '';

  @observable
  String amountSent = '';

  @observable
  ObservableList<Bank> banks = ObservableList<Bank>();

  Future<void> fetchBanks() async {
    isFetchBankLoading = true;
    try {
      banks.addAll(await apiRepo.getBanks()??[]);
      log("bank list found is :$banks");
      log("Bank length is ${banks.length}");
      // if (response != null && response.status) {
      //   final data = response.data as List;
      //   banks.clear();
      //   banks.addAll(data.map((e) => Bank.fromJson(e)).toList());
      // }
    } catch (e) {
      log('Error fetching banks: $e');
      toast('Failed to load banks');
    } finally {
      isFetchBankLoading = false;
    }
  }
  Future<void> createBank(String bankCode, String accountNumber) async {
    isCreateBankLoading = true;
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
    isCreateBankLoading = false;
  }

  Future<void> verifyBank() async {
    isVerifyBankLoading = true;
    Map req = {"bank_id": bankId, "amount_received": amountSent};    
    await apiRepo.verifyBank(req);
    isVerifyBankLoading = false;
  }
}
