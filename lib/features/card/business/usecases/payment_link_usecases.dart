import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/payment_link_entity.dart';
import '../repositories/repository.dart';

class PaymentLinkUseCases {
  final PaymentLinkRepository paymentLinkRepository;

  PaymentLinkUseCases({required this.paymentLinkRepository});

  Future<(Failure?, List<PaymentLinkEntity>?)> call({
    required PaymentLinkParams paymentLinkParams,
  }) async {
    return await paymentLinkRepository.getPaymentLinks(PaymentLinkParams: paymentLinkParams, );
  }
  Future<(Failure?, PaymentLinkEntity?)> createPaymentLink({
    required PaymentLinkParams paymentLinkParams,
  }) async {
    return await paymentLinkRepository.createPaymentLink(PaymentLinkParams: paymentLinkParams, );
  }
}