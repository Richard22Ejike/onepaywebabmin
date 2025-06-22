import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/card_model.dart';

abstract class CardLocalDataSource {
  Future<void> cacheCards({required List<CardModel>? cardToCache});
  Future<List<CardModel>> getLastCards();
}

const cachedCard = 'CACHED_Card';

class CardLocalDataSourceImpl implements CardLocalDataSource {
  final SharedPreferences sharedPreferences;

  CardLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<CardModel>> getLastCards() {
    final jsonString = sharedPreferences.getString(cachedCard);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(jsonList.map((json) => CardModel.fromJson(json: json)).toList());
    } else {
      return Future.value(CardModel.fromJson(json: {}) as FutureOr<List<CardModel>>?);
    }
  }

  @override
  Future<void> cacheCards({required List<CardModel>? cardToCache}) async {
    if (cardToCache != null) {
      sharedPreferences.setString(
        cachedCard,
        json.encode(
          cardToCache.map((card) => card.toJson()).toList(),
        ),
      );
    }
  }
}