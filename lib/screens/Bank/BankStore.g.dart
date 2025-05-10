// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BankStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Bankstore on BankStoreBase, Store {
  late final _$isVerifyBankLoadingAtom =
      Atom(name: 'BankStoreBase.isVerifyBankLoading', context: context);

  @override
  bool get isVerifyBankLoading {
    _$isVerifyBankLoadingAtom.reportRead();
    return super.isVerifyBankLoading;
  }

  @override
  set isVerifyBankLoading(bool value) {
    _$isVerifyBankLoadingAtom.reportWrite(value, super.isVerifyBankLoading, () {
      super.isVerifyBankLoading = value;
    });
  }

  late final _$isCreateBankLoadingAtom =
      Atom(name: 'BankStoreBase.isCreateBankLoading', context: context);

  @override
  bool get isCreateBankLoading {
    _$isCreateBankLoadingAtom.reportRead();
    return super.isCreateBankLoading;
  }

  @override
  set isCreateBankLoading(bool value) {
    _$isCreateBankLoadingAtom.reportWrite(value, super.isCreateBankLoading, () {
      super.isCreateBankLoading = value;
    });
  }

  late final _$isFetchBankLoadingAtom =
      Atom(name: 'BankStoreBase.isFetchBankLoading', context: context);

  @override
  bool get isFetchBankLoading {
    _$isFetchBankLoadingAtom.reportRead();
    return super.isFetchBankLoading;
  }

  @override
  set isFetchBankLoading(bool value) {
    _$isFetchBankLoadingAtom.reportWrite(value, super.isFetchBankLoading, () {
      super.isFetchBankLoading = value;
    });
  }

  late final _$bankIdAtom =
      Atom(name: 'BankStoreBase.bankId', context: context);

  @override
  String get bankId {
    _$bankIdAtom.reportRead();
    return super.bankId;
  }

  @override
  set bankId(String value) {
    _$bankIdAtom.reportWrite(value, super.bankId, () {
      super.bankId = value;
    });
  }

  late final _$amountSentAtom =
      Atom(name: 'BankStoreBase.amountSent', context: context);

  @override
  String get amountSent {
    _$amountSentAtom.reportRead();
    return super.amountSent;
  }

  @override
  set amountSent(String value) {
    _$amountSentAtom.reportWrite(value, super.amountSent, () {
      super.amountSent = value;
    });
  }

  late final _$banksAtom = Atom(name: 'BankStoreBase.banks', context: context);

  @override
  ObservableList<Bank> get banks {
    _$banksAtom.reportRead();
    return super.banks;
  }

  @override
  set banks(ObservableList<Bank> value) {
    _$banksAtom.reportWrite(value, super.banks, () {
      super.banks = value;
    });
  }

  @override
  String toString() {
    return '''
isVerifyBankLoading: ${isVerifyBankLoading},
isCreateBankLoading: ${isCreateBankLoading},
isFetchBankLoading: ${isFetchBankLoading},
bankId: ${bankId},
amountSent: ${amountSent},
banks: ${banks}
    ''';
  }
}
