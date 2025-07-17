import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter;
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.name,
    this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.onEditingComplete,
    this.onChanged,
    this.onValidChanged,
    this.onFocusNodeChanged,
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
    this.suffixIcon,
    this.prefix,
    this.prefixIconConstraints,
    this.borderRadius = const BorderRadius.all(Radius.circular(20.0)),
    this.obscureText = false,
    this.decoration,
    this.inputFormatters,
    this.minWidth = 0.0,
    this.maxWidth = double.infinity,
    this.minHeight = 0.0,
    this.maxHeight = double.infinity,
    this.contentPadding,
    this.showPasswordVisibleIcon = false,
  });

  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;

  final bool showPasswordVisibleIcon;

  final TextEditingController? controller;
  final String name;
  final String? labelText;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Function()? onEditingComplete;
  final void Function(String? value)? onChanged;
  final void Function(String? value)? onValidChanged;
  final void Function(bool focused, String? value)? onFocusNodeChanged;
  final int? maxLines;
  final bool? readOnly;
  final bool enabled;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final InputBorder? focusedBorder;
  final Widget? prefixIcon;
  final Widget? prefix;
  final BoxConstraints? prefixIconConstraints;
  final Widget? suffixIcon;
  final BorderRadius borderRadius;
  final Widget? decorationIcon;
  final String? initialValue;
  final Function(String?)? onSaved;
  final Color? labelColor;
  final AutovalidateMode? autovalidateMode;
  final bool obscureText;
  final InputDecoration? decoration;
  final EdgeInsetsGeometry? contentPadding;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final _focusNode = FocusNode();
  String? _currentText;
  late bool obscureText;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;

    _focusNode.addListener(() {
      widget.onFocusNodeChanged?.call(_focusNode.hasFocus, _currentText);
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
    return Container(
      constraints: BoxConstraints(
        maxHeight: widget.maxHeight,
        maxWidth: widget.maxWidth,
        minHeight: widget.minHeight,
        minWidth: widget.minWidth,
      ),
      padding: const EdgeInsets.all(6.0),
      child: FormBuilderTextField(
        name: widget.name,
        focusNode: _focusNode,
        initialValue: widget.initialValue,
        enabled: widget.enabled,
        textCapitalization: TextCapitalization.sentences,
        maxLines: widget.maxLines,
        readOnly: widget.readOnly ?? false,
        onEditingComplete: widget.onEditingComplete,
        onSaved: widget.onSaved,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        // cursorColor: Colors.grey,
        controller: widget.controller,
        obscureText: obscureText,

        decoration:
            widget.decoration ??
            InputDecoration(
              icon: widget.decorationIcon, //add
              // focusColor: Colors.transparent,
              contentPadding: widget.contentPadding ?? EdgeInsets.only(left: 10, right: 5),
              enabled: widget.enabled,
              focusedBorder: widget.focusedBorder,
              floatingLabelBehavior: widget.floatingLabelBehavior,
              prefixIcon: widget.prefixIcon,
              prefix: widget.prefix,
              prefixIconConstraints: widget.prefixIconConstraints ?? BoxConstraints.tightFor(),
              suffixIcon: widget.suffixIcon ?? GestureDetector(onTap: toggleObscureText, child: getIcons()),
              labelStyle: const TextStyle().copyWith(color: widget.labelColor),
              border: widget.enabled ? OutlineInputBorder(borderRadius: widget.borderRadius) : InputBorder.none,
              labelText: widget.labelText,
              hintText: widget.hintText,
              hintStyle: const TextStyle().copyWith(
                // color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
        autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.disabled,
        validator: widget.validator,
        onChanged: (value) {
          if (widget.validator?.call(value) == null) {
            widget.onValidChanged?.call(value);
          }
          widget.onChanged?.call(value);
          _currentText = value;
        },
      ),
    );
  }
}
