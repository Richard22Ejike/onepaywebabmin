import 'dart:convert';
import 'dart:developer';


import 'package:onepluspay/features/NearMe/business/entities/entity.dart';
import 'package:onepluspay/features/Transactions/business/entities/entity.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../../Auth/business/entities/entity.dart';
import '../../../Auth/data/models/User_model.dart';
import '../../../Escrow/business/entities/entity.dart';
import '../../../Escrow/data/models/escrow_model.dart';
import '../../../NearMe/data/models/near_me_model.dart';
import '../../../card/business/entities/card_entity.dart';
import '../../../card/business/entities/payment_link_entity.dart';
import '../../../card/data/models/card_model.dart';
import '../../../card/data/models/payment_link_model.dart';
import '../../../paybills/business/entities/entity.dart';
import '../../../paybills/data/models/paybills_model.dart';
import '../../business/repositories/repository.dart';
import '../datasources/transaction_local_data_source.dart';
import '../datasources/transaction_remote_data_source.dart';
import '../models/transaction_model.dart';
import 'package:http/http.dart' as http;

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;
  final TransactionLocalDataSource localDataSource;


  TransactionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,

  });

  @override
  Future<(Failure?, List<TransactionModel>?)> getTransaction(
      {required TransactionParams transactionParams}) async {

      try {
        final response = await http.get(
          Uri.parse('$uri/transaction/get-all-transactions/'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${transactionParams.token}'
          },
        );

        if (response.statusCode >= 200 && response.statusCode <= 299) {
          final List<dynamic> jsonResponse = jsonDecode(response.body);
          List<TransactionModel> remoteTransaction = jsonResponse
              .map((transactionJson) => TransactionModel.fromJson(json: transactionJson))
              .toList();
          return (null,remoteTransaction);
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
  Future<(Failure?, List<CardEntity>?)> cards({required TransactionParams transactionParams}) async {
    try {
      final response = await http.get(
          Uri.parse('$uri/transaction/get-all-cards/'),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
          'authorization': 'Bearer $secret_key'
        },

      );
      print('Cards:  the dsa ${response.body}');
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        print('Cards: ${response.body}');
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        List<CardModel> remoteTransaction = jsonResponse
            .map((transactionJson) => CardModel.fromJson(json: transactionJson))
            .toList();
        return (null,remoteTransaction);


      } else {
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        return (ServerFailure(errorMessage: errorMessage.toString()), null);
      }
    } catch (e) {
      return (ServerFailure(errorMessage: e.toString()), null);
    }


  }
  @override
  Future<(Failure?, List<BankModel>?)> getBank() async {

      try {
        final response = await http.get(
          Uri.parse('https://api.blochq.io/v1/banks'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            "accept": "application/json",
            "authorization": "Bearer $secret_key"
          },
        );

        if (response.statusCode >= 200 && response.statusCode <= 299) {
          final List<dynamic> jsonResponse = jsonDecode(response.body)['data'];
          List<BankModel> banks = jsonResponse
              .map((bankJson) => BankModel.fromJson(json: bankJson))
              .toList();

          // Cache the list of banks
          localDataSource.cacheBanks(banksToCache: banks);
          return (null, banks);
        } else {
          final Map<String, dynamic> errorJson = jsonDecode(response.body);
          // Extract the error message
          final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
          // Log the error message
          return (ServerFailure(errorMessage: errorMessage.toString()), null);
        }
      } catch (e) {
        return (ServerFailure(errorMessage: e.toString()), null);
      }

  }

  @override
  Future<(Failure?, List<EscrowEntity>?)> escrows({required TransactionParams transactionParams}) async {
    try {
      final response = await http.get(
          Uri.parse('$uri/transaction/get-all-escrows/'),
        headers: {
          'Content-Type': 'application/json', // Adjust headers if needed
          'Authorization': 'Bearer ${transactionParams.token}'
        },

      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        List<EscrowModel> remoteTransaction = jsonResponse
            .map((transactionJson) => EscrowModel.fromJson(json: transactionJson))
            .toList();
        return (null,remoteTransaction);
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
  Future<(Failure?, List<PaymentLinkEntity>?)> paymentlinks({required TransactionParams transactionParams}) async {
    try {
      final response = await http.get(
          Uri.parse('$uri/transaction/get-all-paymentlinks/'),
        headers: {
          'Content-Type': 'application/json', // Adjust headers if needed
          'Authorization': 'Bearer ${transactionParams.token}'
        },

      );
      print('Payment link: 679 ${response.body}');
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        print('Payment link: 12 ');
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        List<PaymentLinkModel> remoteTransaction = jsonResponse
            .map((transactionJson) {
          try {
            return PaymentLinkModel.fromJson(transactionJson);
          } catch (e) {
            print('Error parsing payment link: $e');
            return null; // or throw if you want to skip entire list
          }
        })
            .whereType<PaymentLinkModel>()
            .toList();


        print('Payment link: 123 ');
        return (null,remoteTransaction);
      }     else{

        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        // Log the error message
        print('Payment link: 123 NO');
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }  catch(e) {
      return (ServerFailure(errorMessage: e.toString()),null);
    }
  }
  @override
  Future<(Failure?, List<UserEntity>?)> getUsers({required TransactionParams transactionParams}) async {
    print('Good2');
    try {
      print('good4');
      final response = await http.get(
        Uri.parse('$uri/users/'),
        headers: {
          'Content-Type': 'application/json', // Adjust headers if needed

        },
      );
      print(response.body);
        print(response);
      if (response.statusCode >= 200 && response.statusCode <= 299) {

        final List<dynamic> jsonResponse = jsonDecode(response.body);
        List<UserModel> remoteUsers =
        jsonResponse
            .map((transactionJson) => UserModel.fromJson(json: transactionJson))
            .toList();
        return (null,remoteUsers);
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
  Future<(Failure?, List<PayBillsEntity>?)> paybills({required TransactionParams transactionParams}) async {
    try {
      final response = await http.get(
          Uri.parse('$uri/transaction/get-all-paybills/'),
        headers: {
          'Content-Type': 'application/json', // Adjust headers if needed
          'Authorization': 'Bearer ${transactionParams.token}'
        },

      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        List<PaybillsModel> remoteTransaction = jsonResponse
            .map((transactionJson) => PaybillsModel.fromJson(json: transactionJson))
            .toList();
        return (null,remoteTransaction);
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
  Future<(Failure?, String?)> getAccountName({required TransactionParams transactionParams}) async {
    try {
      final response = await http.post(
          Uri.parse('$uri/transaction/verify-bill-payment/'),
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
            'Authorization': 'Bearer ${transactionParams.token}'
          },
          body: jsonEncode({
            'service_type':'electricity',
            "electric_company_code":transactionParams.bankCode,
            "meter_no":transactionParams.bankCode,
            "account_bank":transactionParams.bankCode,
            "account_number":transactionParams.accountNumber
          })
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        log(response.body);
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        String accountName = jsonResponse['name'];

        // Cache the account name if needed
        // localDataSource.cacheAccountName(accountName: accountName);

        return (null, accountName);
      } else {
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        return (ServerFailure(errorMessage: errorMessage.toString()), null);
      }
    } catch (e) {
      return (ServerFailure(errorMessage: e.toString()), null);
    }
  }

  @override
  Future<(Failure?, List<NearMeEntity>?)> nearmes({required TransactionParams transactionParams}) async {
    try {
      print('nearmes up');
      final response = await http.get(
          Uri.parse('$uri/near-me/get-nearmes/'),
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
            'Authorization': 'Bearer ${transactionParams.token}'
          },

      );
      print('nearmes');
      print(response.body);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        List<NearMeModel> remoteTransaction = jsonResponse
            .map((transactionJson) => NearMeModel.fromJson(json: transactionJson))
            .toList();
        return (null,remoteTransaction);
      } else {
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        return (ServerFailure(errorMessage: errorMessage.toString()), null);
      }
    } catch (e) {
      return (ServerFailure(errorMessage: e.toString()), null);
    }
  }

}