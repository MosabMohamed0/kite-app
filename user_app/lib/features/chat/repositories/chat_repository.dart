import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/features/chat/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String adminId = 'admin';

  Future<void> sendMessage({required String message}) async {
    try {
      final userId = _auth.currentUser!.uid;

      final chatDocRef = _db.collection("chats").doc(userId);
      final msgRef = chatDocRef.collection("messages").doc();

      final newMessage = Message(
        messageId: msgRef.id,
        senderId: userId,
        receiverId: adminId,
        message: message,
        timestamp: Timestamp.now(),
        status: 'sent',
        isAdmin: false,
      );

      await msgRef.set(newMessage.toMap());

      await chatDocRef.set({
        "chatId": userId,
        "lastMessage": message,
        "lastSenderId": userId,
        "lastMessageTime": FieldValue.serverTimestamp(),
        "unreadCount_admin": FieldValue.increment(1),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<List<Message>> getMessages() {
    final userId = _auth.currentUser!.uid;

    return _db
        .collection("chats")
        .doc(userId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Message.fromDoc(doc)).toList();
        });
  }

  Future<void> markAdminMessagesAsRead() async {
    final userId = _auth.currentUser!.uid;
    final chatDocRef = _db.collection('chats').doc(userId);

    final messagesQuery =
        await chatDocRef
            .collection('messages')
            .where('senderId', isEqualTo: adminId)
            .where('status', isNotEqualTo: 'seen')
            .get();

    if (messagesQuery.docs.isNotEmpty) {
      final batch = _db.batch();
      for (var doc in messagesQuery.docs) {
        batch.update(doc.reference, {'status': 'seen'});
      }
      await batch.commit();
    }
  }

  Future<void> markMessageAsSeen(String chatId, String messageId) async {
    try {
      await _db
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .doc(messageId)
          .update({'status': 'seen'});
    } catch (e) {
      //
    }
  }

  Stream<int> getUnreadCountStream() {
    final userId = _auth.currentUser!.uid;
    return _db.collection('chats').doc(userId).snapshots().map((snapshot) {
      if (!snapshot.exists) return 0;
      final data = snapshot.data() as Map<String, dynamic>;
      return data['unreadCount_user'] ?? 0;
    });
  }

  Future<void> resetUserUnreadCount() async {
    final userId = _auth.currentUser!.uid;
    try {
      await _db.collection('chats').doc(userId).set({
        'unreadCount_user': 0,
      }, SetOptions(merge: true));
    } catch (e) {
      //
    }
  }
}
