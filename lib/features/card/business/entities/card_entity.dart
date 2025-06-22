class CardEntity {
  final String cardId;
  final String accountId;
  final String name;
  final String brand;
  final double balance;
  final String cardNumber;
  final String cvv;
  final String expiryMonth;
  final String expiryYear;
  final String email;
  final String pin;
  final String currency;
  final String txRef;
  final DateTime dateCreated;

  const CardEntity({
    required this.cardId,
    required this.accountId,
    required this.name,
    required this.brand,
    required this.balance,
    required this.cardNumber,
    required this.cvv,
    required this.expiryMonth,
    required this.expiryYear,
    required this.email,
    required this.pin,
    required this.currency,
    required this.txRef,
    required this.dateCreated,
  });
}



