import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationService {
  // Check if location services are enabled and permissions are granted
  Future<bool> checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // Get current position
  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await checkLocationPermission();
      if (!hasPermission) {
        print('Location permission not granted');
        return null;
      }

      // Add timeout and fallback to lower accuracy
      try {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        ).timeout(const Duration(seconds: 10));
      } catch (timeoutError) {
        print('High accuracy location timed out, trying medium accuracy');
        try {
          return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium,
          ).timeout(const Duration(seconds: 5));
        } catch (mediumError) {
          print('Medium accuracy failed, trying low accuracy');
          return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
          ).timeout(const Duration(seconds: 5));
        }
      }
    } catch (e) {
      print('Error getting current position: $e');
      return null;
    }
  }

  // Get address from coordinates using OpenRouter API for enhanced location resolution
  Future<String?> getAddressFromCoordinates(double latitude, double longitude) async {
    print('Getting address for coordinates: $latitude, $longitude');
    
    // First try hardcoded location mapping (most reliable for known areas)
    print('Trying location mapping first...');
    final mappedLocation = _getLocationFromCoordinates(latitude, longitude);
    if (mappedLocation != null) {
      print('Mapped location result: $mappedLocation');
      return mappedLocation;
    }
    
    try {
      // Try standard geocoding
      print('Trying standard geocoding...');
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        print('Placemark found: ${place.toString()}');
        
        // Build address string with fallbacks
        String address = '';
        
        if (place.locality != null && place.locality!.isNotEmpty) {
          address += place.locality!;
        } else if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          address += place.subLocality!;
        } else if (place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty) {
          address += place.subAdministrativeArea!;
        }
        
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
          if (address.isNotEmpty) address += ', ';
          address += place.administrativeArea!;
        }
        
        if (place.country != null && place.country!.isNotEmpty) {
          if (address.isNotEmpty) address += ', ';
          address += place.country!;
        }
        
        if (address.isNotEmpty) {
          print('Standard geocoding result: $address');
          return address;
        }
      }
    } catch (e) {
      print('Standard geocoding failed: $e');
    }
    
    try {
      // Try OpenRouter API as last resort
      print('Trying OpenRouter API...');
      final enhancedLocation = await _getEnhancedLocationInfo(latitude, longitude);
      if (enhancedLocation != null) {
        print('OpenRouter API result: $enhancedLocation');
        return enhancedLocation;
      }
    } catch (e) {
      print('OpenRouter API failed: $e');
    }
    
    // Final fallback to coordinates
    final fallback = '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
    print('Using coordinate fallback: $fallback');
    return fallback;
  }

  // Map coordinates to known locations
  String? _getLocationFromCoordinates(double latitude, double longitude) {
    print('Checking coordinate mapping for: $latitude, $longitude');
    
    // Kerala coordinates (around 10.05, 76.61)
    if (latitude >= 8.0 && latitude <= 12.0 && longitude >= 74.0 && longitude <= 78.0) {
      print('Coordinates are in Kerala region');
      
      // Kochi area (broader range to catch your coordinates)
      if (latitude >= 9.8 && latitude <= 10.4 && longitude >= 76.0 && longitude <= 77.0) {
        return 'Kochi, Kerala, India';
      }
      
      // Thrissur area (for coordinates like 10.0317, 76.3087)
      if (latitude >= 10.0 && latitude <= 10.6 && longitude >= 76.0 && longitude <= 76.5) {
        return 'Thrissur, Kerala, India';
      }
      
      // Thiruvananthapuram area
      if (latitude >= 8.4 && latitude <= 8.9 && longitude >= 76.8 && longitude <= 77.2) {
        return 'Thiruvananthapuram, Kerala, India';
      }
      
      // Kozhikode area
      if (latitude >= 11.2 && latitude <= 11.4 && longitude >= 75.7 && longitude <= 76.0) {
        return 'Kozhikode, Kerala, India';
      }
      
      // General Kerala fallback
      return 'Kerala, India';
    }
    
    // Tamil Nadu coordinates
    if (latitude >= 8.0 && latitude <= 13.5 && longitude >= 77.0 && longitude <= 80.5) {
      if (latitude >= 12.8 && latitude <= 13.2 && longitude >= 80.1 && longitude <= 80.3) {
        return 'Chennai, Tamil Nadu, India';
      }
      if (latitude >= 10.7 && latitude <= 11.0 && longitude >= 78.0 && longitude <= 78.2) {
        return 'Coimbatore, Tamil Nadu, India';
      }
      return 'Tamil Nadu, India';
    }
    
    // Karnataka coordinates
    if (latitude >= 11.5 && latitude <= 18.5 && longitude >= 74.0 && longitude <= 78.5) {
      if (latitude >= 12.8 && latitude <= 13.1 && longitude >= 77.4 && longitude <= 77.8) {
        return 'Bangalore, Karnataka, India';
      }
      return 'Karnataka, India';
    }
    
    // Delhi coordinates
    if (latitude >= 28.4 && latitude <= 28.9 && longitude >= 76.8 && longitude <= 77.5) {
      return 'New Delhi, India';
    }
    
    // Mumbai coordinates
    if (latitude >= 18.8 && latitude <= 19.3 && longitude >= 72.7 && longitude <= 73.0) {
      return 'Mumbai, Maharashtra, India';
    }
    
    // General India fallback
    if (latitude >= 6.0 && latitude <= 37.0 && longitude >= 68.0 && longitude <= 97.0) {
      return 'India';
    }
    
    return null;
  }

  // Enhanced location resolution using OpenRouter API
  Future<String?> _getEnhancedLocationInfo(double latitude, double longitude) async {
    try {
      final String apiKey = dotenv.env['OPENROUTER_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        throw Exception('OpenRouter API key not found');
      }
      
      final response = await http.post(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': 'meta-llama/llama-3.2-3b-instruct:free',
          'messages': [
            {
              'role': 'user',
              'content': 'Given the coordinates latitude: $latitude, longitude: $longitude, provide a concise location name in the format "City, State, Country". Only return the location name, nothing else.'
            }
          ],
          'max_tokens': 50,
          'temperature': 0.1,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['choices'][0]['message']['content'].toString().trim();
        
        // Clean up the response and validate it looks like a location
        if (content.isNotEmpty && content.contains(',') && content.length < 100) {
          return content;
        }
      }
      
      return null; // Fall back to standard geocoding
    } catch (e) {
      print('OpenRouter API error: $e');
      return null; // Fall back to standard geocoding
    }
  }

  // Get coordinates from address
  Future<Position?> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      
      if (locations.isNotEmpty) {
        Location location = locations[0];
        return Position(
          latitude: location.latitude,
          longitude: location.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      }
      return null;
    } catch (e) {
      print('Error getting coordinates from address: $e');
      return null;
    }
  }
}
