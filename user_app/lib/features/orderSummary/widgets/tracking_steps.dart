import 'package:flutter/material.dart';

Widget buildTrackingStep({required String title, required String date, required bool isActive,required context}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(
          isActive ? Icons.radio_button_checked : Icons.radio_button_unchecked,
          color: isActive ?  Theme.of(context).primaryColor : Colors.grey,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                title,
                style: isActive? Theme.of(context).textTheme.titleSmall:Theme.of(context).textTheme.bodyMedium
            ),
            Text(
              date,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        )
      ],
    ),
  );
}