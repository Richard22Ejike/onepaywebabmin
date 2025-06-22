import 'package:onepluspay/features/Escrow/business/entities/entity.dart';
import 'package:onepluspay/features/card/business/entities/card_entity.dart';
import 'package:onepluspay/features/card/business/entities/payment_link_entity.dart';
import 'package:onepluspay/features/paybills/business/entities/entity.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../../Auth/business/entities/entity.dart';
import '../../../NearMe/business/entities/entity.dart';
import '../entities/entity.dart';

abstract class TransactionRepository {
  Future<(Failure?, List<TransactionEntity>?)> getTransaction({
    required TransactionParams transactionParams,
  });
  Future<(Failure?, List<CardEntity>?)> cards({
    required TransactionParams transactionParams,
  });
  Future<(Failure?, List<EscrowEntity>?)> escrows({
    required TransactionParams transactionParams,
  });
  Future<(Failure?, List<PayBillsEntity>?)> paybills({
    required TransactionParams transactionParams,
  });
  Future<(Failure?, List<NearMeEntity>?)>nearmes({
    required TransactionParams transactionParams,
  });
  Future<(Failure?, List<UserEntity>?)> getUsers({
    required TransactionParams transactionParams,
  });
  Future<(Failure?, List<PaymentLinkEntity>?)> paymentlinks({
    required TransactionParams transactionParams,
  });
  Future<(Failure?, String?)> getAccountName({
    required TransactionParams transactionParams,
  });
  Future<(Failure?, List<BankEntity>?)> getBank();
}