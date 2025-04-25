//import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_fit_app/viewmodel/authentication_user_model.dart';
import 'package:get_fit_app/viewmodel/authentication_service_model.dart';
import 'package:get_fit_app/views/authentication_view.dart';
import 'package:go_router/go_router.dart';

// Presenter class that connects the View and the Model (AuthService).
class AuthenticationPresenter {
  final AuthService _authService =
      AuthService(); // Instance of the authentication service.
  final AuthenticationView _view; // The view that the presenter will update.

  bool _register = true; // Boolean to track if the user is in register mode.

  // Constructor takes in the view to communicate with the UI.
  AuthenticationPresenter(this._view);

  // Method to authenticate the user based on whether they're logging in or registering.
  Future<void> authenticate(BuildContext context, bool isRegisterMode) async {
    print(_view.email);
    print(_view.password);
    print(_view.lastName);
    print(_view.firstName);
    print("isRegisterMode: $isRegisterMode");

    if (_view.email.isEmpty ||
        _view.password.isEmpty ||
        (isRegisterMode &&
            (_view.passwordConfirmation == null ||
                _view.passwordConfirmation!.isEmpty))) {
      _view.showErrorMessage('Please fill in all fields.');
      return;
    }

    if (isRegisterMode &&
        (_view.passwordConfirmation == null ||
            _view.password != _view.passwordConfirmation)) {
      _view.showErrorMessage('Passwords do not match.');
      return;
    }

    try {
      UserModel user;

      if (isRegisterMode) {
        user = UserModel(
          email: _view.email,
          password: _view.password,
          firstName: _view.firstName,
          lastName: _view.lastName,
        );
        _authService.setUserInDatabase(user);
      } else {
        user = UserModel(
          email: _view.email,
          password: _view.password,
        );
      }

      await _authService.authenticate(user, isRegisterMode);
      context.go("/home");
      _view.showSuccessMessage(
          isRegisterMode ? 'Registration Successful' : 'Login Successful');
    } catch (e) {
      _view.showErrorMessage('Error: $e');
    }
  }

  // Method to toggle between register and login modes.
  void toggleRegisterMode() {
    _register = !_register;
    _view.updateUIForMode(
        _register); // Update the view to reflect the mode change.
  }
}
