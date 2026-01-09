import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_starter_template/core/constants/app_sizes.dart';
import 'package:flutter_starter_template/views/settings/widgets/settings_tile_config.dart';

/// Factory-based settings tile widget.
class SettingsTile extends StatelessWidget {
  final SettingsTileConfig config;

  const SettingsTile({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return _builders[config.type]?.call(context, config) ?? _buildFallback();
  }

  // Registry pattern for extensibility
  static final Map<SettingsTileType,
      Widget Function(BuildContext, SettingsTileConfig)> _builders = {
    SettingsTileType.toggle: _buildToggle,
    SettingsTileType.navigation: _buildNavigation,
    SettingsTileType.action: _buildAction,
    SettingsTileType.info: _buildInfo,
  };

  static Widget _buildToggle(BuildContext context, SettingsTileConfig config) {
    final value = config.typeData?['value'] as bool? ?? false;
    final onChanged = config.typeData?['onChanged'] as ValueChanged<bool>?;

    return ListTile(
      enabled: config.enabled,
      leading: _buildIcon(context, config),
      title: Text(config.title),
      subtitle: config.subtitle != null ? Text(config.subtitle!) : null,
      trailing: Switch(
        value: value,
        onChanged: config.enabled
            ? (val) {
                HapticFeedback.selectionClick();
                onChanged?.call(val);
              }
            : null,
      ),
    );
  }

  static Widget _buildNavigation(
    BuildContext context,
    SettingsTileConfig config,
  ) {
    return ListTile(
      enabled: config.enabled,
      leading: _buildIcon(context, config),
      title: Text(config.title),
      subtitle: config.subtitle != null ? Text(config.subtitle!) : null,
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: config.enabled ? config.onTap : null,
    );
  }

  static Widget _buildAction(BuildContext context, SettingsTileConfig config) {
    final isDangerous = config.typeData?['isDangerous'] as bool? ?? false;
    final isLoading = config.typeData?['isLoading'] as bool? ?? false;

    final textColor = isDangerous
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.onSurface;

    return ListTile(
      enabled: config.enabled && !isLoading,
      leading: _buildIcon(
        context,
        config,
        color: isDangerous ? Theme.of(context).colorScheme.error : null,
      ),
      title: Text(
        config.title,
        style: TextStyle(color: textColor),
      ),
      subtitle: config.subtitle != null ? Text(config.subtitle!) : null,
      trailing: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : null,
      onTap: config.enabled && !isLoading ? config.onTap : null,
    );
  }

  static Widget _buildInfo(BuildContext context, SettingsTileConfig config) {
    final value = config.typeData?['value'] as String? ?? '';

    return ListTile(
      enabled: config.enabled,
      leading: _buildIcon(context, config),
      title: Text(config.title),
      trailing: Text(
        value,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
      onTap: config.onTap,
    );
  }

  static Widget _buildIcon(
    BuildContext context,
    SettingsTileConfig config, {
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing8),
      decoration: BoxDecoration(
        color: (color ?? config.iconColor ?? Theme.of(context).primaryColor)
            .withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Icon(
        config.icon,
        size: 24,
        color: color ?? config.iconColor ?? Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildFallback() {
    return ListTile(
      title: Text(config.title),
      subtitle: const Text('Unsupported tile type'),
    );
  }
}
