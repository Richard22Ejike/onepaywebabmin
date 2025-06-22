import 'dart:convert';
import 'dart:developer';
import '../../../../core/constants/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/params/params.dart';
import '../models/User_model.dart';
import 'package:http/http.dart' as http;

abstract class UserRemoteDataSource {

}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client httpClient;

  UserRemoteDataSourceImpl({required this.httpClient});

}