import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String labelText;
  final String? hintText;
  final bool isObscureText;

  const AuthField({
    super.key,
    required this.labelText,
    required this.controller,
    this.validator,
    this.hintText,
    this.isObscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: isObscureText,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        labelText: labelText,
        hintText: hintText,
      ),
    );
  }
}
