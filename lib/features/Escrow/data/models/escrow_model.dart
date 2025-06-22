import '../../business/entities/entity.dart';

class EscrowModel extends EscrowEntity {
  const EscrowModel({
    required int id,
    required int receiver_id,
    required String accountId,
    required String customerId,
    required String escrowDescription,
    required String escrowName,
    required String senderName,
    required String receiverEmail,
    required String escrow_Status,
    required String payment_type,
    required String role,
    required String role_paying,
    required String estimated_days,
    required String milestone,
    required String number_milestone,
    required String pin,
    required int amount,
    required bool isDisabled,
    required bool accepted,
    required bool answered,
    required bool make_payment,
    required String reference,
    required DateTime created_at, // New field added
  }) : super(
    id: id,
    accountId: accountId,
    reference: reference,
    customerId: customerId,
    escrowDescription: escrowDescription,
    escrowName: escrowName,
    senderName: senderName,
    receiverEmail: receiverEmail,
    escrow_Status: escrow_Status,
    payment_type: payment_type,
    role: role,
    role_paying: role_paying,
    estimated_days: estimated_days,
    milestone: milestone,
    number_milestone: number_milestone,
    pin: pin,
    amount: amount,
    isDisabled: isDisabled,
    receiver_id: receiver_id,
    accepted: accepted,
    answered: answered,
    make_payment: make_payment,
    created_at: created_at, // New field added
  );

  factory EscrowModel.fromJson({required Map<String, dynamic> json}) {
    return EscrowModel(
      id: json['id'] ?? 0,
      accountId: json['account_id'] ?? '',
      customerId: json['customer_id'] ?? '',
      escrowDescription: json['escrow_description'] ?? '',
      escrowName: json['escrow_name'] ?? '',
      senderName: json['sender_name'] ?? '',
      receiverEmail: json['receiver_email'] ?? '',
      escrow_Status: json['escrow_Status'] ?? '',
      payment_type: json['payment_type'] ?? '',
      role: json['role'] ?? '',
      role_paying: json['role_paying'] ?? '',
      estimated_days: json['estimated_days'] ?? '',
      milestone: json['milestone'] ?? '',
      number_milestone: json['number_milestone'] ?? '',
      pin: json['pin'] ?? '',
      amount: json['amount'] ?? 0,
      isDisabled: json['is_disabled'] ?? false,
      receiver_id: json['receiver_id'] ?? 0,
      accepted: json['accepted'] ?? false,
      answered: json['answered'] ?? false,
      make_payment: json['make_payment'] ?? false,
      created_at: DateTime.parse(json['created_at']), reference: json['reference'] ?? false, // New field added
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account_id': accountId,
      'customer_id': customerId,
      'escrow_description': escrowDescription,
      'escrow_name': escrowName,
      'sender_name': senderName,
      'receiver_email': receiverEmail,
      'amount': amount,
      'is_disabled': isDisabled,
      'escrow_Status': escrow_Status,
      'payment_type': payment_type,
      'role': role,
      'role_paying': role_paying,
      'estimated_days': estimated_days,
      'milestone': milestone,
      'number_milestone': number_milestone,
      'receiver_id': receiver_id,
      'pin': pin,
      'answered': answered,
      'accepted': accepted,
      'make_payment': make_payment,
      'created_at': created_at.toIso8601String(), // New field added
    };
  }
}

// class EscrowModel extends EscrowEntity {
//   const EscrowModel({
//     required int id,
//     required String accountId,
//     required String customerId,
//     required String escrowDescription,
//     required String escrowName,
//     required String senderName,
//     required String receiverEmail,
//     required String escrow_status,
//     required String payment_type,
//     required String role,
//     required String role_paying,
//     required String estimated_days,
//     required String milestone,
//     required String number_milestone,
//     required int amount,
//     required bool isDisabled,
//     required String pin,
//   }) : super(
//     id: id,
//     accountId: accountId,
//     customerId: customerId,
//     escrowDescription: escrowDescription,
//     escrowName: escrowName,
//     senderName: senderName,
//     receiverEmail: receiverEmail,
//     escrow_Status: escrow_status,
//     payment_type: payment_type,
//     role: role,
//     role_paying: role_paying,
//     estimated_days: estimated_days,
//     milestone: milestone,
//     number_milestone: number_milestone,
//     pin: pin,
//     amount: amount,
//     isDisabled: isDisabled,
//   );
//
//   factory EscrowModel.fromJson(Map<String, dynamic> json) {
//     return EscrowModel(
//       id: json['id'],
//       accountId: json['account_id'] as String?,
//       customerId: json['customer_id'],
//       escrowDescription: json['escrow_description'],
//       escrowName: json['escrow_name'],
//       senderName: json['sender_name'],
//       receiverEmail: json['receiver_email'],
//       escrow_status: json['escrow_Status'],
//       payment_type: json['payment_type'],
//       role: json['role'],
//       role_paying: json['role_paying'],
//       estimated_days: json['estimated_days'],
//       milestone: json['milestone'] ,
//       number_milestone: json['number_milestone'],
//       amount: json['amount'],
//       isDisabled: json['is_disabled'],
//       pin: json['pin'] ,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'account_id': accountId,
//       'customer_id': customerId,
//       'escrow_description': escrowDescription,
//       'escrow_name': escrowName,
//       'sender_name': senderName,
//       'receiver_email': receiverEmail,
//       'amount': amount,
//       'is_disabled': isDisabled,
//       'escrow_Status': escrow_Status,
//       'payment_type': payment_type,
//       'role': role,
//       'role_paying': role_paying,
//       'estimated_days': estimated_days,
//       'milestone': milestone,
//       'number_milestone': number_milestone,
//       'pin': pin,
//     };
//   }
// }
class ChatModel extends ChatEntity {
  const ChatModel({
    required int id,
    required int sender,
    required int receiver,
    required int sender_by,
    required int escrow_id,
    required String message,
    required DateTime timestamp,
  }) : super(
    id: id,
    sender_by: sender_by,
    sender: sender,
    receiver: receiver,
    escrow_id: escrow_id,
    message: message,
    timestamp: timestamp,
  );

  factory ChatModel.fromJson({required Map<String, dynamic> json}) {
    return ChatModel(
      id: json['id'],
      sender: json['sender'],
      receiver: json['receiver'],
      escrow_id: json['escrow_id'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      sender_by: json['sender_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'receiver': receiver,
      'escrow_id': escrow_id,
      'sender_by': sender_by,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

