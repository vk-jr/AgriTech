import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/models/plant_disease_model.dart';

class PlantDoctorProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isAnalyzing = false;
  DiagnosisResult? _diagnosisResult;
  String? _errorMessage;
  XFile? _selectedImage;
  List<DiagnosisResult> _diagnosisHistory = [];

  bool get isLoading => _isLoading;
  bool get isAnalyzing => _isAnalyzing;
  DiagnosisResult? get diagnosisResult => _diagnosisResult;
  String? get errorMessage => _errorMessage;
  XFile? get selectedImage => _selectedImage;
  List<DiagnosisResult> get diagnosisHistory => _diagnosisHistory;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setAnalyzing(bool analyzing) {
    _isAnalyzing = analyzing;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> pickImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (image != null) {
        _selectedImage = image;
        _diagnosisResult = null;
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to capture image. Please try again.');
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (image != null) {
        _selectedImage = image;
        _diagnosisResult = null;
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to select image. Please try again.');
    }
  }

  Future<void> analyzeImage() async {
    if (_selectedImage == null) {
      _setError('Please select an image first.');
      return;
    }

    _setAnalyzing(true);
    _setError(null);

    try {
      // Simulate AI analysis
      await Future.delayed(const Duration(seconds: 4));
      
      _diagnosisResult = _generateMockDiagnosis();
      _diagnosisHistory.insert(0, _diagnosisResult!);
      
      // Keep only last 10 diagnoses
      if (_diagnosisHistory.length > 10) {
        _diagnosisHistory = _diagnosisHistory.take(10).toList();
      }
      
      _setAnalyzing(false);
    } catch (e) {
      _setError('Analysis failed. Please try again.');
      _setAnalyzing(false);
    }
  }

  DiagnosisResult _generateMockDiagnosis() {
    // Generate random diagnosis for demo
    final diseases = _getMockDiseases();
    final selectedDisease = diseases[DateTime.now().millisecond % diseases.length];
    
    final confidence = 0.75 + (DateTime.now().millisecond % 25) / 100;
    
    return DiagnosisResult(
      disease: selectedDisease,
      confidence: confidence,
      analysisImageUrl: _selectedImage!.path,
      diagnosisDate: DateTime.now(),
      additionalNotes: [
        'Analysis completed using AI image recognition',
        'Confidence level: ${(confidence * 100).toStringAsFixed(1)}%',
        if (confidence < 0.8) 'Consider consulting with a local expert for verification'
      ],
      requiresExpertVerification: confidence < 0.8,
    );
  }

  List<PlantDiseaseModel> _getMockDiseases() {
    return [
      PlantDiseaseModel(
        id: '1',
        name: 'Early Blight',
        scientificName: 'Alternaria solani',
        type: DiseaseType.fungal,
        description: 'A common fungal disease affecting tomatoes and potatoes, causing dark spots on leaves.',
        symptoms: [
          'Dark brown spots with concentric rings on leaves',
          'Yellowing of affected leaves',
          'Premature leaf drop',
          'Stem lesions near soil line'
        ],
        causes: [
          'High humidity and warm temperatures',
          'Poor air circulation',
          'Overhead watering',
          'Stressed plants'
        ],
        affectedCrops: ['Tomato', 'Potato', 'Eggplant'],
        severity: DiseaseSeverity.medium,
        imageUrl: 'https://example.com/early_blight.jpg',
        treatments: [
          TreatmentOption(
            id: '1',
            name: 'Copper Fungicide',
            type: TreatmentType.chemical,
            description: 'Copper-based fungicide for early blight control',
            instructions: [
              'Mix 2ml per liter of water',
              'Spray on affected areas',
              'Apply in early morning or evening'
            ],
            dosage: '2ml/L',
            applicationFrequencyDays: 7,
            effectiveness: 0.85,
            isOrganic: false,
            costPerApplication: 25.0,
            precautions: ['Wear protective gear', 'Avoid spraying during rain'],
          ),
          TreatmentOption(
            id: '2',
            name: 'Neem Oil',
            type: TreatmentType.organic,
            description: 'Natural neem oil treatment',
            instructions: [
              'Mix 5ml neem oil per liter of water',
              'Add 1ml liquid soap as emulsifier',
              'Spray thoroughly on all plant parts'
            ],
            dosage: '5ml/L',
            applicationFrequencyDays: 5,
            effectiveness: 0.70,
            isOrganic: true,
            costPerApplication: 15.0,
            precautions: ['Test on small area first', 'Apply in cool weather'],
          ),
        ],
        preventionMethods: [
          'Improve air circulation around plants',
          'Avoid overhead watering',
          'Remove affected plant debris',
          'Rotate crops annually',
          'Use disease-resistant varieties'
        ],
        isContagious: true,
      ),
      PlantDiseaseModel(
        id: '2',
        name: 'Powdery Mildew',
        scientificName: 'Erysiphe cichoracearum',
        type: DiseaseType.fungal,
        description: 'A fungal disease that appears as white powdery spots on leaves.',
        symptoms: [
          'White powdery coating on leaves',
          'Yellowing and curling of leaves',
          'Stunted growth',
          'Reduced fruit quality'
        ],
        causes: [
          'High humidity with dry conditions',
          'Poor air circulation',
          'Overcrowded plants',
          'Shade conditions'
        ],
        affectedCrops: ['Cucumber', 'Zucchini', 'Pumpkin', 'Melon'],
        severity: DiseaseSeverity.medium,
        imageUrl: 'https://example.com/powdery_mildew.jpg',
        treatments: [
          TreatmentOption(
            id: '3',
            name: 'Baking Soda Spray',
            type: TreatmentType.organic,
            description: 'Homemade baking soda solution',
            instructions: [
              'Mix 1 tsp baking soda per liter of water',
              'Add few drops of liquid soap',
              'Spray on affected areas'
            ],
            dosage: '1 tsp/L',
            applicationFrequencyDays: 3,
            effectiveness: 0.65,
            isOrganic: true,
            costPerApplication: 5.0,
            precautions: ['Avoid spraying in direct sunlight'],
          ),
        ],
        preventionMethods: [
          'Ensure good air circulation',
          'Avoid overhead watering',
          'Plant in sunny locations',
          'Remove infected plant parts'
        ],
        isContagious: true,
      ),
      PlantDiseaseModel(
        id: '3',
        name: 'Bacterial Wilt',
        scientificName: 'Ralstonia solanacearum',
        type: DiseaseType.bacterial,
        description: 'A serious bacterial disease causing rapid wilting and plant death.',
        symptoms: [
          'Sudden wilting of plants',
          'Yellowing of leaves',
          'Brown discoloration of stem',
          'Plant death within days'
        ],
        causes: [
          'Contaminated soil',
          'Infected tools',
          'Water splash',
          'Root wounds'
        ],
        affectedCrops: ['Tomato', 'Potato', 'Eggplant', 'Pepper'],
        severity: DiseaseSeverity.high,
        imageUrl: 'https://example.com/bacterial_wilt.jpg',
        treatments: [
          TreatmentOption(
            id: '4',
            name: 'Copper Sulfate',
            type: TreatmentType.chemical,
            description: 'Copper-based bactericide',
            instructions: [
              'Mix as per label instructions',
              'Apply as soil drench',
              'Repeat after 10 days'
            ],
            dosage: 'As per label',
            applicationFrequencyDays: 10,
            effectiveness: 0.60,
            isOrganic: false,
            costPerApplication: 40.0,
            precautions: ['Use protective equipment', 'Avoid contact with skin'],
          ),
        ],
        preventionMethods: [
          'Use disease-free seeds',
          'Sanitize tools regularly',
          'Avoid working with wet plants',
          'Remove infected plants immediately',
          'Practice crop rotation'
        ],
        isContagious: true,
      ),
    ];
  }

  void clearDiagnosis() {
    _diagnosisResult = null;
    _selectedImage = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearHistory() {
    _diagnosisHistory = [];
    notifyListeners();
  }

  void removeDiagnosisFromHistory(int index) {
    if (index >= 0 && index < _diagnosisHistory.length) {
      _diagnosisHistory.removeAt(index);
      notifyListeners();
    }
  }
}
