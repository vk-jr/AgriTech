import 'package:flutter/foundation.dart';

class DashboardProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<WeatherAlert> _weatherAlerts = [];
  List<IrrigationAlert> _irrigationAlerts = [];
  List<SustainabilityTip> _sustainabilityTips = [];
  List<QuickAction> _quickActions = [];
  DashboardStats _stats = DashboardStats();

  bool get isLoading => _isLoading;
  List<WeatherAlert> get weatherAlerts => _weatherAlerts;
  List<IrrigationAlert> get irrigationAlerts => _irrigationAlerts;
  List<SustainabilityTip> get sustainabilityTips => _sustainabilityTips;
  List<QuickAction> get quickActions => _quickActions;
  DashboardStats get stats => _stats;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> loadDashboardData() async {
    _setLoading(true);

    try {
      // Simulate API calls
      await Future.delayed(const Duration(seconds: 1));
      
      _loadMockData();
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
    }
  }

  void _loadMockData() {
    _weatherAlerts = [
      WeatherAlert(
        id: '1',
        title: 'Heavy Rain Expected',
        description: 'Heavy rainfall predicted for next 2 days. Ensure proper drainage.',
        severity: AlertSeverity.medium,
        timestamp: DateTime.now().add(const Duration(hours: 6)),
      ),
      WeatherAlert(
        id: '2',
        title: 'Temperature Drop',
        description: 'Temperature will drop to 5°C tonight. Protect sensitive crops.',
        severity: AlertSeverity.high,
        timestamp: DateTime.now().add(const Duration(hours: 12)),
      ),
    ];

    _irrigationAlerts = [
      IrrigationAlert(
        id: '1',
        cropName: 'Tomatoes',
        fieldLocation: 'Field A-1',
        moistureLevel: 25,
        recommendedAction: 'Water immediately - soil moisture below optimal level',
        urgency: AlertUrgency.high,
      ),
      IrrigationAlert(
        id: '2',
        cropName: 'Wheat',
        fieldLocation: 'Field B-2',
        moistureLevel: 45,
        recommendedAction: 'Monitor closely - watering may be needed in 2 days',
        urgency: AlertUrgency.medium,
      ),
    ];

    _sustainabilityTips = [
      SustainabilityTip(
        id: '1',
        title: 'Companion Planting',
        description: 'Plant marigolds with tomatoes to naturally repel pests and improve soil health.',
        category: 'Biodiversity',
        impactScore: 8,
      ),
      SustainabilityTip(
        id: '2',
        title: 'Rainwater Harvesting',
        description: 'Collect rainwater in barrels to reduce irrigation costs and conserve water.',
        category: 'Water Conservation',
        impactScore: 9,
      ),
      SustainabilityTip(
        id: '3',
        title: 'Crop Rotation',
        description: 'Rotate legumes with cereals to naturally fix nitrogen in the soil.',
        category: 'Soil Health',
        impactScore: 10,
      ),
    ];

    _quickActions = [
      QuickAction(
        id: '1',
        title: 'Crop Suggestion',
        description: 'Get AI-powered crop recommendations',
        icon: 'brain',
        route: '/ai-tools/crop-suggestion',
      ),
      QuickAction(
        id: '2',
        title: 'Plant Doctor',
        description: 'Diagnose plant diseases with AI',
        icon: 'medical-bag',
        route: '/ai-tools/plant-doctor',
      ),
      QuickAction(
        id: '3',
        title: 'Market Prices',
        description: 'Check current market rates',
        icon: 'chart-line',
        route: '/market',
      ),
      QuickAction(
        id: '4',
        title: 'Community Forum',
        description: 'Connect with other farmers',
        icon: 'forum',
        route: '/community',
      ),
    ];

    _stats = DashboardStats(
      activeCrops: 8,
      totalYield: 2.5,
      monthlyRevenue: 45000,
      waterSaved: 1200,
      sustainabilityScore: 85,
    );
  }

  Future<void> refreshData() async {
    await loadDashboardData();
  }

  void dismissAlert(String alertId, AlertType type) {
    switch (type) {
      case AlertType.weather:
        _weatherAlerts.removeWhere((alert) => alert.id == alertId);
        break;
      case AlertType.irrigation:
        _irrigationAlerts.removeWhere((alert) => alert.id == alertId);
        break;
    }
    notifyListeners();
  }
}

class WeatherAlert {
  final String id;
  final String title;
  final String description;
  final AlertSeverity severity;
  final DateTime timestamp;

  WeatherAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.timestamp,
  });
}

class IrrigationAlert {
  final String id;
  final String cropName;
  final String fieldLocation;
  final int moistureLevel;
  final String recommendedAction;
  final AlertUrgency urgency;

  IrrigationAlert({
    required this.id,
    required this.cropName,
    required this.fieldLocation,
    required this.moistureLevel,
    required this.recommendedAction,
    required this.urgency,
  });
}

class SustainabilityTip {
  final String id;
  final String title;
  final String description;
  final String category;
  final int impactScore;

  SustainabilityTip({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.impactScore,
  });
}

class QuickAction {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String route;

  QuickAction({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
  });
}

class DashboardStats {
  final int activeCrops;
  final double totalYield;
  final double monthlyRevenue;
  final double waterSaved;
  final int sustainabilityScore;

  DashboardStats({
    this.activeCrops = 0,
    this.totalYield = 0.0,
    this.monthlyRevenue = 0.0,
    this.waterSaved = 0.0,
    this.sustainabilityScore = 0,
  });
}

enum AlertSeverity { low, medium, high, critical }
enum AlertUrgency { low, medium, high }
enum AlertType { weather, irrigation }
