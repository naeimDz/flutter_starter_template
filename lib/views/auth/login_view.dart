import 'package:flutter/material.dart';
import 'package:flutter_starter_template/controllers/auth_controller.dart';
import 'package:flutter_starter_template/core/constants/app_sizes.dart';
import 'package:flutter_starter_template/core/di/service_locator.dart';
import 'package:flutter_starter_template/core/routes/routes.dart';
import 'package:flutter_starter_template/core/utils/validators.dart';
import 'package:flutter_starter_template/shared/helpers/snackbar_helper.dart';
import 'package:flutter_starter_template/shared/widgets/app_text_field.dart';
import 'package:flutter_starter_template/shared/widgets/custom_button.dart';
import 'package:flutter_starter_template/views/auth/widgets/auth_header.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller = sl<AuthController>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    try {
      final success = await _controller.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    } catch (e) {
      if (mounted) {
        SnackbarHelper.showSnackbar(
          context,
          message: e.toString().replaceAll('Exception: ', ''),
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      title: 'Welcome Back!',
                      subtitle: 'Sign in to continue your journey.',
                    ),

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
                      validator:
                          Validators.required(message: 'Password is required'),
                      onSubmitted: (_) => _handleLogin(),
                    ),
                    const SizedBox(height: AppSizes.spacing8),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Navigate to Forgot Password
                          // Navigator.of(context).pushNamed(AppRoutes.forgotPassword);
                        },
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing24),

                    // Login Button
                    CustomButton(
                      text: 'Log In',
                      onPressed: _handleLogin,
                      isLoading: _controller.isLoading,
                    ),

                    const SizedBox(height: AppSizes.spacing24),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRoutes.register);
                          },
                          child: const Text('Sign Up'),
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
