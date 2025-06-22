import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/params/params.dart';
import '../models/near_me_model.dart';
import 'package:http/http.dart' as http;

abstract class NearMeRemoteDataSource {
  Future<NearMeModel> getNearMe({required NearMeParams escrowParams});
}

class NearMeRemoteDataSourceImpl implements NearMeRemoteDataSource {
  final http.Client httpClient;

  NearMeRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<NearMeModel> getNearMe({required NearMeParams escrowParams}) async {
    final response = await httpClient.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon/'),
      headers: {
        'Content-Type': 'application/json', // Adjust headers if needed
        // Add any other headers here
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return NearMeModel.fromJson( json: jsonResponse
      );
    } else {
      throw ServerException();
    }
  }
}