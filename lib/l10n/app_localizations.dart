import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ml.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('ml')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'AgriTech App'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @receiveAllNotifications.
  ///
  /// In en, this message translates to:
  /// **'Receive all notifications'**
  String get receiveAllNotifications;

  /// No description provided for @notificationTypes.
  ///
  /// In en, this message translates to:
  /// **'Notification Types'**
  String get notificationTypes;

  /// No description provided for @newPosts.
  ///
  /// In en, this message translates to:
  /// **'New Posts'**
  String get newPosts;

  /// No description provided for @newPostsDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified about new community posts'**
  String get newPostsDesc;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @commentsDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified when someone comments on your posts'**
  String get commentsDesc;

  /// No description provided for @likes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get likes;

  /// No description provided for @likesDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified when someone likes your content'**
  String get likesDesc;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @ordersDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified about order updates'**
  String get ordersDesc;

  /// No description provided for @weatherAlerts.
  ///
  /// In en, this message translates to:
  /// **'Weather Alerts'**
  String get weatherAlerts;

  /// No description provided for @weatherAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive weather warnings and alerts'**
  String get weatherAlertsDesc;

  /// No description provided for @marketUpdates.
  ///
  /// In en, this message translates to:
  /// **'Market Updates'**
  String get marketUpdates;

  /// No description provided for @marketUpdatesDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified about market price changes'**
  String get marketUpdatesDesc;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get lightTheme;

  /// No description provided for @lightThemeDesc.
  ///
  /// In en, this message translates to:
  /// **'Use light colors and white background'**
  String get lightThemeDesc;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// No description provided for @darkThemeDesc.
  ///
  /// In en, this message translates to:
  /// **'Use dark colors and black background'**
  String get darkThemeDesc;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System Theme'**
  String get systemTheme;

  /// No description provided for @systemThemeDesc.
  ///
  /// In en, this message translates to:
  /// **'Follow your device theme settings'**
  String get systemThemeDesc;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguage;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @displayCurrency.
  ///
  /// In en, this message translates to:
  /// **'Display currency'**
  String get displayCurrency;

  /// No description provided for @temperatureUnit.
  ///
  /// In en, this message translates to:
  /// **'Temperature Unit'**
  String get temperatureUnit;

  /// No description provided for @temperatureDisplay.
  ///
  /// In en, this message translates to:
  /// **'Temperature display'**
  String get temperatureDisplay;

  /// No description provided for @measurementUnit.
  ///
  /// In en, this message translates to:
  /// **'Measurement Unit'**
  String get measurementUnit;

  /// No description provided for @measurementUnitDesc.
  ///
  /// In en, this message translates to:
  /// **'Distance and area measurements'**
  String get measurementUnitDesc;

  /// No description provided for @privacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurity;

  /// No description provided for @profileVisibility.
  ///
  /// In en, this message translates to:
  /// **'Profile Visibility'**
  String get profileVisibility;

  /// No description provided for @profileVisibilityDesc.
  ///
  /// In en, this message translates to:
  /// **'Make your profile visible to other users'**
  String get profileVisibilityDesc;

  /// No description provided for @locationSharing.
  ///
  /// In en, this message translates to:
  /// **'Location Sharing'**
  String get locationSharing;

  /// No description provided for @locationSharingDesc.
  ///
  /// In en, this message translates to:
  /// **'Share your location for better recommendations'**
  String get locationSharingDesc;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changePasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Update your account password'**
  String get changePasswordDesc;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyDesc.
  ///
  /// In en, this message translates to:
  /// **'Read our privacy policy'**
  String get privacyPolicyDesc;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @termsOfServiceDesc.
  ///
  /// In en, this message translates to:
  /// **'Read our terms of service'**
  String get termsOfServiceDesc;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @exportDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Download your account data'**
  String get exportDataDesc;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @clearCacheDesc.
  ///
  /// In en, this message translates to:
  /// **'Free up storage space'**
  String get clearCacheDesc;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @helpSupportDesc.
  ///
  /// In en, this message translates to:
  /// **'Get help or contact support'**
  String get helpSupportDesc;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @rateAppDesc.
  ///
  /// In en, this message translates to:
  /// **'Rate us on the app store'**
  String get rateAppDesc;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @shareAppDesc.
  ///
  /// In en, this message translates to:
  /// **'Share with friends and family'**
  String get shareAppDesc;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0 (Build 1)'**
  String get version;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2024 AgriTech Solutions'**
  String get copyright;

  /// No description provided for @pleaseLoginToAccessSettings.
  ///
  /// In en, this message translates to:
  /// **'Please log in to access settings'**
  String get pleaseLoginToAccessSettings;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @malayalam.
  ///
  /// In en, this message translates to:
  /// **'Malayalam'**
  String get malayalam;

  /// No description provided for @indianRupee.
  ///
  /// In en, this message translates to:
  /// **'Indian Rupee (₹)'**
  String get indianRupee;

  /// No description provided for @usDollar.
  ///
  /// In en, this message translates to:
  /// **'US Dollar (\$)'**
  String get usDollar;

  /// No description provided for @euro.
  ///
  /// In en, this message translates to:
  /// **'Euro (€)'**
  String get euro;

  /// No description provided for @celsius.
  ///
  /// In en, this message translates to:
  /// **'Celsius (°C)'**
  String get celsius;

  /// No description provided for @fahrenheit.
  ///
  /// In en, this message translates to:
  /// **'Fahrenheit (°F)'**
  String get fahrenheit;

  /// No description provided for @metric.
  ///
  /// In en, this message translates to:
  /// **'Metric (km, hectares)'**
  String get metric;

  /// No description provided for @imperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial (miles, acres)'**
  String get imperial;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'disabled'**
  String get disabled;

  /// No description provided for @updatedTo.
  ///
  /// In en, this message translates to:
  /// **'updated to'**
  String get updatedTo;

  /// No description provided for @changePasswordDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordDialogTitle;

  /// No description provided for @changePasswordDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Password change feature will be implemented in the full version.'**
  String get changePasswordDialogContent;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @openingPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Opening privacy policy...'**
  String get openingPrivacyPolicy;

  /// No description provided for @openingTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Opening terms of service...'**
  String get openingTermsOfService;

  /// No description provided for @preparingDataExport.
  ///
  /// In en, this message translates to:
  /// **'Preparing data export...'**
  String get preparingDataExport;

  /// No description provided for @clearCacheDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCacheDialogTitle;

  /// No description provided for @clearCacheDialogContent.
  ///
  /// In en, this message translates to:
  /// **'This will clear all cached data. Are you sure?'**
  String get clearCacheDialogContent;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @cacheClearedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully'**
  String get cacheClearedSuccessfully;

  /// No description provided for @logoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutDialogTitle;

  /// No description provided for @logoutDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutDialogContent;

  /// No description provided for @deleteAccountDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountDialogTitle;

  /// No description provided for @deleteAccountDialogContent.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All your data will be permanently deleted. Are you sure?'**
  String get deleteAccountDialogContent;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @accountDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeletedSuccessfully;

  /// No description provided for @openingHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Opening help center...'**
  String get openingHelpCenter;

  /// No description provided for @openingAppStore.
  ///
  /// In en, this message translates to:
  /// **'Opening app store...'**
  String get openingAppStore;

  /// No description provided for @sharingApp.
  ///
  /// In en, this message translates to:
  /// **'Sharing app...'**
  String get sharingApp;

  /// No description provided for @agritechDashboard.
  ///
  /// In en, this message translates to:
  /// **'AgriTech Dashboard'**
  String get agritechDashboard;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}!'**
  String welcomeBack(Object name);

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @farmOverview.
  ///
  /// In en, this message translates to:
  /// **'Farm Overview'**
  String get farmOverview;

  /// No description provided for @activeCrops.
  ///
  /// In en, this message translates to:
  /// **'Active Crops'**
  String get activeCrops;

  /// No description provided for @totalYield.
  ///
  /// In en, this message translates to:
  /// **'Total Yield'**
  String get totalYield;

  /// No description provided for @monthlyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get monthlyRevenue;

  /// No description provided for @waterSaved.
  ///
  /// In en, this message translates to:
  /// **'Water Saved'**
  String get waterSaved;

  /// No description provided for @alertsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Alerts & Notifications'**
  String get alertsNotifications;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @aiTools.
  ///
  /// In en, this message translates to:
  /// **'AI Tools'**
  String get aiTools;

  /// No description provided for @market.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get market;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @sustainability.
  ///
  /// In en, this message translates to:
  /// **'Sustainability'**
  String get sustainability;

  /// No description provided for @weatherForecast.
  ///
  /// In en, this message translates to:
  /// **'Weather Forecast'**
  String get weatherForecast;

  /// No description provided for @soilHealth.
  ///
  /// In en, this message translates to:
  /// **'Soil Health'**
  String get soilHealth;

  /// No description provided for @cropRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Crop Recommendations'**
  String get cropRecommendations;

  /// No description provided for @irrigationSchedule.
  ///
  /// In en, this message translates to:
  /// **'Irrigation Schedule'**
  String get irrigationSchedule;

  /// No description provided for @pestControl.
  ///
  /// In en, this message translates to:
  /// **'Pest Control'**
  String get pestControl;

  /// No description provided for @fertilizerGuide.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer Guide'**
  String get fertilizerGuide;

  /// No description provided for @marketPrices.
  ///
  /// In en, this message translates to:
  /// **'Market Prices'**
  String get marketPrices;

  /// No description provided for @sellProduce.
  ///
  /// In en, this message translates to:
  /// **'Sell Produce'**
  String get sellProduce;

  /// No description provided for @buySupplies.
  ///
  /// In en, this message translates to:
  /// **'Buy Supplies'**
  String get buySupplies;

  /// No description provided for @connectFarmers.
  ///
  /// In en, this message translates to:
  /// **'Connect with Farmers'**
  String get connectFarmers;

  /// No description provided for @askQuestions.
  ///
  /// In en, this message translates to:
  /// **'Ask Questions'**
  String get askQuestions;

  /// No description provided for @shareExperience.
  ///
  /// In en, this message translates to:
  /// **'Share Experience'**
  String get shareExperience;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @carbonFootprint.
  ///
  /// In en, this message translates to:
  /// **'Carbon Footprint'**
  String get carbonFootprint;

  /// No description provided for @waterUsage.
  ///
  /// In en, this message translates to:
  /// **'Water Usage'**
  String get waterUsage;

  /// No description provided for @organicPractices.
  ///
  /// In en, this message translates to:
  /// **'Organic Practices'**
  String get organicPractices;

  /// No description provided for @renewableEnergy.
  ///
  /// In en, this message translates to:
  /// **'Renewable Energy'**
  String get renewableEnergy;

  /// No description provided for @aiPoweredAgriculture.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Agriculture'**
  String get aiPoweredAgriculture;

  /// No description provided for @aiDescription.
  ///
  /// In en, this message translates to:
  /// **'Leverage artificial intelligence to make smarter farming decisions'**
  String get aiDescription;

  /// No description provided for @aiTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: Take clear, well-lit photos for better AI analysis results'**
  String get aiTip;

  /// No description provided for @plantDoctor.
  ///
  /// In en, this message translates to:
  /// **'Plant Doctor'**
  String get plantDoctor;

  /// No description provided for @plantDoctorDesc.
  ///
  /// In en, this message translates to:
  /// **'Diagnose plant diseases and get treatment recommendations'**
  String get plantDoctorDesc;

  /// No description provided for @cropSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Crop Suggestions'**
  String get cropSuggestions;

  /// No description provided for @cropSuggestionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Get AI-powered crop recommendations based on your soil and climate'**
  String get cropSuggestionsDesc;

  /// No description provided for @arViewer.
  ///
  /// In en, this message translates to:
  /// **'AR Viewer'**
  String get arViewer;

  /// No description provided for @arViewerDesc.
  ///
  /// In en, this message translates to:
  /// **'Visualize crops and farming equipment in augmented reality'**
  String get arViewerDesc;

  /// No description provided for @satelliteAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Satellite Analysis'**
  String get satelliteAnalysis;

  /// No description provided for @satelliteAnalysisDesc.
  ///
  /// In en, this message translates to:
  /// **'Analyze your farmland using satellite imagery'**
  String get satelliteAnalysisDesc;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @smartIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Smart Irrigation'**
  String get smartIrrigation;

  /// No description provided for @smartIrrigationDesc.
  ///
  /// In en, this message translates to:
  /// **'AI-optimized irrigation scheduling'**
  String get smartIrrigationDesc;

  /// No description provided for @yieldPrediction.
  ///
  /// In en, this message translates to:
  /// **'Yield Prediction'**
  String get yieldPrediction;

  /// No description provided for @yieldPredictionDesc.
  ///
  /// In en, this message translates to:
  /// **'Predict crop yields using machine learning'**
  String get yieldPredictionDesc;

  /// No description provided for @weatherInsights.
  ///
  /// In en, this message translates to:
  /// **'Weather Insights'**
  String get weatherInsights;

  /// No description provided for @weatherInsightsDesc.
  ///
  /// In en, this message translates to:
  /// **'Advanced weather analysis and predictions'**
  String get weatherInsightsDesc;

  /// No description provided for @mainAiTools.
  ///
  /// In en, this message translates to:
  /// **'Main AI Tools'**
  String get mainAiTools;

  /// No description provided for @cropSuggestionAi.
  ///
  /// In en, this message translates to:
  /// **'Crop Suggestion AI'**
  String get cropSuggestionAi;

  /// No description provided for @cropSuggestionAiDesc.
  ///
  /// In en, this message translates to:
  /// **'Get personalized crop recommendations based on your soil, climate, and market conditions'**
  String get cropSuggestionAiDesc;

  /// No description provided for @plantRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Plant Recommendation'**
  String get plantRecommendation;

  /// No description provided for @plantRecommendationDesc.
  ///
  /// In en, this message translates to:
  /// **'Get personalized plant suggestions perfect for your conditions and small-scale growing'**
  String get plantRecommendationDesc;

  /// No description provided for @plantDoctorDesc2.
  ///
  /// In en, this message translates to:
  /// **'Upload photos of diseased plants to get instant AI diagnosis and treatment recommendations'**
  String get plantDoctorDesc2;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @smart.
  ///
  /// In en, this message translates to:
  /// **'Smart'**
  String get smart;

  /// No description provided for @newLabel.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newLabel;

  /// No description provided for @additionalTools.
  ///
  /// In en, this message translates to:
  /// **'Additional Tools'**
  String get additionalTools;

  /// No description provided for @arPlantLayout.
  ///
  /// In en, this message translates to:
  /// **'AR Plant Layout'**
  String get arPlantLayout;

  /// No description provided for @arPlantLayoutDesc.
  ///
  /// In en, this message translates to:
  /// **'Visualize crop layouts in your space using augmented reality'**
  String get arPlantLayoutDesc;

  /// No description provided for @weatherPrediction.
  ///
  /// In en, this message translates to:
  /// **'Weather Prediction'**
  String get weatherPrediction;

  /// No description provided for @weatherPredictionDesc.
  ///
  /// In en, this message translates to:
  /// **'AI-powered weather forecasts for better farming decisions'**
  String get weatherPredictionDesc;

  /// No description provided for @soilAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'Soil Analysis'**
  String get soilAnalysisTitle;

  /// No description provided for @soilAnalysisDesc.
  ///
  /// In en, this message translates to:
  /// **'Upload soil photos for AI-powered nutrient analysis'**
  String get soilAnalysisDesc;

  /// No description provided for @moreFeatures.
  ///
  /// In en, this message translates to:
  /// **'More Features'**
  String get moreFeatures;

  /// No description provided for @satelliteFarmAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Satellite Farm Analysis'**
  String get satelliteFarmAnalysis;

  /// No description provided for @satelliteFarmAnalysisDesc.
  ///
  /// In en, this message translates to:
  /// **'Get real-time satellite monitoring and AI-powered analysis of your farm. Monitor crop health, soil conditions, and get smart recommendations.'**
  String get satelliteFarmAnalysisDesc;

  /// No description provided for @exploreSatelliteAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Explore Satellite Analysis'**
  String get exploreSatelliteAnalysis;

  /// No description provided for @weatherPredictionComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Weather prediction feature coming soon!'**
  String get weatherPredictionComingSoon;

  /// No description provided for @soilAnalysisComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Soil analysis feature coming soon!'**
  String get soilAnalysisComingSoon;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @locating.
  ///
  /// In en, this message translates to:
  /// **'Locating...'**
  String get locating;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'ml'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'ml':
      return AppLocalizationsMl();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
