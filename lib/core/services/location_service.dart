import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    try {
      // First try to get enhanced location using OpenRouter API
      final enhancedLocation = await _getEnhancedLocationInfo(latitude, longitude);
      if (enhancedLocation != null) {
        return enhancedLocation;
      }
      
      // Fallback to standard geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        
        // Build address string with fallbacks
        String address = '';
        
        if (place.locality != null && place.locality!.isNotEmpty) {
          address += place.locality!;
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
        
        return address.isNotEmpty ? address : 'Location: ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
      }
      return 'Location: ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
    } catch (e) {
      print('Error getting address from coordinates: $e');
      return 'Location: ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
    }
  }

  // Enhanced location resolution using OpenRouter API
  Future<String?> _getEnhancedLocationInfo(double latitude, double longitude) async {
    try {
      const String apiKey = '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';
      
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
