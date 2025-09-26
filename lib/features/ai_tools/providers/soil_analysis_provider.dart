import 'package:flutter/foundation.dart';
import '../../../core/models/soil_analysis_model.dart';

class SoilAnalysisProvider extends ChangeNotifier {
  List<SoilAnalysisResult> _analysisHistory = [];
  SoilAnalysisResult? _currentAnalysis;
  bool _isAnalyzing = false;
  String? _errorMessage;

  // Getters
  List<SoilAnalysisResult> get analysisHistory => _analysisHistory;
  SoilAnalysisResult? get currentAnalysis => _currentAnalysis;
  bool get isAnalyzing => _isAnalyzing;
  String? get errorMessage => _errorMessage;

  SoilAnalysisProvider() {
    _initializeMockData();
  }

  void _setAnalyzing(bool analyzing) {
    _isAnalyzing = analyzing;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> analyzeSoil({
    required String location,
    String? farmId,
    Map<String, dynamic>? soilSample,
  }) async {
    _setAnalyzing(true);
    _setError(null);

    try {
      // Simulate soil analysis process
      await Future.delayed(const Duration(seconds: 3));
      
      // Generate mock analysis result
      final result = _generateMockAnalysis(location, farmId);
      
      _currentAnalysis = result;
      _analysisHistory.insert(0, result);
      
      // Keep only last 10 analyses
      if (_analysisHistory.length > 10) {
        _analysisHistory = _analysisHistory.take(10).toList();
      }
      
      _setAnalyzing(false);
    } catch (e) {
      _setError('Failed to analyze soil: $e');
      _setAnalyzing(false);
    }
  }

  SoilAnalysisResult _generateMockAnalysis(String location, String? farmId) {
    final random = DateTime.now().millisecondsSinceEpoch;
    
    return SoilAnalysisResult(
      id: 'analysis_$random',
      farmId: farmId ?? 'farm_default',
      location: location,
      analyzedAt: DateTime.now(),
      composition: SoilComposition(
        sand: 35.0 + (random % 20),
        silt: 40.0 + (random % 15),
        clay: 25.0 + (random % 10),
        soilType: SoilType.loam,
      ),
      nutrients: SoilNutrients(
        nitrogen: 45.0 + (random % 30),
        phosphorus: 25.0 + (random % 20),
        potassium: 180.0 + (random % 50),
        organicMatter: 3.2 + (random % 2),
        calcium: 1200.0 + (random % 300),
        magnesium: 150.0 + (random % 50),
        sulfur: 12.0 + (random % 8),
        iron: 4.5 + (random % 2),
        zinc: 1.2 + (random % 1),
        manganese: 5.0 + (random % 3),
      ),
      properties: SoilProperties(
        ph: 6.2 + (random % 2) * 0.1,
        electricalConductivity: 0.8 + (random % 5) * 0.1,
        moisture: 22.0 + (random % 15),
        temperature: 24.0 + (random % 8),
        bulkDensity: 1.3 + (random % 3) * 0.1,
        porosity: 48.0 + (random % 10),
      ),
      health: SoilHealth(
        status: SoilHealthStatus.good,
        microbialActivity: 75.0 + (random % 20),
        carbonContent: 2.8 + (random % 1),
        beneficialMicrobes: [
          'Rhizobium bacteria',
          'Mycorrhizal fungi',
          'Bacillus subtilis',
          'Pseudomonas fluorescens',
        ],
        concerns: random % 3 == 0 ? ['Low organic matter', 'Slight acidity'] : [],
      ),
      recommendations: _generateRecommendations(random),
      qualityScore: SoilQualityScore(
        overall: 78.0 + (random % 15),
        fertility: 82.0 + (random % 12),
        structure: 75.0 + (random % 18),
        health: 80.0 + (random % 15),
        grade: 'B+',
      ),
    );
  }

  List<SoilRecommendation> _generateRecommendations(int seed) {
    return [
      SoilRecommendation(
        id: 'rec_1_$seed',
        type: RecommendationType.fertilizer,
        title: 'Apply Organic Compost',
        description: 'Increase organic matter content to improve soil structure and nutrient retention.',
        priority: RecommendationPriority.high,
        actions: [
          'Apply 2-3 inches of well-aged compost',
          'Mix compost into top 6 inches of soil',
          'Water thoroughly after application',
        ],
        expectedOutcome: 'Improved soil structure and increased organic matter by 0.5-1%',
        timeframeWeeks: 4,
      ),
      SoilRecommendation(
        id: 'rec_2_$seed',
        type: RecommendationType.amendment,
        title: 'pH Adjustment',
        description: 'Soil pH is slightly acidic. Consider lime application to optimize nutrient availability.',
        priority: RecommendationPriority.medium,
        actions: [
          'Apply agricultural lime at 500 lbs per acre',
          'Till lime into soil 4-6 inches deep',
          'Retest pH after 3 months',
        ],
        expectedOutcome: 'pH increase to optimal range of 6.5-7.0',
        timeframeWeeks: 12,
      ),
      SoilRecommendation(
        id: 'rec_3_$seed',
        type: RecommendationType.crop,
        title: 'Cover Crop Planting',
        description: 'Plant nitrogen-fixing cover crops to improve soil health and fertility.',
        priority: RecommendationPriority.medium,
        actions: [
          'Plant legume cover crops (clover, vetch)',
          'Allow 6-8 weeks of growth',
          'Till under before main crop planting',
        ],
        expectedOutcome: 'Increased nitrogen content and improved soil biology',
        timeframeWeeks: 8,
      ),
      SoilRecommendation(
        id: 'rec_4_$seed',
        type: RecommendationType.irrigation,
        title: 'Moisture Management',
        description: 'Optimize irrigation schedule based on current soil moisture levels.',
        priority: RecommendationPriority.low,
        actions: [
          'Install soil moisture sensors',
          'Adjust irrigation frequency',
          'Apply mulch to reduce evaporation',
        ],
        expectedOutcome: 'Better water retention and reduced irrigation costs',
        timeframeWeeks: 2,
      ),
    ];
  }

  void _initializeMockData() {
    // Initialize with one sample analysis
    _analysisHistory = [
      _generateMockAnalysis('Kochi, Kerala', 'farm_sample'),
    ];
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void selectAnalysis(SoilAnalysisResult analysis) {
    _currentAnalysis = analysis;
    notifyListeners();
  }

  String getSoilTypeDisplayName(SoilType type) {
    switch (type) {
      case SoilType.sand:
        return 'Sandy Soil';
      case SoilType.silt:
        return 'Silty Soil';
      case SoilType.clay:
        return 'Clay Soil';
      case SoilType.loam:
        return 'Loamy Soil';
      case SoilType.sandyLoam:
        return 'Sandy Loam';
      case SoilType.siltyLoam:
        return 'Silty Loam';
      case SoilType.clayLoam:
        return 'Clay Loam';
      case SoilType.sandyClay:
        return 'Sandy Clay';
      case SoilType.siltyClay:
        return 'Silty Clay';
    }
  }

  String getHealthStatusDisplayName(SoilHealthStatus status) {
    switch (status) {
      case SoilHealthStatus.excellent:
        return 'Excellent';
      case SoilHealthStatus.good:
        return 'Good';
      case SoilHealthStatus.fair:
        return 'Fair';
      case SoilHealthStatus.poor:
        return 'Poor';
      case SoilHealthStatus.critical:
        return 'Critical';
    }
  }

  String getRecommendationTypeDisplayName(RecommendationType type) {
    switch (type) {
      case RecommendationType.fertilizer:
        return 'Fertilizer';
      case RecommendationType.amendment:
        return 'Soil Amendment';
      case RecommendationType.irrigation:
        return 'Irrigation';
      case RecommendationType.cultivation:
        return 'Cultivation';
      case RecommendationType.crop:
        return 'Crop Management';
      case RecommendationType.pest:
        return 'Pest Control';
    }
  }

  String getPriorityDisplayName(RecommendationPriority priority) {
    switch (priority) {
      case RecommendationPriority.high:
        return 'High Priority';
      case RecommendationPriority.medium:
        return 'Medium Priority';
      case RecommendationPriority.low:
        return 'Low Priority';
    }
  }
}
