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
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Key to validate the form

  late AuthenticationPresenter _presenter;

  // Getter methods for input values
  @override
  String get email => _emailController.text;
  @override
  String get password => _passwordController.text;
  @override
  String? get passwordConfirmation => _passwordConfirmationController.text;
  @override
  String get firstName => _firstNameController.text;
  @override
  String get lastName => _lastNameController.text;

  bool _register = false; // Whether user is registering or logging in
  double registerToLoginPadding = 0;
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
      return 'Enter an email';
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
      return 'Enter a password';
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

  String? _firstAndLastNameValidator(String? value) {
    if (_register && _firstNameController.text.isEmpty) {
      return "Enter first name";
    } else if (_register && _firstNameController.text.isEmpty) {
      return "Enter last name";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFEFF6E0),
      body: Form(
        key: _formKey, // Associate the form with the key
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(50)),
            Text(
              "Get Fit",
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Padding(padding: EdgeInsets.all(40)),
            Center(
              child: Container(
                height: _register ? 500 : 340,
                width: 380,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF124559),
                      spreadRadius: 10,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xFF598392),
                ),
                child: _buildLoginComponents(context),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            _registerOrLoginButton(context),
            _switchLoginOrRegister()
          ],
        ),
      ),
    );
  }

  Container _buildLoginComponents(BuildContext context) {
    return Container(
      width: 350,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(20)),
          Text(
            _register ? "SIGN UP" : "LOGIN",
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.w900,
              color: Color(0xFFEFF6E0),
            ),
          ),
          Padding(padding: EdgeInsets.all(10)),
          if (_register)
            Row(
              children: [
                Flexible(
                  child: AuthenticationTextFormField(
                    label: "First Name",
                    textEditingController: _firstNameController,
                    validator: _firstAndLastNameValidator,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Flexible(
                  child: AuthenticationTextFormField(
                    label: "Last Name",
                    textEditingController: _lastNameController,
                    validator: _firstAndLastNameValidator,
                  ),
                )
              ],
            ),
          Padding(
            padding: EdgeInsets.all(10),
          ),
          AuthenticationTextFormField(
            label: 'Email',
            textEditingController: _emailController,
            validator: _emailValidator, // Use email validator
          ),
          Padding(
            padding: EdgeInsets.all(10),
          ),
          AuthenticationTextFormField(
            label: 'Password',
            textEditingController: _passwordController,
            validator: _passwordValidator, // Use password validator
          ),
          Padding(
            padding: EdgeInsets.all(10),
          ),
          if (_register) // Only show confirmation in register mode
            AuthenticationTextFormField(
              label: 'Confirm Password',
              textEditingController: _passwordConfirmationController,
              validator:
                  _passwordConfirmationValidator, // Use confirmation validator
            ),
        ],
      ),
    );
  }

  InkWell _switchLoginOrRegister() {
    return InkWell(
      focusColor: Color(0xFFDFFDFF),
      onTap: () {
        _presenter.toggleRegisterMode(); // Toggle between login/register
      },
      child: Text(
        _register ? 'Login instead' : 'Register instead',
        style: TextStyle(
            color: Color(0xFF598392),
            fontSize: 14,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline),
      ),
    );
  }

  ElevatedButton _registerOrLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          _presenter.authenticate(
              context); // Delegate to presenter for authentication
        }
      },
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Color(0xFF50C4A1)),
          fixedSize: WidgetStateProperty.all(Size(101, 30))),
      child: Text(
        _register ? 'Register' : 'Login',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
