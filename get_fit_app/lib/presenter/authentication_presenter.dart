import 'package:flutter/material.dart';
import 'package:get_fit_app/viewmodel/authentication_user_model.dart';
import 'package:get_fit_app/viewmodel/authentication_service_model.dart';
import 'package:get_fit_app/views/authentication_view.dart';

class AuthenticationPresenter {
  final AuthService _authService = AuthService();
  final AuthenticationView _view;

  bool _register = true;

  AuthenticationPresenter(this._view);

  // Method to authenticate the user
  Future<void> authenticate() async {
    if (_view.email.isEmpty || _view.password.isEmpty || (_register && _view.passwordConfirmation == null)) {
      _view.showErrorMessage('Please fill in all fields.');
      return;
    }

    if (_register && _view.password != _view.passwordConfirmation) {
      _view.showErrorMessage('Passwords do not match.');
      return;
    }

    try {
      UserModel user = UserModel(email: _view.email, password: _view.password);
      await _authService.authenticate(user, _register);
      _view.showSuccessMessage(_register ? 'Registration Successful' : 'Login Successful');
    } catch (e) {
      _view.showErrorMessage('Error: $e');
    }
  }

  // Method to toggle between login and registration modes
  void toggleRegisterMode() {
    _register = !_register;
    _view.updateUIForMode(_register);
  }
}
