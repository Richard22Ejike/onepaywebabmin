import '../../business/entities/payment_link_entity.dart';

class PaymentLinkModel extends PaymentLinkEntity {
  const PaymentLinkModel({
    required int id,
    required String accountId,
    required String customerId,
    required String organizationId,
    required String environment,
    required String description,
    required String name,
    required String linkId,
    required String country,
    required String currency,
    required String linkUrl,
    required int amount,
    required bool isDisabled,
    required List<PaymentDetailEntity> paymentDetails,
  }) : super(
    id: id,
    accountId: accountId,
    customerId: customerId,
    organizationId: organizationId,
    environment: environment,
    description: description,
    name: name,
    linkId: linkId,
    country: country,
    currency: currency,
    linkUrl: linkUrl,
    amount: amount,
    isDisabled: isDisabled,
    payment_details: paymentDetails,
  );

  factory PaymentLinkModel.fromJson(Map<String, dynamic> json) {
    return PaymentLinkModel(
      id: json['id'],
      accountId: json['account_id'],
      customerId: json['customer_id'],
      organizationId: json['organization_id'],
      environment: json['environment'],
      description: json['description'],
      name: json['name'],
      linkId: json['link_id'],
      country: json['country'],
      currency: json['currency'],
      linkUrl: json['link_url'],
      amount: json['amount'] ?? 0,
      isDisabled: json['is_disabled'],
      paymentDetails: (json['payment_details'] as List)
          .map((detail) => PaymentDetailModel.fromJson(detail))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account_id': accountId,
      'customer_id': customerId,
      'organization_id': organizationId,
      'environment': environment,
      'description': description,
      'name': name,
      'link_id': linkId,
      'country': country,
      'currency': currency,
      'link_url': linkUrl,
      'amount': amount,
      'is_disabled': isDisabled,
      'payment_details': payment_details
          .map((detail) => (detail as PaymentDetailModel).toJson())
          .toList(),
    };
  }
}
class PaymentDetailModel extends PaymentDetailEntity {
  PaymentDetailModel({
    required String name,
    required String phone,
    required String email,
    required String narration,
    required DateTime createdAt,
    required String paymentType,
    required String amount,
  }) : super(
    name: name,
    phone: phone,
    email: email,
    narration: narration,
    createdAt: createdAt,
    payment_type: paymentType,
    amount: amount,
  );

  factory PaymentDetailModel.fromJson(Map<String, dynamic> json) {
    return PaymentDetailModel(
      name: json['name'],
      phone: json['phone_number'].toString(),
      email: json['email'],
      narration: json['narration'],
      createdAt: DateTime.parse(json['created_at']),
      paymentType: json['payment_type'],
      amount: json['amount'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone_number': phone,
      'email': email,
      'narration': narration,
      'created_at': createdAt,
      'payment_type': payment_type,
      'amount': amount,
    };
  }
}
