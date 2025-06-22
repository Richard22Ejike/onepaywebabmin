import 'dart:developer';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/constants/utils.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../../../core/widgets/core/successful_screen.dart';
import '../../../Auth/presentation/providers/User_provider.dart';
import '../../../Transactions/presentation/providers/transactions_provider.dart';
import '../../../skeletion/providers/bottom_bar_selector_provider.dart';
import '../../../skeletion/widgets/skeleton.dart';
import '../../business/entities/entity.dart';
import '../../business/usecases/get_near_me.dart';
import '../../data/datasources/nearme_local_data_source.dart';
import '../../data/datasources/nearme_remote_data_source.dart';
import '../../data/repositories/near_me_repository_impl.dart';
import 'package:http/http.dart' as http;

final nearmeProvider = ChangeNotifierProvider((ref) => NearMeProvider());
final isNearMeLoader = StateProvider((ref) => false);
class NearMeProvider extends ChangeNotifier {
  List<NearMeEntity>? nearmes;
  List<NearMeEntity>? Mynearmes;
  List<NearMeChatEntity>? nearmechats;
  List<ChatRoomEntity>? chatRooms;
  ChatRoomEntity? chatRoom;
  NearMeEntity? nearme;
  SuccessMessage? message;
  Failure? failure;
  String? accountId;
  String? accountName;
  late NearMeParams nearmeParams;
  NearMeProvider({
    this.nearme,
    this.accountId,
    this.failure,
    NearMeParams? initialParams,
  }) {
    nearmeParams = initialParams ?? NearMeParams();
  }



  void updateNearMeParams(NearMeParams newNearMeParams) {
    nearmeParams = newNearMeParams;
    notifyListeners();
  }

  void eitherFailureOrMakeNearMe(BuildContext context, WidgetRef ref) async {
    ref.watch(isNearMeLoader.notifier).state = true;

    final cloudinary = CloudinaryPublic('drawry8xx', 'mypreset');
    List<String> uploadedImageUrls = [];

    try {
      // Upload each image and collect URLs
      if (nearmeParams.productImages != null && nearmeParams.productImages!.isNotEmpty) {
        for (File image in nearmeParams.productImages!) {
          CloudinaryResponse response = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(image.path, folder: nearmeParams.customerId),
          );
          uploadedImageUrls.add(response.secureUrl); // Collect the secure URL
        }
      }

      // Assign uploaded URLs to finalProductImages
      nearmeParams.finalProductImages = uploadedImageUrls;

      // Initialize repository
      NearMeRepositoryImpl repository = NearMeRepositoryImpl(
        remoteDataSource: NearMeRemoteDataSourceImpl(
          httpClient: http.Client(),
        ),
        localDataSource: NearMeLocalDataSourceImpl(
          sharedPreferences: await SharedPreferences.getInstance(),
        ),
        networkInfo: NetworkInfoImpl(
          DataConnectionChecker(),
        ),
      );
      log(nearmeParams.sellerName.toString());
      // Call the repository method with updated nearmeParams
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final failureOrNearMe = await GetNearMe(nearmeRepository: repository).make(
        nearmeParams: NearMeParams(
          lat: nearmeParams.lat,
          long:nearmeParams.long,
          customerId: nearmeParams.customerId,
          finalProductImages: nearmeParams.finalProductImages,
          title: nearmeParams.title,
          brand: nearmeParams.brand,
          condition: nearmeParams.condition,
          location: nearmeParams.location,
          delivery: nearmeParams.delivery,
          price: nearmeParams.price,
          productName: nearmeParams.productName,
          productCategory: nearmeParams.productCategory,
          description: nearmeParams.description,
          video: nearmeParams.video,
          type: nearmeParams.type,
            sellerPhoneNumber: nearmeParams.sellerPhoneNumber,
            sellerName: nearmeParams.sellerName,
            sellerEmail: nearmeParams.sellerEmail,
            sellerImage: nearmeParams.sellerImage,
          sellerId:nearmeParams.sellerId,
          token: token
        ),
      );

      final nearme = failureOrNearMe.$2;
      final failure = failureOrNearMe.$1;

      // Handle success and failure
      if (nearme != null) {
        showSnackBar(context, 'Successfully NearMe Fund');
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const SuccessfulScreen(
            title: 'Product created',
            body: 'Your Product has been successfully added to your Oneplug Store.',
            isShare: true,
          ),
        ));
      }

      if (failure != null) {
        showSnackBar(context, failure!.errorMessage);
      }
    } catch (e) {
      showSnackBar(context, 'An error occurred: ${e.toString()}');
    } finally {
      ref.watch(isNearMeLoader.notifier).state = false;
    }
  }


  void eitherFailureOrMakeChatRoom(BuildContext context, WidgetRef ref) async {
    ref.watch(isNearMeLoader.notifier).state = true;

    NearMeRepositoryImpl repository = NearMeRepositoryImpl(
      remoteDataSource: NearMeRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: NearMeLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    log(nearmeParams.sellerName.toString());
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final failureOrNearMe = await GetNearMe(nearmeRepository: repository).makeChatRoom(
      nearmeParams: NearMeParams(
          token: token,
          sellerId: nearmeParams.sellerId,
          senderId: nearmeParams.senderId,
          chatId: nearmeParams.chatId,
        sellerImage: nearmeParams.sellerImage,
        sellerName: nearmeParams.sellerName




      ),
    );

   chatRoom = failureOrNearMe.$2;
    failure = failureOrNearMe.$1;
    notifyListeners();
    if(nearme != null){

       log(nearme.toString());
      showSnackBar(context, 'successfully NearMe Fund');
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
      const SuccessfulScreen(
          title: 'Transaction created',
          body: 'Your card has been successfully added to your Oneplug account.',
          isShare: true)));

    }
    if(failure != null){
      log(failure!.errorMessage);
      showSnackBar(context, failure!.errorMessage);

    }
    ref.watch(isNearMeLoader.notifier).state = false;

  }

  void eitherFailureOrNearMes(BuildContext context, WidgetRef ref, ) async {
    ref.watch(isNearMeLoader.notifier).state = true;
    NearMeRepositoryImpl repository = NearMeRepositoryImpl(
      remoteDataSource: NearMeRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: NearMeLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final failureOrNearMe = await GetNearMe(nearmeRepository: repository).call(
      nearmeParams: NearMeParams(
          customerId: nearmeParams.customerId,
          lat: nearmeParams.lat,
          long: nearmeParams.long,
          location: nearmeParams.location,
        token: token

      ),
    );

    nearmes = failureOrNearMe.$2;
    failure = failureOrNearMe.$1;
    log('this is nEAR:${nearmes.toString()}');
    log('this is nEAR:${failure?.errorMessage}');

    notifyListeners();
    ref.watch(isNearMeLoader.notifier).state = false;

  }
  void eitherFailureOrGetUserNearMe(BuildContext context, WidgetRef ref) async {
    ref.watch(isNearMeLoader.notifier).state = true;
    NearMeRepositoryImpl repository = NearMeRepositoryImpl(
      remoteDataSource: NearMeRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: NearMeLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final failureOrNearMe = await GetNearMe(nearmeRepository: repository).getUserNearMe(
      nearmeParams: NearMeParams(
        customerId: nearmeParams.customerId,
        token: token

      ),
    );

    Mynearmes = failureOrNearMe.$2;
    failure = failureOrNearMe.$1;
    notifyListeners();
    if( Mynearmes != null){
      ref.watch(SignUpcounter.notifier).state = 1;



    }
    if(failure != null){
      ref.watch(SignUpcounter.notifier).state = 1;
      showSnackBar(context, failure!.errorMessage);
      log(failure!.errorMessage);
    }
    ref.watch(isNearMeLoader.notifier).state = false;
}
  void eitherFailureOrUpdateNearMe(BuildContext context, WidgetRef ref) async {
    ref.watch(isNearMeLoader.notifier).state = true;

    final cloudinary = CloudinaryPublic('drawry8xx', 'mypreset');
    List<String> uploadedImageUrls = [];

      // Upload each image and collect URLs
      if (nearmeParams.productImages != null ) {
        for (File image in nearmeParams.productImages!) {
          CloudinaryResponse response = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(image.path, folder: nearmeParams.customerId),
          );
          uploadedImageUrls.add(response.secureUrl); // Collect the secure URL
        }
      }

      // Assign uploaded URLs to finalProductImages
      nearmeParams.finalProductImages?.addAll(uploadedImageUrls) ;
    NearMeRepositoryImpl repository = NearMeRepositoryImpl(
      remoteDataSource: NearMeRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: NearMeLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final failureOrNearMe = await GetNearMe(nearmeRepository: repository).cancel(
      nearmeParams: NearMeParams(
        token: token,
        id: nearmeParams.id,
        lat: nearmeParams.lat,
        long:nearmeParams.long,
        customerId: nearmeParams.customerId,
        finalProductImages: nearmeParams.finalProductImages,
        title: nearmeParams.title,
        brand: nearmeParams.brand,
        condition: nearmeParams.condition,
        location: nearmeParams.location,
        delivery: nearmeParams.delivery,
        price: nearmeParams.price,
        productName: nearmeParams.productName,
        productCategory: nearmeParams.productCategory,
        description: nearmeParams.description,
        video: nearmeParams.video,
        type: nearmeParams.type,
        status: nearmeParams.status
      ),
    );

    nearme = failureOrNearMe.$2;
    failure = failureOrNearMe.$1;
    notifyListeners();
    if(nearme != null){
      ref.watch(counter.notifier).state = 0;
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Skeleton()));
      showSnackBar(context, 'NearMe Update');

    }
    if (message != null){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Skeleton()));
      showSnackBar(context, message!.successMessage);
    }
    if(failure != null){
      log(failure!.errorMessage);
      showSnackBar(context, failure!.errorMessage);

    }
    ref.watch(isNearMeLoader.notifier).state = false;
  }
  void eitherFailureOrChatNearMe(BuildContext context, WidgetRef ref) async {
    ref.watch(isNearMeLoader.notifier).state = true;
    NearMeRepositoryImpl repository = NearMeRepositoryImpl(
      remoteDataSource: NearMeRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: NearMeLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final failureOrNearMe = await GetNearMe(nearmeRepository: repository).getChat(
      nearmeParams: NearMeParams(
        token: token,
        senderId: nearmeParams.senderId
      ),
    );

    chatRooms = failureOrNearMe.$2;
    failure = failureOrNearMe.$1;
    notifyListeners();
    if(chatRooms != null){
      showSnackBar(context, 'Chats present');
      log('this is chats"${chatRooms.toString()}');

    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);
      log('this is chats error"${failure!.errorMessage}');
    }
    ref.watch(isNearMeLoader.notifier).state = false;
  }

  void eitherFailureOrChatNearMeChat(BuildContext context, WidgetRef ref) async {
    ref.watch(isNearMeLoader.notifier).state = true;
    NearMeRepositoryImpl repository = NearMeRepositoryImpl(
      remoteDataSource: NearMeRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: NearMeLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final failureOrNearMe = await GetNearMe(nearmeRepository: repository).getNearMeChat(
      nearmeParams: NearMeParams(
        token: token,
        chatId: nearmeParams.chatId,
      ),
    );

    nearmechats = failureOrNearMe.$2;
    failure = failureOrNearMe.$1;
    notifyListeners();
    if(nearmechats != null){
      log('chat loaded');
      showSnackBar(context, 'Chat loaded');

    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);

    }
    ref.watch(isNearMeLoader.notifier).state = false;
  }
}