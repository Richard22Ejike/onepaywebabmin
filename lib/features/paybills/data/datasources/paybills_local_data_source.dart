import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/paybills_model.dart';

abstract class PaybillsLocalDataSource {
  Future<void> cachePaybills({required PaybillsModel? paybillsToCache});
  Future<PaybillsModel> getLastPaybills();
}

const cachedPaybills = 'CACHED_Paybills';

class PaybillsLocalDataSourceImpl implements PaybillsLocalDataSource {
  final SharedPreferences sharedPreferences;

  PaybillsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<PaybillsModel> getLastPaybills() {
    final jsonString = sharedPreferences.getString(cachedPaybills);

    if (jsonString != null) {
      return Future.value(PaybillsModel.fromJson(json: json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cachePaybills({required PaybillsModel? paybillsToCache}) async {
    if (paybillsToCache != null) {
      sharedPreferences.setString(
        cachedPaybills,
        json.encode(
          paybillsToCache.toJson(),
        ),
      );
    } else {
      throw CacheException();
    }
  }
}