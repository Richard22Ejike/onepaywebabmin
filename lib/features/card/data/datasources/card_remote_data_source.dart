import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/params/params.dart';
import '../models/card_model.dart';
import 'package:http/http.dart' as http;

abstract class CardRemoteDataSource {
  Future<CardModel> getCard({required CardParams cardParams});
}

class CardRemoteDataSourceImpl implements CardRemoteDataSource {
  final http.Client httpClient;

  CardRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<CardModel> getCard({required CardParams cardParams}) async {
    final response = await httpClient.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon/'),
      headers: {
        'Content-Type': 'application/json', // Adjust headers if needed
        // Add any other headers here
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return CardModel.fromJson( json: jsonResponse
      );
    } else {
      throw ServerException();
    }
  }
}