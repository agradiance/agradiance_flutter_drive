// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

final AppToastificationAlias = toastification;

class AppToastification {
  static ToastificationItem success({
    required String message,
    String? title,
    ToastificationStyle? style = ToastificationStyle.flat,
    Duration? autoCloseDuration,
    final ValueChanged<ToastificationItem>? onTap,
    final ValueChanged<ToastificationItem>? onAutoCompleteCompleted,
    final ValueChanged<ToastificationItem>? onDismissed,
    final ValueChanged<ToastificationItem>? onCloseButtonTap,
  }) {
    return AppToastificationAlias.show(
      type: ToastificationType.success,
      style: style,
      autoCloseDuration: autoCloseDuration ?? const Duration(seconds: 3),
      title: title != null ? Text(title) : null,
      description: Text(message),
      callbacks: ToastificationCallbacks(
        onTap: onTap,
        onAutoCompleteCompleted: onAutoCompleteCompleted,
        onCloseButtonTap: onCloseButtonTap,
        onDismissed: onDismissed,
      ),
    );
  }

  static ToastificationItem error({
    required String message,
    String? title,
    ToastificationStyle? style = ToastificationStyle.flat,
    Duration? autoCloseDuration,
    final ValueChanged<ToastificationItem>? onTap,
    final ValueChanged<ToastificationItem>? onAutoCompleteCompleted,
    final ValueChanged<ToastificationItem>? onDismissed,
    final ValueChanged<ToastificationItem>? onCloseButtonTap,
  }) {
    return AppToastificationAlias.show(
      type: ToastificationType.error,
      style: style,
      autoCloseDuration: autoCloseDuration ?? const Duration(seconds: 3),
      title: title != null ? Text(title) : null,
      description: Text(message),
      callbacks: ToastificationCallbacks(
        onTap: onTap,
        onAutoCompleteCompleted: onAutoCompleteCompleted,
        onCloseButtonTap: onCloseButtonTap,
        onDismissed: onDismissed,
      ),
    );
  }

  static ToastificationItem showInfo({
    required String message,
    String? title,
    ToastificationStyle? style = ToastificationStyle.flat,
    Duration? autoCloseDuration,
    final ValueChanged<ToastificationItem>? onTap,
    final ValueChanged<ToastificationItem>? onAutoCompleteCompleted,
    final ValueChanged<ToastificationItem>? onDismissed,
    final ValueChanged<ToastificationItem>? onCloseButtonTap,
  }) {
    return AppToastificationAlias.show(
      type: ToastificationType.info,
      style: style,
      autoCloseDuration: autoCloseDuration ?? const Duration(seconds: 3),
      title: title != null ? Text(title) : null,
      description: Text(message),
      callbacks: ToastificationCallbacks(
        onTap: onTap,
        onAutoCompleteCompleted: onAutoCompleteCompleted,
        onCloseButtonTap: onCloseButtonTap,
        onDismissed: onDismissed,
      ),
    );
  }
}
