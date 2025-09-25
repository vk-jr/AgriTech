class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? bio;
  final String? location;
  final String? address;
  final DateTime joinDate;
  final UserType userType;
  final bool isVerified;
  final UserStats stats;
  final FarmingProfile? farmingProfile;
  final List<String> interests;
  final List<Achievement> achievements;
  final UserPreferences preferences;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.bio,
    this.location,
    this.address,
    required this.joinDate,
    this.userType = UserType.farmer,
    this.isVerified = false,
    required this.stats,
    this.farmingProfile,
    this.interests = const [],
    this.achievements = const [],
    required this.preferences,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
      location: json['location'],
      address: json['address'],
      joinDate: DateTime.parse(json['joinDate']),
      userType: UserType.values.firstWhere(
        (t) => t.name == json['userType'],
        orElse: () => UserType.farmer,
      ),
      isVerified: json['isVerified'] ?? false,
      stats: UserStats.fromJson(json['stats']),
      farmingProfile: json['farmingProfile'] != null
          ? FarmingProfile.fromJson(json['farmingProfile'])
          : null,
      interests: List<String>.from(json['interests'] ?? []),
      achievements: (json['achievements'] as List? ?? [])
          .map((a) => Achievement.fromJson(a))
          .toList(),
      preferences: UserPreferences.fromJson(json['preferences']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'location': location,
      'address': address,
      'joinDate': joinDate.toIso8601String(),
      'userType': userType.name,
      'isVerified': isVerified,
      'stats': stats.toJson(),
      'farmingProfile': farmingProfile?.toJson(),
      'interests': interests,
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'preferences': preferences.toJson(),
    };
  }

  String get displayName => name.isNotEmpty ? name : email.split('@')[0];
  String get initials => name.split(' ').map((n) => n[0]).take(2).join().toUpperCase();
}

enum UserType {
  farmer,
  buyer,
  expert,
  vendor,
  organization,
}

class UserStats {
  final int postsCount;
  final int commentsCount;
  final int likesReceived;
  final int helpfulAnswers;
  final int ordersPlaced;
  final int ordersSold;
  final double totalEarnings;
  final double totalSpent;
  final int daysActive;
  final int streakDays;

  UserStats({
    this.postsCount = 0,
    this.commentsCount = 0,
    this.likesReceived = 0,
    this.helpfulAnswers = 0,
    this.ordersPlaced = 0,
    this.ordersSold = 0,
    this.totalEarnings = 0.0,
    this.totalSpent = 0.0,
    this.daysActive = 0,
    this.streakDays = 0,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      postsCount: json['postsCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      likesReceived: json['likesReceived'] ?? 0,
      helpfulAnswers: json['helpfulAnswers'] ?? 0,
      ordersPlaced: json['ordersPlaced'] ?? 0,
      ordersSold: json['ordersSold'] ?? 0,
      totalEarnings: json['totalEarnings']?.toDouble() ?? 0.0,
      totalSpent: json['totalSpent']?.toDouble() ?? 0.0,
      daysActive: json['daysActive'] ?? 0,
      streakDays: json['streakDays'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postsCount': postsCount,
      'commentsCount': commentsCount,
      'likesReceived': likesReceived,
      'helpfulAnswers': helpfulAnswers,
      'ordersPlaced': ordersPlaced,
      'ordersSold': ordersSold,
      'totalEarnings': totalEarnings,
      'totalSpent': totalSpent,
      'daysActive': daysActive,
      'streakDays': streakDays,
    };
  }

  int get totalContributions => postsCount + commentsCount;
  double get engagementScore => (likesReceived + helpfulAnswers) / (totalContributions + 1);
}

class FarmingProfile {
  final double farmSize;
  final String farmSizeUnit;
  final FarmType farmType;
  final List<String> cropsGrown;
  final List<String> farmingMethods;
  final int yearsOfExperience;
  final String? farmName;
  final String? farmLocation;
  final bool isOrganic;
  final List<String> certifications;
  final String? soilType;
  final String? climateZone;
  final List<String> equipment;

  FarmingProfile({
    required this.farmSize,
    this.farmSizeUnit = 'acres',
    required this.farmType,
    this.cropsGrown = const [],
    this.farmingMethods = const [],
    this.yearsOfExperience = 0,
    this.farmName,
    this.farmLocation,
    this.isOrganic = false,
    this.certifications = const [],
    this.soilType,
    this.climateZone,
    this.equipment = const [],
  });

  factory FarmingProfile.fromJson(Map<String, dynamic> json) {
    return FarmingProfile(
      farmSize: json['farmSize'].toDouble(),
      farmSizeUnit: json['farmSizeUnit'] ?? 'acres',
      farmType: FarmType.values.firstWhere(
        (t) => t.name == json['farmType'],
        orElse: () => FarmType.mixed,
      ),
      cropsGrown: List<String>.from(json['cropsGrown'] ?? []),
      farmingMethods: List<String>.from(json['farmingMethods'] ?? []),
      yearsOfExperience: json['yearsOfExperience'] ?? 0,
      farmName: json['farmName'],
      farmLocation: json['farmLocation'],
      isOrganic: json['isOrganic'] ?? false,
      certifications: List<String>.from(json['certifications'] ?? []),
      soilType: json['soilType'],
      climateZone: json['climateZone'],
      equipment: List<String>.from(json['equipment'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'farmSize': farmSize,
      'farmSizeUnit': farmSizeUnit,
      'farmType': farmType.name,
      'cropsGrown': cropsGrown,
      'farmingMethods': farmingMethods,
      'yearsOfExperience': yearsOfExperience,
      'farmName': farmName,
      'farmLocation': farmLocation,
      'isOrganic': isOrganic,
      'certifications': certifications,
      'soilType': soilType,
      'climateZone': climateZone,
      'equipment': equipment,
    };
  }

  String get experienceLevel {
    if (yearsOfExperience < 2) return 'Beginner';
    if (yearsOfExperience < 5) return 'Intermediate';
    if (yearsOfExperience < 10) return 'Experienced';
    return 'Expert';
  }
}

enum FarmType {
  crop,
  livestock,
  mixed,
  organic,
  hydroponic,
  greenhouse,
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconUrl;
  final AchievementCategory category;
  final DateTime earnedAt;
  final int points;
  final AchievementRarity rarity;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.category,
    required this.earnedAt,
    this.points = 0,
    this.rarity = AchievementRarity.common,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconUrl: json['iconUrl'],
      category: AchievementCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => AchievementCategory.general,
      ),
      earnedAt: DateTime.parse(json['earnedAt']),
      points: json['points'] ?? 0,
      rarity: AchievementRarity.values.firstWhere(
        (r) => r.name == json['rarity'],
        orElse: () => AchievementRarity.common,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconUrl': iconUrl,
      'category': category.name,
      'earnedAt': earnedAt.toIso8601String(),
      'points': points,
      'rarity': rarity.name,
    };
  }
}

enum AchievementCategory {
  general,
  community,
  farming,
  marketplace,
  learning,
}

enum AchievementRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
}

class UserPreferences {
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool smsNotifications;
  final String language;
  final String currency;
  final String temperatureUnit;
  final String measurementUnit;
  final bool darkMode;
  final bool locationSharing;
  final bool profileVisibility;
  final List<String> interestedCategories;
  final NotificationSettings notifications;

  UserPreferences({
    this.notificationsEnabled = true,
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.smsNotifications = false,
    this.language = 'en',
    this.currency = 'INR',
    this.temperatureUnit = 'celsius',
    this.measurementUnit = 'metric',
    this.darkMode = false,
    this.locationSharing = true,
    this.profileVisibility = true,
    this.interestedCategories = const [],
    required this.notifications,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      emailNotifications: json['emailNotifications'] ?? true,
      pushNotifications: json['pushNotifications'] ?? true,
      smsNotifications: json['smsNotifications'] ?? false,
      language: json['language'] ?? 'en',
      currency: json['currency'] ?? 'INR',
      temperatureUnit: json['temperatureUnit'] ?? 'celsius',
      measurementUnit: json['measurementUnit'] ?? 'metric',
      darkMode: json['darkMode'] ?? false,
      locationSharing: json['locationSharing'] ?? true,
      profileVisibility: json['profileVisibility'] ?? true,
      interestedCategories: List<String>.from(json['interestedCategories'] ?? []),
      notifications: NotificationSettings.fromJson(json['notifications'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'smsNotifications': smsNotifications,
      'language': language,
      'currency': currency,
      'temperatureUnit': temperatureUnit,
      'measurementUnit': measurementUnit,
      'darkMode': darkMode,
      'locationSharing': locationSharing,
      'profileVisibility': profileVisibility,
      'interestedCategories': interestedCategories,
      'notifications': notifications.toJson(),
    };
  }
}

class NotificationSettings {
  final bool newPosts;
  final bool comments;
  final bool likes;
  final bool mentions;
  final bool orders;
  final bool payments;
  final bool weatherAlerts;
  final bool marketUpdates;
  final bool communityEvents;
  final bool tips;

  NotificationSettings({
    this.newPosts = true,
    this.comments = true,
    this.likes = false,
    this.mentions = true,
    this.orders = true,
    this.payments = true,
    this.weatherAlerts = true,
    this.marketUpdates = false,
    this.communityEvents = true,
    this.tips = true,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      newPosts: json['newPosts'] ?? true,
      comments: json['comments'] ?? true,
      likes: json['likes'] ?? false,
      mentions: json['mentions'] ?? true,
      orders: json['orders'] ?? true,
      payments: json['payments'] ?? true,
      weatherAlerts: json['weatherAlerts'] ?? true,
      marketUpdates: json['marketUpdates'] ?? false,
      communityEvents: json['communityEvents'] ?? true,
      tips: json['tips'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'newPosts': newPosts,
      'comments': comments,
      'likes': likes,
      'mentions': mentions,
      'orders': orders,
      'payments': payments,
      'weatherAlerts': weatherAlerts,
      'marketUpdates': marketUpdates,
      'communityEvents': communityEvents,
      'tips': tips,
    };
  }
}

class AppSettings {
  final String version;
  final String buildNumber;
  final DateTime lastUpdated;
  final bool analyticsEnabled;
  final bool crashReportingEnabled;
  final String cacheSize;
  final bool autoBackup;
  final int backupFrequencyDays;

  AppSettings({
    required this.version,
    required this.buildNumber,
    required this.lastUpdated,
    this.analyticsEnabled = true,
    this.crashReportingEnabled = true,
    this.cacheSize = '0 MB',
    this.autoBackup = true,
    this.backupFrequencyDays = 7,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      version: json['version'],
      buildNumber: json['buildNumber'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
      analyticsEnabled: json['analyticsEnabled'] ?? true,
      crashReportingEnabled: json['crashReportingEnabled'] ?? true,
      cacheSize: json['cacheSize'] ?? '0 MB',
      autoBackup: json['autoBackup'] ?? true,
      backupFrequencyDays: json['backupFrequencyDays'] ?? 7,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'buildNumber': buildNumber,
      'lastUpdated': lastUpdated.toIso8601String(),
      'analyticsEnabled': analyticsEnabled,
      'crashReportingEnabled': crashReportingEnabled,
      'cacheSize': cacheSize,
      'autoBackup': autoBackup,
      'backupFrequencyDays': backupFrequencyDays,
    };
  }
}
