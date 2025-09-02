import 'package:flutter/material.dart';

class Navigation {
  // Basic navigation methods
  static void push(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  static void pushReplacement(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  static void pushNamed(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  static void pop(BuildContext context, {dynamic result}) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context, result);
    }
  }

  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(
      context,
      ModalRoute.withName(routeName),
    );
  }

  static Future<bool> maybePop(BuildContext context, {dynamic result}) async {
    return await Navigator.maybePop(context, result);
  }

  // SnackBar utility
  static void showSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
    Color? backgroundColor,
    Color? textColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textColor != null ? TextStyle(color: textColor) : null,
        ),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(8),
      ),
    );
  }

  // Custom dialog utility (renamed to avoid conflict with Flutter's showDialog)
  static void showCustomDialog({
    required BuildContext context,
    required String title,
    required String content,
    required List<Widget> actions,
    bool barrierDismissible = true,
    Color? backgroundColor,
    double? elevation,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: actions,
          backgroundColor: backgroundColor,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  // Confirmation dialog utility
  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color confirmColor = Colors.red,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(cancelText),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(
                foregroundColor: confirmColor,
              ),
              child: Text(confirmText),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );

    return result ?? false;
  }

  // Bottom sheet utility
  static Future<T?> showCustomBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = false,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: child,
        );
      },
    );
  }

  // Loading dialog utility
  static void showLoadingDialog({
    required BuildContext context,
    String message = 'Loading...',
    bool barrierDismissible = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                Text(message),
              ],
            ),
          ),
        );
      },
    );
  }

  // Error dialog utility
  static void showErrorDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    showCustomDialog(
      context: context,
      title: title,
      content: message,
      actions: [
        TextButton(
          onPressed: () => pop(context),
          child: Text(buttonText),
        ),
      ],
    );
  }

  // Success dialog utility
  static void showSuccessDialog({
    required BuildContext context,
    required String message,
    String title = 'Success',
    String buttonText = 'OK',
  }) {
    showCustomDialog(
      context: context,
      title: title,
      content: message,
      actions: [
        TextButton(
          onPressed: () => pop(context),
          child: Text(buttonText),
        ),
      ],
    );
  }

  // Check if can pop
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  // Get current route name
  static String? getCurrentRouteName(BuildContext context) {
    return ModalRoute.of(context)?.settings.name;
  }
}
