import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter_template/controllers/home_controller.dart';
import 'package:flutter_starter_template/core/constants/app_sizes.dart';
import 'package:flutter_starter_template/core/di/service_locator.dart';
import 'package:flutter_starter_template/providers/theme_provider.dart';
import 'package:flutter_starter_template/core/routes/routes.dart';
import 'package:flutter_starter_template/shared/widgets/skeleton.dart';
import 'package:provider/provider.dart';

/// Home screen view following MVC pattern.
///
/// Uses:
/// - HomeController for business logic
/// - ThemeProvider for theme switching
/// - Demonstrates localization and state management
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = sl<HomeController>();
    _controller.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>.value(
      value: _controller,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return AppBar(
      title: Text('home_title'.tr()),
      actions: [
        // Theme Toggle
        IconButton(
          icon: Icon(
            themeProvider.getThemeMode() == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          onPressed: () {
            themeProvider.setThemeMode(
              themeProvider.getThemeMode() == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark,
            );
          },
          tooltip: 'Toggle Theme',
        ),
        // Language Toggle
        PopupMenuButton<String>(
          icon: const Icon(Icons.language),
          tooltip: 'Change Language',
          onSelected: (String locale) {
            context.setLocale(Locale(locale));
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'en',
              child: Text('English'),
            ),
            const PopupMenuItem(
              value: 'ar',
              child: Text('العربية'),
            ),
          ],
        ),
        // Settings
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.settings);
          },
          tooltip: 'Settings',
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return _buildSkeleton(context);
        }

        return SingleChildScrollView(
          padding: AppSizes.paddingScreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Card
              _buildWelcomeCard(context),
              const SizedBox(height: AppSizes.spacing24),

              // Counter Demo
              _buildCounterSection(context, controller),
              const SizedBox(height: AppSizes.spacing24),

              // Features Section
              _buildFeaturesSection(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSizes.paddingAllLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.spacing12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: AppSizes.borderRadiusMd,
                  ),
                  child: Icon(
                    Icons.flutter_dash,
                    size: AppSizes.iconLg,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppSizes.spacing16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'welcome_title'.tr(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSizes.spacing4),
                      Text(
                        'welcome_subtitle'.tr(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterSection(BuildContext context, HomeController controller) {
    return Card(
      child: Padding(
        padding: AppSizes.paddingAllLg,
        child: Column(
          children: [
            Text(
              'counter_title'.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSizes.spacing16),
            Text(
              '${controller.counter}',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: AppSizes.spacing16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  onPressed: controller.decrementCounter,
                  icon: const Icon(Icons.remove),
                ),
                const SizedBox(width: AppSizes.spacing16),
                IconButton.filled(
                  onPressed: controller.resetCounter,
                  icon: const Icon(Icons.refresh),
                ),
                const SizedBox(width: AppSizes.spacing16),
                IconButton.filled(
                  onPressed: controller.incrementCounter,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    final features = [
      _FeatureItem(
        icon: Icons.palette_outlined,
        title: 'feature_theming'.tr(),
        description: 'feature_theming_desc'.tr(),
      ),
      _FeatureItem(
        icon: Icons.language,
        title: 'feature_localization'.tr(),
        description: 'feature_localization_desc'.tr(),
      ),
      _FeatureItem(
        icon: Icons.architecture,
        title: 'feature_architecture'.tr(),
        description: 'feature_architecture_desc'.tr(),
      ),
      _FeatureItem(
        icon: Icons.api,
        title: 'feature_networking'.tr(),
        description: 'feature_networking_desc'.tr(),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'features_title'.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSizes.spacing16),
        ...features.map((feature) => _buildFeatureCard(context, feature)),
      ],
    );
  }

  Widget _buildFeatureCard(BuildContext context, _FeatureItem feature) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spacing12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppSizes.spacing8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: AppSizes.borderRadiusSm,
          ),
          child: Icon(
            feature.icon,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(feature.title),
        subtitle: Text(feature.description),
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSizes.paddingScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome Card Skeleton
          const Skeleton(height: 120, borderRadius: AppSizes.radiusMd),
          const SizedBox(height: AppSizes.spacing24),

          // Counter Section Skeleton
          const Skeleton(height: 180, borderRadius: AppSizes.radiusMd),
          const SizedBox(height: AppSizes.spacing24),

          // Features Section Skeleton
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Skeleton(width: 150, height: 24),
              const SizedBox(height: AppSizes.spacing16),
              ...List.generate(
                3,
                (index) => const Padding(
                  padding: EdgeInsets.only(bottom: AppSizes.spacing12),
                  child: Skeleton(height: 80, borderRadius: AppSizes.radiusMd),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
