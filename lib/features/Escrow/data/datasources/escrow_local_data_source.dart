import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/escrow_model.dart';



abstract class EscrowLocalDataSource {
  Future<void> cacheEscrows({required List<EscrowModel>? escrowsToCache});
  Future<List<EscrowModel>> getLastEscrows();


}
const cachedEscrow = 'CACHED_Escrow';


class EscrowLocalDataSourceImpl implements EscrowLocalDataSource {
  final SharedPreferences sharedPreferences;

  EscrowLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<EscrowModel>> getLastEscrows() {
    final jsonString = sharedPreferences.getString(cachedEscrow);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(jsonList.map((json) => EscrowModel.fromJson(json: json)).toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheEscrows({required List<EscrowModel>? escrowsToCache}) async {
    if (escrowsToCache != null) {
      sharedPreferences.setString(
        cachedEscrow,
        json.encode(
          escrowsToCache.map((escrow) => escrow.toJson()).toList(),
        ),
      );
    }
  }


}
