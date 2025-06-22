import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/User_model.dart';

abstract class UserLocalDataSource {
  Future<void> cacheUser({required UserModel? UserToCache});
  Future<UserModel> getLastUser();
}

const cachedUser = 'CACHED_User';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel> getLastUser() {
    final jsonString = sharedPreferences.getString(cachedUser);

    if (jsonString != null) {
      return Future.value(UserModel.fromJson(json: json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheUser({required UserModel? UserToCache}) async {
    if (UserToCache != null) {
      sharedPreferences.setString(
        cachedUser,
        json.encode(
          UserToCache.toJson(),
        ),
      );
    } else {
      throw CacheException();
    }
  }
}