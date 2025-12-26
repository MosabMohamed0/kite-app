import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/message_model.dart';

class ChatRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String adminId = 'admin';
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
    required bool isAdmin,
  }) async {
    try {
      final chatId = isAdmin ? receiverId : senderId;

      final msgRef =
          _db.collection("chats").doc(chatId).collection("messages").doc();

      final newMessage = Message(
        messageId: msgRef.id,
        senderId: senderId,
        receiverId: receiverId,
        message: message,
        timestamp: Timestamp.now(),
        status: 'sent',
        isAdmin: isAdmin,
      );

      await msgRef.set(newMessage.toMap());

      if (!isAdmin) {
        await _db.collection("chats").doc(chatId).set({
          "chatId": chatId,
          "lastMessage": message,
          "lastSenderId": senderId,
          "lastMessageTime": FieldValue.serverTimestamp(),
          "unreadCount_admin": FieldValue.increment(1),
        }, SetOptions(merge: true));
      } else {
        await _db.collection("chats").doc(chatId).set({
          "lastMessage": message,
          "lastMessageTime": FieldValue.serverTimestamp(),
          "unreadCount_admin": 0,
          "unreadCount_user": FieldValue.increment(1),
          "lastSenderId": senderId,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<List<Message>> getMessages(String chatId) {
    return _db
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Message.fromDoc(doc)).toList(),
        );
  }

  Stream<List<Map<String, dynamic>>> getAllUsersWithChatStatus(
    String? searchQuery,
  ) {
    Query userQuery = _db.collection('users');

    if (searchQuery != null && searchQuery.isNotEmpty) {
      userQuery = userQuery.orderBy('fullName').startAt([searchQuery]).endAt([
        searchQuery + '\uf8ff',
      ]);
    }

    return userQuery.snapshots().asyncMap((usersSnapshot) async {
      List<Map<String, dynamic>> results = [];

      for (var userDoc in usersSnapshot.docs) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final userId = userDoc.id;
        final userName = userData['fullName'] ?? userData['name'] ?? 'Unknown';

        final chatDoc = await _db.collection('chats').doc(userId).get();

        final chatData =
            chatDoc.exists ? (chatDoc.data() as Map<String, dynamic>) : {};

        Map<String, dynamic> userWithChat = {
          ...userData,
          'uid': userId,
          'name': userName,
          'hasChat': chatDoc.exists,

          'lastMessage': chatData['lastMessage'],
          'lastSenderId': chatData['lastSenderId'],
          'lastMessageTime': chatData['lastMessageTime'],
          'unreadCount': chatData['unreadCount_admin'] ?? 0,
        };

        results.add(userWithChat);
      }

      results.sort((a, b) {
        int unreadA = a['unreadCount'] ?? 0;
        int unreadB = b['unreadCount'] ?? 0;
        if (unreadA != unreadB) return unreadB.compareTo(unreadA);

        Timestamp? timeA = a['lastMessageTime'];
        Timestamp? timeB = b['lastMessageTime'];
        if (timeA != null && timeB != null) return timeB.compareTo(timeA);
        if (timeA != null) return -1;
        if (timeB != null) return 1;

        return 0;
      });

      return results;
    });
  }

  Future<void> markMessagesAsRead(String userId) async {
    try {
      final chatDocRef = _db.collection('chats').doc(userId);

      await chatDocRef.set({'unreadCount_admin': 0}, SetOptions(merge: true));

      final messagesQuery =
          await chatDocRef
              .collection('messages')
              .where('receiverId', isEqualTo: adminId)
              .where('status', isNotEqualTo: 'seen')
              .get();

      if (messagesQuery.docs.isNotEmpty) {
        final batch = _db.batch();
        for (var doc in messagesQuery.docs) {
          batch.update(doc.reference, {'status': 'seen'});
        }

        await batch.commit();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateMessageStatus({
    required String chatId,
    required String messageId,
    required String newStatus,
  }) async {
    try {
      await _db
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({'status': newStatus});
    } catch (e) {
      print('Error updating message status: $e');
    }
  }

  Future<void> markAllGlobalMessagesAsDelivered() async {
    try {
      final querySnapshot =
          await _db
              .collectionGroup('messages')
              .where('receiverId', isEqualTo: adminId)
              .where('status', isEqualTo: 'sent')
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        final batch = _db.batch();
        for (var doc in querySnapshot.docs) {
          batch.update(doc.reference, {'status': 'delivered'});
        }
        await batch.commit();
      }
    } catch (e) {
      print('Error marking global delivered: $e');
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
      // ignore
    }
  }
}
