import 'package:flutter/foundation.dart';
import '../../../core/models/chat_model.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatGroup> _groups = [];
  List<ChatChannel> _channels = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ChatGroup> get groups => _groups;
  List<ChatChannel> get channels => _channels;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ChatProvider() {
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

  Future<void> loadChats() async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      // Data is already initialized in _initializeMockData
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load chats: $e');
      _setLoading(false);
    }
  }

  void _initializeMockData() {
    _groups = [
      ChatGroup(
        id: '1',
        name: 'Organic Farmers Kerala',
        description: 'A community of organic farmers sharing tips and experiences',
        imageUrl: 'https://example.com/group1.jpg',
        memberIds: ['user1', 'user2', 'user3', 'user4', 'user5'],
        memberCount: 245,
        lastMessage: ChatMessage(
          id: 'msg1',
          senderId: 'user2',
          senderName: 'Ravi Kumar',
          senderAvatar: 'https://example.com/avatar2.jpg',
          content: 'Anyone tried neem oil for pest control?',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        createdBy: 'user1',
        tags: ['organic', 'kerala', 'farming'],
      ),
      ChatGroup(
        id: '2',
        name: 'Rice Cultivation Tips',
        description: 'Share knowledge about rice farming techniques',
        imageUrl: 'https://example.com/group2.jpg',
        memberIds: ['user1', 'user3', 'user6', 'user7'],
        memberCount: 189,
        lastMessage: ChatMessage(
          id: 'msg2',
          senderId: 'user3',
          senderName: 'Priya Sharma',
          senderAvatar: 'https://example.com/avatar3.jpg',
          content: 'Best time for transplanting is early morning',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        createdBy: 'user3',
        tags: ['rice', 'cultivation', 'tips'],
      ),
      ChatGroup(
        id: '3',
        name: 'Vegetable Growers Network',
        description: 'Connect with vegetable farmers across India',
        imageUrl: 'https://example.com/group3.jpg',
        memberIds: ['user1', 'user4', 'user8', 'user9', 'user10'],
        memberCount: 156,
        lastMessage: ChatMessage(
          id: 'msg3',
          senderId: 'user4',
          senderName: 'Amit Patel',
          senderAvatar: 'https://example.com/avatar4.jpg',
          content: 'Tomato prices are rising in Mumbai market',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        createdBy: 'user4',
        tags: ['vegetables', 'network', 'market'],
      ),
      ChatGroup(
        id: '4',
        name: 'Dairy Farmers Support',
        description: 'Support group for dairy farmers',
        imageUrl: 'https://example.com/group4.jpg',
        memberIds: ['user1', 'user5', 'user11'],
        memberCount: 98,
        lastMessage: ChatMessage(
          id: 'msg4',
          senderId: 'user5',
          senderName: 'Sunita Devi',
          senderAvatar: 'https://example.com/avatar5.jpg',
          content: 'New cattle feed supplement available',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        createdBy: 'user5',
        tags: ['dairy', 'cattle', 'support'],
      ),
    ];

    _channels = [
      ChatChannel(
        id: '1',
        name: 'AgriTech News',
        description: 'Latest news and updates from the agricultural technology world',
        imageUrl: 'https://example.com/channel1.jpg',
        subscriberCount: 12500,
        lastMessage: ChatMessage(
          id: 'ch_msg1',
          senderId: 'admin1',
          senderName: 'AgriTech Admin',
          senderAvatar: 'https://example.com/admin1.jpg',
          content: 'New drone technology for crop monitoring launched',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 100)),
        createdBy: 'admin1',
        isVerified: true,
        category: 'News',
        tags: ['technology', 'news', 'updates'],
      ),
      ChatChannel(
        id: '2',
        name: 'Weather Updates',
        description: 'Real-time weather forecasts and alerts for farmers',
        imageUrl: 'https://example.com/channel2.jpg',
        subscriberCount: 8900,
        lastMessage: ChatMessage(
          id: 'ch_msg2',
          senderId: 'weather_bot',
          senderName: 'Weather Bot',
          senderAvatar: 'https://example.com/weather_bot.jpg',
          content: 'Heavy rainfall expected in Kerala this weekend',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 80)),
        createdBy: 'weather_admin',
        isVerified: true,
        category: 'Weather',
        tags: ['weather', 'forecast', 'alerts'],
      ),
      ChatChannel(
        id: '3',
        name: 'Market Prices',
        description: 'Daily market prices and trading information',
        imageUrl: 'https://example.com/channel3.jpg',
        subscriberCount: 15600,
        lastMessage: ChatMessage(
          id: 'ch_msg3',
          senderId: 'market_bot',
          senderName: 'Market Bot',
          senderAvatar: 'https://example.com/market_bot.jpg',
          content: 'Onion prices up by 15% in Delhi markets',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        createdBy: 'market_admin',
        isVerified: true,
        category: 'Market',
        tags: ['prices', 'market', 'trading'],
      ),
      ChatChannel(
        id: '4',
        name: 'Government Schemes',
        description: 'Updates on government schemes and subsidies for farmers',
        imageUrl: 'https://example.com/channel4.jpg',
        subscriberCount: 6700,
        lastMessage: ChatMessage(
          id: 'ch_msg4',
          senderId: 'gov_admin',
          senderName: 'Government Updates',
          senderAvatar: 'https://example.com/gov_admin.jpg',
          content: 'New PM-KISAN installment released',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        createdBy: 'gov_admin',
        isVerified: true,
        category: 'Government',
        tags: ['schemes', 'subsidies', 'government'],
      ),
      ChatChannel(
        id: '5',
        name: 'Crop Disease Alerts',
        description: 'Early warning system for crop diseases and pests',
        imageUrl: 'https://example.com/channel5.jpg',
        subscriberCount: 4200,
        lastMessage: ChatMessage(
          id: 'ch_msg5',
          senderId: 'disease_bot',
          senderName: 'Disease Alert Bot',
          senderAvatar: 'https://example.com/disease_bot.jpg',
          content: 'Brown spot disease detected in rice fields - Tamil Nadu',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 70)),
        createdBy: 'disease_admin',
        isVerified: true,
        category: 'Health',
        tags: ['disease', 'alerts', 'prevention'],
      ),
    ];
  }

  // Group methods
  void joinGroup(String groupId) {
    final groupIndex = _groups.indexWhere((group) => group.id == groupId);
    if (groupIndex != -1) {
      // In a real app, this would make an API call
      notifyListeners();
    }
  }

  void leaveGroup(String groupId) {
    final groupIndex = _groups.indexWhere((group) => group.id == groupId);
    if (groupIndex != -1) {
      // In a real app, this would make an API call
      notifyListeners();
    }
  }

  // Channel methods
  void subscribeToChannel(String channelId) {
    final channelIndex = _channels.indexWhere((channel) => channel.id == channelId);
    if (channelIndex != -1) {
      // In a real app, this would make an API call
      notifyListeners();
    }
  }

  void unsubscribeFromChannel(String channelId) {
    final channelIndex = _channels.indexWhere((channel) => channel.id == channelId);
    if (channelIndex != -1) {
      // In a real app, this would make an API call
      notifyListeners();
    }
  }

  // Search methods
  List<ChatGroup> searchGroups(String query) {
    if (query.isEmpty) return _groups;
    return _groups.where((group) =>
        group.name.toLowerCase().contains(query.toLowerCase()) ||
        group.description.toLowerCase().contains(query.toLowerCase()) ||
        group.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()))
    ).toList();
  }

  List<ChatChannel> searchChannels(String query) {
    if (query.isEmpty) return _channels;
    return _channels.where((channel) =>
        channel.name.toLowerCase().contains(query.toLowerCase()) ||
        channel.description.toLowerCase().contains(query.toLowerCase()) ||
        channel.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()))
    ).toList();
  }
}
