import 'package:flutter/material.dart';
import 'package:get_fit_app/loginScreenFramework/authentication_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

// A StatefulWidget to manage the authentication screen, either for login or registration.
class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key}); // Constructor, with optional key for widget identification.

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState(); // Creates state for the widget.
}

// The state class responsible for managing the UI and logic of the AuthenticationScreen.
class _AuthenticationScreenState extends State<AuthenticationScreen> {
  // Global key to manage form validation and state.
  final GlobalKey<FormState> _formKey = GlobalKey();

  // Controllers for text input fields to capture user input.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  // Boolean variable to switch between register and login modes.
  bool register = true;

  // Method to handle authentication (either login or register).
  Future<void> _authenticate() async {
    if (_formKey.currentState!.validate() == false) return;

    try {
      // Check if the user is in registration mode
      if (register) {
        // Register the user with email and password
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Show success message on successful registration
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration Successful', textAlign: TextAlign.center),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Log the user in with email and password
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Show success message on successful login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successful', textAlign: TextAlign.center),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Show error message if login or registration fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString(), textAlign: TextAlign.center),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Build method to construct the UI of the screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body of the screen is a form that allows for user input and validation.
      body: Form(
        key: _formKey, // Binding the form to the GlobalKey for validation.
        child: Column(
          children: [
            const SizedBox(height: 50), // Adds spacing at the top of the screen.

            // Authentication text input field for email using the custom AuthenticationTextFormField widget.
            AuthenticationTextFormField(
              key: const Key('email'),
              icon: Icons.email, // Icon for the email field.
              label: 'Email', // Label for the email field.
              textEditingController: emailController, // Controller to manage email input.
            ),

            // Authentication text input field for password.
            AuthenticationTextFormField(
              key: const Key('password'),
              icon: Icons.vpn_key, // Icon for the password field.
              label: 'Password', // Label for the password field.
              textEditingController: passwordController, // Controller to manage password input.
            ),

            // This field appears only if the user is registering (not logging in).
            if (register == true)
              AuthenticationTextFormField(
                key: const Key('password_confirmation'),
                icon: Icons.password, // Icon for password confirmation field.
                label: 'Password Confirmation', // Label for password confirmation.
                textEditingController: passwordConfirmationController, // Controller to manage password confirmation input.
                confirmationController: passwordController, // Links the confirmation field with the password field.
              ),

            // Elevated button to trigger registration or login depending on the state.
            ElevatedButton(
              onPressed: _authenticate, // Action for the button (currently does nothing).
              child: Text(register == true ? 'Register' : 'Login'), // Button text changes based on register state.
            ),

            // InkWell widget allows user to toggle between login and register views.
            InkWell(
              onTap: () {
                // Toggle between login and register mode.
                setState(() => register = !register);

                // Reset the form fields when toggling between login and register.
                _formKey.currentState?.reset();
              },
              child: Text(
                register == true ? 'Login instead' : 'Register instead', // Text changes based on the current mode.
              ),
            ),
          ],
        ),
      ),
    );
  }
}

