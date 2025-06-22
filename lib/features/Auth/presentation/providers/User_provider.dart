import 'dart:developer';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onepluspay/core/constants/firebase_api.dart';
import 'package:onepluspay/features/Auth/business/usecases/get_user_data.dart';
import 'package:onepluspay/features/Auth/business/usecases/reset_password.dart';
import 'package:onepluspay/features/Auth/business/usecases/sign_in_user.dart';
import 'package:onepluspay/features/Auth/presentation/pages/sign_in_screen/reset_password_screen.dart';
import 'package:onepluspay/features/Auth/presentation/pages/sign_in_screen/verify_reset_password_screen.dart';
import 'package:onepluspay/features/skeletion/widgets/skeleton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/constants/utils.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../../../core/widgets/core/successful_screen.dart';
import '../../../../test/screens/main_screen.dart';
import '../../../Account/business/usecases/account_usecases.dart';
import '../../../Account/data/repositories/account_repository_impl.dart';
import '../../business/entities/entity.dart';
import '../../business/usecases/create_User.dart';
import '../../data/datasources/User_local_data_source.dart';
import '../../data/datasources/User_remote_data_source.dart';
import '../../data/repositories/User_repository_impl.dart';
import 'package:http/http.dart' as http;

final SignUpcounter = StateProvider((ref) => 0);

final isLoader = StateProvider((ref) => false);

final userProvider = ChangeNotifierProvider((ref) => UserProvider());
class UserProvider extends ChangeNotifier {
  UserEntity? User;
  File? res;
  MessageEntity ? Message;
  Failure? failure;
  late UserParams userParams;
  late AccountParams accountParams;

  int NotificationNumber;
  UserProvider({
    this.User,
    this.res,
    this.failure,
    this.selectedPage = 0,
    this.NotificationNumber = 0,
     UserParams? initialParams,
    AccountParams? initialAccParams,
  }) {
    userParams = initialParams ?? UserParams();
    accountParams = initialAccParams ?? AccountParams();
  }
  void updateAccountParams(AccountParams newAccountParams) {
    accountParams = newAccountParams;
    notifyListeners();
  }
  Future<void> Notication() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('Noti') != null){
      final int? counter = prefs.getInt('Noti');
      NotificationNumber = ((User!.notification_number - counter!) as int?)!;
    } else{
      await prefs.setInt('Noti', User!.notification_number.toInt() );
    }
  }
  Future<void> updateNotication() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setInt('Noti', User!.notification_number.toInt() );

  }


  void updateUserParams(UserParams newUserParams) {
    userParams = newUserParams;
    notifyListeners();
  }

  void eitherFailureOrUserSignUp(BuildContext context,WidgetRef ref) async {
    UserRepositoryImpl repository = UserRepositoryImpl(
      remoteDataSource: UserRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: UserLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),

    );
    final failureOrUser = await CreateUser(userRepository: repository).call(
      userParams: UserParams(
          first_name: userParams.first_name,
          last_name: userParams.last_name,
          phone_number: userParams.phone_number,
          password: userParams.password,
          email: userParams.email,
          customer_type: userParams.customer_type,
          bvn: userParams.bvn,
          DOfB: userParams.DOfB),
    );

    final prefs = await SharedPreferences.getInstance();


      User = failureOrUser.$2;
      failure = failureOrUser.$1;
      log(User.toString());
      if(User != null){
        prefs.setString('token', User!.access_token);
        showSnackBar(context, 'successfully Signed up');
        ref.watch(isLoader.notifier).state = false;
      }
    if(failure != null){
             showSnackBar(context, failure!.errorMessage);
             ref.watch(isLoader.notifier).state = false;
          }
      notifyListeners();


  }

  void eitherFailureOrUserSignIn(BuildContext context, WidgetRef ref) async {

    UserRepositoryImpl repository = UserRepositoryImpl(
      remoteDataSource: UserRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: UserLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),

    );
    log('the token:');
    // String token = await FirebaseApi().initNotifications(context, ref);
    // log('the token:${token}');
    final failureOrUser = await SignInUser(userRepository: repository).call(
      userParams: UserParams(
          phone_number: userParams.phone_number,
          password:userParams.password ,
          key: '',
       ),
    );
    final prefs = await SharedPreferences.getInstance();
    User = failureOrUser.$2;
    failure = failureOrUser.$1;
    if(User != null){
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
      ref.watch(isLoader.notifier).state = false;
    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);
      ref.watch(isLoader.notifier).state = false;
    }
    notifyListeners();



  }

  void eitherFailureOrGetUser(BuildContext context, WidgetRef ref, String email) async {
    log('getUser');
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
    final failureOrUser = await GetUserData(userRepository: repository).call(
      userParams: UserParams(
        email: email,
        token: token
      ),
    );
    User = failureOrUser.$2;
    failure = failureOrUser.$1;
    if(User != null){
      ref.watch(isLoader.notifier).state = false;
    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);
      ref.watch(isLoader.notifier).state = false;
    }
    notifyListeners();
  }

  void eitherFailureOrUserPhoneOtp(BuildContext context, WidgetRef ref) async {
    UserRepositoryImpl repository = UserRepositoryImpl(
      remoteDataSource: UserRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: UserLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),

    );
    log('good');
    final failureOrUser = await CreateUser(userRepository: repository).phoneOtp(
      userParams: UserParams(
        phone_number: userParams.phone_number,
      ),
    );

    Message = failureOrUser.$2;
    failure = failureOrUser.$1;
    if(Message != null){
      showSnackBar(context, Message!.message);

      ref.read(SignUpcounter.notifier).state = 1;
    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);
    }
    notifyListeners();
    ref.watch(isLoader.notifier).state = false;
  }

  void eitherFailureOrUserEmailOtp(BuildContext context, WidgetRef ref) async {
    UserRepositoryImpl repository = UserRepositoryImpl(
      remoteDataSource: UserRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: UserLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),

    );
    log('good');
    final failureOrUser = await CreateUser(userRepository: repository).emailOtp(
      userParams: UserParams(
        email: userParams.email,
      ),
    );

    Message = failureOrUser.$2;
    failure = failureOrUser.$1;
    if(Message != null){
      showSnackBar(context, 'successfully Signed up');
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Skeleton()));
    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);
    }

    ref.watch(isLoader.notifier).state = false;
    notifyListeners();
  }
  void eitherFailureOrUserVerifyOtp(BuildContext context, WidgetRef ref) async {
    UserRepositoryImpl repository = UserRepositoryImpl(
      remoteDataSource: UserRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: UserLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),

    );
    final failureOrUser = await CreateUser(userRepository: repository).verifyOtp(
      userParams: UserParams(
       phone_number: userParams.phone_number,
        otp: userParams.otp,

      ),
    );

    Message = failureOrUser.$2;
    failure = failureOrUser.$1;
    if(Message != null){
      showSnackBar(context, Message!.message);
      if(ref.read(SignUpcounter.notifier).state == 1) {

        ref.read(SignUpcounter.notifier).state = 2;
      }else {
        ref.read(SignUpcounter.notifier).state = 2;
      }
    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);
    }

    ref.watch(isLoader.notifier).state = false;

    notifyListeners();


  }
  void eitherFailureOrForgotPasswordScreen(BuildContext context, WidgetRef ref, bool Resend) async {
    UserRepositoryImpl repository = UserRepositoryImpl(
      remoteDataSource: UserRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: UserLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),

    );
    final failureOrUser = await ResetPasswordCases(userRepository: repository).forgotPassword(
      userParams: UserParams(
        email: userParams.email,


      ),
    );

    Message = failureOrUser.$2;
    failure = failureOrUser.$1;
    if(Message != null){
      showSnackBar(context, Message!.message);
      if(Resend ){
        Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyResetPasswordScreen()));
      }
    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);
    }

    ref.watch(isLoader.notifier).state = false;

    notifyListeners();


  }
  void eitherFailureOrForgotPasswordScreen2(BuildContext context, WidgetRef ref, bool Resend) async {
    UserRepositoryImpl repository = UserRepositoryImpl(
      remoteDataSource: UserRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: UserLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),

    );
    final failureOrUser = await ResetPasswordCases(userRepository: repository).forgotPassword(
      userParams: UserParams(
        email: userParams.email,


      ),
    );

    Message = failureOrUser.$2;
    failure = failureOrUser.$1;
    if(Message != null){
      showSnackBar(context, Message!.message);

    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);
    }

    ref.watch(isLoader.notifier).state = false;

    notifyListeners();


  }

  void eitherFailureOrChangeEmail(BuildContext context, WidgetRef ref, bool Resend) async {
    UserRepositoryImpl repository = UserRepositoryImpl(
      remoteDataSource: UserRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: UserLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),

    );
    final failureOrUser = await ResetPasswordCases(userRepository: repository).forgotPassword(
      userParams: UserParams(
        email: userParams.email,


      ),
    );

    Message = failureOrUser.$2;
    failure = failureOrUser.$1;
    if(Message != null){
      showSnackBar(context, Message!.message);

    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);
    }

    ref.watch(isLoader.notifier).state = false;

    notifyListeners();


  }
  void eitherFailureOrResetForgotPassword(BuildContext context, WidgetRef ref) async {
    ref.watch(isLoader.notifier).state = true;
    UserRepositoryImpl repository = UserRepositoryImpl(
      remoteDataSource: UserRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: UserLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),

    );
    final failureOrUser = await ResetPasswordCases(userRepository: repository).ResetPassword(
      userParams: UserParams(
        email: userParams.email,
        otp: userParams.otp,
        password: userParams.password,


      ),
    );

    Message = failureOrUser.$2;
    failure = failureOrUser.$1;
    if(Message != null){
      showSnackBar(context, Message!.message);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen()));
    }
    if(failure != null){

      showSnackBar(context, failure!.errorMessage);
    }

    ref.watch(isLoader.notifier).state = false;

    notifyListeners();


  }

  void eitherFailureOrVerifyResetPassword(bool account, BuildContext context, WidgetRef ref, ) async {
    UserRepositoryImpl repository = UserRepositoryImpl(
      remoteDataSource: UserRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: UserLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),

    );
    final failureOrUser = await ResetPasswordCases(userRepository: repository).verifyOtpPassword(
      userParams: UserParams(
        email: userParams.email,
        otp: userParams.otp,



      ),
    );

    Message = failureOrUser.$2;
    failure = failureOrUser.$1;
    if(Message != null){
      showSnackBar(context, Message!.message);
        if (account){

        }else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ResetPasswordScreen()));
        }

    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);
    }

    ref.watch(isLoader.notifier).state = false;

    notifyListeners();


  }

  int selectedPage;



  void changePage(int newValue) {
    selectedPage = newValue;
    notifyListeners();
  }
  void selectImage() async {
    requestPermission();
    var ress = await pickImages();
    res = ress;
  }

  void update(WidgetRef ref,BuildContext context,VoidCallback onReturn) async {
    ref.watch(isLoader.notifier).state = true;
    log( 'user account');
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





      ),
    );

    User = failureOrAccount.$2;
    failure = failureOrAccount.$1;
    notifyListeners();
    if(User != null){
      onReturn();
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
      onReturn();
      showSnackBar(context, failure!.errorMessage);
    }
    ref.watch(isLoader.notifier).state = false;


  }
}