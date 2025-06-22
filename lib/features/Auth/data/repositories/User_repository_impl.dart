import 'dart:convert';
import 'dart:developer';

import 'package:onepluspay/features/Auth/business/entities/entity.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/firebase_api.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../business/repositories/repository.dart';
import '../datasources/User_local_data_source.dart';
import '../datasources/User_remote_data_source.dart';
import '../models/User_model.dart';
import 'package:http/http.dart' as http;

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;


  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,

  });

  @override
  Future<(Failure?, UserModel?)> createUser(
      {required UserParams UserParams}) async {
    // if (await networkInfo.isConnected!) {

      try {


        final response = await http.post(
            Uri.parse('$uri/users/signup/'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              // Adjust headers if needed
              // Add any other headers here
            },
            body: jsonEncode({
              'first_name':UserParams.first_name,
              'last_name':UserParams.last_name,
              'phone_number':UserParams.phone_number,
              'password':UserParams.password,
              'email':UserParams.email,
              'customer_type':UserParams.customer_type,
              'bvn':UserParams.bvn,
              'dob':UserParams.DOfB,

            })


        );
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (response.statusCode >= 200 && response.statusCode <= 299) {

          var userJson = jsonResponse['user'] as Map<String, dynamic>;
          UserModel remoteUser = UserModel.fromJson(json: userJson);
           log(remoteUser.toString());
          return  (null,remoteUser);

        }
        else{
          final Map<String, dynamic> errorJson = jsonDecode(response.body);
          // Extract the error message
          final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
          // Log the error message
           log('$errorMessage error failure');
          return (ServerFailure(errorMessage: errorMessage.toString()),null);
        }
      } catch (e){
        log('problem1');
        log(e.toString());
        return (ServerFailure(errorMessage: e.toString()),null);
      }
    // } else {
    //   try {
    //     UserModel localUser = await localDataSource.getLastUser();
    //     return (null,localUser);
    //   } on CacheException {
    //     return (CacheFailure(errorMessage: 'This is a cache exception'),null);
    //   }
    // }
  }

  @override
  Future<(Failure?, UserEntity?)> signInUser({required UserParams UserParams}) async {
    try {

      final response = await http.post(
          Uri.parse('$uri/users/signinAdmin/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            // Adjust headers if needed
            // Add any other headers here
          },

          body: jsonEncode({
            'phone_number':UserParams.phone_number,
            'password':UserParams.password,

          })


      );
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
       log(response.body);
      if (response.statusCode >= 200 && response.statusCode <= 299) {

        var userJson = jsonResponse['user'] as Map<String, dynamic>;
        UserModel remoteUser = UserModel.fromJson(json: userJson);


        log('user: ${remoteUser.bankName.toString()}');
       log(remoteUser.balance.toString());
        return  (null,remoteUser);

      }
      else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? errorJson['message'] ?? 'Unknown error occurred';
        // Log the error message
        log(errorMessage);
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }catch (e){
      log(e.toString());
      return (ServerFailure(errorMessage: e.toString()),null);
    }
  }

  @override
  Future<(Failure?, MessageEntity?)> emailOtp({required UserParams UserParams}) async {
    try {
      final response = await http.post(
          Uri.parse('$uri/users/send_otp_to_email/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            // Adjust headers if needed
            // Add any other headers here
          },
          body: jsonEncode({
            'email':UserParams.email,
          })


      );
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        MessageModel remoteUser =
        MessageModel.fromJson( json: jsonResponse
        );

        return  (null,remoteUser);

      }
      else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? errorJson['message'] ??'Unknown error occurred';
        // Log the error message
        log(errorMessage);
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }catch (e){
      log(e.toString());
      return (ServerFailure(errorMessage: e.toString()),null);
    }
  }

  @override
  Future<(Failure?, MessageEntity?)> phoneOtp({required UserParams UserParams}) async {
    try {
      log(UserParams.phone_number.toString());
      log('$uri/users/send_otp_to_phone/');
     String? phoneNumber = UserParams.phone_number;
      if (phoneNumber!.startsWith('0')) {
        phoneNumber = phoneNumber.replaceFirst('0', '');
      }
      final response = await http.post(
          Uri.parse('$uri/users/send_otp_to_phone/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            // Adjust headers if needed
            // Add any other headers here
          },

          body: jsonEncode({
            'phone_number':phoneNumber,
          })


      );
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        log('win');
        MessageModel remoteUser =
        MessageModel.fromJson( json: jsonResponse
        );

        return  (null,remoteUser);

      }
      else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? errorJson['message'] ??'Unknown error occurred';
        // Log the error message
        log(errorMessage);
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }catch (e){
      log(e.toString());
      return (ServerFailure(errorMessage: e.toString()),null);
    }
  }

  @override
  Future<(Failure?, MessageEntity?)> verifyOtp({required UserParams UserParams}) async {
    try {
      log(UserParams.otp.toString());
      String? phoneNumber = UserParams.phone_number;
      if (phoneNumber!.startsWith('0')) {
        phoneNumber = phoneNumber.replaceFirst('0', '');
      }
      final response = await http.post(
          Uri.parse('$uri/users/otp_verified/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            // Adjust headers if needed
            // Add any other headers here
          },
          body: jsonEncode({
            'key':phoneNumber,
            'otp':UserParams.otp
          })


      );
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        log('win');
        MessageModel remoteUser =
        MessageModel.fromJson( json: jsonResponse
        );

        return  (null,remoteUser);

      }
      else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? errorJson['message'] ??'Unknown error occurred';
        // Log the error message
        log(errorMessage);
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }catch (e){
      log(e.toString());
      return (ServerFailure(errorMessage: e.toString()),null);
    }
  }

  @override
  Future<(Failure?, UserEntity?)> getUserData({required UserParams UserParams}) async {
    try {
      final response = await http.get(
        Uri.parse('$uri/transaction/get-user-escrows/${UserParams.email}/'),
        headers: {
          'Content-Type': 'application/json', // Adjust headers if needed
          // Add any other headers here
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        UserModel remote = UserModel.fromJson(json: jsonResponse);

        return (null,remote);
      }     else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? errorJson['message'] ??'Unknown error occurred';
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }  catch(e) {
      return (ServerFailure(errorMessage: e.toString()),null);
    }
  }

  @override
  Future<(Failure?, MessageEntity?)> ResetPassword({required UserParams UserParams}) async {
    try {
      final response = await http.post(
        Uri.parse('$uri/users/reset_password/'),
        headers: {
          'Content-Type': 'application/json', // Adjust headers if needed
          // Add any other headers here
        },
          body: jsonEncode({
            'email':UserParams.email,
            'otp':UserParams.otp,
            'new_password':UserParams.password
          })
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        MessageModel remoteUser =
        MessageModel.fromJson( json: jsonResponse
        );

        return  (null,remoteUser);
      }     else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? errorJson['message'] ??'Unknown error occurred';
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }  catch(e) {
      return (ServerFailure(errorMessage: e.toString()),null);
    }
  }

  @override
  Future<(Failure?, MessageEntity?)> forgotPassword({required UserParams UserParams}) async {
    try {
      final response = await http.post(
        Uri.parse('$uri/users/forget_password/'),
        headers: {
          'Content-Type': 'application/json', // Adjust headers if needed
          // Add any other headers here
        },
          body: jsonEncode({
            'email':UserParams.email
          })
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        MessageModel remoteUser =
        MessageModel.fromJson( json: jsonResponse
        );

        return  (null,remoteUser);
      }     else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error']?? errorJson['message']?? 'Unknown error occurred';
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }  catch(e) {
      return (ServerFailure(errorMessage: e.toString()),null);
    }
  }

  @override
  Future<(Failure?, MessageEntity?)> verifyOtpPassword({required UserParams UserParams}) async {
    try {
      final response = await http.post(
        Uri.parse('$uri/users/password_reset_otp_verified/'),
        headers: {
          'Content-Type': 'application/json', // Adjust headers if needed
          // Add any other headers here
        },
          body: jsonEncode({
            'otp':UserParams.otp,
            'email':UserParams.email
          })
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        MessageModel remoteUser =
        MessageModel.fromJson( json: jsonResponse
        );

        return  (null,remoteUser);
      }     else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? errorJson['message'] ??'Unknown error occurred';
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }  catch(e) {
      return (ServerFailure(errorMessage: e.toString()),null);
    }
  }

}