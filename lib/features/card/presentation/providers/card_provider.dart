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
import '../../business/entities/card_entity.dart';
import '../../business/usecases/card_usecases.dart';
import '../../data/datasources/card_local_data_source.dart';
import '../../data/datasources/card_remote_data_source.dart';
import '../../data/repositories/card_repository_impl.dart';
import 'package:http/http.dart' as http;


final counter = StateProvider((ref) => 0);
final isCardLoader = StateProvider((ref) => false);
final cardProvider = ChangeNotifierProvider((ref) => CardProvider());

class CardProvider extends ChangeNotifier {
  List<CardEntity>? cards;
  CardEntity? card;
  Failure? failure;
  late CardParams cardParams;
  CardProvider({
    this.cards,
    this.card,
    this.failure,
    CardParams ? initialParams,
  }) {
    cardParams = initialParams ?? CardParams();
  }
  
  void updateCardParams(CardParams newcardParams, ) {
    cardParams = newcardParams;
    notifyListeners();
  }

  void eitherFailureOrCard(String customerId) async {
    CardRepositoryImpl repository = CardRepositoryImpl(
      remoteDataSource: CardRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: CardLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final failureOrCard = await CardUseCases(cardRepository: repository).call(
      cardParams: CardParams(
        customerId: customerId,
        token: token
      ),
    );

      cards = failureOrCard.$2;
      failure = failureOrCard.$1;
      notifyListeners();


  }
  void eitherFailureOrAddCard(BuildContext context, WidgetRef ref) async {
    ref.watch(isCardLoader.notifier).state = true;
    CardRepositoryImpl repository = CardRepositoryImpl(
      remoteDataSource: CardRemoteDataSourceImpl(
        httpClient: http.Client(),
      ),
      localDataSource: CardLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final failureOrCard = await CardUseCases(cardRepository: repository).addCard(
      cardParams: CardParams(
        token: token,
          customerId: cardParams.customerId,
          amount: cardParams.amount,
          currency: cardParams.currency,
          narration:cardParams.narration,
          gender: cardParams.gender,
          pin: cardParams.pin,
          brand: cardParams.brand,
          cardNumber: cardParams.cardNumber,
          cvv: cardParams.cvv,
          expiryMonth: cardParams.expiryMonth,
          expiryYear: cardParams.expiryYear,
      ),
    );

    card = failureOrCard.$2;
    failure = failureOrCard.$1;
    if(card != null){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SuccessfulScreen(
        title: 'Card successful',
        body: 'Success added Card',
        isShare: false,)));
      ref.watch(isCardLoader.notifier).state = false;
    }
    if(failure != null){

        showSnackBar(context, failure!.errorMessage);
        ref.watch(isCardLoader.notifier).state = false;
    }
    notifyListeners();


  }


}