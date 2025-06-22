import 'dart:convert';

import '../../../../core/constants/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/params/params.dart';
import '../models/paybills_model.dart';
import 'package:http/http.dart' as http;

abstract class PaybillsRemoteDataSource {
  Future<PaybillsModel> getPaybills({required PaybillsParams paybillsParams});
}

class PaybillsRemoteDataSourceImpl implements PaybillsRemoteDataSource {
  final http.Client httpClient;

  PaybillsRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<PaybillsModel> getPaybills({required PaybillsParams paybillsParams}) async {
    final response = await httpClient.get(
      Uri.parse('$uri/transaction/get-payment-links/${paybillsParams.productId}/'),
      headers: {
        'Content-Type': 'application/json', // Adjust headers if needed
        // Add any other headers here
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return PaybillsModel.fromJson( json: jsonResponse
      );
    } else {
      throw ServerException();
    }
  }
}