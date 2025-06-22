import 'package:intl/intl.dart';

class EscrowEntity {
  final int id;
  final String accountId;
  final String customerId;
  final String escrowDescription;
  final String escrowName;
  final String senderName;
  final String receiverEmail;
  final String escrow_Status;
  final String payment_type;
  final String role;
  final String role_paying;
  final String estimated_days;
  final String milestone;
  final String number_milestone;
  final String reference;
  final String pin;
  final int amount;
  final bool isDisabled;
  final int receiver_id;
  final bool accepted;
  final bool answered;
  final bool make_payment;
  final DateTime created_at; // New field added

  const EscrowEntity({
    required this.id,
    required this.reference,
    required this.accountId,
    required this.customerId,
    required this.escrowDescription,
    required this.escrowName,
    required this.senderName,
    required this.receiverEmail,
    required this.escrow_Status,
    required this.payment_type,
    required this.role,
    required this.role_paying,
    required this.estimated_days,
    required this.milestone,
    required this.number_milestone,
    required this.pin,
    required this.amount,
    required this.isDisabled,
    required this.receiver_id,
    required this.accepted,
    required this.answered,
    required this.make_payment,
    required this.created_at, // New field added
  });
  String get formattedEscrowAmount => NumberFormat("#,##0.00", "en_US").format(amount);

}


class ChatEntity {
  final int id;
  final int escrow_id;   // Changed to int to match Django model
  final int sender_by;   // Changed to int to match Django model
  final int sender;
  final int receiver;
  final String message;
  final DateTime timestamp;

  const ChatEntity( {
    required this.id,
    required this.sender_by,   // Changed to match Django model
    required this.sender,
    required this.receiver,
    required this.message,
    required this.timestamp,
    required this.escrow_id,
  });
}

