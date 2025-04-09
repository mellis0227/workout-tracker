// This class represents the user data model for authentication.
class UserModel {
  final String email; // User's email
  final String password;// User's password
  final String? firstName;
  final String? lastName;

  // Constructor to create a UserModel instance
  UserModel({required this.email, required this.password, this.firstName, this.lastName});

  String getCurrentUserID(UserModel user) {
    return user.email;
  }
}
