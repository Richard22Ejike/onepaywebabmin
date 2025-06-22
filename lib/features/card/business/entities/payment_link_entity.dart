import 'package:intl/intl.dart';

class PaymentLinkEntity {
  final int id;
  final String accountId;
  final String customerId;
  final String organizationId;
  final String environment;
  final String description;
  final String name;
  final String linkId;
  final String country;
  final String currency;
  final String linkUrl;
  final int amount;
  final bool isDisabled;
  final List<PaymentDetailEntity> payment_details;

  const PaymentLinkEntity( {
    required this.payment_details,
    required this.id,
    required this.accountId,
    required this.customerId,
    required this.organizationId,
    required this.environment,
    required this.description,
    required this.name,
    required this.linkId,
    required this.country,
    required this.currency,
    required this.linkUrl,
    required this.amount,
    required this.isDisabled,
  });
}

class PaymentDetailEntity{
  final String name;
  final String phone;
  final String email;
  final String narration;
  final DateTime createdAt;
  final String payment_type;
  final String amount;

  PaymentDetailEntity({
      required this.name,
      required this.phone,
    required this.email,
    required this.narration,
    required this.createdAt,
    required this.payment_type,
    required this.amount});
  String get formattedDateSent =>
      DateFormat('MMM. d | HH:mm').format(createdAt);

}