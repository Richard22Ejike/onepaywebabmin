import '../../../../core/constants/constants.dart';
import '../../business/entities/entity.dart';

class PaybillsModel extends PayBillsEntity {
  const PaybillsModel({
    required String name,
    required String customerId,
    required String accountId,
    required double amount,
    required String operatorId,
    required String orderId,
    required String meterType,
    required String deviceNumber,
    required DateTime orderDate,
    required String status,
    required String remark,
    required String orderType,
    required String mobileNetwork,
    required String mobileNumber,
    required String meterToken,
    required double walletBalance,
    required String serviceType,
  }) : super(
    name: name,
    customerId: customerId,
    accountId: accountId,
    amount: amount,
    operatorId: operatorId,
    orderId: orderId,
    meterType: meterType,
    deviceNumber: deviceNumber,
    orderDate: orderDate,
    status: status,
    remark: remark,
    orderType: orderType,
    mobileNetwork: mobileNetwork,
    mobileNumber: mobileNumber,
    meterToken: meterToken,
    walletBalance: walletBalance,
    serviceType:serviceType,
  );

  // Factory method to create an instance from a JSON map
  factory PaybillsModel.fromJson({required Map<String, dynamic> json}) {
    return PaybillsModel(
      name: json['name'] ?? '',
      customerId: json['customer_id'] ?? '',
      accountId: json['account_id'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0.0') ?? 0.0,
      operatorId: json['operator_id'] ?? '',
      orderId: json['order_id'] ?? '',
      meterType: json['meter_type'] ?? '',
      deviceNumber: json['device_number'] ?? '',
      orderDate: DateTime.tryParse(json['order_date'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? '',
      remark: json['remark'] ?? '',
      orderType: json['order_type'] ?? '',
      mobileNetwork: json['mobile_network'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      meterToken: json['meter_token'] ?? '',
      serviceType: json['service_type'] ?? '',
      walletBalance: (json['wallet_balance'] is double)
          ? json['wallet_balance'] as double
          : double.tryParse(json['wallet_balance']?.toString() ?? '0.0') ?? 0.0,
    );
  }


  // Method to convert the instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'customer_id': customerId,
      'account_id': accountId,
      'amount': amount,
      'operator_id': operatorId,
      'order_id': orderId,
      'meter_type': meterType,
      'device_number': deviceNumber,
      'order_date': orderDate.toIso8601String(),
      'status': status,
      'remark': remark,
      'order_type': orderType,
      'service_type': serviceType,
      'mobile_network': mobileNetwork,
      'mobile_number': mobileNumber,
      'meter_token': meterToken,
      'wallet_balance': walletBalance,
    };
  }
}

class TvModel extends TvEntity {
  const TvModel({
    required String item_code,
    required int amount,
    required String biller_code,
    required int charge_fee, // Changed to int
    required String group_name,
    required String short_name,
    String? validity_period, // Nullable
  }) : super(
    item_code: item_code,
    amount: amount,
    biller_code: biller_code,
    charge_fee: charge_fee,
    group_name: group_name,
    short_name: short_name,
    validity_period: validity_period,
  );

  factory TvModel.fromJson({required Map<String, dynamic> json}) {
    return TvModel(
      item_code: json['item_code'],
      amount: json['amount'],
      biller_code: json['biller_code'],
      charge_fee: json['fee'], // Map the 'fee' field from JSON
      group_name: json['group_name'],
      short_name: json['short_name'],
      validity_period: json['validity_period'], // Handle nullable fields
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_code': item_code,
      'amount': amount,
      'biller_code': biller_code,
      'charge_fee': charge_fee, // Output fee as charge_fee
      'group_name': group_name,
      'short_name': short_name,
      'validity_period': validity_period,
    };
  }
}

