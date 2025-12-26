import 'dart:async';
import 'package:admin_app/features/chat/data/repositories/chat_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 1. إضافة
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'admin_chat_state.dart';

class AdminChatCubit extends Cubit<AdminChatState> {
  final ChatRepository _repository;
  StreamSubscription? _usersSubscription;
  StreamSubscription? _chatsTriggerSubscription;
  StreamSubscription? _deliverySubscription;

  AdminChatCubit(this._repository) : super(AdminChatInitial());

  void getUsers({String? query}) {
    emit(AdminChatLoading());

    _startGlobalDeliveryListener();
    _setupRealtimeListener(query);
  }

  void _startGlobalDeliveryListener() {
    _deliverySubscription?.cancel();

    _deliverySubscription = FirebaseFirestore.instance
        .collectionGroup('messages')
        .where('receiverId', isEqualTo: 'admin')
        .where('status', isEqualTo: 'sent')
        .snapshots()
        .listen((snapshot) {
          for (var doc in snapshot.docs) {
            doc.reference.update({'status': 'delivered'});
          }
        });
  }

  void _setupRealtimeListener(String? query) {
    _usersSubscription?.cancel();
    _chatsTriggerSubscription?.cancel();

    _chatsTriggerSubscription = FirebaseFirestore.instance
        .collection('chats')
        .snapshots()
        .listen((_) {
          _fetchUsers(query);
        });

    _fetchUsers(query);
  }

  void _fetchUsers(String? query) {
    _usersSubscription?.cancel();
    _usersSubscription = _repository
        .getAllUsersWithChatStatus(query)
        .listen(
          (users) {
            if (!isClosed) emit(AdminChatLoaded(users));
          },
          onError: (e) {
            if (!isClosed) emit(AdminChatError(e.toString()));
          },
        );
  }

  @override
  Future<void> close() {
    _usersSubscription?.cancel();
    _chatsTriggerSubscription?.cancel();
    _deliverySubscription?.cancel();
    return super.close();
  }
}
