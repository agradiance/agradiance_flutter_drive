import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter;

class CustomTextFormFieldWithDialog extends StatelessWidget {
  CustomTextFormFieldWithDialog({
    super.key,
    required this.child,
    this.title,
    this.titleAlignment = Alignment.center,
    this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.allowEnterIfNotMatched = false,
    this.keyboardType,
    this.onEditingComplete,
    this.onDone,
    this.maxLines,
    this.readOnly,
    this.floatingLabelBehavior,
    this.focusedBorder,
    this.prefixIcon,
    this.value,
    this.onSaved,
    this.enabled = true,
    this.labelColor,
    this.autovalidateMode,
    this.decorationIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.decoration,
    this.canPop = false,
    this.inputFormatters,
  });

  final TextEditingController? controller;
  final Widget child;
  final Widget? title;
  final Alignment titleAlignment;
  final bool canPop;
  final String? labelText;
  final String? hintText;
  final String? Function(String? value)? validator;
  final bool allowEnterIfNotMatched;
  final TextInputType? keyboardType;
  final Function()? onEditingComplete;
  final void Function(String? value)? onDone;
  final int? maxLines;
  final bool? readOnly;
  final bool enabled;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final InputBorder? focusedBorder;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? decorationIcon;
  final String? value;
  final Function(String?)? onSaved;
  final Color? labelColor;
  final AutovalidateMode? autovalidateMode;
  final bool obscureText;
  final InputDecoration? decoration;
  final List<TextInputFormatter>? inputFormatters;

  final ValueNotifier<String?> valueNotifier = ValueNotifier(null);
  final ValueNotifier<int> resetValueNotifier = ValueNotifier(0);

  Future<String?> popupDialog(BuildContext context) async {
    valueNotifier.value = value;
    return await showDialog<String?>(
      context: context,
      builder: (context) {
        return PopScope(
          canPop: canPop,
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Align(alignment: titleAlignment, child: title),
                ],
                ValueListenableBuilder(
                  valueListenable: resetValueNotifier,
                  builder: (context, value, child) {
                    return TextFormField(
                      initialValue: valueNotifier.value,
                      enabled: enabled,

                      inputFormatters: inputFormatters,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: maxLines,
                      readOnly: readOnly ?? false,
                      onEditingComplete: onEditingComplete,
                      onSaved: onSaved,
                      keyboardType: keyboardType,
                      controller: controller,
                      obscureText: obscureText,
                      decoration:
                          decoration ??
                          InputDecoration(
                            icon: decorationIcon, //add
                            enabled: enabled,
                            focusedBorder: focusedBorder,
                            floatingLabelBehavior: floatingLabelBehavior,
                            prefixIcon: prefixIcon,
                            suffixIcon: suffixIcon,
                            labelStyle: const TextStyle().copyWith(
                              color: labelColor,
                            ),
                            border: enabled
                                ? const OutlineInputBorder()
                                : InputBorder.none,
                            labelText: labelText,
                            hintText: hintText,
                            hintStyle: const TextStyle().copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      autovalidateMode:
                          autovalidateMode ?? AutovalidateMode.disabled,
                      validator: validator,
                      onChanged: (value) {
                        valueNotifier.value = value;
                      },
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(value);
                      },
                      child: Text("Cancel"),
                    ),

                    ValueListenableBuilder(
                      valueListenable: valueNotifier,
                      builder: (context, value, child) {
                        return TextButton(
                          onPressed:
                              (allowEnterIfNotMatched) ||
                                  (validator?.call(value) == null)
                              ? () {
                                  Navigator.of(
                                    context,
                                  ).pop(valueNotifier.value);
                                }
                              : null,
                          child: Text("Enter"),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await popupDialog(context);
        onDone?.call(result);
      },
      child: child,
    );
  }
}
