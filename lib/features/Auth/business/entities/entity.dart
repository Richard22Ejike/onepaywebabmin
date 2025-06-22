import 'package:intl/intl.dart';

class UserEntity {
  final int id;
  final String image;
  final String password;
  final String? lastLogin;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final bool isActive;
  final bool isVerified;
  final bool status;
  final String customerId;
  final String customerType;
  final String bvn;
  final String accountNumber;
  final String bankName;
  final String updated;
  final String created;
  final double balance;
  final String street;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final String accountId;
  final String access_token;
  final String refresh_token;
  final double escrow_fund;
  final double notification_number;
  final int tier;
  const UserEntity(  {
    required this.id,
    this.lastLogin,
    required this.notification_number,
    required this.image,
    required this.password,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.isActive,
    required this.isVerified,
    required this.status,
    required this.customerId,
    required this.customerType,
    required this.bvn,
    required this.accountNumber,
    required this.bankName,
    required this.updated,
    required this.created,
    required this.balance,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.accountId,
    required this.access_token,
    required this.refresh_token,
    required this.escrow_fund,
    required this.tier
  });
  String get formattedBalance => NumberFormat("#,##0.00", "en_US").format(balance );
  String get formattedEscrowFund => NumberFormat("#,##0.00", "en_US").format(escrow_fund);
}

class MessageEntity {

  final String message;

  const MessageEntity( {

    required this.message,
  });

}


class NotificationEntity {

  final String topic;
  final String message;
  final String customer_id;


  const NotificationEntity(  {
    required this.topic,
    required this.customer_id,
    required this.message,
  });

}
