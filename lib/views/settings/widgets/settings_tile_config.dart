import 'package:flutter/material.dart';

/// Types of settings tiles.
enum SettingsTileType {
  toggle,
  navigation,
  action,
  info,
}

/// Configuration for a settings tile.
class SettingsTileConfig {
  final SettingsTileType type;
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final bool enabled;

  // Type-specific data
  final Map<String, dynamic>? typeData;

  const SettingsTileConfig({
    required this.type,
    required this.title,
    required this.icon,
    this.subtitle,
    this.iconColor,
    this.onTap,
    this.enabled = true,
    this.typeData,
  });

  /// Create a toggle tile.
  factory SettingsTileConfig.toggle({
    required String title,
    required IconData icon,
    String? subtitle,
    Color? iconColor,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
  }) {
    return SettingsTileConfig(
      type: SettingsTileType.toggle,
      title: title,
      icon: icon,
      subtitle: subtitle,
      iconColor: iconColor,
      enabled: enabled,
      typeData: {
        'value': value,
        'onChanged': onChanged,
      },
    );
  }

  /// Create a navigation tile.
  factory SettingsTileConfig.navigation({
    required String title,
    required IconData icon,
    String? subtitle,
    Color? iconColor,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return SettingsTileConfig(
      type: SettingsTileType.navigation,
      title: title,
      icon: icon,
      subtitle: subtitle,
      iconColor: iconColor,
      onTap: onTap,
      enabled: enabled,
    );
  }

  /// Create an action tile.
  factory SettingsTileConfig.action({
    required String title,
    required IconData icon,
    String? subtitle,
    Color? iconColor,
    required VoidCallback onTap,
    bool isDangerous = false,
    bool isLoading = false,
    bool enabled = true,
  }) {
    return SettingsTileConfig(
      type: SettingsTileType.action,
      title: title,
      icon: icon,
      subtitle: subtitle,
      iconColor: iconColor,
      onTap: onTap,
      enabled: enabled,
      typeData: {
        'isDangerous': isDangerous,
        'isLoading': isLoading,
      },
    );
  }

  /// Create an info tile (read-only).
  factory SettingsTileConfig.info({
    required String title,
    required IconData icon,
    required String value,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return SettingsTileConfig(
      type: SettingsTileType.info,
      title: title,
      icon: icon,
      iconColor: iconColor,
      onTap: onTap,
      typeData: {
        'value': value,
      },
    );
  }
}
