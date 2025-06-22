import 'dart:developer';

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
import '../../business/usecases/get_Escrow.dart';
import '../../data/datasources/escrow_local_data_source.dart';
import '../../data/datasources/escrow_remote_data_source.dart';
import '../../data/repositories/escrow_repository_impl.dart';
import 'package:http/http.dart' as http;

final escrowProvider = ChangeNotifierProvider((ref) => EscrowProvider());
final isEscrowLoader = StateProvider((ref) => false);
class EscrowProvider extends ChangeNotifier {
  List<EscrowEntity>? escrows;
  List<ChatEntity>? chat;
  EscrowEntity? escrow;
  Failure? failure;
  String? accountId;
  late EscrowParams escrowParams;
  EscrowProvider({
    this.escrow,
    this.accountId,
    this.failure,
    EscrowParams? initialParams,
  }) {
    escrowParams = initialParams ?? EscrowParams();
  }

  void updateEscrowPin({required String pin, }) {
    escrowParams.pin = pin;
    notifyListeners();
  }

  void updateUserParams(EscrowParams newEscrowParams) {
    escrowParams = newEscrowParams;
    notifyListeners();
  }

  void eitherFailureOrMakeEscrow(BuildContext context, WidgetRef ref, String email) async {
    ref.watch(isEscrowLoader.notifier).state = true;
    EscrowRepositoryImpl repository = EscrowRepositoryImpl(
      remoteDataSource: EscrowRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: EscrowLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final failureOrEscrow = await GetEscrow(escrowRepository: repository).make(
      escrowParams: EscrowParams(
        token: token,
        pin: escrowParams.pin,
        role: escrowParams.role,
        role_paying: escrowParams.role_paying,
        receiverEmail: escrowParams.receiverEmail,
        senderName: escrowParams.senderName,
        escrow_Status: escrowParams.escrow_Status,
        estimated_days: escrowParams.estimated_days,
        milestone: escrowParams.milestone,
        number_milestone: escrowParams.number_milestone,
        escrowDescription: escrowParams.escrowDescription,
        escrowName: escrowParams.escrowName,
        amount: escrowParams.amount,
        customerId: escrowParams.customerId,
        accountId: escrowParams.accountId,
        receiver_id: escrowParams.receiver_id,

      ),
    );

      escrow = failureOrEscrow.$2;
      failure = failureOrEscrow.$1;
      notifyListeners();
    if(escrow != null){
      ref.read(escrowProvider).updateUserParams(EscrowParams(
      ));
      ref.read(escrowProvider).eitherFailureOrEscrows(context, ref,escrowParams.customerId!);
      ref.read(userProvider).eitherFailureOrGetUser(context, ref, email);
      showSnackBar(context, 'successfully Escrow Fund');
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          const SuccessfulScreen(
              title: 'Transaction created',
              body: 'Your card has been successfully added to your Oneplug account.',
              isShare: true)));

    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);

    }
    ref.watch(isEscrowLoader.notifier).state = false;

  }

  void eitherFailureOrEscrows(BuildContext context, WidgetRef ref, String CustomerId) async {
    ref.watch(isEscrowLoader.notifier).state = true;
    EscrowRepositoryImpl repository = EscrowRepositoryImpl(
      remoteDataSource: EscrowRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: EscrowLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final failureOrEscrow = await GetEscrow(escrowRepository: repository).call(
      escrowParams: EscrowParams(
          customerId: CustomerId,
        token: token
      ),
    );

    escrows = failureOrEscrow.$2;
    failure = failureOrEscrow.$1;
    notifyListeners();
    ref.watch(isEscrowLoader.notifier).state = false;

  }
  void eitherFailureOrGetUserEscrow(BuildContext context, WidgetRef ref) async {
    ref.watch(isEscrowLoader.notifier).state = true;
    EscrowRepositoryImpl repository = EscrowRepositoryImpl(
      remoteDataSource: EscrowRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: EscrowLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final failureOrEscrow = await GetEscrow(escrowRepository: repository).getUserEscrow(
      escrowParams: EscrowParams(
        receiverEmail: escrowParams.receiverEmail,
        token: token
      ),
    );

    accountId = failureOrEscrow.$2;
    failure = failureOrEscrow.$1;
    notifyListeners();
    if(accountId != null){
      ref.watch(SignUpcounter.notifier).state = 1;



    }
    if(failure != null){
      ref.watch(SignUpcounter.notifier).state = 1;
      showSnackBar(context, failure!.errorMessage);

    }
    ref.watch(isEscrowLoader.notifier).state = false;
}
  void eitherFailureOrUpdateEscrow(BuildContext context, WidgetRef ref) async {
    ref.watch(isEscrowLoader.notifier).state = true;
    EscrowRepositoryImpl repository = EscrowRepositoryImpl(
      remoteDataSource: EscrowRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: EscrowLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final failureOrEscrow = await GetEscrow(escrowRepository: repository).cancel(
      escrowParams: EscrowParams(
        disabled: escrowParams.disabled,
        escrow_Status: escrowParams.escrow_Status,
        customerId: escrowParams.customerId,
        id: escrowParams.id,
        token: token
      ),
    );

    escrow = failureOrEscrow.$2;
    failure = failureOrEscrow.$1;
    notifyListeners();
    if(escrow != null){
      ref.watch(counter.notifier).state = 0;
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Skeleton()));
      showSnackBar(context, 'Escrow Update');

    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);

    }
    ref.watch(isEscrowLoader.notifier).state = false;
  }
  void eitherFailureOrdisputeEscrow(BuildContext context, WidgetRef ref) async {
    ref.watch(isEscrowLoader.notifier).state = true;
    EscrowRepositoryImpl repository = EscrowRepositoryImpl(
      remoteDataSource: EscrowRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: EscrowLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final failureOrEscrow = await GetEscrow(escrowRepository: repository).dispute(
      escrowParams: EscrowParams(
          disabled: escrowParams.disabled,
          escrow_Status: escrowParams.escrow_Status,
          customerId: escrowParams.customerId,
        id: escrowParams.id,
        token: token
      ),
    );

    escrow = failureOrEscrow.$2;
    failure = failureOrEscrow.$1;
    notifyListeners();
    if(escrow != null){
      ref.watch(counter.notifier).state = 0;

      eitherFailureOrEscrows( context,  ref, escrowParams.customerId!);
      showSnackBar(context, 'Escrow disputed');

    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);

    }
    ref.watch(isEscrowLoader.notifier).state = false;
  }
  void eitherFailureOrmakePaymentEscrow(BuildContext context, WidgetRef ref,  String email) async {
    ref.watch(isEscrowLoader.notifier).state = true;
    EscrowRepositoryImpl repository = EscrowRepositoryImpl(
      remoteDataSource: EscrowRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: EscrowLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final failureOrEscrow = await GetEscrow(escrowRepository: repository).makePayment(
      escrowParams: EscrowParams(
          amount: escrowParams.amount,
          customerId: escrowParams.customerId,
          id: escrowParams.id,
        token: token

      ),
    );

    escrow = failureOrEscrow.$2;
    failure = failureOrEscrow.$1;
    notifyListeners();
    if(escrow != null){
      ref.watch(counter.notifier).state = 0;
      ref.read(userProvider).eitherFailureOrGetUser(context, ref, email);
      eitherFailureOrEscrows( context,  ref, escrowParams.customerId!);

      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Skeleton()));
      showSnackBar(context, 'Payment made');

    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);

    }
    ref.watch(isEscrowLoader.notifier).state = false;
  }
  void eitherFailureOrReleaseEscrow(BuildContext context, WidgetRef ref,String email) async {
    ref.watch(isEscrowLoader.notifier).state = true;
    EscrowRepositoryImpl repository = EscrowRepositoryImpl(
      remoteDataSource: EscrowRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: EscrowLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final failureOrEscrow = await GetEscrow(escrowRepository: repository).release(
      escrowParams: EscrowParams(
        token: token,
          amount: escrowParams.amount,
          customerId: escrowParams.customerId,
          escrow_Status: escrowParams.escrow_Status,
        id: escrowParams.id,
      ),
    );

    escrow = failureOrEscrow.$2;
    failure = failureOrEscrow.$1;
    notifyListeners();
    if(escrow != null){
      ref.watch(counter.notifier).state = 0;
      ref.read(userProvider).eitherFailureOrGetUser(context, ref, email);
      eitherFailureOrEscrows( context,  ref, escrowParams.customerId!);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Skeleton()));
      showSnackBar(context, 'Escrow Canceled');

    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);

    }
    ref.watch(isEscrowLoader.notifier).state = false;
  }
  void eitherFailureOrChatEscrow(BuildContext context, WidgetRef ref) async {
    ref.watch(isEscrowLoader.notifier).state = true;
    EscrowRepositoryImpl repository = EscrowRepositoryImpl(
      remoteDataSource: EscrowRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: EscrowLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    log(escrowParams.chatId!);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final failureOrEscrow = await GetEscrow(escrowRepository: repository).getChat(
      escrowParams: EscrowParams(
        chatId: escrowParams.chatId,
        token: token
      ),
    );

    chat = failureOrEscrow.$2;
    failure = failureOrEscrow.$1;
    notifyListeners();
    if(chat != null){
      // showSnackBar(context, 'Email exist');

    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);

    }
    ref.watch(isEscrowLoader.notifier).state = false;
  }
}