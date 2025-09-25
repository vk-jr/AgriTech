class ChatGroup {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> memberIds;
  final int memberCount;
  final ChatMessage? lastMessage;
  final DateTime createdAt;
  final String createdBy;
  final bool isPrivate;
  final List<String> tags;

  ChatGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.memberIds,
    required this.memberCount,
    this.lastMessage,
    required this.createdAt,
    required this.createdBy,
    this.isPrivate = false,
    this.tags = const [],
  });

  factory ChatGroup.fromJson(Map<String, dynamic> json) {
    return ChatGroup(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      memberIds: List<String>.from(json['memberIds']),
      memberCount: json['memberCount'],
      lastMessage: json['lastMessage'] != null 
          ? ChatMessage.fromJson(json['lastMessage']) 
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      createdBy: json['createdBy'],
      isPrivate: json['isPrivate'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'memberIds': memberIds,
      'memberCount': memberCount,
      'lastMessage': lastMessage?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'isPrivate': isPrivate,
      'tags': tags,
    };
  }
}

class ChatChannel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int subscriberCount;
  final ChatMessage? lastMessage;
  final DateTime createdAt;
  final String createdBy;
  final bool isVerified;
  final String category;
  final List<String> tags;

  ChatChannel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.subscriberCount,
    this.lastMessage,
    required this.createdAt,
    required this.createdBy,
    this.isVerified = false,
    required this.category,
    this.tags = const [],
  });

  factory ChatChannel.fromJson(Map<String, dynamic> json) {
    return ChatChannel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      subscriberCount: json['subscriberCount'],
      lastMessage: json['lastMessage'] != null 
          ? ChatMessage.fromJson(json['lastMessage']) 
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      createdBy: json['createdBy'],
      isVerified: json['isVerified'] ?? false,
      category: json['category'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'subscriberCount': subscriberCount,
      'lastMessage': lastMessage?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'isVerified': isVerified,
      'category': category,
      'tags': tags,
    };
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isEdited;
  final List<String> attachments;
  final String? replyToMessageId;
  final int likeCount;
  final List<String> likedBy;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isEdited = false,
    this.attachments = const [],
    this.replyToMessageId,
    this.likeCount = 0,
    this.likedBy = const [],
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      senderAvatar: json['senderAvatar'],
      content: json['content'],
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type']}',
        orElse: () => MessageType.text,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      isEdited: json['isEdited'] ?? false,
      attachments: List<String>.from(json['attachments'] ?? []),
      replyToMessageId: json['replyToMessageId'],
      likeCount: json['likeCount'] ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'content': content,
      'type': type.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'isEdited': isEdited,
      'attachments': attachments,
      'replyToMessageId': replyToMessageId,
      'likeCount': likeCount,
      'likedBy': likedBy,
    };
  }
}

enum MessageType {
  text,
  image,
  video,
  audio,
  document,
  location,
  poll,
  announcement,
}

enum ChatType {
  group,
  channel,
  direct,
}

class ChatUser {
  final String id;
  final String name;
  final String avatar;
  final String role;
  final bool isOnline;
  final DateTime lastSeen;

  ChatUser({
    required this.id,
    required this.name,
    required this.avatar,
    this.role = 'member',
    this.isOnline = false,
    required this.lastSeen,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      role: json['role'] ?? 'member',
      isOnline: json['isOnline'] ?? false,
      lastSeen: DateTime.parse(json['lastSeen']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'role': role,
      'isOnline': isOnline,
      'lastSeen': lastSeen.toIso8601String(),
    };
  }
}
