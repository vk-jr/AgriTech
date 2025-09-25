class LeaderboardEntry {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String location;
  final int points;
  final int rank;
  final String farmType;
  final double farmSize;
  final List<String> achievements;
  final int postsCount;
  final int helpfulCount;
  final int ordersCount;
  final bool isVerified;
  final DateTime lastActive;

  LeaderboardEntry({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.location,
    required this.points,
    required this.rank,
    required this.farmType,
    required this.farmSize,
    this.achievements = const [],
    this.postsCount = 0,
    this.helpfulCount = 0,
    this.ordersCount = 0,
    this.isVerified = false,
    required this.lastActive,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      location: json['location'],
      points: json['points'],
      rank: json['rank'],
      farmType: json['farmType'],
      farmSize: json['farmSize'].toDouble(),
      achievements: List<String>.from(json['achievements'] ?? []),
      postsCount: json['postsCount'] ?? 0,
      helpfulCount: json['helpfulCount'] ?? 0,
      ordersCount: json['ordersCount'] ?? 0,
      isVerified: json['isVerified'] ?? false,
      lastActive: DateTime.parse(json['lastActive']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'location': location,
      'points': points,
      'rank': rank,
      'farmType': farmType,
      'farmSize': farmSize,
      'achievements': achievements,
      'postsCount': postsCount,
      'helpfulCount': helpfulCount,
      'ordersCount': ordersCount,
      'isVerified': isVerified,
      'lastActive': lastActive.toIso8601String(),
    };
  }
}

class LeaderboardStats {
  final int totalUsers;
  final int activeUsers;
  final String topRegion;
  final String mostPopularFarmType;
  final double averagePoints;

  LeaderboardStats({
    required this.totalUsers,
    required this.activeUsers,
    required this.topRegion,
    required this.mostPopularFarmType,
    required this.averagePoints,
  });

  factory LeaderboardStats.fromJson(Map<String, dynamic> json) {
    return LeaderboardStats(
      totalUsers: json['totalUsers'],
      activeUsers: json['activeUsers'],
      topRegion: json['topRegion'],
      mostPopularFarmType: json['mostPopularFarmType'],
      averagePoints: json['averagePoints'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'activeUsers': activeUsers,
      'topRegion': topRegion,
      'mostPopularFarmType': mostPopularFarmType,
      'averagePoints': averagePoints,
    };
  }
}

enum LeaderboardType {
  global,
  local,
}

enum LeaderboardTimeframe {
  weekly,
  monthly,
  allTime,
}
