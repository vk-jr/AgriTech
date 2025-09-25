import 'package:flutter/foundation.dart';
import '../../../core/models/community_model.dart';

class CommunityProvider extends ChangeNotifier {
  List<ForumPost> _posts = [];
  List<ForumPost> _filteredPosts = [];
  List<WeatherAlert> _alerts = [];
  List<Event> _events = [];
  bool _isLoading = false;
  String? _errorMessage;
  PostCategory? _selectedCategory;
  String _searchQuery = '';
  PostSortOption _sortOption = PostSortOption.newest;

  // Getters
  List<ForumPost> get posts => _filteredPosts;
  List<ForumPost> get allPosts => _posts;
  List<WeatherAlert> get alerts => _alerts;
  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PostCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  PostSortOption get sortOption => _sortOption;

  List<WeatherAlert> get activeAlerts => _alerts.where((alert) => alert.isActive).toList();
  List<Event> get upcomingEvents => _events.where((event) => event.isUpcoming).toList();

  CommunityProvider() {
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

  Future<void> loadPosts() async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      _initializeMockData();
      _applyFilters();
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load posts: $e');
      _setLoading(false);
    }
  }

  void searchPosts(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void filterByCategory(PostCategory? category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void sortPosts(PostSortOption option) {
    _sortOption = option;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredPosts = List.from(_posts);

    // Apply category filter
    if (_selectedCategory != null) {
      _filteredPosts = _filteredPosts
          .where((post) => post.category == _selectedCategory)
          .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      _filteredPosts = _filteredPosts
          .where((post) =>
              post.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              post.content.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              post.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase())))
          .toList();
    }

    // Apply sorting
    switch (_sortOption) {
      case PostSortOption.newest:
        _filteredPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case PostSortOption.oldest:
        _filteredPosts.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case PostSortOption.mostLiked:
        _filteredPosts.sort((a, b) => b.likes.compareTo(a.likes));
        break;
      case PostSortOption.mostCommented:
        _filteredPosts.sort((a, b) => b.commentCount.compareTo(a.commentCount));
        break;
      case PostSortOption.mostViewed:
        _filteredPosts.sort((a, b) => b.views.compareTo(a.views));
        break;
    }

    // Keep pinned posts at the top
    final pinnedPosts = _filteredPosts.where((post) => post.isPinned).toList();
    final regularPosts = _filteredPosts.where((post) => !post.isPinned).toList();
    _filteredPosts = [...pinnedPosts, ...regularPosts];
  }

  Future<bool> createPost({
    required String title,
    required String content,
    required PostCategory category,
    required PostType type,
    List<String> tags = const [],
    List<String> imageUrls = const [],
    String? location,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      final newPost = ForumPost(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        content: content,
        authorId: 'current_user_id', // In real app, get from auth
        authorName: 'Current User', // In real app, get from auth
        category: category,
        type: type,
        tags: tags,
        createdAt: DateTime.now(),
        imageUrls: imageUrls,
        location: location,
      );

      _posts.insert(0, newPost);
      _applyFilters();
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to create post: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<void> likePost(String postId) async {
    try {
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex >= 0) {
        final post = _posts[postIndex];
        _posts[postIndex] = ForumPost(
          id: post.id,
          title: post.title,
          content: post.content,
          authorId: post.authorId,
          authorName: post.authorName,
          authorAvatarUrl: post.authorAvatarUrl,
          category: post.category,
          tags: post.tags,
          createdAt: post.createdAt,
          updatedAt: post.updatedAt,
          likes: post.likes + 1,
          commentCount: post.commentCount,
          views: post.views,
          isPinned: post.isPinned,
          isResolved: post.isResolved,
          imageUrls: post.imageUrls,
          location: post.location,
          type: post.type,
        );
        _applyFilters();
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to like post: $e');
    }
  }

  Future<void> incrementViews(String postId) async {
    try {
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex >= 0) {
        final post = _posts[postIndex];
        _posts[postIndex] = ForumPost(
          id: post.id,
          title: post.title,
          content: post.content,
          authorId: post.authorId,
          authorName: post.authorName,
          authorAvatarUrl: post.authorAvatarUrl,
          category: post.category,
          tags: post.tags,
          createdAt: post.createdAt,
          updatedAt: post.updatedAt,
          likes: post.likes,
          commentCount: post.commentCount,
          views: post.views + 1,
          isPinned: post.isPinned,
          isResolved: post.isResolved,
          imageUrls: post.imageUrls,
          location: post.location,
          type: post.type,
        );
        notifyListeners();
      }
    } catch (e) {
      // Silently fail for view increment
    }
  }

  ForumPost? getPostById(String postId) {
    try {
      return _posts.firstWhere((post) => post.id == postId);
    } catch (e) {
      return null;
    }
  }

  void _initializeMockData() {
    _posts = [
      ForumPost(
        id: '1',
        title: 'Best practices for tomato cultivation in monsoon',
        content: 'I\'ve been growing tomatoes for 5 years and want to share some tips for the monsoon season. Here are the key points to remember...',
        authorId: 'user1',
        authorName: 'Rajesh Kumar',
        category: PostCategory.cropAdvice,
        type: PostType.tip,
        tags: ['tomato', 'monsoon', 'tips'],
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 15,
        commentCount: 8,
        views: 45,
        isPinned: true,
      ),
      ForumPost(
        id: '2',
        title: 'Help needed: White spots on cucumber leaves',
        content: 'I noticed white spots appearing on my cucumber leaves. They started small but are spreading. Has anyone experienced this before? What could be the cause?',
        authorId: 'user2',
        authorName: 'Priya Sharma',
        category: PostCategory.pestControl,
        type: PostType.question,
        tags: ['cucumber', 'disease', 'help'],
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        likes: 3,
        commentCount: 12,
        views: 67,
      ),
      ForumPost(
        id: '3',
        title: 'Successful harvest: 500kg potatoes from 1 acre!',
        content: 'Just completed my potato harvest and I\'m thrilled with the results! Got 500kg from just 1 acre. Here\'s what I did differently this season...',
        authorId: 'user3',
        authorName: 'Amit Patel',
        category: PostCategory.success,
        type: PostType.success,
        tags: ['potato', 'harvest', 'success'],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        likes: 28,
        commentCount: 15,
        views: 120,
      ),
      ForumPost(
        id: '4',
        title: 'Soil pH testing - DIY methods vs lab testing',
        content: 'Been researching soil pH testing methods. Wondering if DIY kits are reliable enough or should I always go for lab testing? What\'s your experience?',
        authorId: 'user4',
        authorName: 'Sunita Devi',
        category: PostCategory.soilHealth,
        type: PostType.discussion,
        tags: ['soil', 'pH', 'testing'],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        likes: 7,
        commentCount: 9,
        views: 89,
      ),
      ForumPost(
        id: '5',
        title: 'Drip irrigation setup for small farms',
        content: 'Planning to install drip irrigation on my 2-acre farm. Looking for cost-effective solutions and installation tips. Any recommendations?',
        authorId: 'user5',
        authorName: 'Mohan Singh',
        category: PostCategory.irrigation,
        type: PostType.question,
        tags: ['irrigation', 'drip', 'setup'],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        likes: 12,
        commentCount: 18,
        views: 156,
      ),
    ];

    _alerts = [
      WeatherAlert(
        id: 'alert1',
        title: 'Heavy Rainfall Warning',
        description: 'Heavy to very heavy rainfall expected in the next 48 hours. Farmers are advised to take necessary precautions.',
        severity: AlertSeverity.high,
        type: AlertType.weather,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 48)),
        affectedAreas: ['Maharashtra', 'Karnataka', 'Andhra Pradesh'],
        actionAdvice: 'Ensure proper drainage in fields. Harvest ready crops if possible.',
      ),
      WeatherAlert(
        id: 'alert2',
        title: 'Pest Alert: Fall Armyworm',
        description: 'Fall armyworm infestation reported in maize crops. Early detection and treatment recommended.',
        severity: AlertSeverity.medium,
        type: AlertType.pest,
        startTime: DateTime.now().subtract(const Duration(hours: 12)),
        endTime: DateTime.now().add(const Duration(days: 7)),
        affectedAreas: ['Punjab', 'Haryana', 'Uttar Pradesh'],
        actionAdvice: 'Inspect crops regularly. Use recommended pesticides if infestation is confirmed.',
      ),
    ];

    _events = [
      Event(
        id: 'event1',
        title: 'Organic Farming Workshop',
        description: 'Learn the basics of organic farming, composting, and natural pest control methods.',
        startDate: DateTime.now().add(const Duration(days: 7)),
        endDate: DateTime.now().add(const Duration(days: 7, hours: 6)),
        location: 'Agricultural College, Pune',
        type: EventType.workshop,
        organizerId: 'org1',
        organizerName: 'AgriTech Foundation',
        maxAttendees: 50,
        currentAttendees: 23,
        fee: 500.0,
        tags: ['organic', 'workshop', 'composting'],
      ),
      Event(
        id: 'event2',
        title: 'Smart Irrigation Webinar',
        description: 'Online session on modern irrigation techniques and water conservation methods.',
        startDate: DateTime.now().add(const Duration(days: 3)),
        endDate: DateTime.now().add(const Duration(days: 3, hours: 2)),
        location: 'Online',
        type: EventType.webinar,
        organizerId: 'org2',
        organizerName: 'Water Management Institute',
        maxAttendees: 200,
        currentAttendees: 87,
        isOnline: true,
        meetingLink: 'https://meet.example.com/irrigation-webinar',
        tags: ['irrigation', 'water', 'technology'],
      ),
    ];

    _filteredPosts = List.from(_posts);
  }
}

enum PostSortOption {
  newest,
  oldest,
  mostLiked,
  mostCommented,
  mostViewed,
}
