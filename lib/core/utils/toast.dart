import 'package:earnwise_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

void showErrorToast(String message) {
  showToast(
    message,
    context: navigatorKey.currentContext,
    position: StyledToastPosition.top,
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.red, 
    textStyle: const TextStyle(
      color: Colors.white
    )
  );
}

void showSuccessToast(String message) {
  showToast(
    message, 
    context: navigatorKey.currentContext,
    position: StyledToastPosition.top,
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.green, 
    textStyle: const TextStyle(
      color: Colors.white
    )
  );
}

void showWarningToast(String message) {
  showToast(
    message,
    context: navigatorKey.currentContext,
    position: StyledToastPosition.top,
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.orange,
    textStyle: const TextStyle(
      color: Colors.white,
    ),
  );
}