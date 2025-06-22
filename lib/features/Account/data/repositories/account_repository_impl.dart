import 'dart:convert';
import 'dart:developer';

import 'package:onepluspay/features/Auth/business/entities/entity.dart';
import 'package:http/http.dart' as http;
import 'package:onepluspay/features/Auth/presentation/providers/User_provider.dart';
import '../../../../core/connection/network_info.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../../Auth/data/models/User_model.dart';
import '../../business/repositories/repository.dart';


class AccountRepositoryImpl implements AccountRepository {
  final NetworkInfo networkInfo;

  AccountRepositoryImpl({
    required this.networkInfo,
  });

  @override
  Future<(Failure?, UserModel?)> changePin(
      {required AccountParams accountParams}) async {

    try {

      final response = await http.post(
          Uri.parse('$uri/users/change-pin/${accountParams.customerId}'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${accountParams.token}'
          },
          body: jsonEncode({
            'old_pin':accountParams.oldPin,
            'new_pin':accountParams.newPin,
          })


      );
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode <= 299) {

        UserModel remoteUser =
        UserModel.fromJson( json: jsonResponse
        );


        return  (null,remoteUser);

      }
      else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }catch (e){
      return (ServerFailure(errorMessage: e.toString()),null);
    }

    }

  @override
  Future<(Failure?, UserModel?)> setPin(
      {required AccountParams accountParams}) async {

    try {
       log(accountParams.newPin.toString());
      final response = await http.put(
          Uri.parse('$uri/users/set-pin/${accountParams.customerId}/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${accountParams.token}'
            // Add any other headers here
          },

          body: jsonEncode({
            'new_pin':accountParams.newPin,
          })


      );
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode <= 299) {
         log(response.body);
        UserModel remoteUser =
        UserModel.fromJson( json: jsonResponse
        );



        return  (null,remoteUser);

      }
      else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }catch (e){
      return (ServerFailure(errorMessage: e.toString()),null);
    }

  }

  @override
  Future<(Failure?, UserEntity?)> updateKYC1({required AccountParams accountParams}) async {
    log(accountParams.customerId.toString());
    try {
      final response = await http.put(
          Uri.parse('$uri/users/updateKYC1/${accountParams.customerId}/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${accountParams.token}'
            // Add any other headers here
          },
          body: jsonEncode({
          'place_of_birth':accountParams.placeOfBirth,
          'dob':accountParams.dob,
          'gender':accountParams.gender,
          'country':accountParams.country,
          'street':accountParams.street,
          'city':accountParams.city,
          'state':accountParams.state,
          'postal_code':accountParams.postalCode,
          'image':accountParams.image,
          'phone_number':accountParams.phoneNumber,
          })
      );
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode <= 299) {
          log('good');
          log(response.body);
          log(jsonResponse.toString());
        UserModel remoteUser =
        UserModel.fromJson( json: jsonResponse
        );


        return  (null,remoteUser);

      }
      else{
        log('bad');
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }catch (e){
      log('bad1');
      return (ServerFailure(errorMessage: e.toString()),null);
    }
  }

  @override
  Future<(Failure?, UserEntity?)> updateKYC2({required AccountParams accountParams}) async {
    try {
      final response = await http.put(
          Uri.parse('$uri/users/${accountParams.customerId}/updateKYC2/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${accountParams.token}'
            // Add any other headers here
          },
          body: jsonEncode({
            'means_of_id':accountParams.meansOfId,
            'image':accountParams.image,

          })


      );
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode <= 299) {

        UserModel remoteUser =
        UserModel.fromJson( json: jsonResponse
        );


        return  (null,remoteUser);

      }
      else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }catch (e){
      return (ServerFailure(errorMessage: e.toString()),null);
    }
  }

  @override
  Future<(Failure?, UserEntity?)> updateKYC2v2({required AccountParams accountParams}) async {
    try {
      final response = await http.put(
          Uri.parse('$uri/users/updateKYC2v2/${accountParams.customerId}/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            // Adjust headers if needed
            // Add any other headers here
          },
          body: jsonEncode({
            'means_of_id':accountParams.meansOfId,
            'image':accountParams.image,
            'document_number':accountParams.documentNumber
          })


      );
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode <= 299) {

        UserModel remoteUser =
        UserModel.fromJson( json: jsonResponse
        );


        return  (null,remoteUser);

      }
      else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }catch (e){
      return (ServerFailure(errorMessage: e.toString()),null);
    }
  }

  @override
  Future<(Failure?, UserEntity?)> updateKYC3({required AccountParams accountParams}) async {
    try {
      final response = await http.put(
          Uri.parse('$uri/users/updateKYC3/${accountParams.customerId}/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            // Adjust headers if needed
            // Add any other headers here
          },
          body: jsonEncode({
            'image':accountParams.image,
          })


      );
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode <= 299) {

        UserModel remoteUser =
        UserModel.fromJson( json: jsonResponse
        );


        return  (null,remoteUser);

      }
      else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }catch (e){
      return (ServerFailure(errorMessage: e.toString()),null);
    }
  }

  @override
  Future<(Failure?, UserEntity?)> UpdateUser({required AccountParams accountParams}) async {
    try {
      log(accountParams.customerId??'');
      final response = await http.put(
          Uri.parse('$uri/users/update/${accountParams.customerId}/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            // Adjust headers if needed
            // Add any other headers here
          },
          body: jsonEncode({
            'email':accountParams.email,
            'phone_number':accountParams.phoneNumber,
            'key':'1',
            'firstName':accountParams.firstName,
            'lastName':accountParams.lastName,
            'image':accountParams.image,
          })


      );
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode <= 299) {

        UserModel remoteUser =
        UserModel.fromJson( json: jsonResponse
        );


        return  (null,remoteUser);

      }
      else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }catch (e){
      return (ServerFailure(errorMessage: e.toString()),null);
    }
  }

  @override
  Future<(Failure?, UserEntity?)> VerifyEmail({required AccountParams accountParams}) async {
    try {
      final response = await http.post(
          Uri.parse('$uri/users/send_otp_to_email/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            // Adjust headers if needed
            // Add any other headers here
          },
          body: jsonEncode({
            'email':accountParams.email,
          })


      );
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode <= 299) {

        UserModel remoteUser =
        UserModel.fromJson( json: jsonResponse
        );


        return  (null,remoteUser);

      }
      else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }catch (e){
      return (ServerFailure(errorMessage: e.toString()),null);
    }
  }

  @override
  Future<(Failure?, UserEntity?)> resetPassword({required AccountParams accountParams}) async {
    try {
      final response = await http.post(
          Uri.parse('$uri/users/password_reset_otp_verified/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            // Adjust headers if needed
            // Add any other headers here
          },
          body: jsonEncode({
            'email':accountParams.email,
            'password':accountParams.password,
            'otp':accountParams.otp,
          })


      );
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode <= 299) {

        UserModel remoteUser =
        UserModel.fromJson( json: jsonResponse
        );


        return  (null,remoteUser);

      }
      else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }catch (e){
      return (ServerFailure(errorMessage: e.toString()),null);
    }
  }

  @override
  Future<(Failure?, List<NotificationModel>?)> getNotification({required AccountParams accountParams}) async {
    try {
      final response = await http.get(
          Uri.parse('$uri/transaction/user-notification/${accountParams.customerId}/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            // Adjust headers if needed
            // Add any other headers here
          },



      );
      final List<dynamic> jsonResponse = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode <= 299) {

        List<NotificationModel> remoteUser = jsonResponse
            .map((Json) => NotificationModel.fromJson(json: Json))
            .toList();


        return  (null,remoteUser);

      }
      else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }catch (e){
      return (ServerFailure(errorMessage: e.toString()),null);
    }
  }

  }
