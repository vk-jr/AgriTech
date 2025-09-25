class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final UserType userType;
  final String? location;
  final String? profileImageUrl;
  final DateTime createdAt;
  final UserPreferences preferences;
  final GamificationStats gamificationStats;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.userType,
    this.location,
    this.profileImageUrl,
    required this.createdAt,
    required this.preferences,
    required this.gamificationStats,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      userType: UserType.values.firstWhere(
        (type) => type.name == json['userType'],
        orElse: () => UserType.farmer,
      ),
      location: json['location'],
      profileImageUrl: json['profileImageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
      gamificationStats: GamificationStats.fromJson(json['gamificationStats'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'userType': userType.name,
      'location': location,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'preferences': preferences.toJson(),
      'gamificationStats': gamificationStats.toJson(),
    };
  }
}

enum UserType {
  farmer,
  urbanGrower,
  buyer,
  collective,
}

class UserPreferences {
  final String language;
  final bool voiceNavigationEnabled;
  final bool smsNotificationsEnabled;
  final bool pushNotificationsEnabled;
  final bool darkModeEnabled;
  final List<String> interestedCrops;

  UserPreferences({
    this.language = 'en',
    this.voiceNavigationEnabled = false,
    this.smsNotificationsEnabled = true,
    this.pushNotificationsEnabled = true,
    this.darkModeEnabled = false,
    this.interestedCrops = const [],
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      language: json['language'] ?? 'en',
      voiceNavigationEnabled: json['voiceNavigationEnabled'] ?? false,
      smsNotificationsEnabled: json['smsNotificationsEnabled'] ?? true,
      pushNotificationsEnabled: json['pushNotificationsEnabled'] ?? true,
      darkModeEnabled: json['darkModeEnabled'] ?? false,
      interestedCrops: List<String>.from(json['interestedCrops'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'voiceNavigationEnabled': voiceNavigationEnabled,
      'smsNotificationsEnabled': smsNotificationsEnabled,
      'pushNotificationsEnabled': pushNotificationsEnabled,
      'darkModeEnabled': darkModeEnabled,
      'interestedCrops': interestedCrops,
    };
  }
}

class GamificationStats {
  final int totalXP;
  final int level;
  final List<String> badges;
  final int plantsGrown;
  final int diseasesDiagnosed;
  final int marketTransactions;
  final int forumPosts;

  GamificationStats({
    this.totalXP = 0,
    this.level = 1,
    this.badges = const [],
    this.plantsGrown = 0,
    this.diseasesDiagnosed = 0,
    this.marketTransactions = 0,
    this.forumPosts = 0,
  });

  factory GamificationStats.fromJson(Map<String, dynamic> json) {
    return GamificationStats(
      totalXP: json['totalXP'] ?? 0,
      level: json['level'] ?? 1,
      badges: List<String>.from(json['badges'] ?? []),
      plantsGrown: json['plantsGrown'] ?? 0,
      diseasesDiagnosed: json['diseasesDiagnosed'] ?? 0,
      marketTransactions: json['marketTransactions'] ?? 0,
      forumPosts: json['forumPosts'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalXP': totalXP,
      'level': level,
      'badges': badges,
      'plantsGrown': plantsGrown,
      'diseasesDiagnosed': diseasesDiagnosed,
      'marketTransactions': marketTransactions,
      'forumPosts': forumPosts,
    };
  }
}
