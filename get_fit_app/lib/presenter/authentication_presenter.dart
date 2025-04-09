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



  bool _register = true;// Boolean to track if the user is in register mode.


  // Constructor takes in the view to communicate with the UI.
  AuthenticationPresenter(this._view);

  // Method to authenticate the user based on whether they're logging in or registering.
  Future<void> authenticate(BuildContext context) async {
    // Validate form inputs (email and password).
    print(_view.email);
    print(_view.password);
    print(_view.lastName);
    print(_view.firstName);

    if (_view.email.isEmpty ||
        _view.password.isEmpty ||
        (_register && _view.passwordConfirmation == null)) {
      _view.showErrorMessage(
          'Please fill in all fields.'); // Show error message if fields are empty.
      return;
    }

    if (_register && _view.password != _view.passwordConfirmation) {
      _view.showErrorMessage(
          'Passwords do not match.'); // Show error message if passwords don't match.
      return;
    }

    try {
      // Create a UserModel with the email and password.
      UserModel user;

      if (_register) {
        // Include firstName and lastName in the UserModel if it's a registration.
        user = UserModel(
          email: _view.email,
          password: _view.password,
          firstName: _view.firstName,
          lastName: _view.lastName,
        );
      } else {
        // For login, only pass email and password.
        user = UserModel(
          email: _view.email,
          password: _view.password,
        );
      }



      // Call AuthService to perform the authentication.
      await _authService.authenticate(user, _register);

      _authService.setUserInDatabase(user);
      context.go("/home");
      // Show a success message once authentication is successful.
      _view.showSuccessMessage(
          _register ? 'Registration Successful' : 'Login Successful');
    } catch (e) {
      // If authentication fails, show an error message.
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
