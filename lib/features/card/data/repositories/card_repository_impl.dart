import 'dart:convert';

import '../../../../core/connection/network_info.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../business/repositories/repository.dart';
import '../datasources/card_local_data_source.dart';
import '../datasources/card_remote_data_source.dart';
import '../models/card_model.dart';
import 'package:http/http.dart' as http;

class CardRepositoryImpl implements CardRepository {
  final CardRemoteDataSource remoteDataSource;
  final CardLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CardRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<(Failure?, List<CardModel>?)> getCards(
      {required CardParams cardParams}) async {
    if (await networkInfo.isConnected!) {
      try {
        final response = await http.get(
          Uri.parse('$uri/transaction/get-cards/${cardParams.customerId}'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${cardParams.token}'
          },
        );

        if (response.statusCode >= 200 && response.statusCode <= 299) {
          final List<dynamic> jsonResponse = jsonDecode(response.body);
          List<CardModel> remoteCard = jsonResponse
              .map((CardJson) => CardModel.fromJson(json: CardJson))
              .toList();
          return (null,remoteCard);
        }     else{
          final Map<String, dynamic> errorJson = jsonDecode(response.body);
          // Extract the error message
          final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
          // Log the error message
          return (ServerFailure(errorMessage: errorMessage.toString()),null);
        }
      }  catch(e) {
        return (ServerFailure(errorMessage: e.toString()),null);
      }
    } else {
      try {
        List<CardModel> localCard = await localDataSource.getLastCards();
        return (null,localCard);
      } catch(e) {
        return (CacheFailure(errorMessage: e.toString()),null);
      }
    }
  }
  @override
  Future<(Failure?, CardModel?)> addCard(
      {required CardParams cardParams}) async {
      try {
        final response = await http.post(
          Uri.parse('$uri/transaction/issue-card/'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${cardParams.token}'
          },
            body: jsonEncode({
              'customer_id': cardParams.customerId,
              'card_number':  cardParams.cardNumber,
              'brand':'MasterCard',
              'narration': cardParams.narration,
              'pin': cardParams.pin,
              'cvv':  cardParams.cvv,
              'expiry_month':  cardParams.expiryMonth,
              'expiry_year':  cardParams.expiryYear,
              'amount':  cardParams.amount,
              'gender':  cardParams.gender,
            })
        );

        if (response.statusCode >= 200 && response.statusCode <= 299) {
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          CardModel remoteCard =
          CardModel.fromJson( json: jsonResponse
          );
          return (null,remoteCard);
        }     else{
          final Map<String, dynamic> errorJson = jsonDecode(response.body);
          // Extract the error message
          final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
          // Log the error message
          return (ServerFailure(errorMessage: errorMessage.toString()),null);
        }
      }  catch(e) {
        return (ServerFailure(errorMessage: e.toString()),null);
      }
  }
}