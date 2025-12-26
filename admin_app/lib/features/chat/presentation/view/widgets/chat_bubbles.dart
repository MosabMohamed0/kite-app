import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/models/message_model.dart';
import '../../../../../core/theme/app_colors.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const ChatBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('hh:mm a').format(message.timestamp.toDate());
    final size = MediaQuery.sizeOf(context);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: size.height * 0.005,
          horizontal: size.width * 0.03,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.012,
        ),
        constraints: BoxConstraints(maxWidth: size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? AppColors.lightPrimary : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.message,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: size.width * 0.04,
              ),
            ),
            SizedBox(height: size.height * 0.005),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  timeStr,
                  style: TextStyle(
                    color: isMe ? Colors.white70 : Colors.black54,
                    fontSize: size.width * 0.028,
                  ),
                ),
                if (isMe) ...[
                  SizedBox(width: size.width * 0.01),
                  _buildStatusIcon(message.status, size),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(String status, Size size) {
    IconData icon = Icons.done;
    Color color = Colors.white60;

    if (status == 'delivered') icon = Icons.done_all;
    if (status == 'seen') {
      icon = Icons.done_all;
      color = Colors.blueAccent.shade100;
    }

    return Icon(icon, size: size.width * 0.04, color: color);
  }
}
