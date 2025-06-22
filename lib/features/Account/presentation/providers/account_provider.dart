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
import '../../../../core/widgets/core/transaction_failed.dart';
import '../../../Auth/business/entities/entity.dart';
import '../../../Auth/business/usecases/reset_password.dart';
import '../../../Auth/data/datasources/User_local_data_source.dart';
import '../../../Auth/data/datasources/User_remote_data_source.dart';
import '../../../Auth/data/repositories/User_repository_impl.dart';
import '../../../Auth/presentation/providers/User_provider.dart';
import '../../business/usecases/account_usecases.dart';
import '../../data/repositories/account_repository_impl.dart';

import 'package:http/http.dart' as http;


final biometricProvider = StateNotifierProvider<BiometricNotifier, bool>((ref) {
  return BiometricNotifier();
});

class BiometricNotifier extends StateNotifier<bool> {
  BiometricNotifier() : super(false) {
    _loadBiometricPreference();
  }

  // Load the biometric state from SharedPreferences
  Future<void> _loadBiometricPreference() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('biometricEnabled') ?? false;
  }

  // Toggle the biometric state and save it in SharedPreferences
  Future<void> toggleBiometric(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometricEnabled', isEnabled);
    state = isEnabled;
  }
}
final accountProvider = ChangeNotifierProvider((ref) => AccountProvider());

class AccountProvider extends ChangeNotifier {
  File? res;
  UserEntity? user;
  Failure? failure;
  MessageEntity ? Message;
  List<NotificationEntity>? Notification;
  late AccountParams accountParams;

  AccountProvider({
    this.res,
    this.user,
    this.failure,
    AccountParams? initialParams,
  }){
    accountParams = initialParams ?? AccountParams();
  }
  void updateAccountParams(AccountParams newAccountParams) {
    accountParams = newAccountParams;
    notifyListeners();
  }

  void eitherFailureOrPin() async {
    AccountRepositoryImpl repository = AccountRepositoryImpl(
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );

    final failureOrAccount = await Accounts(accountRepository: repository).changePin(
      accountParams: AccountParams(),
    );

      user = failureOrAccount.$2;
      failure = failureOrAccount.$1;
      notifyListeners();


  }
  void eitherFailureOrNotification(String CustomerId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    AccountRepositoryImpl repository = AccountRepositoryImpl(
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );

    final failureOrAccount = await Accounts(accountRepository: repository).accountRepository.getNotification(
      accountParams: AccountParams(
        customerId: CustomerId,
        token: token
      ),
    );

    Notification = failureOrAccount.$2;
    failure = failureOrAccount.$1;
    notifyListeners();


  }
  void selectImage() async {
    requestPermission();
    var ress = await pickImages();
    res = ress;
  }
  void eitherFailureOrLevel1(WidgetRef ref, BuildContext context ) async {
    ref.watch(isLoader.notifier).state = true;
    AccountRepositoryImpl repository = AccountRepositoryImpl(
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    final cloudinary = CloudinaryPublic('drawry8xx', 'mypreset');



    CloudinaryResponse res1 = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(res!.path, folder: accountParams.customerId),
    );
    accountParams.image = res1.secureUrl;

    final failureOrAccount = await Accounts(accountRepository: repository).updateKYC1(
      accountParams: AccountParams(
        customerId: accountParams.customerId,
        state: accountParams.state,
        country: accountParams.country,
        city: accountParams.city,
        postalCode: accountParams.postalCode,
        dob: accountParams.dob,
        gender: accountParams.gender,
        placeOfBirth: accountParams.placeOfBirth,
        image: accountParams.image
      ),
    );
    user = failureOrAccount.$2;
    failure = failureOrAccount.$1;
    notifyListeners();
    if(user != null){
      showSnackBar(context, 'Account upgraded');
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          SuccessfulScreen(
              title: 'Upgrade successful',
              body: 'Your account has been successfully upgraded.',
              isShare: true)));

    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          failedScreen(error: failure!.errorMessage,)));
    }
    ref.watch(isLoader.notifier).state = false;
  }
  void eitherFailureOrLevel2(WidgetRef ref, BuildContext context) async {
    ref.watch(isLoader.notifier).state = true;
    AccountRepositoryImpl repository = AccountRepositoryImpl(
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );

    final failureOrAccount = await Accounts(accountRepository: repository).updateKYC2(
      accountParams: AccountParams(
          meansOfId: accountParams.meansOfId,
          image: accountParams.image
      ),
    );

    user = failureOrAccount.$2;
    failure = failureOrAccount.$1;
    notifyListeners();
    if(user != null){
      showSnackBar(context, 'Account upgraded');
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          SuccessfulScreen(
              title: 'Upgrade successful',
              body: 'Your account has been successfully upgraded.',
              isShare: true)));

    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          failedScreen(error: failure!.errorMessage,)));
    }
    ref.watch(isLoader.notifier).state = false;
  }
  void eitherFailureOrLevel2v2(WidgetRef ref, BuildContext context) async {
    ref.watch(isLoader.notifier).state = true;
    AccountRepositoryImpl repository = AccountRepositoryImpl(
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    final cloudinary = CloudinaryPublic('drawry8xx', 'mypreset');

    CloudinaryResponse res1 = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(res!.path, folder: accountParams.customerId),
    );
    accountParams.image = res1.secureUrl;

    final failureOrAccount = await Accounts(accountRepository: repository).updateKYC2v2(
      accountParams: AccountParams(
            customerId: accountParams.customerId,
            meansOfId: accountParams.meansOfId,
            image: accountParams.image,
            documentNumber: accountParams.documentNumber,

      ),
    );

    user = failureOrAccount.$2;
    failure = failureOrAccount.$1;
    notifyListeners();
    if(user != null){
      showSnackBar(context, 'Account upgraded');
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          SuccessfulScreen(
              title: 'Upgrade successful',
              body: 'Your account has been successfully upgraded.',
              isShare: true)));

    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          failedScreen(error: failure!.errorMessage,)));
    }
    ref.watch(isLoader.notifier).state = false;
  }

  void eitherFailureOrLevel3(String path, WidgetRef ref, BuildContext context) async {
    ref.watch(isLoader.notifier).state = true;
    AccountRepositoryImpl repository = AccountRepositoryImpl(
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    final cloudinary = CloudinaryPublic('drawry8xx', 'mypreset');

    CloudinaryResponse res1 = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(path, folder: accountParams.customerId),
    );
    accountParams.image = res1.secureUrl;

    final failureOrAccount = await Accounts(accountRepository: repository).updateKYC3(
      accountParams: AccountParams(
        image: accountParams.image,
      ),
    );

    user = failureOrAccount.$2;
    failure = failureOrAccount.$1;
    notifyListeners();

    if(user != null){
      showSnackBar(context, 'Account upgraded');
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          SuccessfulScreen(
              title: 'Upgrade successful',
              body: 'Your account has been successfully upgraded.',
              isShare: true)));

    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          failedScreen(error: failure!.errorMessage,)));
    }
    ref.watch(isLoader.notifier).state = false;
  }
  void setPin(WidgetRef ref,BuildContext context) async {
    ref.watch(isLoader.notifier).state = true;
    AccountRepositoryImpl repository = AccountRepositoryImpl(
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final failureOrAccount = await Accounts(accountRepository: repository).setPin(
      accountParams: AccountParams(
        newPin: accountParams.newPin,
        customerId: accountParams.customerId,
        token: token
      ),
    );

    user = failureOrAccount.$2;
    failure = failureOrAccount.$1;
    notifyListeners();
    if(user != null){
      Navigator
          .of(context)
          .push(
          MaterialPageRoute(
              builder:
                  (context) =>  SuccessfulScreen(
                title: 'Successful',
                body: 'Your Pin has been successfully changed',
                isShare: false,)));
    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);
    }
    ref.watch(isLoader.notifier).state = false;


  }
  void update(WidgetRef ref,BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    ref.watch(isLoader.notifier).state = true;
    AccountRepositoryImpl repository = AccountRepositoryImpl(
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    final cloudinary = CloudinaryPublic('donpd3pem', 'vhmdvidt');



    CloudinaryResponse res1 = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(res!.path, folder: accountParams.customerId),
    );
    accountParams.image = res1.secureUrl;
    log( 'accounted');
    log( accountParams.customerId!);
    final failureOrAccount = await Accounts(accountRepository: repository).UpdateUser(
      accountParams: AccountParams(
          customerId: accountParams.customerId,
          email: accountParams.email,
          image: accountParams.image,
          firstName: accountParams.firstName,
          lastName: accountParams.lastName,
          bvn: accountParams.bvn,
          gender: accountParams.gender,
        token:token,





      ),
    );

    user = failureOrAccount.$2;
    failure = failureOrAccount.$1;
    notifyListeners();
    if(user != null){
      Navigator
          .of(context)
          .push(
          MaterialPageRoute(
              builder:
                  (context) =>  SuccessfulScreen(
                title: 'Successful',
                body: 'Your Profile has been successfully changed',
                isShare: false,)));
    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);
    }
    ref.watch(isLoader.notifier).state = false;


  }
  void eitherFailureOrVerifyEmail(bool account, BuildContext context, WidgetRef ref, ) async {
    UserRepositoryImpl repository = UserRepositoryImpl(
      remoteDataSource: UserRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: UserLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),

    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final failureOrUser = await ResetPasswordCases(userRepository: repository).verifyOtpPassword(
      userParams: UserParams(
        email: accountParams.email,
        otp: accountParams.otp,
         token: token,


      ),
    );

    Message = failureOrUser.$2;
    failure = failureOrUser.$1;
    if(Message != null){
      showSnackBar(context, Message!.message);
      if (account){

      }else {
        ref.read(accountProvider).update(ref, context);
        Navigator
            .of(context)
            .push(
            MaterialPageRoute(
                builder:
                    (context) =>  SuccessfulScreen(
                  title: 'Successful',
                  body: 'Your Email address has been successfully changed',
                  isShare: false,)));
      }

    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);
    }

    ref.watch(isLoader.notifier).state = false;

    notifyListeners();


  }
  void eitherFailureOrVerifyEmailPin( BuildContext context, WidgetRef ref, ) async {
    UserRepositoryImpl repository = UserRepositoryImpl(
      remoteDataSource: UserRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: UserLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),

    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final failureOrUser = await ResetPasswordCases(userRepository: repository).verifyOtpPassword(
      userParams: UserParams(
        email: accountParams.email,
        otp: accountParams.otp,
token: token,


      ),
    );

    Message = failureOrUser.$2;
    failure = failureOrUser.$1;
    if(Message != null){



    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);
    }

    ref.watch(isLoader.notifier).state = false;

    notifyListeners();


  }
}