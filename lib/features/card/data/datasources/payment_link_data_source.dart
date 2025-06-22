import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/payment_link_model.dart';
import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/params/params.dart';
import '../models/card_model.dart';
import 'package:http/http.dart' as http;

abstract class PaymentLinkLocalDataSource {
  Future<void> cachePaymentLink({required List <PaymentLinkModel>? paymentLinkToCache});
  Future<List<PaymentLinkModel>> getLastPaymentLinks();
}

const cachedPaymentLink = 'CACHED_PaymentLink';

class PaymentLinkLocalDataSourceImpl implements PaymentLinkLocalDataSource {
  final SharedPreferences sharedPreferences;

  PaymentLinkLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<PaymentLinkModel>> getLastPaymentLinks() {
    final jsonString = sharedPreferences.getString(cachedPaymentLink);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(jsonList.map((json) => PaymentLinkModel.fromJson( json)).toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cachePaymentLink({required List<PaymentLinkModel>? paymentLinkToCache}) async {
    if (paymentLinkToCache != null) {
      sharedPreferences.setString(
        cachedPaymentLink,
        json.encode(
          paymentLinkToCache.map((paymentLink) => paymentLink.toJson()).toList(),

        ),
      );
    } else {
      throw CacheException();
    }
  }
}


abstract class PaymentLinkRemoteDataSource {
  Future<PaymentLinkModel> getPaymentLink({required PaymentLinkParams paymentLinkParams});
}

class PaymentLinkRemoteDataSourceImpl implements PaymentLinkRemoteDataSource {
  final http.Client httpClient;

  PaymentLinkRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<PaymentLinkModel> getPaymentLink({required PaymentLinkParams paymentLinkParams}) async {
    final response = await httpClient.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon/'),
      headers: {
        'Content-Type': 'application/json', // Adjust headers if needed
        // Add any other headers here
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return PaymentLinkModel.fromJson(  jsonResponse
      );
    } else {
      throw ServerException();
    }
  }
}