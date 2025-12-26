import 'package:flutter/material.dart';

Widget buildStatCard(
  BuildContext context,
  String number,
  String label,
  VoidCallback? onTap,
) {
  final theme = Theme.of(context);
  final size = MediaQuery.of(context).size;
  final screenWidth = size.width;
  final screenHeight = size.height;
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Card(
        color: theme.cardColor,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.017),
          child: Column(
            children: [
              Text(
                number,
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  color: Color(0xFF80AF81),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(label, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    ),
  );
}
