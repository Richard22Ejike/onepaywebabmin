import 'dart:io';

class NoParams {}

class TemplateParams {}

class EscrowParams {
  String? token;
  int? id;
  String?  accountId;
  String?  customerId;
  String? escrowDescription;
  String? escrowName;
  String? escrow_Status;
  String? payment_type;
  String? role;
  String?  role_paying;
  String?  senderName;
  String?  receiverEmail;
  String?  estimated_days;
  int?  amount;
  String? milestone;
  String? number_milestone;
  String? pin;
  String? dispute;
  bool? disabled;
  String? chatId;
  String? receiver_id;
  bool? accepted;
  bool? answered;
  bool? make_payment;
  EscrowParams({
    this.token,
    this.id,
    this.dispute,
    this.accountId,
    this.customerId,
    this.escrowDescription,
    this.escrowName,
    this.payment_type,
    this.role,
    this.role_paying,
    this.senderName,
    this.receiverEmail,
    this.estimated_days,
    this.amount,
    this.milestone,
    this.number_milestone,
    this.pin,
    this.escrow_Status,
    this.disabled,
    this.chatId,
    this.receiver_id,
    this.accepted,
    this.answered,
    this.make_payment
});
}

class NearMeParams {
  String? token;
  int? id;
  String? productId;
  String? productCategory;
  String? productName;
  List<File>? productImages;
  List<String>? finalProductImages;
  List<String>? chatIds;
  String? customerId;
  String? video;
  String? title;
  String? location;
  String? lat;
  String? long;
  String? brand;
  String? type;
  String? condition;
  String? description;
  String? price;
  String? delivery;
  DateTime? createdAt;
  String? status;
  String? sellerName;
  String? sellerImage;
  String? sellerPhoneNumber;
  String? escrowId;
  String? senderId;
  String? chatId;
  String? receiverId;
  String? timestamp;
  String? sellerEmail;
  String? sellerId;

  NearMeParams({
    this.token,
    this.id,
    this.productId,
    this.productCategory,
    this.productName,
    this.productImages,
    this.customerId,
    this.video,
    this.title,
    this.location,
    this.lat,
    this.long,
    this.brand,
    this.type,
    this.condition,
    this.description,
    this.price,
    this.delivery,
    this.createdAt,
    this.status,
    this.chatId,
    this.sellerName,
    this.sellerImage,
    this.sellerPhoneNumber,
    this.escrowId,
    this.senderId,
    this.chatIds,
    this.receiverId,
    this.timestamp,
    this.finalProductImages,
    this.sellerEmail,
    this.sellerId,
  });
}


class UserParams {
    String? token;
   String? first_name = '';
   String? last_name = '';
   String? phone_number = '';
   String? password = '';
   String? email = '';
   String? customer_type = '';
   String? bvn = '';
   String? otp = '';
   String? key = '';
   String? DOfB = '';

  UserParams({
    this.token,
     this.first_name,
     this.last_name,
     this.phone_number,
     this.password,
     this.email,
     this.customer_type,
     this.bvn,
     this.otp,
     this.key,
     this.DOfB
  });
}

class AccountParams {
  String? token;
  String? customerId;
  String? placeOfBirth;
  String? dob;
  String? gender;
  String? country;
  String? street;
  String? city;
  String? state;
  String? postalCode;
  String? image;
  String? meansOfId;
  String? documentNumber;
  String? email;
  String? phoneNumber;
  String? bvn;
  String? oldPin;
  String? newPin;
  String? customerType;
  String? otp;
  String? password;
  String? firstName;
  String? lastName;


  AccountParams({
    this.token,
    this.firstName,
    this.lastName,
    this.customerId,
    this.placeOfBirth,
    this.dob,
    this.gender,
    this.country,
    this.street,
    this.city,
    this.state,
    this.postalCode,
    this.image,
    this.meansOfId,
    this.documentNumber,
    this.email,
    this.phoneNumber,
    this.bvn,
    this.newPin,
    this.oldPin,
    this.customerType,
    this.otp,
    this.password
  });
}


class TransactionParams {
  String? token;
  int? key;
  int? amount;
  String? bankCode;
  String? accountNumber;
  String? narration;
  String? accountId;
  String? reference;
  String? accountBank;
  String? pin;
  String? customerId;
  String? name;
  bool? credit;


  TransactionParams({
    this.token,
    this.amount,
    this.bankCode,
    this.accountNumber,
    this.narration,
    this.accountId,
    this.reference,
    this.accountBank,
    this.pin,
    this.customerId,
    this.key,
    this.credit,
    this.name
  });
}


class PaybillsParams {
  String? token;
  int? amount;
  String? productId;
  String? operatorId;
  String? accountId;
  String? meterType;
  String? electricCompanyCode;
  String? meterNo;
  String? cableTvCode;
  String? smartCardNo;
  String? bettingCode;
  String? bettingCustomerId;
  String? serviceType;
  String? requestId;
  String? callbackUrl;
  String? dataPlan;
  String? packageCode;
  String? mobileNumber;
  String? mobileNetwork;
  String? pin;
  String? customerId;

  PaybillsParams({
    this.token,
    this.amount,
    this.productId,
    this.operatorId,
    this.accountId,
    this.meterType,
    this.serviceType,
    this.electricCompanyCode,
    this.meterNo,
    this.cableTvCode,
    this.smartCardNo,
    this.bettingCode,
    this.bettingCustomerId,
    this.requestId,
    this.callbackUrl,
    this.dataPlan,
    this.packageCode,
    this.mobileNumber,
    this.mobileNetwork,
    this.pin,
    this.customerId
  });
}


class PaymentLinkParams {
  String? token;
  String? name;
  String? description;
  int? amount;
  String? currency;
  String? accountId;
  String? customerId;

  PaymentLinkParams({
    this.token,
    this.name,
    this.description,
    this.amount,
    this.currency,
    this.accountId,
    this.customerId
  });
}


class CardParams {
  String? token;
  String? customerId;
  String? brand;
  String? pin;
  String? cardNumber;
  String? narration;
  int? amount;
  String? gender;
  String? currency;
  String? cvv;
  String? expiryMonth;
  String? expiryYear;

  CardParams({
    this.token,
    this.customerId,
    this.brand,
    this.pin,
    this.cardNumber,
    this.narration,
    this.amount,
    this.gender,
    this.currency,
    this.cvv,
    this.expiryMonth,
    this.expiryYear,
  });
}


class PokemonParams {
  final String id;
  const PokemonParams({
    required this.id,
  });
}

