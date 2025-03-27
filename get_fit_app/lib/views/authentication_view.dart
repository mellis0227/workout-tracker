abstract class AuthenticationView {
  String get email;
  String get password;
  String? get passwordConfirmation;

  void showErrorMessage(String message);
  void showSuccessMessage(String message);
  void updateUIForMode(bool register);
}
