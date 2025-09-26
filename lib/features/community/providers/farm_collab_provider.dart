import 'package:flutter/foundation.dart';
import '../../../core/models/farm_collab_model.dart';

class FarmCollabProvider extends ChangeNotifier {
  List<FarmCollaboration> _allCollaborations = [];
  List<CollabApplication> _userApplications = [];
  List<FarmCollaboration> _activeCollaborations = [];
  UserCollabPreference? _userPreference;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<FarmCollaboration> get allCollaborations => _allCollaborations;
  List<CollabApplication> get userApplications => _userApplications;
  List<FarmCollaboration> get activeCollaborations => _activeCollaborations;
  UserCollabPreference? get userPreference => _userPreference;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Filtered lists for tabs
  List<CollabApplication> get pendingApplications => 
      _userApplications.where((app) => app.status == ApplicationStatus.pending).toList();
  
  List<CollabApplication> get acceptedApplications => 
      _userApplications.where((app) => app.status == ApplicationStatus.accepted).toList();

  FarmCollabProvider() {
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

  Future<void> loadCollaborations() async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      _initializeMockData();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load collaborations: $e');
      _setLoading(false);
    }
  }

  Future<bool> applyForCollaboration(String collabId, String message, List<String> skills, String experience) async {
    try {
      final application = CollabApplication(
        id: 'app_${DateTime.now().millisecondsSinceEpoch}',
        collabId: collabId,
        applicantId: 'current_user',
        applicantName: 'Current User',
        applicantAvatar: 'CU',
        message: message,
        skills: skills,
        experience: experience,
        status: ApplicationStatus.pending,
        appliedAt: DateTime.now(),
      );

      _userApplications.add(application);
      
      // Update collaboration applications list
      final collabIndex = _allCollaborations.indexWhere((c) => c.id == collabId);
      if (collabIndex != -1) {
        _allCollaborations[collabIndex].applications.add(application);
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to apply: $e');
      return false;
    }
  }

  Future<bool> withdrawApplication(String applicationId) async {
    try {
      final appIndex = _userApplications.indexWhere((app) => app.id == applicationId);
      if (appIndex != -1) {
        _userApplications[appIndex] = CollabApplication(
          id: _userApplications[appIndex].id,
          collabId: _userApplications[appIndex].collabId,
          applicantId: _userApplications[appIndex].applicantId,
          applicantName: _userApplications[appIndex].applicantName,
          applicantAvatar: _userApplications[appIndex].applicantAvatar,
          message: _userApplications[appIndex].message,
          skills: _userApplications[appIndex].skills,
          experience: _userApplications[appIndex].experience,
          status: ApplicationStatus.withdrawn,
          appliedAt: _userApplications[appIndex].appliedAt,
          respondedAt: DateTime.now(),
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to withdraw application: $e');
      return false;
    }
  }

  void updateUserPreference(UserCollabPreference preference) {
    _userPreference = preference;
    notifyListeners();
  }

  void toggleCollaborationAvailability() {
    if (_userPreference != null) {
      _userPreference = UserCollabPreference(
        userId: _userPreference!.userId,
        isOpenForCollaboration: !_userPreference!.isOpenForCollaboration,
        interestedSkills: _userPreference!.interestedSkills,
        availableSkills: _userPreference!.availableSkills,
        preferredLocation: _userPreference!.preferredLocation,
        preferredType: _userPreference!.preferredType,
        bio: _userPreference!.bio,
      );
      notifyListeners();
    }
  }

  List<FarmCollaboration> searchCollaborations(String query) {
    if (query.isEmpty) return _allCollaborations;
    
    return _allCollaborations.where((collab) {
      return collab.title.toLowerCase().contains(query.toLowerCase()) ||
             collab.description.toLowerCase().contains(query.toLowerCase()) ||
             collab.farmName.toLowerCase().contains(query.toLowerCase()) ||
             collab.location.toLowerCase().contains(query.toLowerCase()) ||
             collab.skillsNeeded.any((skill) => skill.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  List<FarmCollaboration> filterByType(CollabType? type) {
    if (type == null) return _allCollaborations;
    return _allCollaborations.where((collab) => collab.type == type).toList();
  }

  void _initializeMockData() {
    _userPreference = UserCollabPreference(
      userId: 'current_user',
      isOpenForCollaboration: true,
      interestedSkills: ['Organic Farming', 'Irrigation', 'Pest Control'],
      availableSkills: ['Rice Cultivation', 'Water Management'],
      preferredLocation: 'Kerala, India',
      preferredType: CollabType.knowledgeExchange,
      bio: 'Experienced rice farmer looking to learn and share knowledge',
    );

    _allCollaborations = [
      FarmCollaboration(
        id: 'collab_1',
        title: 'Organic Vegetable Farm Partnership',
        description: 'Looking for experienced farmers to collaborate on organic vegetable cultivation. Share resources, knowledge, and market access.',
        farmName: 'Green Valley Farm',
        location: 'Kochi, Kerala',
        ownerName: 'Rajesh Kumar',
        ownerAvatar: 'RK',
        type: CollabType.jointVenture,
        skillsNeeded: ['Organic Farming', 'Marketing', 'Quality Control'],
        skillsOffered: ['Land Access', 'Equipment', 'Local Market Connections'],
        startDate: DateTime.now().add(const Duration(days: 15)),
        endDate: DateTime.now().add(const Duration(days: 180)),
        maxParticipants: 3,
        currentParticipants: 1,
        budget: 50000,
        status: CollabStatus.open,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        tags: ['organic', 'vegetables', 'partnership', 'kerala'],
        contactInfo: '+91 9876543210',
        isUrgent: false,
        applications: [],
      ),
      FarmCollaboration(
        id: 'collab_2',
        title: 'Rice Harvesting Equipment Sharing',
        description: 'Share harvesting equipment costs and labor during rice season. Looking for nearby farms to coordinate harvesting schedule.',
        farmName: 'Paddy Fields Co-op',
        location: 'Alappuzha, Kerala',
        ownerName: 'Priya Nair',
        ownerAvatar: 'PN',
        type: CollabType.equipmentSharing,
        skillsNeeded: ['Equipment Operation', 'Coordination'],
        skillsOffered: ['Harvester Access', 'Storage Facility'],
        startDate: DateTime.now().add(const Duration(days: 30)),
        endDate: DateTime.now().add(const Duration(days: 45)),
        maxParticipants: 5,
        currentParticipants: 2,
        budget: 25000,
        status: CollabStatus.open,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        tags: ['rice', 'harvesting', 'equipment', 'alappuzha'],
        contactInfo: 'priya.nair@email.com',
        isUrgent: true,
        applications: [],
      ),
      FarmCollaboration(
        id: 'collab_3',
        title: 'Spice Garden Knowledge Exchange',
        description: 'Experienced spice farmers welcome newcomers. Learn traditional cultivation methods and modern techniques.',
        farmName: 'Spice Heritage Farm',
        location: 'Wayanad, Kerala',
        ownerName: 'Suresh Menon',
        ownerAvatar: 'SM',
        type: CollabType.knowledgeExchange,
        skillsNeeded: ['Enthusiasm to Learn', 'Basic Farming Knowledge'],
        skillsOffered: ['Expert Guidance', 'Traditional Techniques', 'Market Insights'],
        startDate: DateTime.now().add(const Duration(days: 7)),
        maxParticipants: 8,
        currentParticipants: 3,
        status: CollabStatus.open,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        tags: ['spices', 'knowledge', 'traditional', 'wayanad'],
        contactInfo: '+91 9123456789',
        isUrgent: false,
        applications: [],
      ),
    ];

    _userApplications = [
      CollabApplication(
        id: 'app_1',
        collabId: 'collab_1',
        applicantId: 'current_user',
        applicantName: 'Current User',
        applicantAvatar: 'CU',
        message: 'I have 5 years of organic farming experience and would love to contribute to this partnership.',
        skills: ['Organic Farming', 'Pest Control', 'Soil Management'],
        experience: '5 years in organic vegetable cultivation',
        status: ApplicationStatus.pending,
        appliedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      CollabApplication(
        id: 'app_2',
        collabId: 'collab_3',
        applicantId: 'current_user',
        applicantName: 'Current User',
        applicantAvatar: 'CU',
        message: 'Interested in learning traditional spice cultivation methods.',
        skills: ['Basic Farming', 'Water Management'],
        experience: '2 years in general farming',
        status: ApplicationStatus.accepted,
        appliedAt: DateTime.now().subtract(const Duration(days: 4)),
        respondedAt: DateTime.now().subtract(const Duration(days: 1)),
        responseMessage: 'Welcome! Looking forward to sharing knowledge with you.',
      ),
    ];

    _activeCollaborations = [
      _allCollaborations[2], // Spice Garden Knowledge Exchange
    ];
  }

  String getCollabTypeDisplayName(CollabType type) {
    switch (type) {
      case CollabType.general:
        return 'General';
      case CollabType.laborSharing:
        return 'Labor Sharing';
      case CollabType.equipmentSharing:
        return 'Equipment Sharing';
      case CollabType.knowledgeExchange:
        return 'Knowledge Exchange';
      case CollabType.jointVenture:
        return 'Joint Venture';
      case CollabType.resourceSharing:
        return 'Resource Sharing';
      case CollabType.skillExchange:
        return 'Skill Exchange';
      case CollabType.marketingTogether:
        return 'Marketing Together';
    }
  }

  String getApplicationStatusDisplayName(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return 'Pending';
      case ApplicationStatus.accepted:
        return 'Accepted';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.withdrawn:
        return 'Withdrawn';
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
