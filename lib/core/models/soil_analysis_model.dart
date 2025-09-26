class SoilAnalysisResult {
  final String id;
  final String farmId;
  final String location;
  final DateTime analyzedAt;
  final SoilComposition composition;
  final SoilNutrients nutrients;
  final SoilProperties properties;
  final SoilHealth health;
  final List<SoilRecommendation> recommendations;
  final SoilQualityScore qualityScore;

  SoilAnalysisResult({
    required this.id,
    required this.farmId,
    required this.location,
    required this.analyzedAt,
    required this.composition,
    required this.nutrients,
    required this.properties,
    required this.health,
    required this.recommendations,
    required this.qualityScore,
  });

  factory SoilAnalysisResult.fromJson(Map<String, dynamic> json) {
    return SoilAnalysisResult(
      id: json['id'],
      farmId: json['farmId'],
      location: json['location'],
      analyzedAt: DateTime.parse(json['analyzedAt']),
      composition: SoilComposition.fromJson(json['composition']),
      nutrients: SoilNutrients.fromJson(json['nutrients']),
      properties: SoilProperties.fromJson(json['properties']),
      health: SoilHealth.fromJson(json['health']),
      recommendations: (json['recommendations'] as List)
          .map((r) => SoilRecommendation.fromJson(r))
          .toList(),
      qualityScore: SoilQualityScore.fromJson(json['qualityScore']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmId': farmId,
      'location': location,
      'analyzedAt': analyzedAt.toIso8601String(),
      'composition': composition.toJson(),
      'nutrients': nutrients.toJson(),
      'properties': properties.toJson(),
      'health': health.toJson(),
      'recommendations': recommendations.map((r) => r.toJson()).toList(),
      'qualityScore': qualityScore.toJson(),
    };
  }
}

class SoilComposition {
  final double sand; // percentage
  final double silt; // percentage
  final double clay; // percentage
  final SoilType soilType;

  SoilComposition({
    required this.sand,
    required this.silt,
    required this.clay,
    required this.soilType,
  });

  factory SoilComposition.fromJson(Map<String, dynamic> json) {
    return SoilComposition(
      sand: json['sand'].toDouble(),
      silt: json['silt'].toDouble(),
      clay: json['clay'].toDouble(),
      soilType: SoilType.values.firstWhere(
        (e) => e.toString() == 'SoilType.${json['soilType']}',
        orElse: () => SoilType.loam,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sand': sand,
      'silt': silt,
      'clay': clay,
      'soilType': soilType.toString().split('.').last,
    };
  }
}

class SoilNutrients {
  final double nitrogen; // ppm
  final double phosphorus; // ppm
  final double potassium; // ppm
  final double organicMatter; // percentage
  final double calcium; // ppm
  final double magnesium; // ppm
  final double sulfur; // ppm
  final double iron; // ppm
  final double zinc; // ppm
  final double manganese; // ppm

  SoilNutrients({
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.organicMatter,
    required this.calcium,
    required this.magnesium,
    required this.sulfur,
    required this.iron,
    required this.zinc,
    required this.manganese,
  });

  factory SoilNutrients.fromJson(Map<String, dynamic> json) {
    return SoilNutrients(
      nitrogen: json['nitrogen'].toDouble(),
      phosphorus: json['phosphorus'].toDouble(),
      potassium: json['potassium'].toDouble(),
      organicMatter: json['organicMatter'].toDouble(),
      calcium: json['calcium'].toDouble(),
      magnesium: json['magnesium'].toDouble(),
      sulfur: json['sulfur'].toDouble(),
      iron: json['iron'].toDouble(),
      zinc: json['zinc'].toDouble(),
      manganese: json['manganese'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nitrogen': nitrogen,
      'phosphorus': phosphorus,
      'potassium': potassium,
      'organicMatter': organicMatter,
      'calcium': calcium,
      'magnesium': magnesium,
      'sulfur': sulfur,
      'iron': iron,
      'zinc': zinc,
      'manganese': manganese,
    };
  }
}

class SoilProperties {
  final double ph;
  final double electricalConductivity; // dS/m
  final double moisture; // percentage
  final double temperature; // Celsius
  final double bulkDensity; // g/cm³
  final double porosity; // percentage

  SoilProperties({
    required this.ph,
    required this.electricalConductivity,
    required this.moisture,
    required this.temperature,
    required this.bulkDensity,
    required this.porosity,
  });

  factory SoilProperties.fromJson(Map<String, dynamic> json) {
    return SoilProperties(
      ph: json['ph'].toDouble(),
      electricalConductivity: json['electricalConductivity'].toDouble(),
      moisture: json['moisture'].toDouble(),
      temperature: json['temperature'].toDouble(),
      bulkDensity: json['bulkDensity'].toDouble(),
      porosity: json['porosity'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ph': ph,
      'electricalConductivity': electricalConductivity,
      'moisture': moisture,
      'temperature': temperature,
      'bulkDensity': bulkDensity,
      'porosity': porosity,
    };
  }
}

class SoilHealth {
  final SoilHealthStatus status;
  final double microbialActivity; // percentage
  final double carbonContent; // percentage
  final List<String> beneficialMicrobes;
  final List<String> concerns;

  SoilHealth({
    required this.status,
    required this.microbialActivity,
    required this.carbonContent,
    required this.beneficialMicrobes,
    required this.concerns,
  });

  factory SoilHealth.fromJson(Map<String, dynamic> json) {
    return SoilHealth(
      status: SoilHealthStatus.values.firstWhere(
        (e) => e.toString() == 'SoilHealthStatus.${json['status']}',
        orElse: () => SoilHealthStatus.good,
      ),
      microbialActivity: json['microbialActivity'].toDouble(),
      carbonContent: json['carbonContent'].toDouble(),
      beneficialMicrobes: List<String>.from(json['beneficialMicrobes']),
      concerns: List<String>.from(json['concerns']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.toString().split('.').last,
      'microbialActivity': microbialActivity,
      'carbonContent': carbonContent,
      'beneficialMicrobes': beneficialMicrobes,
      'concerns': concerns,
    };
  }
}

class SoilRecommendation {
  final String id;
  final RecommendationType type;
  final String title;
  final String description;
  final RecommendationPriority priority;
  final List<String> actions;
  final String expectedOutcome;
  final int timeframeWeeks;

  SoilRecommendation({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.priority,
    required this.actions,
    required this.expectedOutcome,
    required this.timeframeWeeks,
  });

  factory SoilRecommendation.fromJson(Map<String, dynamic> json) {
    return SoilRecommendation(
      id: json['id'],
      type: RecommendationType.values.firstWhere(
        (e) => e.toString() == 'RecommendationType.${json['type']}',
        orElse: () => RecommendationType.fertilizer,
      ),
      title: json['title'],
      description: json['description'],
      priority: RecommendationPriority.values.firstWhere(
        (e) => e.toString() == 'RecommendationPriority.${json['priority']}',
        orElse: () => RecommendationPriority.medium,
      ),
      actions: List<String>.from(json['actions']),
      expectedOutcome: json['expectedOutcome'],
      timeframeWeeks: json['timeframeWeeks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'title': title,
      'description': description,
      'priority': priority.toString().split('.').last,
      'actions': actions,
      'expectedOutcome': expectedOutcome,
      'timeframeWeeks': timeframeWeeks,
    };
  }
}

class SoilQualityScore {
  final double overall; // 0-100
  final double fertility; // 0-100
  final double structure; // 0-100
  final double health; // 0-100
  final String grade; // A+, A, B+, B, C+, C, D

  SoilQualityScore({
    required this.overall,
    required this.fertility,
    required this.structure,
    required this.health,
    required this.grade,
  });

  factory SoilQualityScore.fromJson(Map<String, dynamic> json) {
    return SoilQualityScore(
      overall: json['overall'].toDouble(),
      fertility: json['fertility'].toDouble(),
      structure: json['structure'].toDouble(),
      health: json['health'].toDouble(),
      grade: json['grade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overall': overall,
      'fertility': fertility,
      'structure': structure,
      'health': health,
      'grade': grade,
    };
  }
}

enum SoilType {
  sand,
  silt,
  clay,
  loam,
  sandyLoam,
  siltyLoam,
  clayLoam,
  sandyClay,
  siltyClay,
}

enum SoilHealthStatus {
  excellent,
  good,
  fair,
  poor,
  critical,
}

enum RecommendationType {
  fertilizer,
  amendment,
  irrigation,
  cultivation,
  crop,
  pest,
}

enum RecommendationPriority {
  high,
  medium,
  low,
}
