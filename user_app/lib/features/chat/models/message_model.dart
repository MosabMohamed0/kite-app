import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String messageId;
  final String senderId;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final String status;
  final bool isAdmin;

  Message({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.status,
    this.isAdmin = false,
  });

  factory Message.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message(
      messageId: doc.id,
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      message: data['message'] ?? '',
      timestamp:
          data['timestamp'] is Timestamp ? data['timestamp'] : Timestamp.now(),
      status: data['status'] ?? 'sent',
      isAdmin: data['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'status': status,
      'isAdmin': isAdmin,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['messageId'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      message: json['message'] ?? '',
      timestamp:
          json['timestamp'] is Timestamp
              ? json['timestamp']
              : Timestamp.fromDate(
                DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
                    DateTime.now(),
              ),
      status: json['status'] ?? 'sent',
      isAdmin: json['isAdmin'] ?? false,
    );
  }
}
