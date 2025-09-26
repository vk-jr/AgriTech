class FarmCollaboration {
  final String id;
  final String title;
  final String description;
  final String farmName;
  final String location;
  final String ownerName;
  final String ownerAvatar;
  final CollabType type;
  final List<String> skillsNeeded;
  final List<String> skillsOffered;
  final DateTime startDate;
  final DateTime? endDate;
  final int maxParticipants;
  final int currentParticipants;
  final double? budget;
  final String? budgetCurrency;
  final CollabStatus status;
  final DateTime createdAt;
  final List<String> tags;
  final String? contactInfo;
  final bool isUrgent;
  final List<CollabApplication> applications;

  FarmCollaboration({
    required this.id,
    required this.title,
    required this.description,
    required this.farmName,
    required this.location,
    required this.ownerName,
    required this.ownerAvatar,
    required this.type,
    required this.skillsNeeded,
    required this.skillsOffered,
    required this.startDate,
    this.endDate,
    required this.maxParticipants,
    required this.currentParticipants,
    this.budget,
    this.budgetCurrency = 'INR',
    required this.status,
    required this.createdAt,
    required this.tags,
    this.contactInfo,
    this.isUrgent = false,
    required this.applications,
  });

  factory FarmCollaboration.fromJson(Map<String, dynamic> json) {
    return FarmCollaboration(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      farmName: json['farmName'],
      location: json['location'],
      ownerName: json['ownerName'],
      ownerAvatar: json['ownerAvatar'],
      type: CollabType.values.firstWhere(
        (e) => e.toString() == 'CollabType.${json['type']}',
        orElse: () => CollabType.general,
      ),
      skillsNeeded: List<String>.from(json['skillsNeeded']),
      skillsOffered: List<String>.from(json['skillsOffered']),
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      maxParticipants: json['maxParticipants'],
      currentParticipants: json['currentParticipants'],
      budget: json['budget']?.toDouble(),
      budgetCurrency: json['budgetCurrency'] ?? 'INR',
      status: CollabStatus.values.firstWhere(
        (e) => e.toString() == 'CollabStatus.${json['status']}',
        orElse: () => CollabStatus.open,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      tags: List<String>.from(json['tags']),
      contactInfo: json['contactInfo'],
      isUrgent: json['isUrgent'] ?? false,
      applications: (json['applications'] as List?)
          ?.map((app) => CollabApplication.fromJson(app))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'farmName': farmName,
      'location': location,
      'ownerName': ownerName,
      'ownerAvatar': ownerAvatar,
      'type': type.toString().split('.').last,
      'skillsNeeded': skillsNeeded,
      'skillsOffered': skillsOffered,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'budget': budget,
      'budgetCurrency': budgetCurrency,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'tags': tags,
      'contactInfo': contactInfo,
      'isUrgent': isUrgent,
      'applications': applications.map((app) => app.toJson()).toList(),
    };
  }
}

class CollabApplication {
  final String id;
  final String collabId;
  final String applicantId;
  final String applicantName;
  final String applicantAvatar;
  final String message;
  final List<String> skills;
  final String experience;
  final ApplicationStatus status;
  final DateTime appliedAt;
  final DateTime? respondedAt;
  final String? responseMessage;

  CollabApplication({
    required this.id,
    required this.collabId,
    required this.applicantId,
    required this.applicantName,
    required this.applicantAvatar,
    required this.message,
    required this.skills,
    required this.experience,
    required this.status,
    required this.appliedAt,
    this.respondedAt,
    this.responseMessage,
  });

  factory CollabApplication.fromJson(Map<String, dynamic> json) {
    return CollabApplication(
      id: json['id'],
      collabId: json['collabId'],
      applicantId: json['applicantId'],
      applicantName: json['applicantName'],
      applicantAvatar: json['applicantAvatar'],
      message: json['message'],
      skills: List<String>.from(json['skills']),
      experience: json['experience'],
      status: ApplicationStatus.values.firstWhere(
        (e) => e.toString() == 'ApplicationStatus.${json['status']}',
        orElse: () => ApplicationStatus.pending,
      ),
      appliedAt: DateTime.parse(json['appliedAt']),
      respondedAt: json['respondedAt'] != null ? DateTime.parse(json['respondedAt']) : null,
      responseMessage: json['responseMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collabId': collabId,
      'applicantId': applicantId,
      'applicantName': applicantName,
      'applicantAvatar': applicantAvatar,
      'message': message,
      'skills': skills,
      'experience': experience,
      'status': status.toString().split('.').last,
      'appliedAt': appliedAt.toIso8601String(),
      'respondedAt': respondedAt?.toIso8601String(),
      'responseMessage': responseMessage,
    };
  }
}

class UserCollabPreference {
  final String userId;
  final bool isOpenForCollaboration;
  final List<String> interestedSkills;
  final List<String> availableSkills;
  final String preferredLocation;
  final CollabType preferredType;
  final String? bio;

  UserCollabPreference({
    required this.userId,
    required this.isOpenForCollaboration,
    required this.interestedSkills,
    required this.availableSkills,
    required this.preferredLocation,
    required this.preferredType,
    this.bio,
  });

  factory UserCollabPreference.fromJson(Map<String, dynamic> json) {
    return UserCollabPreference(
      userId: json['userId'],
      isOpenForCollaboration: json['isOpenForCollaboration'],
      interestedSkills: List<String>.from(json['interestedSkills']),
      availableSkills: List<String>.from(json['availableSkills']),
      preferredLocation: json['preferredLocation'],
      preferredType: CollabType.values.firstWhere(
        (e) => e.toString() == 'CollabType.${json['preferredType']}',
        orElse: () => CollabType.general,
      ),
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'isOpenForCollaboration': isOpenForCollaboration,
      'interestedSkills': interestedSkills,
      'availableSkills': availableSkills,
      'preferredLocation': preferredLocation,
      'preferredType': preferredType.toString().split('.').last,
      'bio': bio,
    };
  }
}

enum CollabType {
  general,
  laborSharing,
  equipmentSharing,
  knowledgeExchange,
  jointVenture,
  resourceSharing,
  skillExchange,
  marketingTogether,
}

enum CollabStatus {
  open,
  inProgress,
  completed,
  cancelled,
  paused,
}

enum ApplicationStatus {
  pending,
  accepted,
  rejected,
  withdrawn,
}
