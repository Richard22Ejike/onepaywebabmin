import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/params/params.dart';
import '../models/escrow_model.dart';
import 'package:http/http.dart' as http;

abstract class EscrowRemoteDataSource {
  Future<EscrowModel> getEscrow({required EscrowParams escrowParams});
}

class EscrowRemoteDataSourceImpl implements EscrowRemoteDataSource {
  final http.Client httpClient;

  EscrowRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<EscrowModel> getEscrow({required EscrowParams escrowParams}) async {
    final response = await httpClient.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon/'),
      headers: {
        'Content-Type': 'application/json', // Adjust headers if needed
        // Add any other headers here
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return EscrowModel.fromJson( json: jsonResponse
      );
    } else {
      throw ServerException();
    }
  }
}