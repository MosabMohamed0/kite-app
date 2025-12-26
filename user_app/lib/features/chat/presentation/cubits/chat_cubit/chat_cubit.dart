import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:depi_app/features/chat/models/message_model.dart';
import 'package:depi_app/features/chat/repositories/chat_repository.dart';
import 'package:equatable/equatable.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;
  StreamSubscription? _messagesSubscription;

  ChatCubit(this.repository) : super(ChatInitial());

  void getMessages(String userId) {
    emit(ChatLoading());
    _messagesSubscription?.cancel();

    final chatId = userId;

    _messagesSubscription = repository.getMessages().listen(
      (messages) {
        repository.resetUserUnreadCount();

        for (var msg in messages) {
          final amIReceiver = msg.receiverId == userId;

          if (amIReceiver && msg.status != 'seen') {
            repository.markMessageAsSeen(chatId, msg.messageId);
          }
        }

        emit(ChatLoaded(messages));
      },
      onError: (e) {
        emit(ChatError(e.toString()));
      },
    );
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;
    try {
      await repository.sendMessage(message: message);
    } catch (e) {
      emit(ChatError("Failed to send: $e"));
    }
  }

  Future<void> markAsRead() async {
    try {
      await repository.markAdminMessagesAsRead();
    } catch (e) {
      //
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
