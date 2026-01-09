import 'package:flutter/material.dart';
import 'package:flutter_starter_template/controllers/auth_controller.dart';
import 'package:flutter_starter_template/core/constants/app_sizes.dart';
import 'package:flutter_starter_template/core/di/service_locator.dart';
import 'package:flutter_starter_template/core/routes/routes.dart';
import 'package:flutter_starter_template/core/utils/validators.dart';
import 'package:flutter_starter_template/shared/widgets/app_text_field.dart';
import 'package:flutter_starter_template/shared/widgets/custom_button.dart';
import 'package:flutter_starter_template/views/auth/widgets/auth_header.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final AuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller = sl<AuthController>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    try {
      final success = await _controller.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        // Navigate all the way home or just replace?
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
      }
    } catch (e) {
      if (mounted) {
        // Fix SnackHelper usage later if signature is different
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSizes.paddingScreen,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthHeader(
                      title: 'Create Account',
                      subtitle: 'Sign up to get started!',
                    ),

                    // Name
                    AppTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'John Doe',
                      prefixIcon: const Icon(Icons.person_outline),
                      validator: Validators.required(),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSizes.spacing16),

                    // Email
                    EmailTextField(
                      controller: _emailController,
                      validator: Validators.compose([
                        Validators.required(),
                        Validators.email(),
                      ]),
                    ),
                    const SizedBox(height: AppSizes.spacing16),

                    // Password
                    PasswordTextField(
                      controller: _passwordController,
                      validator: Validators.compose([
                        Validators.required(),
                        Validators.minLength(6),
                      ]),
                    ),
                    const SizedBox(height: AppSizes.spacing16),

                    // Confirm Password
                    PasswordTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      hint: 'Re-enter your password',
                      validator: (val) {
                        if (val != _passwordController.text)
                          return 'Passwords do not match';
                        return null;
                      },
                      onSubmitted: (_) => _handleRegister(),
                    ),
                    const SizedBox(height: AppSizes.spacing32),

                    // Register Button
                    CustomButton(
                      text: 'Sign Up',
                      onPressed: _handleRegister,
                      isLoading: _controller.isLoading,
                    ),

                    const SizedBox(height: AppSizes.spacing24),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Log In'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
