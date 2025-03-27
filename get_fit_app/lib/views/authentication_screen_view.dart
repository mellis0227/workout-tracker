import 'package:flutter/material.dart';
import 'package:get_fit_app/views/authentication_text_form_field_view.dart';
import 'package:get_fit_app/presenter/authentication_presenter.dart';
import 'authentication_view.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> implements AuthenticationView {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  late AuthenticationPresenter _presenter;
  bool _register = true;
  String get email => _emailController.text;
  String get password => _passwordController.text;
  String? get passwordConfirmation => _passwordConfirmationController.text;

  @override
  void initState() {
    super.initState();
    _presenter = AuthenticationPresenter(this);
  }

  // Display error messages in the UI
  @override
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  // Display success messages in the UI
  @override
  void showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
  }

  // Update the UI based on the register/login mode
  @override
  void updateUIForMode(bool register) {
    setState(() {
      _register = register;
    });
  }

  // Build the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Column(
          children: [
            const SizedBox(height: 50),
            AuthenticationTextFormField(
              label: 'Email',
              icon: Icons.email,
              textEditingController: _emailController,
            ),
            AuthenticationTextFormField(
              label: 'Password',
              icon: Icons.vpn_key,
              textEditingController: _passwordController,
            ),
            if (_register)
              AuthenticationTextFormField(
                label: 'Password Confirmation',
                icon: Icons.password,
                textEditingController: _passwordConfirmationController,
              ),
            ElevatedButton(
              onPressed: () => _presenter.authenticate(),
              child: Text(_register ? 'Register' : 'Login'),
            ),
            InkWell(
              onTap: () {
                _presenter.toggleRegisterMode();
              },
              child: Text(_register ? 'Login instead' : 'Register instead'),
            ),
          ],
        ),
      ),
    );
  }
}


