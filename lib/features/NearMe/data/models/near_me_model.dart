import '../../business/entities/entity.dart';

class NearMeModel extends NearMeEntity {
  const NearMeModel({
    required int id,
    required String productId,
    required String productCategory,
    required String productName,
    required List<String> productImages,
    required String customerId,
    required String video,
    required String title,
    required String location,
    required String lat,
    required String long,
    required String brand,
    required String type,
    required String condition,
    required String description,
    required String price,
    required String delivery,
    required DateTime createdAt,
    required String status,
    required String sellerName,
    required String sellerImage,
    required String sellerPhoneNumber,
    required String sellerEmail,
    required String sellerId
  }) : super(
    id: id,
    productId: productId,
    productCategory: productCategory,
    productName: productName,
    productImages: productImages,
    customerId: customerId,
    video: video,
    title: title,
    location: location,
    lat: lat,
    long: long,
    brand: brand,
    type: type,
    condition: condition,
    description: description,
    price: price,
    delivery: delivery,
    createdAt: createdAt,
    status: status,
    sellerName:sellerName,
    sellerImage:sellerImage,
    sellerPhoneNumber:sellerPhoneNumber,
    sellerEmail: sellerEmail,
      sellerId: sellerId
  );

  /// Factory method to create `EscrowModel` from JSON
  factory NearMeModel.fromJson({required Map<String, dynamic> json}) {
    return NearMeModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? '',
      productCategory: json['product_category'] ?? '',
      productName: json['product_name'] ?? '',
      productImages: List<String>.from(json['product_images'] ?? []),
      customerId: json['customer_id'] ?? '',
      video: json['video'] ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      lat: json['lat'] ?? '',
      long: json['long'] ?? '',
      brand: json['brand'] ?? '',
      type: json['type'] ?? '',
      condition: json['condition'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '0.00',
      delivery: json['delivery'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      status: json['status'] ?? '',
      sellerName:json["seller_name"] ?? '',
      sellerImage:json["seller_image"] ?? '',
      sellerPhoneNumber:json["seller_phone_number"] ?? '',
      sellerEmail:json["seller_email"]??'',
      sellerId:json["seller_id"]??'',
    );
  }

  /// Convert `EscrowModel` to JSON
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_category': productCategory,
      'product_name': productName,
      'product_images': productImages,
      'customer_id': customerId,
      'video': video,
      'title': title,
      'location': location,
      'lat': lat,
      'long': long,
      'brand': brand,
      'type': type,
      'condition': condition,
      'description': description,
      'price': price,
      'delivery': delivery,
      'created_at': createdAt.toIso8601String(),
      'status': status,
      'sellerName':sellerName,
      'sellerImage':sellerImage,
      'sellerPhoneNumber':sellerPhoneNumber,
      'sellerEmail':sellerEmail,
      'sellerId':sellerId,
    };
  }
}

class NearMeChatModel extends NearMeChatEntity {
  const NearMeChatModel({
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

  factory NearMeChatModel.fromJson({required Map<String, dynamic> json}) {
    return NearMeChatModel(
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

class ChatRoomModel extends ChatRoomEntity {
  const ChatRoomModel({
    required String chat_id,
    required String sender_image,
    required String sender_name,
    required int id,
    required int sender,
    required int receiver,
    required int sender_by,
    required int escrow_id,
    required String last_message,
    required DateTime timestamp,
  }) : super(
    id: id,
    sender_by: sender_by,
    sender: sender,
    receiver: receiver,
    escrow_id: escrow_id,
    last_message: last_message,
    timestamp: timestamp,
    chat_id: chat_id,
    sender_image: sender_image,
    sender_name: sender_name,

  );

  factory ChatRoomModel.fromJson({required Map<String, dynamic> json}) {
    return ChatRoomModel(
      id: json['id'],
      sender: json['sender'],
      receiver: json['receiver'],
      escrow_id: json['escrow_id'],
      last_message: json['last_message'],
      timestamp: DateTime.parse(json['timestamp']),
      sender_by: json['sender_by'], chat_id: json['chat_id'], sender_image: json['sender_image'], sender_name: json['sender_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'receiver': receiver,
      'escrow_id': escrow_id,
      'sender_by': sender_by,
      'last_message': last_message,
      'chat_id':chat_id,
      'sender_image':sender_image,
      'sender_name':sender_name,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}


