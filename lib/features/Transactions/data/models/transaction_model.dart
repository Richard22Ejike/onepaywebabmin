import '../../business/entities/entity.dart';

class TransactionModel extends TransactionEntity {
  final String senderAccountNumber;
  final String bank;
  final String bankCode;
  final String reference;
  final String accountId;
  final String accountNumber;
  final int amount;
  final String currency;
  final String narration;
  final int transactionFee;
  final String name;
  final bool credit;
  final int transaction_balance;
  final DateTime dateSent; // Adding dateSent field

  TransactionModel({
    required this.name,
    required this.senderAccountNumber,
    required this.bank,
    required this.bankCode,
    required this.reference,
    required this.accountId,
    required this.accountNumber,
    required this.amount,
    required this.currency,
    required this.narration,
    required this.transactionFee,
    required this.credit,
    required this.dateSent,
    required this.transaction_balance// Include dateSent in the constructor
  }) : super(
    dateSent: dateSent,
    senderAccountNumber: senderAccountNumber,
    bank: bank,
    bankCode: bankCode,
    reference: reference,
    accountId: accountId,
    accountNumber: accountNumber,
    amount: amount,
    currency: currency,
    narration: narration,
    transactionFee: transactionFee,
    credit: credit,
    name: name,
    transaction_balance: transaction_balance
  );

  factory TransactionModel.fromJson({required Map<String, dynamic> json}) {
    return TransactionModel(
      transaction_balance: json['user_balance'],
      senderAccountNumber: json['sender_account_number'],
      bank: json['bank'],
      bankCode: json['bank_code'],
      reference: json['reference'],
      accountId: json['account_id'],
      accountNumber: json['account_number'],
      amount: json['amount'],
      currency: json['currency'],
      narration: json['narration'],
      transactionFee: json['transaction_fee'],
      credit: json['credit'],
      name: json['receiver_name'],
      dateSent: DateTime.parse(json['date_sent']), // Parsing dateSent from string
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_account_number': senderAccountNumber,
      'bank': bank,
      'bank_code': bankCode,
      'reference': reference,
      'account_id': accountId,
      'account_number': accountNumber,
      'amount': amount,
      'currency': currency,
      'narration': narration,
      'transaction_fee': transactionFee,
      'credit': credit,
      'date_sent': dateSent.toIso8601String(), // Converting dateSent to string
    };
  }
}


class BankModel extends BankEntity{
  final String bankName;
  final String shortCode;
  final String bankCode;

  BankModel({
    required this.bankName,
    required this.shortCode,
    required this.bankCode,
  }) : super(bankName: bankName, shortCode: shortCode, bankCode: bankCode);

  factory BankModel.fromJson({required Map<String, dynamic> json}) {
    return BankModel(
      bankName: json['bank_name'],
      shortCode: json['short_code'],
      bankCode: json['bank_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank_name': bankName,
      'short_code': shortCode,
      'bank_code': bankCode,
    };
  }
}

