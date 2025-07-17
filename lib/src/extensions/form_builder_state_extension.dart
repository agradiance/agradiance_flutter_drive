import 'package:flutter/material.dart' show GlobalKey;
import 'package:flutter_form_builder/flutter_form_builder.dart' show FormBuilderState;

extension GlobalKeyFormBuilderState on GlobalKey<FormBuilderState> {
  dynamic getValueFromFieldName(String name) {
    return currentState?.fields[name]?.value;
  }
}
