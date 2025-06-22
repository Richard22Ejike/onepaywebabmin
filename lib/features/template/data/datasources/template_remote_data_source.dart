import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/params/params.dart';
import '../models/template_model.dart';
import 'package:http/http.dart' as http;

abstract class TemplateRemoteDataSource {
  Future<TemplateModel> getTemplate({required TemplateParams templateParams});
}

class TemplateRemoteDataSourceImpl implements TemplateRemoteDataSource {
  final http.Client httpClient;

  TemplateRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<TemplateModel> getTemplate({required TemplateParams templateParams}) async {
    final response = await httpClient.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon/'),
      headers: {
        'Content-Type': 'application/json', // Adjust headers if needed
        // Add any other headers here
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return TemplateModel.fromJson( json: jsonResponse
      );
    } else {
      throw ServerException();
    }
  }
}