import 'dart:async';
import 'package:admin_app/features/chat/data/repositories/chat_repository.dart';
import 'package:admin_app/features/chat/domain/models/message_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _repository;
  StreamSubscription? _messagesSubscription;

  ChatCubit(this._repository) : super(ChatInitial());

  void getMessages(String userId) {
    emit(ChatLoading());
    _messagesSubscription?.cancel();

    final chatId = userId;

    _messagesSubscription = _repository
        .getMessages(userId)
        .listen(
          (messages) {
            for (var msg in messages) {
              final amIReceiver = msg.receiverId == 'admin';

              if (amIReceiver && msg.status != 'seen') {
                _repository.markMessageAsSeen(chatId, msg.messageId);

                _repository.markMessagesAsRead(chatId);
              }
            }

            emit(ChatLoaded(messages));
          },
          onError: (e) {
            emit(ChatError(e.toString()));
          },
        );
  }

  Future<void> sendMessage({
    required String userId,
    required String message,
    required bool isAdmin,
  }) async {
    if (message.trim().isEmpty) return;

    try {
      await _repository.sendMessage(
        senderId: isAdmin ? ChatRepository.adminId : userId,
        receiverId: isAdmin ? userId : ChatRepository.adminId,
        message: message,
        isAdmin: isAdmin,
      );
    } catch (e) {
      emit(ChatError("Failed to send message: $e"));
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }

  Future<void> markMessagesAsRead(String userId) async {
    try {
      await _repository.markMessagesAsRead(userId);
    } catch (e) {
      emit(ChatError("Failed to mark messages as read: $e"));
    }
  }
}
