import 'package:flutter/material.dart';

class AuthenticationTextFormField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController textEditingController;

  const AuthenticationTextFormField({
    required this.label,
    required this.icon,
    required this.textEditingController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      obscureText: label.toLowerCase().contains('password'),
      decoration: InputDecoration(
        icon: Icon(icon),
        labelText: label,
      ),
    );
  }
}


