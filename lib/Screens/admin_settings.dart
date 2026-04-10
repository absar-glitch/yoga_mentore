import 'package:flutter/material.dart';

/// Admin ke liye app settings manage karne ka page
class AdminSettingsPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const AdminSettingsPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  bool _pushNotifications = true;
  bool _emailAlerts = false;
  bool _analyticsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.grey : Colors.grey[600]!;
    final accentColor = const Color(0xFF13EC5B);

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Configure app behavior and preferences',
              style: TextStyle(color: subtitleColor, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // General settings
            _sectionTitle('General', accentColor),
            const SizedBox(height: 12),
            _settingsTile(
              'App Name',
              'Yoga Mentor AI',
              Icons.app_registration,
              cardColor,
              textColor,
              subtitleColor,
              accentColor,
              onTap: () {},
            ),
            _settingsTile(
              'App Version',
              'v1.0.0',
              Icons.info_outline,
              cardColor,
              textColor,
              subtitleColor,
              accentColor,
              onTap: () {},
            ),
            _settingsTile(
              'AI Engine',
              'v2.4.1 — Optimal',
              Icons.memory,
              cardColor,
              textColor,
              subtitleColor,
              accentColor,
              onTap: () {},
            ),
            const SizedBox(height: 24),

            // Notifications
            _sectionTitle('Notifications', accentColor),
            const SizedBox(height: 12),
            _switchTile(
              'Push Notifications',
              'Send alerts to users',
              Icons.notifications_active,
              _pushNotifications,
              (val) => setState(() => _pushNotifications = val),
              cardColor,
              textColor,
              subtitleColor,
              accentColor,
            ),
            _switchTile(
              'Email Alerts',
              'Send email reports to admin',
              Icons.email,
              _emailAlerts,
              (val) => setState(() => _emailAlerts = val),
              cardColor,
              textColor,
              subtitleColor,
              accentColor,
            ),
            const SizedBox(height: 24),

            // System
            _sectionTitle('System', accentColor),
            const SizedBox(height: 12),
            _switchTile(
              'Theme Mode',
              widget.isDarkMode
                  ? 'Currently Dark — switch to Light'
                  : 'Currently Light — switch to Dark',
              Icons.brightness_6,
              !widget.isDarkMode,
              widget.onThemeChanged,
              cardColor,
              textColor,
              subtitleColor,
              accentColor,
            ),
            _switchTile(
              'Analytics',
              'Collect usage statistics',
              Icons.analytics,
              _analyticsEnabled,
              (val) => setState(() => _analyticsEnabled = val),
              cardColor,
              textColor,
              subtitleColor,
              accentColor,
            ),
            _settingsTile(
              'Clear Cache',
              'Free up storage space',
              Icons.cached,
              cardColor,
              textColor,
              subtitleColor,
              accentColor,
              onTap: () {},
            ),
            _settingsTile(
              'Export Data',
              'Download user data as CSV',
              Icons.download,
              cardColor,
              textColor,
              subtitleColor,
              accentColor,
              onTap: () {},
            ),
            const SizedBox(height: 24),

            // Danger zone
            _sectionTitle('Danger Zone', accentColor),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.redAccent.withValues(alpha: 0.3),
                ),
              ),
              child: const ListTile(
                leading: Icon(Icons.warning_amber, color: Colors.redAccent),
                title: Text(
                  'Reset All Data',
                  style: TextStyle(color: Colors.redAccent),
                ),
                subtitle: Text(
                  'This action cannot be undone',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.redAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, Color accentColor) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: accentColor,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _settingsTile(
    String title,
    String subtitle,
    IconData icon,
    Color cardColor,
    Color textColor,
    Color subtitleColor,
    Color accentColor, {
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: accentColor),
        title: Text(title, style: TextStyle(color: textColor)),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: subtitleColor, fontSize: 12),
        ),
        trailing: Icon(Icons.chevron_right, color: accentColor),
        onTap: onTap,
      ),
    );
  }

  Widget _switchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
    Color cardColor,
    Color textColor,
    Color subtitleColor,
    Color accentColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: accentColor),
        title: Text(title, style: TextStyle(color: textColor)),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: subtitleColor, fontSize: 12),
        ),
        value: value,
        onChanged: onChanged,
        activeTrackColor: accentColor,
      ),
    );
  }
}
