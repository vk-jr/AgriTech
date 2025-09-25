import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/theme_provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/home/providers/dashboard_provider.dart';
import 'features/ai_tools/providers/crop_suggestion_provider.dart';
import 'features/ai_tools/providers/plant_doctor_provider.dart';
import 'features/market/providers/market_provider.dart';
import 'features/community/providers/community_provider.dart';
import 'features/profile/providers/profile_provider.dart';
import 'features/weather/providers/weather_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize theme provider
  final themeProvider = ThemeProvider();
  await themeProvider.initializeTheme();
  
  runApp(AgriTechApp(themeProvider: themeProvider));
}

class AgriTechApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  
  const AgriTechApp({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => CropSuggestionProvider()),
        ChangeNotifierProvider(create: (_) => PlantDoctorProvider()),
        ChangeNotifierProvider(create: (_) => MarketProvider()),
        ChangeNotifierProvider(create: (_) => CommunityProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'AgriTech App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.materialThemeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
