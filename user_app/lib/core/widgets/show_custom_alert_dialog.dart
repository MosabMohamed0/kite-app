import 'package:depi_app/core/utils/app_router.dart';
import 'package:flutter/material.dart';

Future<dynamic> showCustomAlertDialog(BuildContext context, String email) {
  return showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          title: const Text('Email Sent'),
          content: Text(
            'A password reset link has been sent to $email. '
            'Check your inbox and follow the link to reset your password.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                AppRouter.router.go(AppRouter.kLogin);
              },
              child: const Text('OK'),
            ),
          ],
        ),
  );
}
