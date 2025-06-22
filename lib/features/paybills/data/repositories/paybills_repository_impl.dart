import 'dart:convert';
import 'dart:developer';

import 'package:onepluspay/features/paybills/business/entities/entity.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../business/repositories/repository.dart';
import '../datasources/paybills_local_data_source.dart';
import '../datasources/paybills_remote_data_source.dart';
import '../models/paybills_model.dart';
import 'package:http/http.dart' as http;

class PaybillsRepositoryImpl implements PaybillsRepository {
  final PaybillsRemoteDataSource remoteDataSource;
  final PaybillsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PaybillsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<(Failure?, PaybillsModel?)> getPaybills(
      {required PaybillsParams paybillsParams}) async {
    if (await networkInfo.isConnected!) {
      try {
        PaybillsModel remotePaybills =
        await remoteDataSource.getPaybills(paybillsParams: paybillsParams);

        localDataSource.cachePaybills(paybillsToCache: remotePaybills);

        return  (null,remotePaybills);
      } on ServerException {
        return (ServerFailure(errorMessage: 'This is a server exception'),null);
      }
    } else {
      try {
        PaybillsModel localPaybills = await localDataSource.getLastPaybills();
        return (null,localPaybills);
      } on CacheException {
        return (CacheFailure(errorMessage: 'This is a cache exception'),null);
      }
    }
  }

  @override
  Future<(Failure?, PayBillsEntity?)> payPaybills({required PaybillsParams paybillsParams}) async {
    try {
      log('the electricity code:${paybillsParams.electricCompanyCode}');
      log('the meter number:${paybillsParams.meterNo}');
      final response = await http.post(
          Uri.parse('$uri/transaction/make-bill-payment/${paybillsParams.customerId}/'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${paybillsParams.token}'
          },
          body: jsonEncode({
            "customer_id": paybillsParams.customerId,
            "account_id": paybillsParams.accountId,
            "amount": paybillsParams.amount,
            "operator_id": paybillsParams.operatorId,
            "meter_type": paybillsParams.meterType,
            "service_type": paybillsParams.serviceType,
            "mobile_network": paybillsParams.mobileNetwork,
            "mobile_number": paybillsParams.mobileNumber,
            "electric_company_code": paybillsParams.electricCompanyCode,
            "meter_no": paybillsParams.meterNo,
            "cable_tv_code": paybillsParams.cableTvCode,
            "smart_card_no": paybillsParams.smartCardNo,
            "betting_code": paybillsParams.bettingCode,
            "betting_customer_id": paybillsParams.bettingCustomerId,
            "request_id": paybillsParams.requestId,
            "callback_url": paybillsParams.callbackUrl,
            "data_plan": paybillsParams.dataPlan,
            "package_code": paybillsParams.packageCode,
            "pin": paybillsParams.pin
          })
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        PaybillsModel remoteCard =
        PaybillsModel.fromJson( json: jsonResponse
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

  @override
  Future<(Failure?, List<TvEntity>?)> Tvbills({required PaybillsParams paybillsParams}) async {
    try {
      log('biller item ${paybillsParams.customerId}');
      final response = await http.get(
          Uri.parse('https://api.flutterwave.com/v3/billers/${paybillsParams.customerId}/items'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            "authorization": "Bearer $secret_key"
          },

      );
      log(response.body);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        log(response.body);
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // Assuming that the 'items' key holds a list of items to be mapped to TvEntity
        final List<dynamic> itemsList = jsonResponse['data'];

        // Convert the items list to a List<TvEntity>
        final List<TvEntity> tvEntities = itemsList.map((item) => TvModel.fromJson( json: item)).toList();
        log(tvEntities.toString());
        return (null, tvEntities);
      }     else{

        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        // Log the error message
        log(errorJson['error']);
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }  catch(e) {
      return (ServerFailure(errorMessage: e.toString()),null);
    }
  }
}