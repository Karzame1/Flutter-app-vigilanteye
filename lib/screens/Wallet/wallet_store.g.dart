// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WalletStore on WalletStoreBase, Store {
  late final _$isApprovedVisitsLoadingAtom =
      Atom(name: 'WalletStoreBase.isApprovedVisitsLoading', context: context);

  @override
  bool get isApprovedVisitsLoading {
    _$isApprovedVisitsLoadingAtom.reportRead();
    return super.isApprovedVisitsLoading;
  }

  @override
  set isApprovedVisitsLoading(bool value) {
    _$isApprovedVisitsLoadingAtom
        .reportWrite(value, super.isApprovedVisitsLoading, () {
      super.isApprovedVisitsLoading = value;
    });
  }

  late final _$isPendingVisitsLoadingAtom =
      Atom(name: 'WalletStoreBase.isPendingVisitsLoading', context: context);

  @override
  bool get isPendingVisitsLoading {
    _$isPendingVisitsLoadingAtom.reportRead();
    return super.isPendingVisitsLoading;
  }

  @override
  set isPendingVisitsLoading(bool value) {
    _$isPendingVisitsLoadingAtom
        .reportWrite(value, super.isPendingVisitsLoading, () {
      super.isPendingVisitsLoading = value;
    });
  }

  late final _$isDeclinedVisitsLoadingAtom =
      Atom(name: 'WalletStoreBase.isDeclinedVisitsLoading', context: context);

  @override
  bool get isDeclinedVisitsLoading {
    _$isDeclinedVisitsLoadingAtom.reportRead();
    return super.isDeclinedVisitsLoading;
  }

  @override
  set isDeclinedVisitsLoading(bool value) {
    _$isDeclinedVisitsLoadingAtom
        .reportWrite(value, super.isDeclinedVisitsLoading, () {
      super.isDeclinedVisitsLoading = value;
    });
  }

  late final _$isWalletBalanceLoadingAtom =
      Atom(name: 'WalletStoreBase.isWalletBalanceLoading', context: context);

  @override
  bool get isWalletBalanceLoading {
    _$isWalletBalanceLoadingAtom.reportRead();
    return super.isWalletBalanceLoading;
  }

  @override
  set isWalletBalanceLoading(bool value) {
    _$isWalletBalanceLoadingAtom
        .reportWrite(value, super.isWalletBalanceLoading, () {
      super.isWalletBalanceLoading = value;
    });
  }

  late final _$approvedVisitsAtom =
      Atom(name: 'WalletStoreBase.approvedVisits', context: context);

  @override
  ObservableList<VisitsModel> get approvedVisits {
    _$approvedVisitsAtom.reportRead();
    return super.approvedVisits;
  }

  @override
  set approvedVisits(ObservableList<VisitsModel> value) {
    _$approvedVisitsAtom.reportWrite(value, super.approvedVisits, () {
      super.approvedVisits = value;
    });
  }

  late final _$pendingVisitsAtom =
      Atom(name: 'WalletStoreBase.pendingVisits', context: context);

  @override
  ObservableList<VisitsModel> get pendingVisits {
    _$pendingVisitsAtom.reportRead();
    return super.pendingVisits;
  }

  @override
  set pendingVisits(ObservableList<VisitsModel> value) {
    _$pendingVisitsAtom.reportWrite(value, super.pendingVisits, () {
      super.pendingVisits = value;
    });
  }

  late final _$declinedVisitsAtom =
      Atom(name: 'WalletStoreBase.declinedVisits', context: context);

  @override
  ObservableList<VisitsModel> get declinedVisits {
    _$declinedVisitsAtom.reportRead();
    return super.declinedVisits;
  }

  @override
  set declinedVisits(ObservableList<VisitsModel> value) {
    _$declinedVisitsAtom.reportWrite(value, super.declinedVisits, () {
      super.declinedVisits = value;
    });
  }

  late final _$walletBalanceAtom =
      Atom(name: 'WalletStoreBase.walletBalance', context: context);

  @override
  String get walletBalance {
    _$walletBalanceAtom.reportRead();
    return super.walletBalance;
  }

  @override
  set walletBalance(String value) {
    _$walletBalanceAtom.reportWrite(value, super.walletBalance, () {
      super.walletBalance = value;
    });
  }

  @override
  String toString() {
    return '''
isApprovedVisitsLoading: ${isApprovedVisitsLoading},
isPendingVisitsLoading: ${isPendingVisitsLoading},
isDeclinedVisitsLoading: ${isDeclinedVisitsLoading},
isWalletBalanceLoading: ${isWalletBalanceLoading},
approvedVisits: ${approvedVisits},
pendingVisits: ${pendingVisits},
declinedVisits: ${declinedVisits},
walletBalance: ${walletBalance}
    ''';
  }
}
