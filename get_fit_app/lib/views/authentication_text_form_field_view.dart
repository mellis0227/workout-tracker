import 'package:flutter/material.dart';

// Custom widget for reusable text input fields (email, password, etc.)
class AuthenticationTextFormField extends StatelessWidget {
  final String label; // Label for the text field
  final TextEditingController
      textEditingController; // Controller for text input
  final String? Function(String?)?
      validator; // Field-specific validator for validation

  const AuthenticationTextFormField({
    required this.label,
    required this.textEditingController,
    this.validator, // Optional validator for the field
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController, // Set the controller for text input
      obscureText: label
          .toLowerCase()
          .contains('password'), // Hide text for password field
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(17)),
          borderSide: BorderSide(color: Colors.red..shade900),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(17)),
          borderSide: BorderSide(color: Color(0xFFEFF6E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(17)),
          borderSide: BorderSide(color: Color(0xFFEFF6E0)), // Enabled color
        ),
        labelText: label, // Display the label for the text field
        labelStyle: TextStyle(color: Color(0xFFEFF6E0)),
      ),
      validator: validator, // Set the validator for this field
    );
  }
}
