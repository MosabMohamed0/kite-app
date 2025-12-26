import 'package:depi_app/features/chat/presentation/cubits/chat_cubit/chat_cubit.dart';
import 'package:depi_app/features/chat/repositories/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets/chat_bubbles.dart';

class UserChatScreen extends StatefulWidget {
  const UserChatScreen({super.key});

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final _controller = ScrollController();
  final TextEditingController controller = TextEditingController();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    return BlocProvider(
      create:
          (context) =>
              ChatCubit(ChatRepository())
                ..getMessages(currentUserId)
                ..markAsRead()
                ..repository.resetUserUnreadCount(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white24,
                    radius: size.width * 0.05,
                    child: Icon(
                      Iconsax.headphone_copy,
                      color: Colors.white,
                      size: size.width * 0.05,
                    ),
                  ),
                  SizedBox(width: size.width * 0.03),
                  Text(
                    "Customer Support",
                    style: TextStyle(fontSize: size.width * 0.045),
                  ),
                ],
              ),
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
            ),
            body: Column(
              children: [
                Expanded(
                  child: BlocBuilder<ChatCubit, ChatState>(
                    builder: (context, state) {
                      if (state is ChatLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ChatError) {
                        return Center(child: Text("Error: ${state.message}"));
                      } else if (state is ChatLoaded) {
                        final messages = state.messages;

                        if (messages.isEmpty) {
                          return _buildEmptyState(size);
                        }

                        return ListView.builder(
                          reverse: true,
                          controller: _controller,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final msg = messages[index];
                            final isMe = msg.senderId == currentUserId;
                            return ChatBubble(message: msg, isMe: isMe);
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                _buildInputArea(context, size),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(Size size) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.message_question_copy,
            size: size.width * 0.2,
            color: Colors.grey,
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            'How can we help you today?',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: size.width * 0.045,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (data) => _sendMessage(context, data),
              style: TextStyle(fontSize: size.width * 0.04),
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(fontSize: size.width * 0.035),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: size.height * 0.012,
                ),
              ),
            ),
          ),
          SizedBox(width: size.width * 0.02),
          CircleAvatar(
            radius: size.width * 0.06,
            backgroundColor: Theme.of(context).primaryColor,
            child: IconButton(
              icon: Icon(
                Iconsax.send_1_copy,
                color: Colors.white,
                size: size.width * 0.05,
              ),
              onPressed: () => _sendMessage(context, controller.text),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(BuildContext context, String text) {
    if (text.trim().isEmpty) return;
    context.read<ChatCubit>().sendMessage(text.trim());
    controller.clear();
    if (_controller.hasClients) {
      _controller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
