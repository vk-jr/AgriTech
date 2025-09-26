import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  static String get _apiKey => dotenv.env['OPENWEATHERMAP_API_KEY'] ?? '';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Get current weather by coordinates
  Future<Map<String, dynamic>> getCurrentWeather(double lat, double lon) async {
    try {
      final url = '$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }

  // Get 5-day weather forecast
  Future<Map<String, dynamic>> getWeatherForecast(double lat, double lon) async {
    try {
      final url = '$_baseUrl/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=metric';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load forecast data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching forecast data: $e');
    }
  }

  // Get weather by city name
  Future<Map<String, dynamic>> getWeatherByCity(String cityName) async {
    try {
      final url = '$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data for $cityName: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather data for $cityName: $e');
    }
  }

  // Get historical weather data (simulated since OpenWeatherMap historical data requires paid plan)
  Future<List<Map<String, dynamic>>> getHistoricalWeather(double lat, double lon, int days) async {
    try {
      // Since historical data requires paid plan, we'll simulate it based on current weather
      final currentWeather = await getCurrentWeather(lat, lon);
      final List<Map<String, dynamic>> historicalData = [];
      
      final baseTemp = currentWeather['main']['temp'];
      final baseHumidity = currentWeather['main']['humidity'];
      
      for (int i = days; i >= 1; i--) {
        final date = DateTime.now().subtract(Duration(days: i));
        // Simulate temperature variations (±5°C from current)
        final tempVariation = (i % 3 - 1) * 2.5 + (i % 2 == 0 ? 1 : -1) * 1.5;
        final humidityVariation = (i % 4 - 2) * 5;
        
        historicalData.add({
          'date': date,
          'temp': baseTemp + tempVariation,
          'humidity': (baseHumidity + humidityVariation).clamp(0, 100),
          'weather': _getSimulatedWeather(baseTemp + tempVariation),
        });
      }
      
      return historicalData;
    } catch (e) {
      print('Error generating historical weather: $e');
      return [];
    }
  }

  // Get extended forecast (7-14 days) - simulated
  Future<List<Map<String, dynamic>>> getExtendedForecast(double lat, double lon) async {
    try {
      final forecast = await getWeatherForecast(lat, lon);
      final List<Map<String, dynamic>> extendedData = [];
      
      // Get base data from 5-day forecast
      final forecastList = forecast['list'] as List;
      final baseTemp = forecastList.isNotEmpty ? forecastList[0]['main']['temp'] : 20.0;
      
      for (int i = 6; i <= 14; i++) {
        final date = DateTime.now().add(Duration(days: i));
        // Simulate future weather trends
        final tempTrend = (i % 5 - 2) * 1.8 + (i > 10 ? -2 : 1);
        final temp = baseTemp + tempTrend;
        
        extendedData.add({
          'date': date,
          'temp': temp,
          'humidity': (65 + (i % 6 - 3) * 8).clamp(30, 90),
          'weather': _getSimulatedWeather(temp),
        });
      }
      
      return extendedData;
    } catch (e) {
      print('Error generating extended forecast: $e');
      return [];
    }
  }

  String _getSimulatedWeather(double temp) {
    if (temp > 30) return 'Clear';
    if (temp > 25) return 'Clouds';
    if (temp > 15) return 'Rain';
    return 'Clouds';
  }

  // Get agricultural weather alerts and recommendations
  Future<List<WeatherAlert>> getAgriculturalAlerts(double lat, double lon) async {
    try {
      final currentWeather = await getCurrentWeather(lat, lon);
      final forecast = await getWeatherForecast(lat, lon);
      
      List<WeatherAlert> alerts = [];
      
      // Analyze current conditions
      final temp = currentWeather['main']['temp'];
      final humidity = currentWeather['main']['humidity'];
      final windSpeed = currentWeather['wind']['speed'];
      
      // Temperature alerts
      if (temp > 35) {
        alerts.add(WeatherAlert(
          id: 'temp_high_${DateTime.now().millisecondsSinceEpoch}',
          title: 'High Temperature Alert',
          description: 'Temperature is ${temp.round()}°C. Consider increasing irrigation and providing shade for sensitive crops.',
          severity: AlertSeverity.medium,
          type: 'temperature',
        ));
      } else if (temp < 5) {
        alerts.add(WeatherAlert(
          id: 'temp_low_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Frost Warning',
          description: 'Temperature is ${temp.round()}°C. Protect sensitive plants from frost damage.',
          severity: AlertSeverity.high,
          type: 'temperature',
        ));
      }
      
      // Humidity alerts
      if (humidity > 85) {
        alerts.add(WeatherAlert(
          id: 'humidity_high_${DateTime.now().millisecondsSinceEpoch}',
          title: 'High Humidity Alert',
          description: 'Humidity is $humidity%. Monitor for fungal diseases and improve ventilation.',
          severity: AlertSeverity.medium,
          type: 'humidity',
        ));
      }
      
      // Wind alerts
      if (windSpeed > 10) {
        alerts.add(WeatherAlert(
          id: 'wind_high_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Strong Wind Warning',
          description: 'Wind speed is ${windSpeed.round()} m/s. Secure loose structures and protect tall crops.',
          severity: AlertSeverity.medium,
          type: 'wind',
        ));
      }
      
      // Precipitation alerts from forecast
      final forecastList = forecast['list'] as List;
      for (int i = 0; i < 8 && i < forecastList.length; i++) { // Next 24 hours
        final item = forecastList[i];
        if (item['weather'][0]['main'] == 'Rain') {
          final rainVolume = item['rain']?['3h'] ?? 0.0;
          if (rainVolume > 10) {
            alerts.add(WeatherAlert(
              id: 'rain_heavy_${DateTime.now().millisecondsSinceEpoch}',
              title: 'Heavy Rain Expected',
              description: 'Heavy rainfall predicted in next 24 hours. Ensure proper drainage and postpone field activities.',
              severity: AlertSeverity.high,
              type: 'precipitation',
            ));
            break;
          }
        }
      }
      
      return alerts;
    } catch (e) {
      print('Error generating agricultural alerts: $e');
      return [];
    }
  }
}

class WeatherAlert {
  final String id;
  final String title;
  final String description;
  final AlertSeverity severity;
  final String type;

  WeatherAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.type,
  });
}

enum AlertSeverity { low, medium, high, critical }
