import 'package:flutter/material.dart';
import 'package:get_fit_app/views/authentication_text_form_field_view.dart';
import 'package:get_fit_app/presenter/authentication_presenter.dart';
import 'authentication_view.dart';

// Screen where the user interacts for login or registration
class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    implements AuthenticationView {
  final _emailController =
      TextEditingController(); // Controller for email input
  final _passwordController =
      TextEditingController(); // Controller for password input
  final _passwordConfirmationController =
      TextEditingController(); // Controller for confirmation

  final _formKey = GlobalKey<FormState>(); // Key to validate the form

  late AuthenticationPresenter _presenter;

  // Getter methods for input values
  @override
  String get email => _emailController.text;
  @override
  String get password => _passwordController.text;
  @override
  String? get passwordConfirmation => _passwordConfirmationController.text;

  bool _register = true; // Whether user is registering or logging in

  @override
  void initState() {
    super.initState();
    _presenter =
        AuthenticationPresenter(this); // Initialize presenter with this view
  }

  // Method to show error messages globally
  @override
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // Method to show success messages
  @override
  void showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  // Update the UI for toggling between register/login modes
  @override
  void updateUIForMode(bool register) {
    setState(() {
      _register = register;
    });
  }

  // Email field validator
  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    final emailRegEx = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegEx.hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  // Password field validator
  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Password confirmation validator (only in register mode)
  String? _passwordConfirmationValidator(String? value) {
    if (_register && value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey, // Associate the form with the key
        child: Column(
          children: [
            const SizedBox(height: 50),
            AuthenticationTextFormField(
              label: 'Email',
              icon: Icons.email,
              textEditingController: _emailController,
              validator: _emailValidator, // Use email validator
            ),
            AuthenticationTextFormField(
              label: 'Password',
              icon: Icons.vpn_key,
              textEditingController: _passwordController,
              validator: _passwordValidator, // Use password validator
            ),
            if (_register) // Only show confirmation in register mode
              AuthenticationTextFormField(
                label: 'Password Confirmation',
                icon: Icons.password,
                textEditingController: _passwordConfirmationController,
                validator:
                    _passwordConfirmationValidator, // Use confirmation validator
              ),
            // Button to trigger login or registration
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _presenter
                      .authenticate(); // Delegate to presenter for authentication
                }
              },
              child: Text(_register ? 'Register' : 'Login'),
            ),
            // Link to toggle between login and register mode
            InkWell(
              onTap: () {
                _presenter
                    .toggleRegisterMode(); // Toggle between login/register
              },
              child: Text(_register ? 'Login instead' : 'Register instead'),
            ),
          ],
        ),
      ),
    );
  }
}
