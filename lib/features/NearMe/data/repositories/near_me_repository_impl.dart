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
import '../datasources/nearme_local_data_source.dart';
import '../datasources/nearme_remote_data_source.dart';
import '../models/near_me_model.dart';

class NearMeRepositoryImpl implements NearMeRepository {
  final NearMeRemoteDataSource remoteDataSource;
  final NearMeLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NearMeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<(Failure?, List<NearMeModel>?)> getNearMe(
      {required NearMeParams nearmeParams}) async {
    // if (await networkInfo.isConnected!) {
      try {
        final response = await http.get(
          Uri.parse('$uri/near-me/get-filtered-products/?location=${nearmeParams.location}&lat=${nearmeParams.lat}28&long=${nearmeParams.long}&name=${nearmeParams.productName}/'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${nearmeParams.token}'
          },
        );

        if (response.statusCode >= 200 && response.statusCode <= 299) {
          final List<dynamic> jsonResponse = jsonDecode(response.body);
          log('this is NearMe ${response.body}');
          List<NearMeModel> remoteNearMe = jsonResponse
              .map((NearMeJson) => NearMeModel.fromJson(json: NearMeJson))
              .toList();
          return (null,remoteNearMe);
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
    //     List<NearMeModel> localNearMe = await localDataSource.getLastNearMes();
    //     return (null,localNearMe);
    //   } catch(e) {
    //     return (CacheFailure(errorMessage: e.toString()),null);
    //   }
    // }
  }

  @override
  Future<(Failure?, List<NearMeModel>?)> getUserNearMe(
      {required NearMeParams nearmeParams}) async {

      try {
        log('frined');
        final response = await http.get(
          Uri.parse('$uri/near-me/get-product/${nearmeParams.customerId}/'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${nearmeParams.token}'
          },
        );
        log('frined');

        if (response.statusCode >= 200 && response.statusCode <= 299) {
          final List<dynamic> jsonResponse = jsonDecode(response.body);
          log('this is NearMe ${response.body}');
          List<NearMeModel> remoteNearMe = jsonResponse
              .map((NearMeJson) => NearMeModel.fromJson(json: NearMeJson))
              .toList();
          return (null,remoteNearMe);
        }     else{
          final Map<String, dynamic> errorJson = jsonDecode(response.body);
          // Extract the error message

          final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
          log(errorMessage.toString());
          // Log the error message
          return (ServerFailure(errorMessage: errorMessage.toString()),null);
        }
      }  catch(e) {
        return (ServerFailure(errorMessage: e.toString()),null);
      }

  }



  @override
  Future<(Failure?, NearMeEntity?)> makeNearMe({required NearMeParams nearmeParams}) async {
    try {
      log('good');
      log(nearmeParams.sellerName.toString());
      final response = await http.post(
          Uri.parse('$uri/near-me/create-product/${nearmeParams.customerId}/'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${nearmeParams.token}'
          },

          body: jsonEncode({
            'seller_image':nearmeParams.sellerImage,
            'seller_email':nearmeParams.sellerEmail,
            'seller_name':nearmeParams.sellerName,
            'seller_phone_number':nearmeParams.sellerPhoneNumber,
            'seller_id':nearmeParams.sellerId,
          'product_category': nearmeParams.productCategory,
          'product_name': nearmeParams.productName,
          'product_images': nearmeParams.finalProductImages,
          'customer_id': nearmeParams.customerId,
          'video': nearmeParams.video,
          'title': nearmeParams.title,
          'location': nearmeParams.location,
          'lat': nearmeParams.lat,
          'long': nearmeParams.long,
          'brand': nearmeParams.brand,
          'type': nearmeParams.type,
          'condition': nearmeParams.condition,
          'description': nearmeParams.description,
          'price': nearmeParams.price,
          'delivery': nearmeParams.delivery,
          'status': 'Available',

          })
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        log(response.body);
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        NearMeModel remoteNearMe =
        NearMeModel.fromJson( json: jsonResponse
        );
        return (null,remoteNearMe);
      }     else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message

        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }  catch(e) {
      log(e.toString());
      return (ServerFailure(errorMessage: e.toString()),null);
    }
  }

  @override
  Future<(Failure?, ChatRoomEntity?)> makeChatRoom({required NearMeParams nearmeParams}) async {
    try {
      log('good');

      final response = await http.post(
          Uri.parse('$uri/near-me/create-chat-room/'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${nearmeParams.token}'
          },
          body: jsonEncode({
                  'chat_id':nearmeParams.chatId,
                  'sender_id':nearmeParams.senderId,
                  'receiver_id':nearmeParams.sellerId,
                  'sender_image':nearmeParams.sellerImage,
                  'sender_name':nearmeParams.sellerName,



          })
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        log('this chat room ${response.body}');
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        ChatRoomModel remoteNearMe =
        ChatRoomModel.fromJson( json: jsonResponse
        );
        return (null,remoteNearMe);
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
  Future<(Failure?, NearMeEntity?, SuccessMessage?)> EditNearMe({required NearMeParams nearmeParams}) async {
    try {
      log('i see you');
      final response = await http.put(
          Uri.parse('$uri/near-me/edit-product/${nearmeParams.id}/'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${nearmeParams.token}'
          },
          body: jsonEncode({
            'product_category': nearmeParams.productCategory,
            'product_name': nearmeParams.productName,
            'product_images': nearmeParams.finalProductImages,
            'video': nearmeParams.video,
            'title': nearmeParams.title,
            'location': nearmeParams.location,
            'brand': nearmeParams.brand,
            'type': nearmeParams.type,
            'condition': nearmeParams.condition,
            'description': nearmeParams.description,
            'price': nearmeParams.price,
            'delivery': nearmeParams.delivery,
             'status': nearmeParams.status
          })
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {

        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        // Extract the message and data
        if (jsonResponse.containsKey('message')) {
          // Handle message-only response
          return (null, null, SuccessApiMessage(successMessage: jsonResponse['message']));
        } else {
          // Handle serialized data response
          NearMeModel remoteNearMe = NearMeModel.fromJson(json: jsonResponse);
          return (null, remoteNearMe, null);
        }
      }     else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);
        // Extract the error message
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null, null);
      }
    }  catch(e) {
      return (ServerFailure(errorMessage: e.toString()),null, null);
    }
  }

  @override
  Future<(Failure?, NearMeEntity?)> updateNearMe({required NearMeParams nearmeParams}) async {
    try {
      final response = await http.put(
          Uri.parse('$uri/transaction/update-NearMe/${nearmeParams.id}/'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${nearmeParams.token}'
          },
          body: jsonEncode({

          })
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        NearMeModel remoteNearMe =
        NearMeModel.fromJson( json: jsonResponse
        );
        return (null,remoteNearMe);
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
  Future<(Failure?, List<ChatRoomModel>?)> getChat({required NearMeParams nearmeParams}) async {
    try {

      final response = await http.get(
          Uri.parse('$uri/near-me/chat-rooms/${nearmeParams.senderId}/'),
          headers: {
            'Content-Type': 'application/json', // Adjust headers if needed
            'Authorization': 'Bearer ${nearmeParams.token}'
          },

      );
      log(response.body);
      log(response.statusCode.toString());

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        log(response.body);
        List<ChatRoomModel> remoteChat = jsonResponse
            .map((chatJson) => ChatRoomModel.fromJson(json: chatJson))
            .toList();
        return (null,remoteChat);
      }     else{
        final Map<String, dynamic> errorJson = jsonDecode(response.body);

        // Extract the error message
        final errorMessage = errorJson['error'] ?? 'Unknown error occurred';
        log(errorMessage.toString());
        // Log the error message
        return (ServerFailure(errorMessage: errorMessage.toString()),null);
      }
    }  catch(e) {
      return (ServerFailure(errorMessage: e.toString()),null);
    };
  }
  @override
  Future<(Failure?, List<NearMeChatEntity>?)> getNearMeChat({required NearMeParams nearmeParams}) async {
    try {
      log(nearmeParams.chatId!);
      final response = await http.get(
        Uri.parse('$uri/near-me/get_chat/${nearmeParams.chatId}/'),
        headers: {
          'Content-Type': 'application/json', // Adjust headers if needed
          'Authorization': 'Bearer ${nearmeParams.token}'
        },

      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        log(response.body);
        List<NearMeChatModel> remoteChat = jsonResponse
            .map((chatJson) => NearMeChatModel.fromJson(json: chatJson))
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