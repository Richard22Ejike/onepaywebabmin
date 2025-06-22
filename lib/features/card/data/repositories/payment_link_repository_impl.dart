import 'dart:convert';

import '../../../../core/connection/network_info.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../business/repositories/repository.dart';
import '../datasources/payment_link_data_source.dart';
import '../models/payment_link_model.dart';
import 'package:http/http.dart' as http;

class PaymentLinkRepositoryImpl implements PaymentLinkRepository {
  final PaymentLinkRemoteDataSource remoteDataSource;
  final PaymentLinkLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PaymentLinkRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<(Failure?, List<PaymentLinkModel>?)> getPaymentLinks(
      {required PaymentLinkParams PaymentLinkParams}) async {
    if (await networkInfo.isConnected!) {
      try {
        final response = await http.get(
          Uri.parse('$uri/transaction/get-payment-links/${PaymentLinkParams.customerId}'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${PaymentLinkParams.token}'
          },
        );

        if (response.statusCode >= 200 && response.statusCode <= 299) {
          final List<dynamic> jsonResponse = jsonDecode(response.body);
          List<PaymentLinkModel> remotePaymentLink = jsonResponse
              .map((PaymentLinkJson) => PaymentLinkModel.fromJson(PaymentLinkJson))
              .toList();
          return (null,remotePaymentLink);
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
        List<PaymentLinkModel> localPaymentLink = await localDataSource.getLastPaymentLinks();
        return (null,localPaymentLink);
      } catch(e) {
        return (CacheFailure(errorMessage: e.toString()),null);
      }
    }
  }
  @override
  Future<(Failure?, PaymentLinkModel?)> createPaymentLink(
      {required PaymentLinkParams PaymentLinkParams}) async {


        final response = await http.post(
          Uri.parse('$uri/transaction/create-payment-link/'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${PaymentLinkParams.token}'
          },
            body: jsonEncode({
              'customer_id': PaymentLinkParams.customerId,
              'name':  PaymentLinkParams.name,
              'description': PaymentLinkParams.description,
              'amount': PaymentLinkParams.amount,
              'currency':  'NGN',
              'account_id':  PaymentLinkParams.accountId,
            })
        );

        if (response.statusCode >= 200 && response.statusCode <= 299) {
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          PaymentLinkModel remotePaymentLink =
          PaymentLinkModel.fromJson( jsonResponse
          );
          return (null,remotePaymentLink);

        }     else{
          final Map<String, dynamic> errorJson = jsonDecode(response.body);
          // Extract the error message
          final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
          // Log the error message
          return (ServerFailure(errorMessage: errorMessage.toString()),null);
        }
      }



  }
