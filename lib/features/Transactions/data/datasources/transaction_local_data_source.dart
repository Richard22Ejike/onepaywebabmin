import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/transaction_model.dart';


abstract class TransactionLocalDataSource {
  Future<void> cacheTransactions({required List<TransactionModel>? transactionsToCache});
  Future<List<TransactionModel>> getLastTransactions();

  Future<void> cacheBanks({required List<BankModel>? banksToCache});
  Future<List<BankModel>> getLastBanks();
}
const cachedTransaction = 'CACHED_Transaction';
const cachedBank = 'CACHED_Bank';

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final SharedPreferences sharedPreferences;

  TransactionLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<TransactionModel>> getLastTransactions() {
    final jsonString = sharedPreferences.getString(cachedTransaction);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(jsonList.map((json) => TransactionModel.fromJson(json: json)).toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheTransactions({required List<TransactionModel>? transactionsToCache}) async {
    if (transactionsToCache != null) {
      sharedPreferences.setString(
        cachedTransaction,
        json.encode(
          transactionsToCache.map((transaction) => transaction.toJson()).toList(),
        ),
      );
    }
  }

  @override
  Future<void> cacheBanks({required List<BankModel>? banksToCache}) async {
    if (banksToCache != null) {
      sharedPreferences.setString(
        cachedBank,
        json.encode(
          banksToCache.map((bank) => bank.toJson()).toList(),
        ),
      );
    }
  }

  @override
  Future<List<BankModel>> getLastBanks() {
    final jsonString = sharedPreferences.getString(cachedBank);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(jsonList.map((json) => BankModel.fromJson(json: json)).toList());
    } else {
      final List<dynamic> jsonList = json.decode('');
      return Future.value(jsonList.map((json) => BankModel.fromJson(json: json)).toList());
    }
  }
}
