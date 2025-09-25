class PlantDiseaseModel {
  final String id;
  final String name;
  final String scientificName;
  final DiseaseType type;
  final String description;
  final List<String> symptoms;
  final List<String> causes;
  final List<String> affectedCrops;
  final DiseaseSeverity severity;
  final String imageUrl;
  final List<TreatmentOption> treatments;
  final List<String> preventionMethods;
  final bool isContagious;
  final double confidenceScore;

  PlantDiseaseModel({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.type,
    required this.description,
    required this.symptoms,
    required this.causes,
    required this.affectedCrops,
    required this.severity,
    required this.imageUrl,
    required this.treatments,
    required this.preventionMethods,
    this.isContagious = false,
    this.confidenceScore = 0.0,
  });

  factory PlantDiseaseModel.fromJson(Map<String, dynamic> json) {
    return PlantDiseaseModel(
      id: json['id'],
      name: json['name'],
      scientificName: json['scientificName'],
      type: DiseaseType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => DiseaseType.fungal,
      ),
      description: json['description'],
      symptoms: List<String>.from(json['symptoms']),
      causes: List<String>.from(json['causes']),
      affectedCrops: List<String>.from(json['affectedCrops']),
      severity: DiseaseSeverity.values.firstWhere(
        (s) => s.name == json['severity'],
        orElse: () => DiseaseSeverity.medium,
      ),
      imageUrl: json['imageUrl'],
      treatments: (json['treatments'] as List)
          .map((t) => TreatmentOption.fromJson(t))
          .toList(),
      preventionMethods: List<String>.from(json['preventionMethods']),
      isContagious: json['isContagious'] ?? false,
      confidenceScore: json['confidenceScore']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scientificName': scientificName,
      'type': type.name,
      'description': description,
      'symptoms': symptoms,
      'causes': causes,
      'affectedCrops': affectedCrops,
      'severity': severity.name,
      'imageUrl': imageUrl,
      'treatments': treatments.map((t) => t.toJson()).toList(),
      'preventionMethods': preventionMethods,
      'isContagious': isContagious,
      'confidenceScore': confidenceScore,
    };
  }
}

enum DiseaseType {
  fungal,
  bacterial,
  viral,
  pest,
  nutritional,
  environmental,
}

enum DiseaseSeverity {
  low,
  medium,
  high,
  critical,
}

class TreatmentOption {
  final String id;
  final String name;
  final TreatmentType type;
  final String description;
  final List<String> instructions;
  final String dosage;
  final int applicationFrequencyDays;
  final double effectiveness;
  final bool isOrganic;
  final double costPerApplication;
  final List<String> precautions;

  TreatmentOption({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.instructions,
    required this.dosage,
    required this.applicationFrequencyDays,
    required this.effectiveness,
    this.isOrganic = false,
    this.costPerApplication = 0.0,
    this.precautions = const [],
  });

  factory TreatmentOption.fromJson(Map<String, dynamic> json) {
    return TreatmentOption(
      id: json['id'],
      name: json['name'],
      type: TreatmentType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => TreatmentType.chemical,
      ),
      description: json['description'],
      instructions: List<String>.from(json['instructions']),
      dosage: json['dosage'],
      applicationFrequencyDays: json['applicationFrequencyDays'],
      effectiveness: json['effectiveness'].toDouble(),
      isOrganic: json['isOrganic'] ?? false,
      costPerApplication: json['costPerApplication']?.toDouble() ?? 0.0,
      precautions: List<String>.from(json['precautions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'description': description,
      'instructions': instructions,
      'dosage': dosage,
      'applicationFrequencyDays': applicationFrequencyDays,
      'effectiveness': effectiveness,
      'isOrganic': isOrganic,
      'costPerApplication': costPerApplication,
      'precautions': precautions,
    };
  }
}

enum TreatmentType {
  chemical,
  organic,
  biological,
  cultural,
  mechanical,
}

class DiagnosisResult {
  final PlantDiseaseModel disease;
  final double confidence;
  final String analysisImageUrl;
  final DateTime diagnosisDate;
  final List<String> additionalNotes;
  final bool requiresExpertVerification;

  DiagnosisResult({
    required this.disease,
    required this.confidence,
    required this.analysisImageUrl,
    required this.diagnosisDate,
    this.additionalNotes = const [],
    this.requiresExpertVerification = false,
  });

  factory DiagnosisResult.fromJson(Map<String, dynamic> json) {
    return DiagnosisResult(
      disease: PlantDiseaseModel.fromJson(json['disease']),
      confidence: json['confidence'].toDouble(),
      analysisImageUrl: json['analysisImageUrl'],
      diagnosisDate: DateTime.parse(json['diagnosisDate']),
      additionalNotes: List<String>.from(json['additionalNotes'] ?? []),
      requiresExpertVerification: json['requiresExpertVerification'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'disease': disease.toJson(),
      'confidence': confidence,
      'analysisImageUrl': analysisImageUrl,
      'diagnosisDate': diagnosisDate.toIso8601String(),
      'additionalNotes': additionalNotes,
      'requiresExpertVerification': requiresExpertVerification,
    };
  }
}
