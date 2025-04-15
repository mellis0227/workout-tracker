// Interface that the view must implement. It defines the methods used by the presenter to communicate with the view.
abstract class AuthenticationView {
  String get email; // Getter to retrieve the email input
  String get password; // Getter to retrieve the password input
  String?
      get passwordConfirmation; // Getter to retrieve the password confirmation input (if applicable)
  String? get firstName;
  String? get lastName;

  // Methods for showing error and success messages
  void showErrorMessage(String message);
  void showSuccessMessage(String message);

  // Method to update the UI when toggling between register and login modes
  void updateUIForMode(bool register);
}
