import 'package:flutter/foundation.dart';
import '../../../core/models/profile_model.dart';

class ProfileProvider extends ChangeNotifier {
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isEditing = false;

  // Getters
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEditing => _isEditing;
  bool get isLoggedIn => _userProfile != null;

  ProfileProvider() {
    _initializeMockProfile();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _setEditing(bool editing) {
    _isEditing = editing;
    notifyListeners();
  }

  Future<void> loadUserProfile() async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // In a real app, this would fetch from an API
      _initializeMockProfile();
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load profile: $e');
      _setLoading(false);
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? bio,
    String? location,
    String? address,
  }) async {
    if (_userProfile == null) return false;

    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      _userProfile = UserProfile(
        id: _userProfile!.id,
        name: name ?? _userProfile!.name,
        email: email ?? _userProfile!.email,
        phone: phone ?? _userProfile!.phone,
        avatarUrl: _userProfile!.avatarUrl,
        bio: bio ?? _userProfile!.bio,
        location: location ?? _userProfile!.location,
        address: address ?? _userProfile!.address,
        joinDate: _userProfile!.joinDate,
        userType: _userProfile!.userType,
        isVerified: _userProfile!.isVerified,
        stats: _userProfile!.stats,
        farmingProfile: _userProfile!.farmingProfile,
        interests: _userProfile!.interests,
        achievements: _userProfile!.achievements,
        preferences: _userProfile!.preferences,
      );

      _setLoading(false);
      _setEditing(false);
      return true;
    } catch (e) {
      _setError('Failed to update profile: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateFarmingProfile({
    double? farmSize,
    String? farmSizeUnit,
    FarmType? farmType,
    List<String>? cropsGrown,
    List<String>? farmingMethods,
    int? yearsOfExperience,
    String? farmName,
    String? farmLocation,
    bool? isOrganic,
    List<String>? certifications,
    String? soilType,
    String? climateZone,
    List<String>? equipment,
  }) async {
    if (_userProfile == null) return false;

    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      final currentFarming = _userProfile!.farmingProfile;
      final updatedFarming = FarmingProfile(
        farmSize: farmSize ?? currentFarming?.farmSize ?? 0.0,
        farmSizeUnit: farmSizeUnit ?? currentFarming?.farmSizeUnit ?? 'acres',
        farmType: farmType ?? currentFarming?.farmType ?? FarmType.mixed,
        cropsGrown: cropsGrown ?? currentFarming?.cropsGrown ?? [],
        farmingMethods: farmingMethods ?? currentFarming?.farmingMethods ?? [],
        yearsOfExperience: yearsOfExperience ?? currentFarming?.yearsOfExperience ?? 0,
        farmName: farmName ?? currentFarming?.farmName,
        farmLocation: farmLocation ?? currentFarming?.farmLocation,
        isOrganic: isOrganic ?? currentFarming?.isOrganic ?? false,
        certifications: certifications ?? currentFarming?.certifications ?? [],
        soilType: soilType ?? currentFarming?.soilType,
        climateZone: climateZone ?? currentFarming?.climateZone,
        equipment: equipment ?? currentFarming?.equipment ?? [],
      );

      _userProfile = UserProfile(
        id: _userProfile!.id,
        name: _userProfile!.name,
        email: _userProfile!.email,
        phone: _userProfile!.phone,
        avatarUrl: _userProfile!.avatarUrl,
        bio: _userProfile!.bio,
        location: _userProfile!.location,
        address: _userProfile!.address,
        joinDate: _userProfile!.joinDate,
        userType: _userProfile!.userType,
        isVerified: _userProfile!.isVerified,
        stats: _userProfile!.stats,
        farmingProfile: updatedFarming,
        interests: _userProfile!.interests,
        achievements: _userProfile!.achievements,
        preferences: _userProfile!.preferences,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update farming profile: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updatePreferences(UserPreferences preferences) async {
    if (_userProfile == null) return false;

    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _userProfile = UserProfile(
        id: _userProfile!.id,
        name: _userProfile!.name,
        email: _userProfile!.email,
        phone: _userProfile!.phone,
        avatarUrl: _userProfile!.avatarUrl,
        bio: _userProfile!.bio,
        location: _userProfile!.location,
        address: _userProfile!.address,
        joinDate: _userProfile!.joinDate,
        userType: _userProfile!.userType,
        isVerified: _userProfile!.isVerified,
        stats: _userProfile!.stats,
        farmingProfile: _userProfile!.farmingProfile,
        interests: _userProfile!.interests,
        achievements: _userProfile!.achievements,
        preferences: preferences,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update preferences: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateAvatar(String avatarUrl) async {
    if (_userProfile == null) return false;

    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      _userProfile = UserProfile(
        id: _userProfile!.id,
        name: _userProfile!.name,
        email: _userProfile!.email,
        phone: _userProfile!.phone,
        avatarUrl: avatarUrl,
        bio: _userProfile!.bio,
        location: _userProfile!.location,
        address: _userProfile!.address,
        joinDate: _userProfile!.joinDate,
        userType: _userProfile!.userType,
        isVerified: _userProfile!.isVerified,
        stats: _userProfile!.stats,
        farmingProfile: _userProfile!.farmingProfile,
        interests: _userProfile!.interests,
        achievements: _userProfile!.achievements,
        preferences: _userProfile!.preferences,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update avatar: $e');
      _setLoading(false);
      return false;
    }
  }

  void startEditing() {
    _setEditing(true);
  }

  void cancelEditing() {
    _setEditing(false);
  }

  Future<void> logout() async {
    _setLoading(true);
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      _userProfile = null;
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to logout: $e');
      _setLoading(false);
    }
  }

  Future<bool> deleteAccount() async {
    if (_userProfile == null) return false;

    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 3));
      
      _userProfile = null;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete account: $e');
      _setLoading(false);
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _initializeMockProfile() {
    _userProfile = UserProfile(
      id: 'user123',
      name: 'Rajesh Kumar',
      email: 'rajesh.kumar@example.com',
      phone: '+91 9876543210',
      bio: 'Passionate organic farmer with 8 years of experience. Growing tomatoes, peppers, and leafy greens using sustainable methods.',
      location: 'Pune, Maharashtra',
      address: 'Village Khed, Tal. Khed, Dist. Pune, Maharashtra 412105',
      joinDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
      userType: UserType.farmer,
      isVerified: true,
      stats: UserStats(
        postsCount: 23,
        commentsCount: 156,
        likesReceived: 89,
        helpfulAnswers: 34,
        ordersPlaced: 12,
        ordersSold: 45,
        totalEarnings: 125000.0,
        totalSpent: 25000.0,
        daysActive: 487,
        streakDays: 15,
      ),
      farmingProfile: FarmingProfile(
        farmSize: 2.5,
        farmSizeUnit: 'acres',
        farmType: FarmType.organic,
        cropsGrown: ['Tomatoes', 'Peppers', 'Lettuce', 'Spinach', 'Carrots'],
        farmingMethods: ['Organic', 'Drip Irrigation', 'Composting', 'Crop Rotation'],
        yearsOfExperience: 8,
        farmName: 'Green Valley Organic Farm',
        farmLocation: 'Khed, Pune',
        isOrganic: true,
        certifications: ['Organic Certification', 'Good Agricultural Practices'],
        soilType: 'Red Soil',
        climateZone: 'Semi-Arid',
        equipment: ['Tractor', 'Drip Irrigation System', 'Greenhouse', 'Composting Unit'],
      ),
      interests: ['Organic Farming', 'Sustainable Agriculture', 'Crop Rotation', 'Pest Management'],
      achievements: [
        Achievement(
          id: 'ach1',
          title: 'First Post',
          description: 'Created your first community post',
          iconUrl: 'https://example.com/first-post.png',
          category: AchievementCategory.community,
          earnedAt: DateTime.now().subtract(const Duration(days: 600)),
          points: 10,
          rarity: AchievementRarity.common,
        ),
        Achievement(
          id: 'ach2',
          title: 'Helpful Farmer',
          description: 'Received 25+ helpful votes on your answers',
          iconUrl: 'https://example.com/helpful.png',
          category: AchievementCategory.community,
          earnedAt: DateTime.now().subtract(const Duration(days: 200)),
          points: 50,
          rarity: AchievementRarity.uncommon,
        ),
        Achievement(
          id: 'ach3',
          title: 'Organic Expert',
          description: 'Verified organic farming certification',
          iconUrl: 'https://example.com/organic.png',
          category: AchievementCategory.farming,
          earnedAt: DateTime.now().subtract(const Duration(days: 100)),
          points: 100,
          rarity: AchievementRarity.rare,
        ),
      ],
      preferences: UserPreferences(
        notificationsEnabled: true,
        emailNotifications: true,
        pushNotifications: true,
        smsNotifications: false,
        language: 'en',
        currency: 'INR',
        temperatureUnit: 'celsius',
        measurementUnit: 'metric',
        darkMode: false,
        locationSharing: true,
        profileVisibility: true,
        interestedCategories: ['Vegetables', 'Organic', 'Sustainable'],
        notifications: NotificationSettings(
          newPosts: true,
          comments: true,
          likes: false,
          mentions: true,
          orders: true,
          payments: true,
          weatherAlerts: true,
          marketUpdates: true,
          communityEvents: true,
          tips: true,
        ),
      ),
    );
  }

  // Helper methods for UI
  String getUserTypeDisplayName(UserType type) {
    switch (type) {
      case UserType.farmer:
        return 'Farmer';
      case UserType.buyer:
        return 'Buyer';
      case UserType.expert:
        return 'Agricultural Expert';
      case UserType.vendor:
        return 'Vendor';
      case UserType.organization:
        return 'Organization';
    }
  }

  String getFarmTypeDisplayName(FarmType type) {
    switch (type) {
      case FarmType.crop:
        return 'Crop Farming';
      case FarmType.livestock:
        return 'Livestock';
      case FarmType.mixed:
        return 'Mixed Farming';
      case FarmType.organic:
        return 'Organic Farming';
      case FarmType.hydroponic:
        return 'Hydroponic';
      case FarmType.greenhouse:
        return 'Greenhouse';
    }
  }

  String getAchievementRarityDisplayName(AchievementRarity rarity) {
    switch (rarity) {
      case AchievementRarity.common:
        return 'Common';
      case AchievementRarity.uncommon:
        return 'Uncommon';
      case AchievementRarity.rare:
        return 'Rare';
      case AchievementRarity.epic:
        return 'Epic';
      case AchievementRarity.legendary:
        return 'Legendary';
    }
  }

  List<Achievement> getAchievementsByCategory(AchievementCategory category) {
    if (_userProfile == null) return [];
    return _userProfile!.achievements
        .where((achievement) => achievement.category == category)
        .toList();
  }

  int getTotalAchievementPoints() {
    if (_userProfile == null) return 0;
    return _userProfile!.achievements
        .fold(0, (sum, achievement) => sum + achievement.points);
  }

  double getProfileCompletionPercentage() {
    if (_userProfile == null) return 0.0;
    
    int completedFields = 0;
    int totalFields = 10;
    
    if (_userProfile!.name.isNotEmpty) completedFields++;
    if (_userProfile!.email.isNotEmpty) completedFields++;
    if (_userProfile!.phone != null && _userProfile!.phone!.isNotEmpty) completedFields++;
    if (_userProfile!.bio != null && _userProfile!.bio!.isNotEmpty) completedFields++;
    if (_userProfile!.location != null && _userProfile!.location!.isNotEmpty) completedFields++;
    if (_userProfile!.address != null && _userProfile!.address!.isNotEmpty) completedFields++;
    if (_userProfile!.avatarUrl != null) completedFields++;
    if (_userProfile!.farmingProfile != null) completedFields++;
    if (_userProfile!.interests.isNotEmpty) completedFields++;
    if (_userProfile!.isVerified) completedFields++;
    
    return completedFields / totalFields;
  }
}
