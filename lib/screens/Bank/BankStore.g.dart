// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BankStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Bankstore on BankStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'BankStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
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

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
bankId: ${bankId},
amountSent: ${amountSent}
    ''';
  }
}
