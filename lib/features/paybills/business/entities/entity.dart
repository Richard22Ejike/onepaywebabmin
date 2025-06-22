class PayBillsEntity {
  final String name;
  final String customerId;
  final String accountId;
  final double amount;
  final String operatorId;
  final String orderId;
  final String meterType;
  final String serviceType;
  final String deviceNumber;
  final DateTime orderDate;
  final String status;
  final String remark;
  final String orderType;
  final String mobileNetwork;
  final String mobileNumber;
  final String meterToken;
  final double walletBalance;

  const PayBillsEntity({
    required this.name,
    required this.customerId,
    required this.accountId,
    required this.amount,
    required this.operatorId,
    required this.orderId,
    required this.meterType,
    required this.deviceNumber,
    required this.orderDate,
    required this.status,
    required this.remark,
    required this.orderType,
    required this.mobileNetwork,
    required this.mobileNumber,
    required this.meterToken,
    required this.walletBalance,
    required this.serviceType,
  });
}

class TvEntity {
  final String item_code;
  final int amount;
  final String biller_code;
  final String group_name;
  final String short_name;
  final int charge_fee;
  final String? validity_period; // Nullable field

  const TvEntity({
    required this.item_code,
    required this.amount,
    required this.biller_code,
    required this.group_name,
    required this.short_name,
    required this.charge_fee,
    this.validity_period, // Properly initialize the nullable field
  });
}

