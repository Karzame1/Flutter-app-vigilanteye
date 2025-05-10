import 'package:fieldmanager_hrms_flutter/main.dart';
import 'package:fieldmanager_hrms_flutter/models/visits_model.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

part 'wallet_store.g.dart';

class WalletStore = WalletStoreBase with _$WalletStore;

abstract class WalletStoreBase with Store {
  @observable
  bool isApprovedVisitsLoading = false;
  @observable
  bool isPendingVisitsLoading = false;
  @observable
  bool isDeclinedVisitsLoading = false;
  @observable
  bool isWalletBalanceLoading = false;

  @observable
  ObservableList<VisitsModel> approvedVisits = ObservableList<VisitsModel>();
  @observable
  ObservableList<VisitsModel> pendingVisits = ObservableList<VisitsModel>();
  @observable
  ObservableList<VisitsModel> declinedVisits = ObservableList<VisitsModel>();

  @observable
  String walletBalance = '₦ 0.00';

  Future<void> fetchVisits(String status) async {
    try {
      switch (status) {
        case 'approved':
          log(status);
          isApprovedVisitsLoading = true;
          approvedVisits.clear();
          approvedVisits.addAll(await apiRepo.getVisits(status) ?? []);
          isApprovedVisitsLoading = false;
          break;
        case 'pending':
          log(status);
          isPendingVisitsLoading = true;
          pendingVisits.clear();
          pendingVisits.addAll(await apiRepo.getVisits(status) ?? []);
          isPendingVisitsLoading = false;
          break;
        case 'rejected':
          log(status);
          isDeclinedVisitsLoading = true;
          declinedVisits.clear();
          declinedVisits.addAll(await apiRepo.getVisits(status) ?? []);
          isDeclinedVisitsLoading = false;
          break;
        default:
          throw Exception('Invalid status: $status');
      }
    } catch (e) {
      log('Error fetching visits: $e');
      toast('Failed to load visits');
    }
  }

  Future<void> fetchWalletBalance() async {
    try {
      log("I am here");

      isWalletBalanceLoading = true;
      walletBalance = '₦ ${await apiRepo.getWalletBalance() ?? '0.00'}';
      isWalletBalanceLoading = false;
    } catch (e) {
      log('Error fetching wallet balance: $e');
      toast('Failed to load wallet balance');
    }
  }
}
