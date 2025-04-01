import 'package:flutter/material.dart';

// Custom widget for reusable text input fields (email, password, etc.).
class AuthenticationTextFormField extends StatelessWidget {
  final String label;  // Label for the text field (e.g., email, password)
  final IconData icon;  // Icon for the text field (e.g., email icon)
  final TextEditingController textEditingController;  // Controller to manage the input value

  const AuthenticationTextFormField({
    required this.label,
    required this.icon,
    required this.textEditingController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,  // Set the controller for text field
      obscureText: label.toLowerCase().contains('password'),  // Hide text for password field
      decoration: InputDecoration(
        icon: Icon(icon),  // Display the field's icon
        labelText: label,  // Set the field's label
      ),
    );
  }
}


