import 'dart:developer';

import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onepluspay/features/paybills/data/models/paybills_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/constants/utils.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../../../core/widgets/core/successful_screen.dart';
import '../../../../core/widgets/core/transaction_failed.dart';
import '../../../Auth/presentation/providers/User_provider.dart';
import '../../business/entities/entity.dart';
import '../../business/usecases/get_paybills.dart';
import '../../data/datasources/paybills_local_data_source.dart';
import '../../data/datasources/paybills_remote_data_source.dart';
import '../../data/repositories/paybills_repository_impl.dart';
import 'package:http/http.dart' as http;

final isBillLoader = StateProvider((ref) => false);
final dataIndex = StateProvider((ref) => 0);
final paybillsProvider = ChangeNotifierProvider((ref) => PaybillsProvider());
class PaybillsProvider extends ChangeNotifier {
  PayBillsEntity? paybills;
  List<TvEntity>? Dstvbill = [];
  List<TvEntity>? Gotvbill = [];
  List<TvEntity>? STARTIMEbill = [];
  Failure? failure;
  late PaybillsParams paybillsParams;

  PaybillsProvider({
    this.paybills,
    this.failure,
    PaybillsParams? initialParams,
  }) {
    paybillsParams = initialParams ?? PaybillsParams();
  }



  void updatePayBillsPin({required String pin, }) {
    paybillsParams.pin = pin;
    notifyListeners();
  }
  void updatePaybillsParams(PaybillsParams newPaybillsParams) {
    paybillsParams = newPaybillsParams;
    notifyListeners();
  }
  void eitherFailureOrPaybills(BuildContext context, WidgetRef ref) async {
    ref.watch(isBillLoader.notifier).state = true;
    PaybillsRepositoryImpl repository = PaybillsRepositoryImpl(
      remoteDataSource: PaybillsRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: PaybillsLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    log(paybillsParams.productId.toString());
    log(paybillsParams.operatorId.toString());
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final failureOrPaybills = await GetPaybills(paybillsRepository: repository).payPaybills(
      paybillsParams: PaybillsParams(
        amount: paybillsParams.amount,
        productId:  paybillsParams.productId,
        operatorId: paybillsParams.operatorId,
        meterType: paybillsParams.meterType,
        serviceType: paybillsParams.serviceType,
        mobileNumber:  paybillsParams.mobileNumber,
        mobileNetwork:  paybillsParams.mobileNetwork,
        accountId:  paybillsParams.accountId,
        customerId: paybillsParams.customerId,
        pin: paybillsParams.pin,
        electricCompanyCode: paybillsParams.electricCompanyCode,
        smartCardNo: paybillsParams.smartCardNo,
        requestId: paybillsParams.requestId,
        packageCode: paybillsParams.packageCode,
        meterNo: paybillsParams.meterNo,
        dataPlan: paybillsParams.dataPlan,
        callbackUrl: paybillsParams.callbackUrl,
        cableTvCode: paybillsParams.cableTvCode,
        bettingCustomerId: paybillsParams.bettingCustomerId,
        bettingCode: paybillsParams.bettingCode,
        token:token,
      ),
    );

      paybills = failureOrPaybills.$2;
      failure = failureOrPaybills.$1;
      notifyListeners();
    if(paybills != null){
      log('runni ng');
      log('service tupe : ${paybills?.serviceType}');
      if (paybills?.serviceType == 'cabletv'){
        showSnackBar(context, 'Cable purchase successful');
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
            SuccessfulScreen(
                title: 'Cable purchase successful',
                body: 'Your Cable has been successfully purchase. '
                    '\nSmart Card no: ${paybillsParams.smartCardNo} '
                    '\nName: ${paybills?.name}',
                isShare: true)));
      } else  if (paybills?.serviceType == 'electricity'){
        showSnackBar(context, 'credit purchase successful');
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
            SuccessfulScreen(
                title: 'credit purchase successful',
                body: 'Your credit has been successfully purchase. '
                    '\nToken no: ${paybills?.meterToken} '
                    '\nSmart Card no: ${paybillsParams.meterNo} '
                    '\nName: ${paybills?.name}',
                isShare: true)));
      } else {
        showSnackBar(context, 'credit purchase successful');
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
            SuccessfulScreen(
                title: 'purchase successful',
                body: 'Your credit has been successfully purchase. ',
                isShare: true)));
      }


    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          failedScreen(error: failure!.errorMessage,)));
    }
    ref.watch(isBillLoader.notifier).state = false;

  }
  void eitherFailureOrgettvbills(BuildContext context, WidgetRef ref) async {
    PaybillsRepositoryImpl repository = PaybillsRepositoryImpl(
      remoteDataSource: PaybillsRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: PaybillsLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    log(paybillsParams.accountId.toString());
    final failureOrDstvbills = await GetPaybills(paybillsRepository: repository).Tvbills(
      paybillsParams: PaybillsParams(

          customerId: 'BIL121',

      ),
    );
    final failureOrGotvbills = await GetPaybills(paybillsRepository: repository).Tvbills(
      paybillsParams: PaybillsParams(

        customerId: 'BIL122',

      ),
    );
    final failureOrStartbills = await GetPaybills(paybillsRepository: repository).Tvbills(
      paybillsParams: PaybillsParams(

        customerId: 'BIL123',

      ),
    );

    Dstvbill = failureOrDstvbills.$2;
    Gotvbill = failureOrGotvbills.$2;
    STARTIMEbill = failureOrStartbills.$2;
    failure = failureOrDstvbills.$1;
    notifyListeners();
    if(Dstvbill != null){
      showSnackBar(context, 'successfully tv bills lookup');


    }
    if(failure != null){
      showSnackBar(context, failure!.errorMessage);

    }
    ref.watch(isBillLoader.notifier).state = false;

  }
}