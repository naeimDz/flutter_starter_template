import 'package:flutter/material.dart';
import 'package:flutter_starter_template/core/constants/app_colors.dart';
import 'package:flutter_starter_template/core/constants/app_sizes.dart';
import 'package:flutter_starter_template/core/routes/routes.dart';

/// Animated splash screen.
///
/// Features:
/// - Logo animation (fade + scale)
/// - App initialization
/// - Auto-navigation to home
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initialize();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
  }

  Future<void> _initialize() async {
    // Perform initialization tasks here:
    // - Check auth status
    // - Load cached data
    // - Check for updates
    // - etc.

    // Minimum splash duration for branding
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppColors.primaryDark,
                    AppColors.secondaryDark,
                  ]
                : [
                    AppColors.primary,
                    AppColors.secondary,
                  ],
          ),
        ),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.flutter_dash,
                        size: 64,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.spacing32),
                // App Name
                Opacity(
                  opacity: _fadeAnimation.value,
                  child: Text(
                    'Flutter Starter',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: AppSizes.spacing8),
                // Tagline
                Opacity(
                  opacity: _fadeAnimation.value,
                  child: Text(
                    'Build amazing apps faster',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.white.withOpacity(0.8),
                        ),
                  ),
                ),
                const SizedBox(height: AppSizes.spacing48),
                // Loading indicator
                Opacity(
                  opacity: _fadeAnimation.value,
                  child: const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
