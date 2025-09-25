import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../providers/profile_provider.dart';
import '../../../core/models/profile_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          if (provider.userProfile == null) {
            return const Center(
              child: Text('Please log in to access settings'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildNotificationSettings(context, provider),
                _buildAppSettings(context, provider),
                _buildPrivacySettings(context, provider),
                _buildAccountSettings(context, provider),
                _buildAboutSection(context),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationSettings(BuildContext context, ProfileProvider provider) {
    final preferences = provider.userProfile!.preferences;
    final notifications = preferences.notifications;

    return CustomCard(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notifications',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildSwitchTile(
            'Enable Notifications',
            'Receive all notifications',
            preferences.notificationsEnabled,
            (value) => _updateNotificationSetting('general', value),
          ),
          
          const Divider(),
          
          Text(
            'Notification Types',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          
          _buildSwitchTile(
            'New Posts',
            'Get notified about new community posts',
            notifications.newPosts,
            (value) => _updateNotificationSetting('newPosts', value),
          ),
          
          _buildSwitchTile(
            'Comments',
            'Get notified when someone comments on your posts',
            notifications.comments,
            (value) => _updateNotificationSetting('comments', value),
          ),
          
          _buildSwitchTile(
            'Likes',
            'Get notified when someone likes your content',
            notifications.likes,
            (value) => _updateNotificationSetting('likes', value),
          ),
          
          _buildSwitchTile(
            'Orders',
            'Get notified about order updates',
            notifications.orders,
            (value) => _updateNotificationSetting('orders', value),
          ),
          
          _buildSwitchTile(
            'Weather Alerts',
            'Receive weather warnings and alerts',
            notifications.weatherAlerts,
            (value) => _updateNotificationSetting('weatherAlerts', value),
          ),
          
          _buildSwitchTile(
            'Market Updates',
            'Get notified about market price changes',
            notifications.marketUpdates,
            (value) => _updateNotificationSetting('marketUpdates', value),
          ),
          
          const Divider(),
          
          Text(
            'Delivery Methods',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          
          _buildSwitchTile(
            'Push Notifications',
            'Receive notifications on your device',
            preferences.pushNotifications,
            (value) => _updateDeliveryMethod('push', value),
          ),
          
          _buildSwitchTile(
            'Email Notifications',
            'Receive notifications via email',
            preferences.emailNotifications,
            (value) => _updateDeliveryMethod('email', value),
          ),
          
          _buildSwitchTile(
            'SMS Notifications',
            'Receive notifications via SMS',
            preferences.smsNotifications,
            (value) => _updateDeliveryMethod('sms', value),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettings(BuildContext context, ProfileProvider provider) {
    final preferences = provider.userProfile!.preferences;

    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'App Settings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildSwitchTile(
            'Dark Mode',
            'Use dark theme',
            preferences.darkMode,
            (value) => _updateAppSetting('darkMode', value),
          ),
          
          _buildDropdownTile(
            'Language',
            'App language',
            preferences.language,
            ['en', 'hi', 'mr'],
            ['English', 'Hindi', 'Marathi'],
            (value) => _updateAppSetting('language', value),
          ),
          
          _buildDropdownTile(
            'Currency',
            'Display currency',
            preferences.currency,
            ['INR', 'USD', 'EUR'],
            ['Indian Rupee (₹)', 'US Dollar (\$)', 'Euro (€)'],
            (value) => _updateAppSetting('currency', value),
          ),
          
          _buildDropdownTile(
            'Temperature Unit',
            'Temperature display',
            preferences.temperatureUnit,
            ['celsius', 'fahrenheit'],
            ['Celsius (°C)', 'Fahrenheit (°F)'],
            (value) => _updateAppSetting('temperatureUnit', value),
          ),
          
          _buildDropdownTile(
            'Measurement Unit',
            'Distance and area measurements',
            preferences.measurementUnit,
            ['metric', 'imperial'],
            ['Metric (km, hectares)', 'Imperial (miles, acres)'],
            (value) => _updateAppSetting('measurementUnit', value),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySettings(BuildContext context, ProfileProvider provider) {
    final preferences = provider.userProfile!.preferences;

    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy & Security',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildSwitchTile(
            'Profile Visibility',
            'Make your profile visible to other users',
            preferences.profileVisibility,
            (value) => _updatePrivacySetting('profileVisibility', value),
          ),
          
          _buildSwitchTile(
            'Location Sharing',
            'Share your location for better recommendations',
            preferences.locationSharing,
            (value) => _updatePrivacySetting('locationSharing', value),
          ),
          
          const SizedBox(height: 16),
          
          _buildActionTile(
            'Change Password',
            'Update your account password',
            Icons.lock_outline,
            _changePassword,
          ),
          
          _buildActionTile(
            'Privacy Policy',
            'Read our privacy policy',
            Icons.privacy_tip_outlined,
            _showPrivacyPolicy,
          ),
          
          _buildActionTile(
            'Terms of Service',
            'Read our terms of service',
            Icons.description_outlined,
            _showTermsOfService,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettings(BuildContext context, ProfileProvider provider) {
    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildActionTile(
            'Export Data',
            'Download your account data',
            Icons.download_outlined,
            _exportData,
          ),
          
          _buildActionTile(
            'Clear Cache',
            'Free up storage space',
            Icons.cleaning_services_outlined,
            _clearCache,
          ),
          
          const SizedBox(height: 16),
          
          CustomButton(
            text: 'Logout',
            type: ButtonType.secondary,
            width: double.infinity,
            onPressed: () => _logout(context, provider),
          ),
          
          const SizedBox(height: 8),
          
          CustomButton(
            text: 'Delete Account',
            backgroundColor: Colors.red,
            width: double.infinity,
            onPressed: () => _deleteAccount(context, provider),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildActionTile(
            'Help & Support',
            'Get help or contact support',
            Icons.help_outline,
            _showHelp,
          ),
          
          _buildActionTile(
            'Rate App',
            'Rate us on the app store',
            Icons.star_outline,
            _rateApp,
          ),
          
          _buildActionTile(
            'Share App',
            'Share with friends and family',
            Icons.share_outlined,
            _shareApp,
          ),
          
          const SizedBox(height: 16),
          
          Center(
            child: Column(
              children: [
                Text(
                  'AgriTech App',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Version 1.0.0 (Build 1)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '© 2024 AgriTech Solutions',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildDropdownTile(
    String title,
    String subtitle,
    String currentValue,
    List<String> values,
    List<String> displayNames,
    Function(String) onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: DropdownButton<String>(
        value: currentValue,
        items: values.asMap().entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.value,
            child: Text(displayNames[entry.key]),
          );
        }).toList(),
        onChanged: (value) => onChanged(value!),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildActionTile(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _updateNotificationSetting(String setting, bool value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$setting notification ${value ? 'enabled' : 'disabled'}'),
      ),
    );
  }

  void _updateDeliveryMethod(String method, bool value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$method notifications ${value ? 'enabled' : 'disabled'}'),
      ),
    );
  }

  void _updateAppSetting(String setting, dynamic value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$setting updated to $value'),
      ),
    );
  }

  void _updatePrivacySetting(String setting, bool value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$setting ${value ? 'enabled' : 'disabled'}'),
      ),
    );
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: const Text('Password change feature will be implemented in the full version.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening privacy policy...'),
      ),
    );
  }

  void _showTermsOfService() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening terms of service...'),
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preparing data export...'),
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear all cached data. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully'),
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context, ProfileProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await provider.logout();
              if (mounted) {
                context.go('/login');
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount(BuildContext context, ProfileProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              final success = await provider.deleteAccount();
              if (success && mounted) {
                context.go('/login');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account deleted successfully'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening help center...'),
      ),
    );
  }

  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening app store...'),
      ),
    );
  }

  void _shareApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing app...'),
      ),
    );
  }
}
