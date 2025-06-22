import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/card_entity.dart';
import '../entities/payment_link_entity.dart';

abstract class CardRepository {
  Future<(Failure?, List<CardEntity>?)> getCards({
    required CardParams cardParams,
  });
  Future<(Failure?, CardEntity?)> addCard({
    required CardParams cardParams,
  });
}

abstract class PaymentLinkRepository {
  Future<(Failure?, List<PaymentLinkEntity>?)> getPaymentLinks({
    required PaymentLinkParams PaymentLinkParams,
  });
  Future<(Failure?, PaymentLinkEntity?)> createPaymentLink({
    required PaymentLinkParams PaymentLinkParams,
  });
}