import 'package:flutter/foundation.dart';
import '../../../core/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock user data
      _currentUser = UserModel(
        id: '1',
        name: 'John Farmer',
        email: email,
        phoneNumber: '+1234567890',
        userType: UserType.farmer,
        location: 'Punjab, India',
        profileImageUrl: null,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        preferences: UserPreferences(
          language: 'en',
          voiceNavigationEnabled: false,
          interestedCrops: ['wheat', 'rice', 'corn'],
        ),
        gamificationStats: GamificationStats(
          totalXP: 1250,
          level: 3,
          badges: ['first_crop', 'disease_detective', 'market_trader'],
          plantsGrown: 15,
          diseasesDiagnosed: 8,
          marketTransactions: 5,
          forumPosts: 12,
        ),
      );
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Login failed. Please check your credentials.');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required UserType userType,
    String? phoneNumber,
    String? location,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      _currentUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        userType: userType,
        location: location,
        profileImageUrl: null,
        createdAt: DateTime.now(),
        preferences: UserPreferences(),
        gamificationStats: GamificationStats(),
      );
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Registration failed. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    _setLoading(true);
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      _currentUser = updatedUser;
      _setLoading(false);
    } catch (e) {
      _setError('Failed to update profile.');
      _setLoading(false);
    }
  }

  void clearError() {
    _setError(null);
  }
}
