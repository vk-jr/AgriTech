import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/providers/localization_provider.dart';
import '../providers/profile_provider.dart';
import '../../../core/models/profile_model.dart';
import '../../../l10n/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context)!.settings),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          if (provider.userProfile == null) {
            return Center(
              child: Text(AppLocalizations.of(context)!.pleaseLoginToAccessSettings),
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
            AppLocalizations.of(context)!.notifications,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildSwitchTile(
            AppLocalizations.of(context)!.enableNotifications,
            AppLocalizations.of(context)!.receiveAllNotifications,
            preferences.notificationsEnabled,
            (value) => _updateNotificationSetting('general', value),
          ),
          
          const Divider(),
          
          Text(
            AppLocalizations.of(context)!.notificationTypes,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          
          _buildSwitchTile(
            AppLocalizations.of(context)!.newPosts,
            AppLocalizations.of(context)!.newPostsDesc,
            notifications.newPosts,
            (value) => _updateNotificationSetting('newPosts', value),
          ),
          
          _buildSwitchTile(
            AppLocalizations.of(context)!.comments,
            AppLocalizations.of(context)!.commentsDesc,
            notifications.comments,
            (value) => _updateNotificationSetting('comments', value),
          ),
          
          _buildSwitchTile(
            AppLocalizations.of(context)!.likes,
            AppLocalizations.of(context)!.likesDesc,
            notifications.likes,
            (value) => _updateNotificationSetting('likes', value),
          ),
          
          _buildSwitchTile(
            AppLocalizations.of(context)!.orders,
            AppLocalizations.of(context)!.ordersDesc,
            notifications.orders,
            (value) => _updateNotificationSetting('orders', value),
          ),
          
          _buildSwitchTile(
            AppLocalizations.of(context)!.weatherAlerts,
            AppLocalizations.of(context)!.weatherAlertsDesc,
            notifications.weatherAlerts,
            (value) => _updateNotificationSetting('weatherAlerts', value),
          ),
          
          _buildSwitchTile(
            AppLocalizations.of(context)!.marketUpdates,
            AppLocalizations.of(context)!.marketUpdatesDesc,
            notifications.marketUpdates,
            (value) => _updateNotificationSetting('marketUpdates', value),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettings(BuildContext context, ProfileProvider provider) {
    return Consumer2<ThemeProvider, LocalizationProvider>(
      builder: (context, themeProvider, localizationProvider, child) {
        final preferences = provider.userProfile!.preferences;

        return CustomCard(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.appSettings,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Theme Selection
              _buildThemeSelector(context, themeProvider),
              
              const Divider(),
              
              _buildLanguageDropdownTile(
                context,
                localizationProvider,
              ),
              
              _buildDropdownTile(
                AppLocalizations.of(context)!.currency,
                AppLocalizations.of(context)!.displayCurrency,
                preferences.currency,
                ['INR', 'USD', 'EUR'],
                [AppLocalizations.of(context)!.indianRupee, AppLocalizations.of(context)!.usDollar, AppLocalizations.of(context)!.euro],
                (value) => _updateAppSetting('currency', value),
              ),
              
              _buildDropdownTile(
                AppLocalizations.of(context)!.temperatureUnit,
                AppLocalizations.of(context)!.temperatureDisplay,
                preferences.temperatureUnit,
                ['celsius', 'fahrenheit'],
                [AppLocalizations.of(context)!.celsius, AppLocalizations.of(context)!.fahrenheit],
                (value) => _updateAppSetting('temperatureUnit', value),
              ),
              
              _buildDropdownTile(
                AppLocalizations.of(context)!.measurementUnit,
                AppLocalizations.of(context)!.measurementUnitDesc,
                preferences.measurementUnit,
                ['metric', 'imperial'],
                [AppLocalizations.of(context)!.metric, AppLocalizations.of(context)!.imperial],
                (value) => _updateAppSetting('measurementUnit', value),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeSelector(BuildContext context, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.theme,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        
        // Light Theme Option
        _buildThemeOption(
          context,
          AppLocalizations.of(context)!.lightTheme,
          AppLocalizations.of(context)!.lightThemeDesc,
          Icons.light_mode,
          themeProvider.isLightMode,
          () => themeProvider.setLightTheme(),
        ),
        
        // Dark Theme Option
        _buildThemeOption(
          context,
          AppLocalizations.of(context)!.darkTheme,
          AppLocalizations.of(context)!.darkThemeDesc,
          Icons.dark_mode,
          themeProvider.isDarkMode,
          () => themeProvider.setDarkTheme(),
        ),
        
        // System Theme Option
        _buildThemeOption(
          context,
          AppLocalizations.of(context)!.systemTheme,
          AppLocalizations.of(context)!.systemThemeDesc,
          Icons.settings_system_daydream,
          themeProvider.isSystemMode,
          () => themeProvider.setSystemTheme(),
        ),
      ],
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected 
            ? Theme.of(context).colorScheme.primary 
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected 
              ? Theme.of(context).colorScheme.primary 
              : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: isSelected 
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
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
            AppLocalizations.of(context)!.privacySecurity,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildSwitchTile(
            AppLocalizations.of(context)!.profileVisibility,
            AppLocalizations.of(context)!.profileVisibilityDesc,
            preferences.profileVisibility,
            (value) => _updatePrivacySetting('profileVisibility', value),
          ),
          
          _buildSwitchTile(
            AppLocalizations.of(context)!.locationSharing,
            AppLocalizations.of(context)!.locationSharingDesc,
            preferences.locationSharing,
            (value) => _updatePrivacySetting('locationSharing', value),
          ),
          
          const SizedBox(height: 16),
          
          _buildActionTile(
            AppLocalizations.of(context)!.changePassword,
            AppLocalizations.of(context)!.changePasswordDesc,
            Icons.lock_outline,
            _changePassword,
          ),
          
          _buildActionTile(
            AppLocalizations.of(context)!.privacyPolicy,
            AppLocalizations.of(context)!.privacyPolicyDesc,
            Icons.privacy_tip_outlined,
            _showPrivacyPolicy,
          ),
          
          _buildActionTile(
            AppLocalizations.of(context)!.termsOfService,
            AppLocalizations.of(context)!.termsOfServiceDesc,
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
            AppLocalizations.of(context)!.account,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildActionTile(
            AppLocalizations.of(context)!.exportData,
            AppLocalizations.of(context)!.exportDataDesc,
            Icons.download_outlined,
            _exportData,
          ),
          
          _buildActionTile(
            AppLocalizations.of(context)!.clearCache,
            AppLocalizations.of(context)!.clearCacheDesc,
            Icons.cleaning_services_outlined,
            _clearCache,
          ),
          
          const SizedBox(height: 16),
          
          CustomButton(
            text: AppLocalizations.of(context)!.logout,
            type: ButtonType.secondary,
            width: double.infinity,
            onPressed: () => _logout(context, provider),
          ),
          
          const SizedBox(height: 8),
          
          CustomButton(
            text: AppLocalizations.of(context)!.deleteAccount,
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
            AppLocalizations.of(context)!.about,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildActionTile(
            AppLocalizations.of(context)!.helpSupport,
            AppLocalizations.of(context)!.helpSupportDesc,
            Icons.help_outline,
            _showHelp,
          ),
          
          _buildActionTile(
            AppLocalizations.of(context)!.rateApp,
            AppLocalizations.of(context)!.rateAppDesc,
            Icons.star_outline,
            _rateApp,
          ),
          
          _buildActionTile(
            AppLocalizations.of(context)!.shareApp,
            AppLocalizations.of(context)!.shareAppDesc,
            Icons.share_outlined,
            _shareApp,
          ),
          
          const SizedBox(height: 16),
          
          Center(
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.appTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.version,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.copyright,
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

  Widget _buildLanguageDropdownTile(
    BuildContext context,
    LocalizationProvider localizationProvider,
  ) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.language),
      subtitle: Text(AppLocalizations.of(context)!.appLanguage),
      trailing: DropdownButton<String>(
        value: localizationProvider.currentLanguageCode,
        items: localizationProvider.supportedLanguageCodes.map((code) {
          String displayName;
          switch (code) {
            case 'en':
              displayName = AppLocalizations.of(context)!.english;
              break;
            case 'hi':
              displayName = AppLocalizations.of(context)!.hindi;
              break;
            case 'ml':
              displayName = AppLocalizations.of(context)!.malayalam;
              break;
            default:
              displayName = code;
          }
          return DropdownMenuItem<String>(
            value: code,
            child: Text(displayName),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            localizationProvider.setLanguage(value);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${AppLocalizations.of(context)!.language} ${AppLocalizations.of(context)!.updatedTo} $value'),
              ),
            );
          }
        },
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
        content: Text('$setting notification ${value ? AppLocalizations.of(context)!.enabled : AppLocalizations.of(context)!.disabled}'),
      ),
    );
  }

  void _updateAppSetting(String setting, dynamic value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$setting ${AppLocalizations.of(context)!.updatedTo} $value'),
      ),
    );
  }

  void _updatePrivacySetting(String setting, bool value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$setting ${value ? AppLocalizations.of(context)!.enabled : AppLocalizations.of(context)!.disabled}'),
      ),
    );
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.changePasswordDialogTitle),
        content: Text(AppLocalizations.of(context)!.changePasswordDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.openingPrivacyPolicy),
      ),
    );
  }

  void _showTermsOfService() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.openingTermsOfService),
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.preparingDataExport),
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.clearCacheDialogTitle),
        content: Text(AppLocalizations.of(context)!.clearCacheDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.cacheClearedSuccessfully),
                ),
              );
            },
            child: Text(AppLocalizations.of(context)!.clear),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context, ProfileProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.logoutDialogTitle),
        content: Text(AppLocalizations.of(context)!.logoutDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await provider.logout();
              if (mounted) {
                context.go('/login');
              }
            },
            child: Text(AppLocalizations.of(context)!.logout),
          ),
        ],
      ),
    );
  }

  void _deleteAccount(BuildContext context, ProfileProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteAccountDialogTitle),
        content: Text(AppLocalizations.of(context)!.deleteAccountDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              final success = await provider.deleteAccount();
              if (success && mounted) {
                context.go('/login');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.accountDeletedSuccessfully),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  void _showHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.openingHelpCenter),
      ),
    );
  }

  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.openingAppStore),
      ),
    );
  }

  void _shareApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.sharingApp),
      ),
    );
  }
}
