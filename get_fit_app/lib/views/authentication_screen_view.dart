import 'package:flutter/material.dart';
import 'package:get_fit_app/views/authentication_text_form_field_view.dart';
import 'package:get_fit_app/presenter/authentication_presenter.dart';
import 'package:go_router/go_router.dart';
import 'authentication_view.dart';

// The screen where the user interacts for login or registration.
class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> implements AuthenticationView {
  final _emailController = TextEditingController();  // Controller for the email input field.
  final _passwordController = TextEditingController();  // Controller for the password input field.
  final _passwordConfirmationController = TextEditingController();  // Controller for password confirmation.

  late AuthenticationPresenter _presenter;  // Instance of the presenter to handle business logic.

  // Getter methods to access the text from controllers.
  String get email => _emailController.text;
  String get password => _passwordController.text;
  String? get passwordConfirmation => _passwordConfirmationController.text;

  bool _register = true;  // Track if the user is in register mode.

  @override
  void initState() {
    super.initState();
    _presenter = AuthenticationPresenter(this);  // Initialize the presenter with the view.
  }

  // Method to show error messages (e.g., validation errors, authentication errors).
  @override
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  // Method to show success messages (e.g., successful login or registration).
  @override
  void showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
  }

  // Method to update the UI when switching between login and registration modes.
  @override
  void updateUIForMode(bool register) {
    setState(() {
      _register = register;
    });
  }

  // Method to build the UI of the screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Column(
          children: [
            const SizedBox(height: 50),
            AuthenticationTextFormField(
              label: 'Email',  // Label for email field
              icon: Icons.email,  // Icon for email field
              textEditingController: _emailController,  // Controller for email field
            ),
            AuthenticationTextFormField(
              label: 'Password',  // Label for password field
              icon: Icons.vpn_key,  // Icon for password field
              textEditingController: _passwordController,  // Controller for password field
            ),
            // Password confirmation field only shown when in registration mode.
            if (_register)
              AuthenticationTextFormField(
                label: 'Password Confirmation',  // Label for password confirmation
                icon: Icons.password,  // Icon for password confirmation field
                textEditingController: _passwordConfirmationController,  // Controller for password confirmation
              ),
            // Button to trigger login or registration
            ElevatedButton(
              onPressed: () {
                _presenter.authenticate();
                context.go('/home');
                },
              child: Text(_register ? 'Register' : 'Login'),  // Button text based on mode
            ),
            // Link to toggle between login and register mode
            InkWell(
              onTap: () {
                _presenter.toggleRegisterMode();  // Toggle between register/login mode
              },
              child: Text(_register ? 'Login instead' : 'Register instead'),  // Text changes based on mode
            ),
          ],
        ),
      ),
    );
  }
}


