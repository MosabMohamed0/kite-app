import 'package:flutter/material.dart';

enum FieldType { name, email, password, phone }

class CustomFormTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final FieldType fieldType;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool obscureText;
  final bool isLogin;
  final Color? fillColor;
  final TextEditingController? originalPassword;

  const CustomFormTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.fieldType,
    this.prefixIcon,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    this.isLogin = false,
    this.fillColor,
    this.originalPassword,
  });

  @override
  State<CustomFormTextField> createState() => _CustomFormTextFieldState();
}

class _CustomFormTextFieldState extends State<CustomFormTextField> {
  bool _isPasswordVisible = false;

  TextInputType _getKeyboardType() {
    switch (widget.fieldType) {
      case FieldType.phone:
        return TextInputType.phone;
      case FieldType.email:
        return TextInputType.emailAddress;
      default:
        return TextInputType.text;
    }
  }

  String? _validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }

    switch (widget.fieldType) {
      case FieldType.email:
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
        if (!emailRegex.hasMatch(value)) {
          return 'Enter a valid email address';
        }
        break;

      case FieldType.password:
        if (!widget.isLogin &&
            value.length < 6 &&
            widget.originalPassword == null) {
          return 'Password must be at least 6 characters';
        }
        break;

      case FieldType.name:
        if (value.trim().length < 3) {
          return 'Name must be at least 3 characters';
        }
        break;

      case FieldType.phone:
        if (value.trim().length < 10) {
          return 'Enter a valid phone number';
        }
        break;
    }

    if (widget.fieldType == FieldType.password &&
        widget.originalPassword != null &&
        widget.labelText == 'Confirm Password') {
      if (value != widget.originalPassword!.text) {
        return 'Passwords do not match';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isPasswordField = widget.fieldType == FieldType.password;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: isPasswordField && !_isPasswordVisible,
        keyboardType: _getKeyboardType(),
        validator: _validate,
        onChanged: widget.onChanged,
        maxLines: 1,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon:
              widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: const Color(0xff9ca3af))
                  : null,
          suffixIcon:
              isPasswordField
                  ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xff9ca3af),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                  : null,
          filled: true,
          fillColor: widget.fillColor ?? Theme.of(context).cardColor,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffd1d5db)),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:  BorderSide(
              color: Theme.of(context).scaffoldBackgroundColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
