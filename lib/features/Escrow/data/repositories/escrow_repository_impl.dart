import 'dart:convert';
import 'dart:developer';



import '../../../../core/connection/network_info.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../../Auth/business/entities/entity.dart';
import '../../../Auth/data/models/User_model.dart';

import 'package:http/http.dart' as http;

import '../../business/entities/entity.dart';
import '../../business/repositories/repository.dart';
import '../datasources/escrow_local_data_source.dart';
import '../datasources/escrow_remote_data_source.dart';
import '../models/escrow_model.dart';

class EscrowRepositoryImpl implements EscrowRepository {
  final EscrowRemoteDataSource remoteDataSource;
  final EscrowLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  EscrowRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<(Failure?, List<EscrowModel>?)> getEscrow(
      {required EscrowParams escrowParams}) async {
    // if (await networkInfo.isConnected!) {
      try {
        final response = await http.get(
          Uri.parse('$uri/transaction/get-escrows/${escrowParams.customerId}/'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${escrowParams.token}'
          },
        );

        if (response.statusCode >= 200 && response.statusCode <= 299) {
          final List<dynamic> jsonResponse = jsonDecode(response.body);
          log('this is escrow ${response.body}');
          List<EscrowModel> remoteEscrow = jsonResponse
              .map((escrowJson) => EscrowModel.fromJson(json: escrowJson))
              .toList();
          return (null,remoteEscrow);
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
    // }
    //
    // else {
    //   try {
    //     List<EscrowModel> localEscrow = await localDataSource.getLastEscrows();
    //     return (null,localEscrow);
    //   } catch(e) {
    //     return (CacheFailure(errorMessage: e.toString()),null);
    //   }
    // }
  }

  @override
  Future<(Failure?, String?)> getUserEscrow(
      {required EscrowParams escrowParams}) async {

      try {
        final response = await http.get(
          Uri.parse('$uri/transaction/get-user-escrows/${escrowParams.receiverEmail}/'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${escrowParams.token}'
          },
        );

        if (response.statusCode >= 200 && response.statusCode <= 299) {
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          UserModel remote = UserModel.fromJson(json: jsonResponse);
          String id = remote.id.toString();
          log(id);
          return (null,id);
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
  Future<(Failure?, EscrowEntity?)> makeEscrow({required EscrowParams escrowParams}) async {
    try {
      log('good');

      final response = await http.post(
          Uri.parse('$uri/transaction/create-escrow/${escrowParams.customerId}/'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${escrowParams.token}'
          },
          body: jsonEncode({
            'customer_id':escrowParams.customerId,
            'escrow_description':escrowParams.escrowDescription,
            'amount':escrowParams.amount,
            'sender_name':escrowParams.escrowName,
            'escrow_name':escrowParams.escrowName,
            'estimated_days':escrowParams.estimated_days,
            'number_milestone':escrowParams.number_milestone,
            'account_id':escrowParams.accountId,
            'receiver_email':escrowParams.receiverEmail,
            'escrow_Status':escrowParams.escrow_Status,
            'payment_type':'One-time',
            'role':escrowParams.role,
            'role_paying':escrowParams.role_paying,
            'milestone':escrowParams.milestone,
            'receiver_id':escrowParams.receiver_id,
            'pin':escrowParams.pin


          })
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        log(response.body);
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        EscrowModel remoteEscrow =
        EscrowModel.fromJson( json: jsonResponse
        );
        return (null,remoteEscrow);
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
  Future<(Failure?, EscrowEntity?)> EditEscrow({required EscrowParams escrowParams}) async {
    try {
      final response = await http.post(
          Uri.parse('$uri/escrow/fund-account-with-card/${escrowParams.customerId}/'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${escrowParams.token}'
          },
          body: jsonEncode({
            'amount':escrowParams.amount,
          })
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        EscrowModel remoteEscrow =
        EscrowModel.fromJson( json: jsonResponse
        );
        return (null,remoteEscrow);
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
  Future<(Failure?, EscrowEntity?)> updateEscrow({required EscrowParams escrowParams}) async {
    try {
      final response = await http.put(
          Uri.parse('$uri/transaction/update-escrow/${escrowParams.id}/'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${escrowParams.token}'
          },
          body: jsonEncode({
            'disabled':escrowParams.disabled,
            'escrow_status':escrowParams.escrow_Status,
          })
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        EscrowModel remoteEscrow =
        EscrowModel.fromJson( json: jsonResponse
        );
        return (null,remoteEscrow);
      }     else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }  catch(e) {
      return (ServerFailure(errorMessage: e.toString()),null);
    };
  }

  @override
  Future<(Failure?, EscrowEntity?)> disputeEscrow({required EscrowParams escrowParams}) async {
    try {
      final response = await http.put(
          Uri.parse('$uri/transaction/dispute-escrow/${escrowParams.id}/'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${escrowParams.token}'
          },
          body: jsonEncode({
            'dispute':escrowParams.dispute,
            'escrow_status':escrowParams.escrow_Status,
          })
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        EscrowModel remoteEscrow =
        EscrowModel.fromJson( json: jsonResponse
        );
        return (null,remoteEscrow);
      }     else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }  catch(e) {
      return (ServerFailure(errorMessage: e.toString()),null);
    };
  }

  @override
  Future<(Failure?, EscrowEntity?)> makePaymentEscrow({required EscrowParams escrowParams}) async {
    try {
      final response = await http.put(
          Uri.parse('$uri/transaction/make-payment-escrows/${escrowParams.customerId}/'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${escrowParams.token}'
          },
          body: jsonEncode({
            'amount':escrowParams.amount,
            'escrow_id':escrowParams.id,

          })
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        EscrowModel remoteEscrow =
        EscrowModel.fromJson( json: jsonResponse
        );
        return (null,remoteEscrow);
      }     else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }  catch(e) {
      return (ServerFailure(errorMessage: e.toString()),null);
    };
  }

  @override
  Future<(Failure?, EscrowEntity?)> releaseEscrowFund({required EscrowParams escrowParams}) async {
    try {
      final response = await http.put(
          Uri.parse('$uri/transaction/release-escrows-fund/${escrowParams.id}/'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${escrowParams.token}'
          },
          body: jsonEncode({
            'amount':escrowParams.amount,
            'escrow_status':escrowParams.escrow_Status,
          })
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        EscrowModel remoteEscrow =
        EscrowModel.fromJson( json: jsonResponse
        );
        return (null,remoteEscrow);
      }     else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }  catch(e) {
      return (ServerFailure(errorMessage: e.toString()),null);
    };
  }
  @override
  Future<(Failure?, List<ChatEntity>?)> getChat({required EscrowParams escrowParams}) async {
    try {
      log(escrowParams.chatId!);
      final response = await http.get(
          Uri.parse('$uri/transaction/get-message/${escrowParams.chatId}/'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${escrowParams.token}'
          },

      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        log(response.body);
        List<ChatModel> remoteChat = jsonResponse
            .map((chatJson) => ChatModel.fromJson(json: chatJson))
            .toList();
        return (null,remoteChat);
      }     else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }  catch(e) {
      return (ServerFailure(errorMessage: e.toString()),null);
    };
  }

}