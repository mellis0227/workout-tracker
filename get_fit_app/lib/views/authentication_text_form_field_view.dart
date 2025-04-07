import 'package:flutter/material.dart';

// Custom widget for reusable text input fields (email, password, etc.)
class AuthenticationTextFormField extends StatelessWidget {
  final String label; // Label for the text field
  final IconData icon; // Icon for the text field
  final TextEditingController
      textEditingController; // Controller for text input
  final String? Function(String?)?
      validator; // Field-specific validator for validation

  const AuthenticationTextFormField({
    required this.label,
    required this.icon,
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
        icon: Icon(icon), // Display the icon for the text field
        labelText: label, // Display the label for the text field
      ),
      validator: validator, // Set the validator for this field
    );
  }
}
