import 'package:flutter/material.dart';
import 'package:flutter_recaptcha_v2_compat/flutter_recaptcha_v2_compat.dart';

/// A stateful widget representing the Login Screen using reCAPTCHA V2.
class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({super.key});

  @override
  State<LoginScreen2> createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controller for managing the reCAPTCHA V2 widget visibility
  final RecaptchaV2Controller _recaptchaV2Controller = RecaptchaV2Controller();

  bool _isVerified = false;
  bool _isLoading = false;
  String _statusMessage = '';

  void _verifyRecaptcha() {
    // Show the reCAPTCHA widget overlay
    _recaptchaV2Controller.addListener(() {});
  }

  Future<void> _login() async {
    // Validate form fields first
    if (!_formKey.currentState!.validate()) return;

    // Ensure the user has verified they are not a robot
    if (!_isVerified) {
      setState(() {
        _statusMessage = 'Please verify that you are not a robot first.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });

    // Simulate backend login API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _statusMessage = 'Login successful!';
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login with reCAPTCHA v2')),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.person, size: 80, color: Colors.blue),
                    const SizedBox(height: 32),
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter email' : null,
                    ),
                    const SizedBox(height: 16),
                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter password' : null,
                    ),
                    const SizedBox(height: 24),

                    // The "I am not a robot" section
                    InkWell(
                      onTap: () {
                        if (!_isVerified) {
                          _verifyRecaptcha();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: _isVerified,
                              onChanged: (value) {
                                if (!_isVerified) {
                                  _verifyRecaptcha();
                                }
                              },
                            ),
                            const Text(
                              "I'm not a robot",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            // Optional: Add a dummy reCAPTCHA logo or icon here
                            Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/RecaptchaLogo.svg/2048px-RecaptchaLogo.svg.png',
                              height: 30,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.security,
                                    color: Colors.blue,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
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
                    const SizedBox(height: 16),
                    // Status Message
                    if (_statusMessage.isNotEmpty)
                      Text(
                        _statusMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _statusMessage.contains('successful')
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

          // The actual reCAPTCHA v2 webview widget overlay
          // This remains hidden until _recaptchaV2Controller.show() is called
          RecaptchaV2(
            // REPLACE THESE WITH YOUR ACTUAL RECAPTCHA V2 KEYS
            apiKey: "YOUR_V2_SITE_KEY",
            apiSecret: "YOUR_V2_SECRET_KEY",
            controller: _recaptchaV2Controller,
            onVerifiedError: (err) {
              debugPrint("reCAPTCHA Error: $err");
              setState(() {
                _statusMessage = 'Verification failed: $err';
              });
            },
            onVerifiedSuccessfully: (success) {
              setState(() {
                if (success) {
                  _isVerified = true;
                  _statusMessage = 'Verified successfully!';
                } else {
                  _isVerified = false;
                  _statusMessage = 'Failed to verify.';
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
