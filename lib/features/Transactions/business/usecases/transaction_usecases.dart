import 'package:onepluspay/features/Escrow/business/entities/entity.dart';
import 'package:onepluspay/features/NearMe/business/entities/entity.dart';
import 'package:onepluspay/features/card/business/entities/card_entity.dart';
import 'package:onepluspay/features/card/business/entities/payment_link_entity.dart';
import 'package:onepluspay/features/paybills/business/entities/entity.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../../Auth/business/entities/entity.dart';
import '../entities/entity.dart';
import '../repositories/repository.dart';

class Transactions {
  final TransactionRepository transactionRepository;

  Transactions({required this.transactionRepository});

  Future<(Failure?, List<TransactionEntity>?)> call({
    required TransactionParams transactionParams,
  }) async {
    return await transactionRepository.getTransaction(transactionParams: transactionParams);
  }
  Future<(Failure?, List<CardEntity>?)> cards({
    required TransactionParams transactionParams,
  }) async {
    return await transactionRepository.cards(transactionParams: transactionParams);
  }
  Future<(Failure?, List<PaymentLinkEntity>?)> paymentlinks({
    required TransactionParams transactionParams,
  }) async {
    return await transactionRepository.paymentlinks(transactionParams: transactionParams);
  }
  Future<(Failure?, List<EscrowEntity>?)> escrows({
    required TransactionParams transactionParams,
  }) async {
    return await transactionRepository.escrows(transactionParams: transactionParams);
  }
  Future<(Failure?, List<PayBillsEntity>?)> paybills({
    required TransactionParams transactionParams,
  }) async {
    return await transactionRepository.paybills(transactionParams: transactionParams);
  }
  Future<(Failure?, List<NearMeEntity>?)> nearmes({
    required TransactionParams transactionParams,
  }) async {
    return await transactionRepository.nearmes(transactionParams: transactionParams);
  }
  Future<(Failure?, List<UserEntity>?)> getUsers({
    required TransactionParams transactionParams,
  }) async {
    return await transactionRepository.getUsers(transactionParams: transactionParams);
  }

}
class GetBank {
  final TransactionRepository transactionRepository;

  GetBank({required this.transactionRepository});

  Future<(Failure?, List<BankEntity>?)> call() async {
    return await transactionRepository.getBank();
  }

  Future<(Failure?, String?)> getAccountName({
    required TransactionParams transactionParams,
  }) async {
    return await transactionRepository.getAccountName(transactionParams: transactionParams);
  }
}