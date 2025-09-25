import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/services/weather_service.dart';
import '../../../core/services/location_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  // Current weather data
  Map<String, dynamic>? _currentWeather;
  Map<String, dynamic>? _forecast;
  List<WeatherAlert> _alerts = [];
  Position? _currentPosition;
  String? _currentLocation;
  
  // Historical and extended data
  List<Map<String, dynamic>> _historicalData = [];
  List<Map<String, dynamic>> _extendedForecast = [];

  // Loading states
  bool _isLoadingWeather = false;
  bool _isLoadingLocation = false;
  String? _error;

  // Getters
  Map<String, dynamic>? get currentWeather => _currentWeather;
  Map<String, dynamic>? get forecast => _forecast;
  List<WeatherAlert> get alerts => _alerts;
  Position? get currentPosition => _currentPosition;
  String? get currentLocation => _currentLocation;
  List<Map<String, dynamic>> get historicalData => _historicalData;
  List<Map<String, dynamic>> get extendedForecast => _extendedForecast;
  bool get isLoadingWeather => _isLoadingWeather;
  bool get isLoadingLocation => _isLoadingLocation;
  String? get error => _error;

  // Get current location and weather
  Future<void> getCurrentLocationAndWeather() async {
    _isLoadingLocation = true;
    _isLoadingWeather = true;
    _error = null;
    notifyListeners();

    try {
      // Get current position
      _currentPosition = await _locationService.getCurrentPosition();
      
      if (_currentPosition != null) {
        // Get location name
        print('Getting location name for coordinates: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');
        _currentLocation = await _locationService.getAddressFromCoordinates(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        
        print('Location service returned: $_currentLocation');
        
        // If location name is still null, use coordinates
        if (_currentLocation == null || _currentLocation!.isEmpty) {
          _currentLocation = 'Lat: ${_currentPosition!.latitude.toStringAsFixed(4)}, Lon: ${_currentPosition!.longitude.toStringAsFixed(4)}';
          print('Using coordinate fallback: $_currentLocation');
        }
        
        _isLoadingLocation = false;
        notifyListeners();

        // Get weather data
        await _loadWeatherData(_currentPosition!.latitude, _currentPosition!.longitude);
      } else {
        // Fallback to a default location if GPS fails
        print('GPS location failed, using default location');
        _currentLocation = 'Default Location';
        _currentPosition = Position(
          latitude: 28.6139, // Delhi coordinates as fallback
          longitude: 77.2090,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
        
        _isLoadingLocation = false;
        notifyListeners();
        
        // Get weather data for default location
        await _loadWeatherData(_currentPosition!.latitude, _currentPosition!.longitude);
      }
    } catch (e) {
      _error = e.toString();
      _isLoadingLocation = false;
      _isLoadingWeather = false;
      notifyListeners();
    }
  }

  // Load weather data for specific coordinates
  Future<void> _loadWeatherData(double lat, double lon) async {
    try {
      // Get current weather, forecast, alerts, historical data, and extended forecast
      final weatherFuture = _weatherService.getCurrentWeather(lat, lon);
      final forecastFuture = _weatherService.getWeatherForecast(lat, lon);
      final alertsFuture = _weatherService.getAgriculturalAlerts(lat, lon);
      final historicalFuture = _weatherService.getHistoricalWeather(lat, lon, 7);
      final extendedFuture = _weatherService.getExtendedForecast(lat, lon);

      final results = await Future.wait([
        weatherFuture, 
        forecastFuture, 
        alertsFuture, 
        historicalFuture, 
        extendedFuture
      ]);
      
      _currentWeather = results[0] as Map<String, dynamic>;
      _forecast = results[1] as Map<String, dynamic>;
      _alerts = results[2] as List<WeatherAlert>;
      _historicalData = results[3] as List<Map<String, dynamic>>;
      _extendedForecast = results[4] as List<Map<String, dynamic>>;

      _isLoadingWeather = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoadingWeather = false;
      notifyListeners();
    }
  }

  // Get weather for a specific city
  Future<void> getWeatherByCity(String cityName) async {
    _isLoadingWeather = true;
    _error = null;
    notifyListeners();

    try {
      _currentWeather = await _weatherService.getWeatherByCity(cityName);
      
      // Get coordinates for forecast and alerts
      if (_currentWeather != null) {
        final coord = _currentWeather!['coord'];
        final lat = coord['lat'].toDouble();
        final lon = coord['lon'].toDouble();
        
        final forecastFuture = _weatherService.getWeatherForecast(lat, lon);
        final alertsFuture = _weatherService.getAgriculturalAlerts(lat, lon);
        
        final results = await Future.wait([forecastFuture, alertsFuture]);
        _forecast = results[0] as Map<String, dynamic>;
        _alerts = results[1] as List<WeatherAlert>;
      }

      _isLoadingWeather = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoadingWeather = false;
      notifyListeners();
    }
  }

  // Refresh weather data
  Future<void> refreshWeather() async {
    if (_currentPosition != null) {
      await _loadWeatherData(_currentPosition!.latitude, _currentPosition!.longitude);
    } else {
      await getCurrentLocationAndWeather();
    }
  }

  // Get weather icon based on weather condition
  String getWeatherIcon(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return '☀️';
      case 'clouds':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'drizzle':
        return '🌦️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'mist':
      case 'fog':
        return '🌫️';
      default:
        return '🌤️';
    }
  }

  // Get temperature in Celsius
  String getTemperature() {
    if (_currentWeather != null) {
      final temp = _currentWeather!['main']['temp'];
      return '${temp.round()}°C';
    }
    return '--°C';
  }

  // Get weather description
  String getWeatherDescription() {
    if (_currentWeather != null) {
      return _currentWeather!['weather'][0]['description'];
    }
    return 'No data available';
  }

  // Get humidity
  String getHumidity() {
    if (_currentWeather != null) {
      return '${_currentWeather!['main']['humidity']}%';
    }
    return '--%';
  }

  // Get wind speed
  String getWindSpeed() {
    if (_currentWeather != null) {
      final speed = _currentWeather!['wind']['speed'];
      return '${speed.round()} m/s';
    }
    return '-- m/s';
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
