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
import '../../business/entities/payment_link_entity.dart';
import '../../business/usecases/payment_link_usecases.dart';
import '../../data/datasources/payment_link_data_source.dart';
import 'package:http/http.dart' as http;

import '../../data/repositories/payment_link_repository_impl.dart';
import 'card_provider.dart';


final paymentLinkProvider = ChangeNotifierProvider((ref) => PaymentLinkProvider());

class PaymentLinkProvider extends ChangeNotifier {
  List<PaymentLinkEntity>? paymentLinks;
  PaymentLinkEntity? paymentLink;
  Failure? failure;
  late PaymentLinkParams paymentLinkParams;

  PaymentLinkProvider({
    this.paymentLinks,
    this.paymentLink,
    this.failure,
    PaymentLinkParams ? initialParams,
  }) {
    paymentLinkParams = initialParams ?? PaymentLinkParams();
  }

  void updatePaymentLinkParams(PaymentLinkParams newpaymentLinkParams) {
    paymentLinkParams = newpaymentLinkParams;
    notifyListeners();
  }

  void eitherFailureOrPaymentLink(String CustomerId) async {
    PaymentLinkRepositoryImpl repository = PaymentLinkRepositoryImpl(
      remoteDataSource: PaymentLinkRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: PaymentLinkLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final failureOrPaymentLink = await PaymentLinkUseCases(paymentLinkRepository: repository).call(
      paymentLinkParams: PaymentLinkParams(
        customerId: CustomerId,
        token: token
      ),
    );

    paymentLinks = failureOrPaymentLink.$2;
    failure = failureOrPaymentLink.$1;
    notifyListeners();
  }
  void eitherFailureOrCreatePaymentLink(BuildContext context, WidgetRef ref) async {
    ref.watch(isCardLoader.notifier).state = true;
    PaymentLinkRepositoryImpl repository = PaymentLinkRepositoryImpl(
      remoteDataSource: PaymentLinkRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: PaymentLinkLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final failureOrPaymentLink = await PaymentLinkUseCases(paymentLinkRepository: repository).createPaymentLink(
      paymentLinkParams: PaymentLinkParams(
          amount: paymentLinkParams.amount,
          name: paymentLinkParams.name,
          customerId: paymentLinkParams.customerId,
          description: paymentLinkParams.description,
          currency: paymentLinkParams.currency,
        token: token
      ),
    );

    paymentLink = failureOrPaymentLink.$2;
    failure = failureOrPaymentLink.$1;
    notifyListeners();
    if(paymentLink != null){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SuccessfulScreen(title: 'Payment link created', body: 'You’ve now created a unique link. Send it to your customer so that they make a payment', isShare: true)));

    }
    if(failure != null){
        showSnackBar(context, failure!.errorMessage);
        ref.watch(isCardLoader.notifier).state = false;

    }

    ref.watch(isCardLoader.notifier).state = false;
  }


}