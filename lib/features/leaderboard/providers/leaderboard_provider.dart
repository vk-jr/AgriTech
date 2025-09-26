import 'package:flutter/foundation.dart';
import '../../../core/models/leaderboard_model.dart';

class LeaderboardProvider extends ChangeNotifier {
  List<LeaderboardEntry> _globalLeaderboard = [];
  List<LeaderboardEntry> _localLeaderboard = [];
  LeaderboardStats? _stats;
  bool _isLoading = false;
  String? _errorMessage;
  LeaderboardTimeframe _selectedTimeframe = LeaderboardTimeframe.allTime;
  final String _userLocation = 'Kerala, India'; // This would come from user profile

  // Getters
  List<LeaderboardEntry> get globalLeaderboard => _globalLeaderboard;
  List<LeaderboardEntry> get localLeaderboard => _localLeaderboard;
  LeaderboardStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LeaderboardTimeframe get selectedTimeframe => _selectedTimeframe;
  String get userLocation => _userLocation;

  LeaderboardProvider() {
    _initializeMockData();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> loadLeaderboards() async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      // Data is already initialized in _initializeMockData
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load leaderboards: $e');
      _setLoading(false);
    }
  }

  void updateTimeframe(LeaderboardTimeframe timeframe) {
    _selectedTimeframe = timeframe;
    notifyListeners();
    // In a real app, this would trigger a new data fetch
    loadLeaderboards();
  }

  void _initializeMockData() {
    // Global Leaderboard
    _globalLeaderboard = [
      LeaderboardEntry(
        id: '1',
        userId: 'user1',
        userName: 'Rajesh Kumar',
        userAvatar: 'https://example.com/avatar1.jpg',
        location: 'Punjab, India',
        points: 15420,
        rank: 1,
        farmType: 'Organic Farming',
        farmSize: 25.5,
        achievements: ['Top Contributor', 'Eco Warrior', 'Market Master'],
        postsCount: 156,
        helpfulCount: 89,
        ordersCount: 45,
        isVerified: true,
        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      LeaderboardEntry(
        id: '2',
        userId: 'user2',
        userName: 'Priya Sharma',
        userAvatar: 'https://example.com/avatar2.jpg',
        location: 'Kerala, India',
        points: 14850,
        rank: 2,
        farmType: 'Rice Cultivation',
        farmSize: 18.2,
        achievements: ['Knowledge Sharer', 'Community Helper'],
        postsCount: 134,
        helpfulCount: 76,
        ordersCount: 38,
        isVerified: true,
        lastActive: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      LeaderboardEntry(
        id: '3',
        userId: 'user3',
        userName: 'Amit Patel',
        userAvatar: 'https://example.com/avatar3.jpg',
        location: 'Gujarat, India',
        points: 13960,
        rank: 3,
        farmType: 'Vegetable Farming',
        farmSize: 12.8,
        achievements: ['Innovation Leader', 'Tech Adopter'],
        postsCount: 98,
        helpfulCount: 65,
        ordersCount: 52,
        isVerified: false,
        lastActive: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      LeaderboardEntry(
        id: '4',
        userId: 'user4',
        userName: 'Sunita Devi',
        userAvatar: 'https://example.com/avatar4.jpg',
        location: 'Haryana, India',
        points: 12750,
        rank: 4,
        farmType: 'Dairy Farming',
        farmSize: 8.5,
        achievements: ['Sustainability Champion'],
        postsCount: 87,
        helpfulCount: 54,
        ordersCount: 29,
        isVerified: false,
        lastActive: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      LeaderboardEntry(
        id: '5',
        userId: 'user5',
        userName: 'Ravi Krishnan',
        userAvatar: 'https://example.com/avatar5.jpg',
        location: 'Tamil Nadu, India',
        points: 11890,
        rank: 5,
        farmType: 'Spice Cultivation',
        farmSize: 15.3,
        achievements: ['Quality Producer', 'Market Leader'],
        postsCount: 76,
        helpfulCount: 43,
        ordersCount: 67,
        isVerified: true,
        lastActive: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      LeaderboardEntry(
        id: '6',
        userId: 'user6',
        userName: 'Meera Nair',
        userAvatar: 'https://example.com/avatar6.jpg',
        location: 'Karnataka, India',
        points: 10540,
        rank: 6,
        farmType: 'Coffee Plantation',
        farmSize: 22.1,
        achievements: ['Export Excellence'],
        postsCount: 65,
        helpfulCount: 38,
        ordersCount: 31,
        isVerified: false,
        lastActive: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      LeaderboardEntry(
        id: '7',
        userId: 'user7',
        userName: 'Vikram Singh',
        userAvatar: 'https://example.com/avatar7.jpg',
        location: 'Rajasthan, India',
        points: 9820,
        rank: 7,
        farmType: 'Desert Farming',
        farmSize: 35.7,
        achievements: ['Water Conservation Hero'],
        postsCount: 54,
        helpfulCount: 32,
        ordersCount: 18,
        isVerified: false,
        lastActive: DateTime.now().subtract(const Duration(days: 1)),
      ),
      LeaderboardEntry(
        id: '8',
        userId: 'user8',
        userName: 'Lakshmi Reddy',
        userAvatar: 'https://example.com/avatar8.jpg',
        location: 'Andhra Pradesh, India',
        points: 9150,
        rank: 8,
        farmType: 'Cotton Farming',
        farmSize: 28.4,
        achievements: ['Pest Management Expert'],
        postsCount: 48,
        helpfulCount: 29,
        ordersCount: 25,
        isVerified: true,
        lastActive: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];

    // Local Leaderboard (Kerala-specific)
    _localLeaderboard = [
      LeaderboardEntry(
        id: '2',
        userId: 'user2',
        userName: 'Priya Sharma',
        userAvatar: 'https://example.com/avatar2.jpg',
        location: 'Kochi, Kerala',
        points: 14850,
        rank: 1,
        farmType: 'Rice Cultivation',
        farmSize: 18.2,
        achievements: ['Knowledge Sharer', 'Community Helper'],
        postsCount: 134,
        helpfulCount: 76,
        ordersCount: 38,
        isVerified: true,
        lastActive: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      LeaderboardEntry(
        id: '9',
        userId: 'user9',
        userName: 'Suresh Menon',
        userAvatar: 'https://example.com/avatar9.jpg',
        location: 'Thiruvananthapuram, Kerala',
        points: 11200,
        rank: 2,
        farmType: 'Coconut Farming',
        farmSize: 12.5,
        achievements: ['Local Champion', 'Coconut King'],
        postsCount: 89,
        helpfulCount: 56,
        ordersCount: 42,
        isVerified: false,
        lastActive: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      LeaderboardEntry(
        id: '10',
        userId: 'user10',
        userName: 'Radha Pillai',
        userAvatar: 'https://example.com/avatar10.jpg',
        location: 'Kozhikode, Kerala',
        points: 9850,
        rank: 3,
        farmType: 'Spice Garden',
        farmSize: 8.7,
        achievements: ['Spice Master', 'Organic Pioneer'],
        postsCount: 67,
        helpfulCount: 41,
        ordersCount: 35,
        isVerified: true,
        lastActive: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      LeaderboardEntry(
        id: '11',
        userId: 'user11',
        userName: 'Jose Thomas',
        userAvatar: 'https://example.com/avatar11.jpg',
        location: 'Kottayam, Kerala',
        points: 8750,
        rank: 4,
        farmType: 'Rubber Plantation',
        farmSize: 15.8,
        achievements: ['Rubber Expert'],
        postsCount: 52,
        helpfulCount: 34,
        ordersCount: 28,
        isVerified: false,
        lastActive: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      LeaderboardEntry(
        id: '12',
        userId: 'user12',
        userName: 'Anitha Kumar',
        userAvatar: 'https://example.com/avatar12.jpg',
        location: 'Palakkad, Kerala',
        points: 7920,
        rank: 5,
        farmType: 'Vegetable Farming',
        farmSize: 6.3,
        achievements: ['Fresh Produce Leader'],
        postsCount: 45,
        helpfulCount: 28,
        ordersCount: 33,
        isVerified: false,
        lastActive: DateTime.now().subtract(const Duration(hours: 12)),
      ),
    ];

    // Stats
    _stats = LeaderboardStats(
      totalUsers: 12450,
      activeUsers: 8920,
      topRegion: 'Punjab',
      mostPopularFarmType: 'Organic Farming',
      averagePoints: 6850.5,
    );
  }

  // Get user's rank in global leaderboard
  int? getUserGlobalRank(String userId) {
    final entry = _globalLeaderboard.where((e) => e.userId == userId).firstOrNull;
    return entry?.rank;
  }

  // Get user's rank in local leaderboard
  int? getUserLocalRank(String userId) {
    final entry = _localLeaderboard.where((e) => e.userId == userId).firstOrNull;
    return entry?.rank;
  }

  // Get top performers by category
  List<LeaderboardEntry> getTopPerformers(LeaderboardType type, {int limit = 3}) {
    final leaderboard = type == LeaderboardType.global ? _globalLeaderboard : _localLeaderboard;
    return leaderboard.take(limit).toList();
  }

  // Search leaderboard entries
  List<LeaderboardEntry> searchEntries(LeaderboardType type, String query) {
    final leaderboard = type == LeaderboardType.global ? _globalLeaderboard : _localLeaderboard;
    if (query.isEmpty) return leaderboard;
    
    return leaderboard.where((entry) =>
        entry.userName.toLowerCase().contains(query.toLowerCase()) ||
        entry.location.toLowerCase().contains(query.toLowerCase()) ||
        entry.farmType.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
