import 'package:flutter/material.dart';

// A custom StatelessWidget for reusable text input fields, typically for authentication forms.
class AuthenticationTextFormField extends StatelessWidget {
  // Constructor to pass the required parameters: icon, label, and controller.
  const AuthenticationTextFormField({
    this.confirmationController,
    required this.icon, // Icon for the input field (e.g., email, password).
    required this.label, // Label to display on top of the input field.
    required this.textEditingController, // Controller to manage the input field's text.
    super.key, // Optional key for widget identification.
  });

  // Properties to hold the icon, label, and controller.
  final TextEditingController? confirmationController;
  final IconData icon;
  final String label;
  final TextEditingController textEditingController;

  // Method to validate the input field's value.
  String? _validate(String? value) {
    if (value!.isEmpty) {
      return 'This field cannot be empty.'; // Error message when the field is empty.
    }

    // Check if the label is 'email' and validate the email format.
    if (key.toString().contains('email') == true &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value) == false) {
      return 'This is not a valid email address.'; // Error message for invalid email.
    }

    // Check if the label is 'password' and ensure password length is at least 6 characters.
    if (key.toString().contains('password') == true && value.length < 6) {
      return 'The password must be at least 6 characters.'; // Error message for short password.
    }

    // Check if the label is 'password_confirmation' and validate if the passwords match.
    if (key.toString().contains('password_confirmation') == true &&
        value != confirmationController?.text) {
      return 'The password does not match.'; // Error message if passwords do not match.
    }

    return null; // Return null if the input is valid.
  }

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
      validator: _validate, // Set the custom validator for the text field.
    );
  }
}

