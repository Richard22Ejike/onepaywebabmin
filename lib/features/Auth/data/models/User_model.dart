import '../../business/entities/entity.dart';

class UserModel extends UserEntity {


  const UserModel({
    required int id,
    required String image,
    required double escrow_fund,
    required String password,
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required bool isActive,
    required bool isVerified,
    required bool status,
    required String customerId,
    required String customerType,
    required String bvn,
    required String accountNumber,
    required String bankName,
    required String updated,
    required String created,
    required double balance,
    required String street,
    required String city,
    required String state,
    required String country,
    required String postalCode,
    required int lastLogin,
    required String accountId,
    required String accessToken,
    required String refreshToken,
    required double notification_number,
    required int tier,
  }) : super(
    id: id,
    image:image,
    password: password,
    email: email,
    firstName: firstName,
    lastName: lastName,
    phoneNumber: phoneNumber,
    isActive: isActive,
    isVerified: isVerified,
    status: status,
    customerId: customerId,
    customerType: customerType,
    bvn: bvn,
    accountNumber: accountNumber,
    bankName: bankName,
    updated: updated,
    created: created,
    balance: balance,
    street: street,
    city: city,
    state: state,
    country: country,
    postalCode: postalCode,
    accountId: accountId,
    refresh_token: refreshToken,
    access_token: accessToken,
    escrow_fund: escrow_fund,
    tier:tier,
    notification_number: notification_number
  );

  factory UserModel.fromJson({required Map<String, dynamic> json}) {
    return UserModel(
// Example default value of 0 if 'id' is null
      id: json['id'],
      image: json['image'],
      lastLogin: json['last_login'] ?? 0,
      password: json['password'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      isActive: json['is_active'] ?? false,
      isVerified: json['is_verified'] ?? false,
      status: json['status'] ?? false,
      customerId: json['customer_id'] ?? '',
      customerType: json['customer_type'] ?? '',
      bvn: json['bvn'] ?? '',
      accountNumber: json['account_number'] ?? '',
      bankName: json['bank_name'] ?? '',
      updated: json['updated'] ?? '',
      created: json['created'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      postalCode: json['postal_code'] ?? '',
      accountId: json['account_id'] ?? '',
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      escrow_fund: (json['escrow_fund'] ?? 0).toDouble(),
      tier:(json['kyc_tier']?? 0),
      notification_number: (json['notification_number'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'password': password,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'is_active': isActive,
      'is_verified': isVerified,
      'status': status,
      'customer_id': customerId,
      'customer_type': customerType,
      'bvn': bvn,
      'account_number': accountNumber,
      'bank_name': bankName,
      'updated': updated,
      'created': created,
      'balance': balance,
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'postal_code': postalCode,
      'account_id': accountId,
      'refresh_token': refresh_token,
      'access_token': access_token,
      'escrow_fund' : escrow_fund,
      'image':image,
      'kyc_tier': tier,
      'notification_number':notification_number
    };
  }
}


class MessageModel extends MessageEntity {
  const MessageModel({

    required String message,
  }) : super(

    message: message,
  );


  factory MessageModel.fromJson({required Map<String, dynamic> json}) {
    return MessageModel(

      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {

      'message': message,
    };
  }
}

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required String customer_id,
    required String topic,
    required String message,
  }) : super(
      customer_id: customer_id,
    topic: topic,
    message: message,
  );


  factory NotificationModel.fromJson({required Map<String, dynamic> json}) {
    return NotificationModel(

      message: json['message'],
      customer_id: json['customer_id'],
      topic: json['topic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topic':topic,
      'customer_id':customer_id,
      'message': message,
    };
  }
}