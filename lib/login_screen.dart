import 'package:flutter/material.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_action.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_client.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise.dart';
import 'dart:io' show Platform;

/// A stateful widget representing the Login Screen.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for email and password input fields.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Global key to uniquely identify the form and validate it.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _statusMessage = '';
  RecaptchaClient? _recaptchaClient;

  @override
  void initState() {
    super.initState();
    _initRecaptcha();
  }

  /// Initializes the reCAPTCHA Enterprise client.
  Future<void> _initRecaptcha() async {
    // Determine the site key based on the platform.
    // Replace these placeholder strings with your actual site keys from Google Cloud Console.
    final String siteKey = Platform.isAndroid
        ? 'Andoid key'
        : 'YOUR_IOS_SITE_KEY';

    try {
      // Fetch the reCAPTCHA client using the platform-specific site key.
      _recaptchaClient = await Recaptcha.fetchClient(siteKey);
      debugPrint("reCAPTCHA client initialized successfully.");
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to initialize reCAPTCHA: $e';
      });
      debugPrint(_statusMessage);
    }
  }

  /// Handles the login process, including reCAPTCHA validation.
  Future<void> _login() async {
    // Validate the form fields first.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });

    try {
      // 1. Ensure the reCAPTCHA client is initialized.
      if (_recaptchaClient == null) {
        throw Exception('reCAPTCHA client is not initialized.');
      }

      // 2. Execute the reCAPTCHA challenge with the LOGIN action.
      // This returns a token that you must send to your backend server.
      String token = await _recaptchaClient!.execute(RecaptchaAction.LOGIN());

      debugPrint("reCAPTCHA token generated: $token");

      // 3. Perform your actual backend login API call here.
      // You should send the [email], [password], and the [token] to your backend.
      // The backend should then verify the token with Google's reCAPTCHA API to get a risk score.

      // Simulating a network request delay.
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _statusMessage =
            'Login simulated successfully!\nToken (truncated): ${token.substring(0, 15)}...';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Login failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is removed from the widget tree.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login with reCAPTCHA')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.security, size: 80, color: Colors.blue),
                const SizedBox(height: 32),
                // Email Input Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Password Input Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // reCAPTCHA Disclosure Text
                const Text(
                  'This app is protected by reCAPTCHA Enterprise and the Google\n'
                  'Privacy Policy and Terms of Service apply.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                // Login Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Login', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 24),
                // Status Message Display
                if (_statusMessage.isNotEmpty)
                  Text(
                    _statusMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _statusMessage.contains('successfully')
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
