import 'package:intl/intl.dart';

class NearMeEntity {
  final int id;
  final String sellerId;
  final String productId;
  final String productCategory;
  final String productName;
  final List<String> productImages;
  final String customerId;
  final String video;
  final String title;
  final String location;
  final String lat;
  final String long;
  final String brand;
  final String type;
  final String condition;
  final String description;
  final String price;
  final String delivery;
  final DateTime createdAt;
  final String status;
  final String sellerName;
  final String sellerImage;
  final String sellerPhoneNumber;
  final String sellerEmail;

  const NearMeEntity({
    required this.id,
    required this.productId,
    required this.productCategory,
    required this.productName,
    required this.productImages,
    required this.customerId,
    required this.video,
    required this.title,
    required this.location,
    required this.lat,
    required this.long,
    required this.brand,
    required this.type,
    required this.condition,
    required this.description,
    required this.price,
    required this.delivery,
    required this.createdAt,
    required this.status,
    required this.sellerName,
    required this.sellerImage,
    required this.sellerPhoneNumber,
    required this.sellerEmail,
    required this.sellerId,
  });

  /// Format price as a currency string
  String get formattedPrice => NumberFormat("#,##0.00", "en_US").format(double.parse(price));

}


class NearMeChatEntity {
  final int id;
  final int escrow_id;   // Changed to int to match Django model
  final int sender_by;   // Changed to int to match Django model
  final int sender;
  final int receiver;
  final String message;
  final DateTime timestamp;

  const NearMeChatEntity( {
    required this.id,
    required this.sender_by,   // Changed to match Django model
    required this.sender,
    required this.receiver,
    required this.message,
    required this.timestamp,
    required this.escrow_id,
  });
}

class ChatRoomEntity {
  final int id;
  final String chat_id;
  final String sender_image;
  final String sender_name;
  final int escrow_id;   // Changed to int to match Django model
  final int sender_by;   // Changed to int to match Django model
  final int sender;
  final int receiver;
  final String last_message;
  final DateTime timestamp;

  const ChatRoomEntity(  {
    required this.chat_id,
    required this.sender_image,
    required this.sender_name,
    required this.id,
    required this.sender_by,   // Changed to match Django model
    required this.sender,
    required this.receiver,
    required this.last_message,
    required this.timestamp,
    required this.escrow_id,
  });
}

