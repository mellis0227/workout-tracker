import 'package:flutter/material.dart';
import 'package:get_fit_app/loginScreenFramework/authentication_text_form_field.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  bool register = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 50),
            AuthenticationTextFormField(
              icon: Icons.email,
              label: 'Email',
              textEditingController: emailController,
            ),
            AuthenticationTextFormField(
              icon: Icons.vpn_key,
              label: 'Password',
              textEditingController: passwordController,
            ),
            if (register == true)
              AuthenticationTextFormField(
                icon: Icons.password,
                label: 'Password Confirmation',
                textEditingController: passwordConfirmationController,
              ),
            ElevatedButton(
              onPressed: () {},
              child: Text(register == true ? 'Register' : 'Login'),
            ),
            InkWell(
              onTap: () {
                setState(() => register = !register);
                _formKey.currentState?.reset();
              },
              child: Text(
                register == true ? 'Login instead' : 'Register instead',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
