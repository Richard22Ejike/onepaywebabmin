import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/near_me_model.dart';



abstract class NearMeLocalDataSource {
  Future<void> cacheNearMes({required List<NearMeModel>? NearMesToCache});
  Future<List<NearMeModel>> getLastNearMes();


}
const cachedNearMe = 'CACHED_NearMe';


class NearMeLocalDataSourceImpl implements NearMeLocalDataSource {
  final SharedPreferences sharedPreferences;

  NearMeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<NearMeModel>> getLastNearMes() {
    final jsonString = sharedPreferences.getString(cachedNearMe);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(jsonList.map((json) => NearMeModel.fromJson(json: json)).toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNearMes({required List<NearMeModel>? NearMesToCache}) async {
    if (NearMesToCache != null) {
      sharedPreferences.setString(
        cachedNearMe,
        json.encode(
          NearMesToCache.map((NearMe) => NearMe.toJson()).toList(),
        ),
      );
    }
  }


}
