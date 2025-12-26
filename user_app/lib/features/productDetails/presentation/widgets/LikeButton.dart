import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final int likeCount;
  final String reviewId;
  final Function(String reviewId)? onLikePressed;

  const LikeButton({
    super.key,
    required this.likeCount,
    required this.reviewId,
    this.onLikePressed,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late bool isLiked;
  late int currentLikes;

  @override
  void initState() {
    super.initState();
    isLiked = false;
    currentLikes = widget.likeCount;
  }

  void _toggleLike() {
    setState(() {
      if (isLiked) {
        currentLikes--;
        isLiked = false;
      } else {
        currentLikes++;
        isLiked = true;
      }
    });

    if (widget.onLikePressed != null) {
      widget.onLikePressed!(widget.reviewId);
    }
  }

  @override
  Widget build(BuildContext context) {
    late final theme=Theme.of(context);
    return InkWell(
      onTap: _toggleLike,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:
              isLiked ? theme.primaryColor.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isLiked ? theme.primaryColor : Colors.grey[300]!,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
              size: 16,
              color: isLiked ? theme.primaryColor : Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              currentLikes.toString(),
              style: TextStyle(
                color: isLiked ? theme.primaryColor : Colors.grey,
                fontSize: 12,
                fontWeight: isLiked ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
