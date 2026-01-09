import 'package:flutter/material.dart';
import 'package:flutter_starter_template/controllers/appearance_settings_controller.dart';
import 'package:flutter_starter_template/controllers/auth_controller.dart';
import 'package:flutter_starter_template/controllers/notification_settings_controller.dart';
import 'package:flutter_starter_template/controllers/profile_controller.dart';
import 'package:flutter_starter_template/core/constants/app_sizes.dart';
import 'package:flutter_starter_template/core/di/service_locator.dart';
import 'package:flutter_starter_template/core/routes/routes.dart';
import 'package:flutter_starter_template/providers/locale_provider.dart';
import 'package:flutter_starter_template/providers/theme_provider.dart';
import 'package:flutter_starter_template/shared/helpers/dialog_helper.dart';
import 'package:flutter_starter_template/views/settings/widgets/profile_header_card.dart';
import 'package:flutter_starter_template/views/settings/widgets/settings_section.dart';
import 'package:flutter_starter_template/views/settings/widgets/settings_tile.dart';
import 'package:flutter_starter_template/views/settings/widgets/settings_tile_config.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

/// Premium Settings Screen with domain-based controllers.
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late final ProfileController _profileCtrl;
  late final AppearanceSettingsController _appearanceCtrl;
  late final NotificationSettingsController _notificationCtrl;
  late final AuthController _authCtrl;

  @override
  void initState() {
    super.initState();
    _profileCtrl = sl<ProfileController>();
    _appearanceCtrl = sl<AppearanceSettingsController>();
    _notificationCtrl = sl<NotificationSettingsController>();
    _authCtrl = sl<AuthController>();

    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _profileCtrl.loadProfile(),
      _appearanceCtrl.loadThemeMode(),
      _notificationCtrl.loadPreferences(),
    ]);
  }

  @override
  void dispose() {
    _profileCtrl.dispose();
    _appearanceCtrl.dispose();
    _notificationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Profile Header
          AnimatedBuilder(
            animation: _profileCtrl,
            builder: (context, _) {
              return ProfileHeaderCard(
                user: _profileCtrl.user,
                isLoading: _profileCtrl.isLoading,
                onAvatarTap: () => _showAvatarOptions(),
                onEditTap: () => _navigateToProfileEdit(),
              );
            },
          ),

          // Appearance Section
          _buildAppearanceSection(),

          // Notifications Section
          _buildNotificationsSection(),

          // Security & Privacy Section
          _buildSecuritySection(),

          // Data & Storage Section
          _buildDataSection(),

          // About Section
          _buildAboutSection(),

          // Logout Button
          _buildLogoutButton(),

          const SizedBox(height: AppSizes.spacing32),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection() {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return SettingsSection(
      title: 'Appearance',
      icon: Icons.palette_outlined,
      children: [
        AnimatedBuilder(
          animation: _appearanceCtrl,
          builder: (context, _) {
            return SettingsTile(
              config: SettingsTileConfig.toggle(
                title: 'Dark Mode',
                subtitle: 'Enable dark theme',
                icon: Icons.dark_mode_outlined,
                value: themeProvider.getThemeMode() == ThemeMode.dark,
                onChanged: (value) {
                  final mode = value ? ThemeMode.dark : ThemeMode.light;
                  themeProvider.setThemeMode(mode);
                  _appearanceCtrl.setThemeMode(mode);
                },
              ),
            );
          },
        ),
        SettingsTile(
          config: SettingsTileConfig.navigation(
            title: 'Language',
            subtitle:
                context.locale.languageCode == 'ar' ? 'العربية' : 'English',
            icon: Icons.language,
            onTap: () => _showLanguageDialog(localeProvider),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return SettingsSection(
      title: 'Notifications',
      icon: Icons.notifications_outlined,
      children: [
        AnimatedBuilder(
          animation: _notificationCtrl,
          builder: (context, _) {
            final prefs = _notificationCtrl.preferences;
            return Column(
              children: [
                SettingsTile(
                  config: SettingsTileConfig.toggle(
                    title: 'Push Notifications',
                    subtitle: 'Receive push notifications',
                    icon: Icons.notifications_active_outlined,
                    value: prefs.pushEnabled,
                    onChanged: _notificationCtrl.togglePush,
                  ),
                ),
                SettingsTile(
                  config: SettingsTileConfig.toggle(
                    title: 'Email Notifications',
                    subtitle: 'Receive email updates',
                    icon: Icons.email_outlined,
                    value: prefs.emailEnabled,
                    onChanged: _notificationCtrl.toggleEmail,
                  ),
                ),
                SettingsTile(
                  config: SettingsTileConfig.toggle(
                    title: 'Marketing Emails',
                    subtitle: 'Receive promotional content',
                    icon: Icons.campaign_outlined,
                    value: prefs.marketingEnabled,
                    onChanged: _notificationCtrl.toggleMarketing,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return SettingsSection(
      title: 'Security & Privacy',
      icon: Icons.security_outlined,
      children: [
        SettingsTile(
          config: SettingsTileConfig.navigation(
            title: 'Change Password',
            icon: Icons.lock_outline,
            onTap: () {
              // TODO: Navigate to change password
            },
          ),
        ),
        SettingsTile(
          config: SettingsTileConfig.navigation(
            title: 'Two-Factor Authentication',
            subtitle: 'Not enabled',
            icon: Icons.verified_user_outlined,
            onTap: () {
              // TODO: Navigate to 2FA setup
            },
          ),
        ),
        SettingsTile(
          config: SettingsTileConfig.navigation(
            title: 'Privacy Policy',
            icon: Icons.privacy_tip_outlined,
            onTap: () {
              // TODO: Show privacy policy
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDataSection() {
    return SettingsSection(
      title: 'Data & Storage',
      icon: Icons.storage_outlined,
      children: [
        SettingsTile(
          config: SettingsTileConfig.action(
            title: 'Clear Cache',
            subtitle: 'Free up storage space',
            icon: Icons.delete_outline,
            onTap: _clearCache,
          ),
        ),
        SettingsTile(
          config: SettingsTileConfig.action(
            title: 'Download Data',
            subtitle: 'Export your data',
            icon: Icons.download_outlined,
            onTap: () {
              // TODO: Implement data export
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return SettingsSection(
      title: 'About',
      icon: Icons.info_outlined,
      children: [
        SettingsTile(
          config: SettingsTileConfig.info(
            title: 'Version',
            value: '1.0.0',
            icon: Icons.info_outline,
          ),
        ),
        SettingsTile(
          config: SettingsTileConfig.navigation(
            title: 'Terms of Service',
            icon: Icons.description_outlined,
            onTap: () {
              // TODO: Show terms
            },
          ),
        ),
        SettingsTile(
          config: SettingsTileConfig.navigation(
            title: 'Rate App',
            icon: Icons.star_outline,
            onTap: () {
              // TODO: Open store rating
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing16,
        vertical: AppSizes.spacing8,
      ),
      child: AnimatedBuilder(
        animation: _authCtrl,
        builder: (context, _) {
          return SettingsTile(
            config: SettingsTileConfig.action(
              title: 'Logout',
              icon: Icons.logout,
              isDangerous: true,
              isLoading: _authCtrl.isLoading,
              onTap: _handleLogout,
            ),
          );
        },
      ),
    );
  }

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement camera
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement gallery
              },
            ),
            if (_profileCtrl.user?.avatarUrl != null)
              ListTile(
                leading: Icon(Icons.delete,
                    color: Theme.of(context).colorScheme.error),
                title: Text(
                  'Remove Photo',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _profileCtrl.removeAvatar();
                },
              ),
          ],
        ),
      ),
    );
  }

  void _navigateToProfileEdit() {
    Navigator.of(context).pushNamed(AppRoutes.profileEdit);
  }

  void _showLanguageDialog(LocaleProvider localeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: context.locale.languageCode,
              onChanged: (value) {
                if (value != null) {
                  localeProvider.setLocale(context, Locale(value));
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('العربية'),
              value: 'ar',
              groupValue: context.locale.languageCode,
              onChanged: (value) {
                if (value != null) {
                  localeProvider.setLocale(context, Locale(value));
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _clearCache() async {
    final confirmed = await DialogHelper.showConfirm(
      title: 'Clear Cache',
      message: 'This will free up storage space. Continue?',
    );

    if (confirmed == true) {
      // TODO: Implement cache clearing
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cache cleared successfully')),
        );
      }
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await DialogHelper.showConfirm(
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      isDangerous: true,
    );

    if (confirmed == true) {
      await _authCtrl.logout();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => false,
        );
      }
    }
  }
}
