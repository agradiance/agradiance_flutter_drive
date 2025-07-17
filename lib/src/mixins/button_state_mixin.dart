// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:agradiance_flutter_drive/src/logs/debub_print.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

extension StringExtension on String {
  ButtonItem? getButtonItemByStringId(Map<String, ButtonItem> items) {
    return items[this];
  }
}

mixin ButtonStateMixin<T extends StatefulWidget> on State<T> {
  final ValueNotifier<Map<String, ButtonItem>> _buttonItemsNotifier = ValueNotifier({});

  Map<String, ButtonItem> get buttonItems => _buttonItemsNotifier.value;
  ValueNotifier<Map<String, ButtonItem>> get buttonItemsNotifier => _buttonItemsNotifier;

  static const String sharedId = "all";

  ButtonItem button([String id = sharedId]) {
    final buttonItem = buttonItems[id];
    if (buttonItem != null) {
      return buttonItem;
    } else {
      final newButton = ButtonItem(id: id, state: ButtonState.active);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          addButton(newButton);
        });
      });

      return newButton;
    }
  }

  // ButtonItem? getButtonItem(String id) {
  //   return context.getButtonItem(id, _buttonItems);
  // }

  void addButton(ButtonItem button) {
    _buttonItemsNotifier.value[button.id] = button;
  }

  void removeButton(ButtonItem button) {
    _buttonItemsNotifier.value.remove(button.id);
  }

  void updateButton(String id, ButtonState state) {
    try {
      if (mounted) {
        setState(() {
          (_buttonItemsNotifier.value[id] ??= ButtonItem(id: id, state: ButtonState.active)).updateState(state);
        });
      }
    } on Exception catch (e) {
      dprint(e);
    }

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (mounted) {
    //     setState(() {
    //       (_buttonItemsNotifier.value[id] ??= ButtonItem(id: id, state: ButtonState.active)).updateState(state);
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    _buttonItemsNotifier.dispose();
    super.dispose();
  }

  Future<R?> call<R>(
    Future<R> Function() action, {
    String id = sharedId,
    ButtonState start = ButtonState.running,
    ButtonState end = ButtonState.active,
    ButtonState onError = ButtonState.error,
  }) {
    return runButton<R>(action, id: id, start: start, end: end, onError: onError);
  }

  Future<R?> runButton<R>(
    Future<R> Function() action, {
    String id = sharedId,
    ButtonState start = ButtonState.running,
    ButtonState end = ButtonState.active,
    ButtonState onError = ButtonState.error,
    bool allowMultiple = false,
  }) async {
    if (!allowMultiple && (buttonItems[id]?.isRunning ?? false)) {
      return null;
    }

    updateButton(id, start);

    try {
      final result = await action();
      updateButton(id, end);
      return result;
    } catch (e) {
      updateButton(id, onError);
      rethrow;
    }
  }
}

enum ButtonState {
  active(key: "active", text: "Active"),
  error(key: "error", text: "Error"),
  success(key: "success", text: "Success"),
  running(key: "running", text: "Running");

  const ButtonState({required this.key, required this.text});
  final String key;
  final String text;

  factory ButtonState.fromKey({required String key}) {
    return ButtonState.values.firstWhereOrNull((element) => element.key == key.toLowerCase()) ?? ButtonState.active;
  }
}

class ButtonItem {
  final String id;
  ButtonState state;
  ButtonItem({required this.id, required this.state});

  void updateState(ButtonState state) {
    this.state = state;
  }

  // Future<R?> runButton<R>(
  //   Future<R> Function() action, {
  //   ButtonState start = ButtonState.loading,
  //   ButtonState end = ButtonState.active,
  //   ButtonState onError = ButtonState.error,
  //   bool allowMultiple = false,
  //   void Function(String id, ButtonState state)? onUpdate,
  // }) async {
  //   if (!allowMultiple && (isLoading)) {
  //     return null;
  //   }

  //   updateButton(id, start);

  //   try {
  //     final result = await action();
  //     updateButton(id, end);
  //     return result;
  //   } catch (e) {
  //     updateButton(id, onError);
  //     rethrow;
  //   }
  // }

  bool get isRunning => state == ButtonState.running;
  bool get isIdle => state == ButtonState.active;
  bool get isError => state == ButtonState.error;
  bool get isSuccess => state == ButtonState.success;

  ButtonItem copyWith({String? id, ButtonState? state}) {
    return ButtonItem(id: id ?? this.id, state: state ?? this.state);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'state': state.key};
  }

  factory ButtonItem.fromMap(Map<String, dynamic> map) {
    return ButtonItem(
      id: map['id'] as String,
      state: ButtonState.fromKey(key: map['state']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ButtonItem.fromJson(String source) => ButtonItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ButtonItem(id: $id, state: $state)';

  @override
  bool operator ==(covariant ButtonItem other) {
    if (identical(this, other)) return true;

    return other.id == id && other.state == state;
  }

  @override
  int get hashCode => id.hashCode ^ state.hashCode;
}
