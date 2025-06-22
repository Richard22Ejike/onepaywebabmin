import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/params/params.dart';
import '../models/transaction_model.dart';
import 'package:http/http.dart' as http;

abstract class TransactionRemoteDataSource {

}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final http.Client httpClient;

  TransactionRemoteDataSourceImpl({required this.httpClient});

}