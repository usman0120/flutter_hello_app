import 'package:flutter/material.dart';
import 'package:tasknest/utils/helpers.dart';

class ErrorHandler {
  static void handleError(BuildContext context, dynamic error,
      {String? contextMessage}) {
    final String errorMessage;

    if (error is String) {
      errorMessage = error;
    } else if (error is FormatException) {
      errorMessage = 'Data format error: ${error.message}';
    } else if (error is Exception) {
      errorMessage = 'An unexpected error occurred: ${error.toString()}';
    } else {
      errorMessage = 'An unknown error occurred';
    }

    final fullMessage = contextMessage != null
        ? '$contextMessage: $errorMessage'
        : errorMessage;

    // Show error to user
    Helpers.showSnackBar(context, fullMessage, isError: true);

    // Also log the error for debugging
    debugPrint('Error: $fullMessage');
    debugPrint(
        'Stack trace: ${error is Error ? error.stackTrace : 'No stack trace available'}');
  }

  static Future<T> runWithErrorHandling<T>(
    BuildContext context,
    Future<T> Function() operation, {
    String? errorContext,
    T? defaultValue,
  }) async {
    try {
      return await operation();
    } catch (error) {
      handleError(context, error, contextMessage: errorContext);
      return defaultValue as T;
    }
  }

  static void showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(buttonText ?? 'OK'),
          ),
        ],
      ),
    );
  }
}
