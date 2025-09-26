import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/localization_provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/home/providers/dashboard_provider.dart';
import 'features/ai_tools/providers/crop_suggestion_provider.dart';
import 'features/ai_tools/providers/plant_doctor_provider.dart';
import 'features/ai_tools/providers/soil_analysis_provider.dart';
import 'features/market/providers/market_provider.dart';
import 'features/community/providers/community_provider.dart';
import 'features/community/providers/farm_collab_provider.dart';
import 'features/profile/providers/profile_provider.dart';
import 'features/chat/providers/chat_provider.dart';
import 'features/leaderboard/providers/leaderboard_provider.dart';
import 'l10n/app_localizations.dart';
import 'features/weather/providers/weather_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize theme provider
  final themeProvider = ThemeProvider();
  await themeProvider.initializeTheme();
  
  // Initialize localization provider
  final localizationProvider = LocalizationProvider();
  
  runApp(AgriTechApp(
    themeProvider: themeProvider,
    localizationProvider: localizationProvider,
  ));
}

class AgriTechApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  final LocalizationProvider localizationProvider;
  
  const AgriTechApp({
    super.key, 
    required this.themeProvider,
    required this.localizationProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: localizationProvider),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => CropSuggestionProvider()),
        ChangeNotifierProvider(create: (_) => PlantDoctorProvider()),
        ChangeNotifierProvider(create: (_) => SoilAnalysisProvider()),
        ChangeNotifierProvider(create: (_) => MarketProvider()),
        ChangeNotifierProvider(create: (_) => CommunityProvider()),
        ChangeNotifierProvider(create: (_) => FarmCollabProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => LeaderboardProvider()),
      ],
      child: Consumer2<ThemeProvider, LocalizationProvider>(
        builder: (context, themeProvider, localizationProvider, child) {
          return MaterialApp.router(
            title: 'AgriTech App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.materialThemeMode,
            locale: localizationProvider.currentLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LocalizationProvider.supportedLocales,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
