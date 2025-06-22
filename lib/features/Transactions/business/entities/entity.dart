import 'package:intl/intl.dart';

class TransactionEntity {
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
  final bool credit;
  final String name;
  final DateTime dateSent;
  final int transaction_balance;

  TransactionEntity( {
    required this.transaction_balance,
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
    required this.name,
    required this.dateSent
  });
  // Formatted date in the format: Feb. 24 | 20:34
  String get formattedDateSent =>
      DateFormat('MMM. d | HH:mm').format(dateSent);
  String get formattedBalance => NumberFormat("#,##0.00", "en_US").format(transaction_balance );
  // Formatted amount in the format: 10,000.00
  String get formattedAmount => NumberFormat("#,##0.00", "en_US").format(amount);
}

class BankEntity {
  final String bankName;
  final String shortCode;
  final String bankCode;

  BankEntity({
    required this.bankName,
    required this.shortCode,
    required this.bankCode,
  });
}

