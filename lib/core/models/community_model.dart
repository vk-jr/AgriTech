class ForumPost {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;
  final PostCategory category;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likes;
  final int commentCount;
  final int views;
  final bool isPinned;
  final bool isResolved;
  final List<String> imageUrls;
  final String? location;
  final PostType type;

  ForumPost({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    this.authorAvatarUrl,
    required this.category,
    this.tags = const [],
    required this.createdAt,
    this.updatedAt,
    this.likes = 0,
    this.commentCount = 0,
    this.views = 0,
    this.isPinned = false,
    this.isResolved = false,
    this.imageUrls = const [],
    this.location,
    this.type = PostType.discussion,
  });

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    return ForumPost(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorAvatarUrl: json['authorAvatarUrl'],
      category: PostCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => PostCategory.general,
      ),
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      likes: json['likes'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      views: json['views'] ?? 0,
      isPinned: json['isPinned'] ?? false,
      isResolved: json['isResolved'] ?? false,
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      location: json['location'],
      type: PostType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => PostType.discussion,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatarUrl': authorAvatarUrl,
      'category': category.name,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'likes': likes,
      'commentCount': commentCount,
      'views': views,
      'isPinned': isPinned,
      'isResolved': isResolved,
      'imageUrls': imageUrls,
      'location': location,
      'type': type.name,
    };
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

enum PostCategory {
  general,
  cropAdvice,
  pestControl,
  soilHealth,
  irrigation,
  harvesting,
  marketing,
  equipment,
  weather,
  success,
}

enum PostType {
  discussion,
  question,
  tip,
  success,
  alert,
}

class Comment {
  final String id;
  final String postId;
  final String content;
  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likes;
  final String? parentCommentId;
  final List<Comment> replies;
  final bool isAuthorVerified;

  Comment({
    required this.id,
    required this.postId,
    required this.content,
    required this.authorId,
    required this.authorName,
    this.authorAvatarUrl,
    required this.createdAt,
    this.updatedAt,
    this.likes = 0,
    this.parentCommentId,
    this.replies = const [],
    this.isAuthorVerified = false,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'],
      content: json['content'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorAvatarUrl: json['authorAvatarUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      likes: json['likes'] ?? 0,
      parentCommentId: json['parentCommentId'],
      replies: (json['replies'] as List? ?? [])
          .map((reply) => Comment.fromJson(reply))
          .toList(),
      isAuthorVerified: json['isAuthorVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatarUrl': authorAvatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'likes': likes,
      'parentCommentId': parentCommentId,
      'replies': replies.map((reply) => reply.toJson()).toList(),
      'isAuthorVerified': isAuthorVerified,
    };
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class CommunityUser {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final String? location;
  final DateTime joinDate;
  final int postCount;
  final int commentCount;
  final int helpfulCount;
  final UserBadge badge;
  final List<String> specialties;
  final bool isVerified;
  final bool isExpert;

  CommunityUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.location,
    required this.joinDate,
    this.postCount = 0,
    this.commentCount = 0,
    this.helpfulCount = 0,
    this.badge = UserBadge.newbie,
    this.specialties = const [],
    this.isVerified = false,
    this.isExpert = false,
  });

  factory CommunityUser.fromJson(Map<String, dynamic> json) {
    return CommunityUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
      location: json['location'],
      joinDate: DateTime.parse(json['joinDate']),
      postCount: json['postCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      helpfulCount: json['helpfulCount'] ?? 0,
      badge: UserBadge.values.firstWhere(
        (b) => b.name == json['badge'],
        orElse: () => UserBadge.newbie,
      ),
      specialties: List<String>.from(json['specialties'] ?? []),
      isVerified: json['isVerified'] ?? false,
      isExpert: json['isExpert'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'location': location,
      'joinDate': joinDate.toIso8601String(),
      'postCount': postCount,
      'commentCount': commentCount,
      'helpfulCount': helpfulCount,
      'badge': badge.name,
      'specialties': specialties,
      'isVerified': isVerified,
      'isExpert': isExpert,
    };
  }

  int get totalContributions => postCount + commentCount;
}

enum UserBadge {
  newbie,
  contributor,
  helper,
  expert,
  master,
  legend,
}

class WeatherAlert {
  final String id;
  final String title;
  final String description;
  final AlertSeverity severity;
  final AlertType type;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> affectedAreas;
  final String? actionAdvice;
  final bool isActive;

  WeatherAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.affectedAreas,
    this.actionAdvice,
    this.isActive = true,
  });

  factory WeatherAlert.fromJson(Map<String, dynamic> json) {
    return WeatherAlert(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      severity: AlertSeverity.values.firstWhere(
        (s) => s.name == json['severity'],
        orElse: () => AlertSeverity.low,
      ),
      type: AlertType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => AlertType.weather,
      ),
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      affectedAreas: List<String>.from(json['affectedAreas']),
      actionAdvice: json['actionAdvice'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'severity': severity.name,
      'type': type.name,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'affectedAreas': affectedAreas,
      'actionAdvice': actionAdvice,
      'isActive': isActive,
    };
  }
}

enum AlertSeverity {
  low,
  medium,
  high,
  critical,
}

enum AlertType {
  weather,
  pest,
  disease,
  market,
  general,
}

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final EventType type;
  final String organizerId;
  final String organizerName;
  final int maxAttendees;
  final int currentAttendees;
  final double? fee;
  final List<String> tags;
  final String? imageUrl;
  final bool isOnline;
  final String? meetingLink;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.type,
    required this.organizerId,
    required this.organizerName,
    this.maxAttendees = 0,
    this.currentAttendees = 0,
    this.fee,
    this.tags = const [],
    this.imageUrl,
    this.isOnline = false,
    this.meetingLink,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      location: json['location'],
      type: EventType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => EventType.workshop,
      ),
      organizerId: json['organizerId'],
      organizerName: json['organizerName'],
      maxAttendees: json['maxAttendees'] ?? 0,
      currentAttendees: json['currentAttendees'] ?? 0,
      fee: json['fee']?.toDouble(),
      tags: List<String>.from(json['tags'] ?? []),
      imageUrl: json['imageUrl'],
      isOnline: json['isOnline'] ?? false,
      meetingLink: json['meetingLink'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'location': location,
      'type': type.name,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'maxAttendees': maxAttendees,
      'currentAttendees': currentAttendees,
      'fee': fee,
      'tags': tags,
      'imageUrl': imageUrl,
      'isOnline': isOnline,
      'meetingLink': meetingLink,
    };
  }

  bool get isFull => maxAttendees > 0 && currentAttendees >= maxAttendees;
  bool get isUpcoming => startDate.isAfter(DateTime.now());
  bool get isOngoing => DateTime.now().isAfter(startDate) && DateTime.now().isBefore(endDate);
  bool get isPast => endDate.isBefore(DateTime.now());
}

enum EventType {
  workshop,
  seminar,
  fieldTrip,
  training,
  conference,
  meetup,
  webinar,
}
