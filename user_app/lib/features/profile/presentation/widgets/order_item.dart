import 'package:flutter/material.dart';

Widget buildOrderItem({
  required String id,
  required String date,
  required String price,
  required String status,
  required Color color,
  required context,
}) {
  final size = MediaQuery.of(context).size;
  final screenWidth = size.width;
  final screenHeight = size.height;
  return Column(
    children: [
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text('#$id', style: Theme.of(context).textTheme.labelSmall),
        subtitle: Text(date, style: Theme.of(context).textTheme.bodySmall),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.01,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 5),
            Text(price, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    ],
  );
}
