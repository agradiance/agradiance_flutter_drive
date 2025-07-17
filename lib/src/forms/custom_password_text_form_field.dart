import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomPasswordFormField extends StatefulWidget {
  const CustomPasswordFormField({
    super.key,
    required this.name,
    this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.onEditingComplete,
    this.onChanged,
    this.maxLines,
    this.readOnly,
    this.floatingLabelBehavior,
    this.focusedBorder,
    this.prefixIcon,
    this.initialValue,
    this.onSaved,
    this.enabled = true,
    this.labelColor,
    this.autovalidateMode,
    this.decorationIcon,
    this.obscureText = false,
    this.decoration,
    this.showPasswordVisibleIcon = true,
  });

  final TextEditingController? controller;
  final String name;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Function()? onEditingComplete;
  final void Function(String?)? onChanged;
  final int? maxLines;
  final bool? readOnly;
  final bool showPasswordVisibleIcon;
  final bool enabled;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final InputBorder? focusedBorder;
  final Widget? prefixIcon;

  final Widget? decorationIcon;
  final String? initialValue;
  final Function(String?)? onSaved;
  final Color? labelColor;
  final AutovalidateMode? autovalidateMode;
  final bool obscureText;
  final InputDecoration? decoration;

  @override
  State<CustomPasswordFormField> createState() => _CustomPasswordFormFieldState();
}

class _CustomPasswordFormFieldState extends State<CustomPasswordFormField> {
  late bool obscureText;
  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;
  }

  void toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  Widget? getIcons() {
    if (widget.showPasswordVisibleIcon) {
      return Icon(obscureText ? Icons.visibility : Icons.visibility_off);
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: FormBuilderTextField(
        name: widget.name,
        initialValue: widget.initialValue,
        enabled: widget.enabled,
        textCapitalization: TextCapitalization.sentences,
        maxLines: widget.maxLines,
        readOnly: widget.readOnly ?? false,
        onEditingComplete: widget.onEditingComplete,
        onSaved: widget.onSaved,
        keyboardType: widget.keyboardType,
        // cursorColor: Colors.grey,
        controller: widget.controller,
        obscureText: obscureText,

        decoration: widget.decoration ??
            InputDecoration(
              icon: widget.decorationIcon, //add
              // focusColor: Colors.transparent,
              enabled: widget.enabled,
              focusedBorder: widget.focusedBorder,
              floatingLabelBehavior: widget.floatingLabelBehavior,
              prefixIcon: widget.prefixIcon,
              suffixIcon: GestureDetector(
                onTap: toggleObscureText,
                child: getIcons(),
              ),
              labelStyle: const TextStyle().copyWith(color: widget.labelColor),
              border: widget.enabled ? const OutlineInputBorder() : InputBorder.none,
              labelText: widget.labelText,
              hintText: widget.hintText,
              hintStyle: const TextStyle().copyWith(
                // color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
        autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.disabled,
        validator: widget.validator,
        onChanged: widget.onChanged,
      ),
    );
  }
}
