class CropModel {
  final String id;
  final String name;
  final String scientificName;
  final String category;
  final String imageUrl;
  final CropRequirements requirements;
  final List<String> suitableSoilTypes;
  final List<String> suitableClimates;
  final int growthDurationDays;
  final double expectedYieldPerSqMeter;
  final double marketPricePerKg;
  final List<String> commonDiseases;
  final List<String> commonPests;
  final String description;
  final bool isOrganicFriendly;
  final CropDifficulty difficulty;

  CropModel({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.category,
    required this.imageUrl,
    required this.requirements,
    required this.suitableSoilTypes,
    required this.suitableClimates,
    required this.growthDurationDays,
    required this.expectedYieldPerSqMeter,
    required this.marketPricePerKg,
    required this.commonDiseases,
    required this.commonPests,
    required this.description,
    this.isOrganicFriendly = true,
    this.difficulty = CropDifficulty.medium,
  });

  factory CropModel.fromJson(Map<String, dynamic> json) {
    return CropModel(
      id: json['id'],
      name: json['name'],
      scientificName: json['scientificName'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      requirements: CropRequirements.fromJson(json['requirements']),
      suitableSoilTypes: List<String>.from(json['suitableSoilTypes']),
      suitableClimates: List<String>.from(json['suitableClimates']),
      growthDurationDays: json['growthDurationDays'],
      expectedYieldPerSqMeter: json['expectedYieldPerSqMeter'].toDouble(),
      marketPricePerKg: json['marketPricePerKg'].toDouble(),
      commonDiseases: List<String>.from(json['commonDiseases']),
      commonPests: List<String>.from(json['commonPests']),
      description: json['description'],
      isOrganicFriendly: json['isOrganicFriendly'] ?? true,
      difficulty: CropDifficulty.values.firstWhere(
        (d) => d.name == json['difficulty'],
        orElse: () => CropDifficulty.medium,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scientificName': scientificName,
      'category': category,
      'imageUrl': imageUrl,
      'requirements': requirements.toJson(),
      'suitableSoilTypes': suitableSoilTypes,
      'suitableClimates': suitableClimates,
      'growthDurationDays': growthDurationDays,
      'expectedYieldPerSqMeter': expectedYieldPerSqMeter,
      'marketPricePerKg': marketPricePerKg,
      'commonDiseases': commonDiseases,
      'commonPests': commonPests,
      'description': description,
      'isOrganicFriendly': isOrganicFriendly,
      'difficulty': difficulty.name,
    };
  }
}

class CropRequirements {
  final double minTemperature;
  final double maxTemperature;
  final double minHumidity;
  final double maxHumidity;
  final double minRainfall;
  final double maxRainfall;
  final double phMin;
  final double phMax;
  final int sunlightHours;
  final double waterRequirementLitersPerDay;

  CropRequirements({
    required this.minTemperature,
    required this.maxTemperature,
    required this.minHumidity,
    required this.maxHumidity,
    required this.minRainfall,
    required this.maxRainfall,
    required this.phMin,
    required this.phMax,
    required this.sunlightHours,
    required this.waterRequirementLitersPerDay,
  });

  factory CropRequirements.fromJson(Map<String, dynamic> json) {
    return CropRequirements(
      minTemperature: json['minTemperature'].toDouble(),
      maxTemperature: json['maxTemperature'].toDouble(),
      minHumidity: json['minHumidity'].toDouble(),
      maxHumidity: json['maxHumidity'].toDouble(),
      minRainfall: json['minRainfall'].toDouble(),
      maxRainfall: json['maxRainfall'].toDouble(),
      phMin: json['phMin'].toDouble(),
      phMax: json['phMax'].toDouble(),
      sunlightHours: json['sunlightHours'],
      waterRequirementLitersPerDay: json['waterRequirementLitersPerDay'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minTemperature': minTemperature,
      'maxTemperature': maxTemperature,
      'minHumidity': minHumidity,
      'maxHumidity': maxHumidity,
      'minRainfall': minRainfall,
      'maxRainfall': maxRainfall,
      'phMin': phMin,
      'phMax': phMax,
      'sunlightHours': sunlightHours,
      'waterRequirementLitersPerDay': waterRequirementLitersPerDay,
    };
  }
}

enum CropDifficulty {
  easy,
  medium,
  hard,
}

class CropSuggestion {
  final CropModel crop;
  final double suitabilityScore;
  final String reason;
  final List<String> tips;
  final double profitabilityScore;
  final double riskLevel;

  CropSuggestion({
    required this.crop,
    required this.suitabilityScore,
    required this.reason,
    required this.tips,
    required this.profitabilityScore,
    required this.riskLevel,
  });

  factory CropSuggestion.fromJson(Map<String, dynamic> json) {
    return CropSuggestion(
      crop: CropModel.fromJson(json['crop']),
      suitabilityScore: json['suitabilityScore'].toDouble(),
      reason: json['reason'],
      tips: List<String>.from(json['tips']),
      profitabilityScore: json['profitabilityScore'].toDouble(),
      riskLevel: json['riskLevel'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crop': crop.toJson(),
      'suitabilityScore': suitabilityScore,
      'reason': reason,
      'tips': tips,
      'profitabilityScore': profitabilityScore,
      'riskLevel': riskLevel,
    };
  }
}
