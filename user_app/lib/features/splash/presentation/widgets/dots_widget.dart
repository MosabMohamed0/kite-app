import 'dart:math';
import 'package:flutter/material.dart';

class DotsWidget extends StatelessWidget {
  const DotsWidget({super.key, required this.controller});
  final AnimationController controller;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final scale =
                1 + 0.3 * sin((controller.value * 2 * pi) + (index * 0.7));
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
