import 'package:flutter/material.dart';

// A custom StatelessWidget for reusable text input fields, typically for authentication forms.
class AuthenticationTextFormField extends StatelessWidget {
  // Constructor to pass the required parameters: icon, label, and controller.
  const AuthenticationTextFormField({
    required this.icon, // Icon for the input field (e.g., email, password).
    required this.label, // Label to display on top of the input field.
    required this.textEditingController, // Controller to manage the input field's text.
    super.key, // Optional key for widget identification.
  });

  // Properties to hold the icon, label, and controller.
  final IconData icon;
  final String label;
  final TextEditingController textEditingController;

  // Build method to construct the UI of the widget.
  @override
  Widget build(BuildContext context) {
    // Retrieve the current theme to use in the widget.
    final theme = Theme.of(context);

    return TextFormField(
      controller: textEditingController, // Assign the controller to the TextFormField.
      obscureText: label.toLowerCase().contains('password'), // If the label contains 'password', obscure the text input.
      decoration: InputDecoration(
        // Styling the label when it's floating above the field.
        floatingLabelStyle: theme.textTheme.titleLarge,

        // Display the icon inside the input field, with primary color from the theme.
        icon: Icon(icon, color: theme.colorScheme.primary),

        // The label text that shows inside the input field.
        labelText: label,
      ),
    );
  }
}
