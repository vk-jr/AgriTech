import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/models/crop_model.dart';

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}

class CropSuggestionProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<CropSuggestion> _suggestions = [];
  String? _errorMessage;
  
  // Input parameters
  String _soilType = '';
  String _climate = '';
  double _landSize = 0.0;
  String _location = '';
  double _budget = 0.0;
  bool _isOrganicPreferred = false;
  List<String> _marketDemand = [];
  List<ChatMessage> _chatMessages = [];

  bool get isLoading => _isLoading;
  List<CropSuggestion> get suggestions => _suggestions;
  String? get errorMessage => _errorMessage;
  
  String get soilType => _soilType;
  String get climate => _climate;
  double get landSize => _landSize;
  String get location => _location;
  double get budget => _budget;
  bool get isOrganicPreferred => _isOrganicPreferred;
  List<String> get marketDemand => _marketDemand;
  List<ChatMessage> get chatMessages => _chatMessages;

  void updateSoilType(String value) {
    _soilType = value;
    notifyListeners();
  }

  void updateClimate(String value) {
    _climate = value;
    notifyListeners();
  }

  void updateLandSize(double value) {
    _landSize = value;
    notifyListeners();
  }

  void updateLocation(String value) {
    _location = value;
    notifyListeners();
  }

  void updateBudget(double value) {
    _budget = value;
    notifyListeners();
  }

  void updateOrganicPreference(bool value) {
    _isOrganicPreferred = value;
    notifyListeners();
  }

  void updateMarketDemand(List<String> value) {
    _marketDemand = value;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> getCropSuggestions() async {
    _setLoading(true);
    _setError(null);

    try {
      // Add user input summary to chat
      String userSummary = _buildUserInputSummary();
      _chatMessages.add(ChatMessage(
        content: userSummary,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      notifyListeners();

      // Add loading message to chat
      _chatMessages.add(ChatMessage(
        content: "Let's see...",
        isUser: false,
        timestamp: DateTime.now(),
      ));
      notifyListeners();

      // Send data to webhook
      final response = await _sendDataToWebhook();
      
      // Remove loading message
      if (_chatMessages.isNotEmpty && _chatMessages.last.content.contains("🤔 Analyzing")) {
        _chatMessages.removeLast();
      }
      
      if (response != null) {
        // Add webhook response to chat
        _chatMessages.add(ChatMessage(
          content: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      }
      
      _setLoading(false);
    } catch (e) {
      // Remove loading message if error occurs
      if (_chatMessages.isNotEmpty && _chatMessages.last.content.contains("🤔 Analyzing")) {
        _chatMessages.removeLast();
      }
      _setError('Failed to get crop suggestions. Please try again.');
      _setLoading(false);
    }
  }

  String _buildUserInputSummary() {
    List<String> details = [];
    
    if (_soilType.isNotEmpty) details.add("Soil: $_soilType");
    if (_climate.isNotEmpty) details.add("Climate: $_climate");
    if (_location.isNotEmpty) details.add("Location: $_location");
    if (_landSize > 0) details.add("Land Size: $_landSize acres");
    if (_budget > 0) details.add("Budget: ₹$_budget");
    if (_isOrganicPreferred) details.add("Prefers organic farming");
    
    return "Looking for crop recommendations with:\n${details.join('\n')}";
  }

  Future<String?> _sendDataToWebhook() async {
    try {
      const String webhookUrl = 'https://vxsm321.app.n8n.cloud/webhook/cropAssistant';
      
      final requestData = {
        'soilType': _soilType,
        'climate': _climate,
        'location': _location,
        'landSize': _landSize,
        'budget': _budget,
        'isOrganicPreferred': _isOrganicPreferred,
        'marketDemand': _marketDemand,
      };

      if (kDebugMode) {
        print('Sending crop data to webhook: $webhookUrl');
        print('Request data: ${json.encode(requestData)}');
      }

      final response = await http.post(
        Uri.parse(webhookUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (kDebugMode) {
          print('Data successfully sent to webhook');
          print('Response: $responseBody');
        }
        
        // Parse the JSON response
        try {
          final jsonResponse = json.decode(responseBody);
          if (jsonResponse['Result'] != null) {
            return jsonResponse['Result'].toString();
          }
          return responseBody;
        } catch (e) {
          return responseBody;
        }
      } else {
        if (kDebugMode) {
          print('Failed to send data to webhook. Status code: ${response.statusCode}');
        }
        return 'Failed to get crop recommendations. Please try again.';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending data to webhook: $e');
      }
      return 'Error occurred while getting recommendations.';
    }
  }

  List<CropSuggestion> _generateMockSuggestions() {
    // Mock data based on input parameters
    List<CropSuggestion> mockSuggestions = [];

    if (_soilType.toLowerCase().contains('clay') || _soilType.toLowerCase().contains('loam')) {
      mockSuggestions.add(CropSuggestion(
        crop: CropModel(
          id: '1',
          name: 'Rice',
          scientificName: 'Oryza sativa',
          category: 'Cereal',
          imageUrl: 'https://example.com/rice.jpg',
          requirements: CropRequirements(
            minTemperature: 20,
            maxTemperature: 35,
            minHumidity: 60,
            maxHumidity: 90,
            minRainfall: 1000,
            maxRainfall: 2500,
            phMin: 5.5,
            phMax: 7.0,
            sunlightHours: 6,
            waterRequirementLitersPerDay: 5.0,
          ),
          suitableSoilTypes: ['Clay', 'Clay Loam', 'Silty Clay'],
          suitableClimates: ['Tropical', 'Subtropical'],
          growthDurationDays: 120,
          expectedYieldPerSqMeter: 0.6,
          marketPricePerKg: 25.0,
          commonDiseases: ['Blast', 'Brown Spot', 'Sheath Blight'],
          commonPests: ['Rice Stem Borer', 'Brown Plant Hopper'],
          description: 'Rice is a staple food crop that grows well in clay soils with good water retention.',
          isOrganicFriendly: true,
          difficulty: CropDifficulty.medium,
        ),
        suitabilityScore: 0.92,
        reason: 'Excellent match for clay soil and tropical climate. High market demand.',
        tips: [
          'Ensure proper water management during monsoon',
          'Use disease-resistant varieties',
          'Consider direct seeding for better yield'
        ],
        profitabilityScore: 0.85,
        riskLevel: 0.3,
      ));
    }

    if (_soilType.toLowerCase().contains('sandy') || _soilType.toLowerCase().contains('loam')) {
      mockSuggestions.add(CropSuggestion(
        crop: CropModel(
          id: '2',
          name: 'Tomato',
          scientificName: 'Solanum lycopersicum',
          category: 'Vegetable',
          imageUrl: 'https://example.com/tomato.jpg',
          requirements: CropRequirements(
            minTemperature: 18,
            maxTemperature: 29,
            minHumidity: 40,
            maxHumidity: 70,
            minRainfall: 600,
            maxRainfall: 1200,
            phMin: 6.0,
            phMax: 7.0,
            sunlightHours: 8,
            waterRequirementLitersPerDay: 3.0,
          ),
          suitableSoilTypes: ['Sandy Loam', 'Loam', 'Clay Loam'],
          suitableClimates: ['Temperate', 'Subtropical'],
          growthDurationDays: 90,
          expectedYieldPerSqMeter: 4.0,
          marketPricePerKg: 40.0,
          commonDiseases: ['Early Blight', 'Late Blight', 'Bacterial Wilt'],
          commonPests: ['Whitefly', 'Aphids', 'Fruit Borer'],
          description: 'High-value vegetable crop with excellent market potential.',
          isOrganicFriendly: true,
          difficulty: CropDifficulty.medium,
        ),
        suitabilityScore: 0.88,
        reason: 'Good soil drainage and climate conditions. High profit potential.',
        tips: [
          'Use drip irrigation for water efficiency',
          'Provide support structures for climbing',
          'Regular pruning increases yield'
        ],
        profitabilityScore: 0.92,
        riskLevel: 0.4,
      ));
    }

    mockSuggestions.add(CropSuggestion(
      crop: CropModel(
        id: '3',
        name: 'Wheat',
        scientificName: 'Triticum aestivum',
        category: 'Cereal',
        imageUrl: 'https://example.com/wheat.jpg',
        requirements: CropRequirements(
          minTemperature: 12,
          maxTemperature: 25,
          minHumidity: 50,
          maxHumidity: 70,
          minRainfall: 500,
          maxRainfall: 1000,
          phMin: 6.0,
          phMax: 7.5,
          sunlightHours: 7,
          waterRequirementLitersPerDay: 2.5,
        ),
        suitableSoilTypes: ['Loam', 'Clay Loam', 'Sandy Loam'],
        suitableClimates: ['Temperate', 'Semi-arid'],
        growthDurationDays: 150,
        expectedYieldPerSqMeter: 0.4,
        marketPricePerKg: 22.0,
        commonDiseases: ['Rust', 'Smut', 'Bunt'],
        commonPests: ['Aphids', 'Army Worm'],
        description: 'Staple cereal crop with stable market demand.',
        isOrganicFriendly: true,
        difficulty: CropDifficulty.easy,
      ),
      suitabilityScore: 0.75,
      reason: 'Reliable crop with low risk and stable returns.',
      tips: [
        'Sow at optimal time for best yield',
        'Use certified seeds',
        'Apply balanced fertilization'
      ],
      profitabilityScore: 0.70,
      riskLevel: 0.2,
    ));

    // Sort by suitability score
    mockSuggestions.sort((a, b) => b.suitabilityScore.compareTo(a.suitabilityScore));
    
    return mockSuggestions;
  }

  void clearSuggestions() {
    _suggestions = [];
    _errorMessage = null;
    _chatMessages.clear();
    notifyListeners();
  }

  void resetForm() {
    _soilType = '';
    _climate = '';
    _landSize = 0.0;
    _location = '';
    _budget = 0.0;
    _isOrganicPreferred = false;
    _marketDemand = [];
    _suggestions = [];
    _errorMessage = null;
    _chatMessages.clear();
    notifyListeners();
  }
}
