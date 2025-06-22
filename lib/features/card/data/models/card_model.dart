import '../../business/entities/card_entity.dart';

class CardModel extends CardEntity {
  const CardModel({
    required String cardId,
    required String accountId,
    required String name,
    required String brand,
    required double balance,
    required String cardNumber,
    required String cvv,
    required String expiryMonth,
    required String expiryYear,
    required String email,
    required String pin,
    required String currency,
    required String txRef,
    required DateTime dateCreated,
  }) : super(
    cardId: cardId,
    accountId: accountId,
    name: name,
    brand: brand,
    balance: balance,
    cardNumber: cardNumber,
    cvv: cvv,
    expiryMonth: expiryMonth,
    expiryYear: expiryYear,
    email: email,
    pin: pin,
    currency: currency,
    txRef: txRef,
    dateCreated: dateCreated,
  );

  factory CardModel.fromJson({required Map<String, dynamic> json}) {
    return CardModel(
      cardId: json['card_id'],
      accountId: json['account_id'],
      name: json['name'],
      brand: json['brand'],
      balance: json['balance'],
      cardNumber: json['card_number'],
      cvv: json['cvv'],
      expiryMonth: json['expiry_month'],
      expiryYear: json['expiry_year'],
      email: json['email'],
      pin: json['pin'],
      currency: json['currency'],
      txRef: json['tx_ref'],
      dateCreated: DateTime.parse(json['date_created']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'card_id': cardId,
      'account_id': accountId,
      'name': name,
      'brand': brand,
      'balance': balance,
      'card_number': cardNumber,
      'cvv': cvv,
      'expiry_month': expiryMonth,
      'expiry_year': expiryYear,
      'email': email,
      'pin': pin,
      'currency': currency,
      'tx_ref': txRef,
      'date_created': dateCreated.toIso8601String(),
    };
  }
}

