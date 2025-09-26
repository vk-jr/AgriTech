import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../providers/community_provider.dart';
import '../../../core/models/community_model.dart';
import '../../../core/theme/app_theme.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommunityProvider>().loadPosts();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Posts', icon: Icon(Icons.forum)),
            Tab(text: 'Alerts', icon: Icon(Icons.warning)),
            Tab(text: 'Events', icon: Icon(Icons.event)),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildFarmCollabButton(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPostsTab(),
                _buildAlertsTab(),
                _buildEventsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: _showCreatePostDialog,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildFarmCollabButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: CustomButton(
          text: 'Farm Collaboration',
          icon: MdiIcons.handshake,
          onPressed: () => context.go('/community/farm-collab'),
          backgroundColor: AppTheme.primaryGreen,
        ),
      ),
    );
  }

  Widget _buildPostsTab() {
    return Consumer<CommunityProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            _buildSearchAndFilters(context, provider),
            Expanded(
              child: provider.isLoading && provider.posts.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : provider.posts.isEmpty
                      ? _buildEmptyState(context, 'No posts found')
                      : _buildPostsList(context, provider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchAndFilters(BuildContext context, CommunityProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search posts...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        provider.searchPosts('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: provider.searchPosts,
          ),
          const SizedBox(height: 16),
          
          // Category and Sort Filters
          Row(
            children: [
              Expanded(
                child: _buildCategoryFilter(context, provider),
              ),
              const SizedBox(width: 16),
              _buildSortFilter(context, provider),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context, CommunityProvider provider) {
    return DropdownButtonFormField<PostCategory?>(
      initialValue: provider.selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Category',
        prefixIcon: Icon(Icons.category),
      ),
      items: [
        const DropdownMenuItem<PostCategory?>(
          value: null,
          child: Text('All Categories'),
        ),
        ...PostCategory.values.map((category) {
          return DropdownMenuItem<PostCategory?>(
            value: category,
            child: Text(_getCategoryName(category)),
          );
        }),
      ],
      onChanged: provider.filterByCategory,
    );
  }

  Widget _buildSortFilter(BuildContext context, CommunityProvider provider) {
    return PopupMenuButton<PostSortOption>(
      icon: const Icon(Icons.sort),
      onSelected: provider.sortPosts,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: PostSortOption.newest,
          child: Text('Newest First'),
        ),
        const PopupMenuItem(
          value: PostSortOption.oldest,
          child: Text('Oldest First'),
        ),
        const PopupMenuItem(
          value: PostSortOption.mostLiked,
          child: Text('Most Liked'),
        ),
        const PopupMenuItem(
          value: PostSortOption.mostCommented,
          child: Text('Most Commented'),
        ),
        const PopupMenuItem(
          value: PostSortOption.mostViewed,
          child: Text('Most Viewed'),
        ),
      ],
    );
  }

  Widget _buildPostsList(BuildContext context, CommunityProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.posts.length,
      itemBuilder: (context, index) {
        final post = provider.posts[index];
        return _buildPostCard(context, post, provider);
      },
    );
  }

  Widget _buildPostCard(BuildContext context, ForumPost post, CommunityProvider provider) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      onTap: () {
        provider.incrementViews(post.id);
        context.go('/community/post/${post.id}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Text(
                  post.authorName[0].toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          post.authorName,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (post.isPinned) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.push_pin,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(post.category).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getCategoryName(post.category),
                            style: TextStyle(
                              fontSize: 10,
                              color: _getCategoryColor(post.category),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          post.timeAgo,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _buildPostTypeIcon(post.type),
            ],
          ),
          const SizedBox(height: 12),
          
          // Post Title
          Text(
            post.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Post Content Preview
          Text(
            post.content,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          
          // Post Tags
          if (post.tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: post.tags.take(3).map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '#$tag',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          
          const SizedBox(height: 12),
          
          // Post Stats
          Row(
            children: [
              _buildStatButton(
                Icons.thumb_up_outlined,
                '${post.likes}',
                () => provider.likePost(post.id),
              ),
              const SizedBox(width: 16),
              _buildStatButton(
                Icons.comment_outlined,
                '${post.commentCount}',
                () => context.go('/community/post/${post.id}'),
              ),
              const SizedBox(width: 16),
              _buildStatButton(
                Icons.visibility_outlined,
                '${post.views}',
                null,
              ),
              const Spacer(),
              if (post.isResolved)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'RESOLVED',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatButton(IconData icon, String count, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            count,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostTypeIcon(PostType type) {
    IconData icon;
    Color color;
    
    switch (type) {
      case PostType.question:
        icon = Icons.help_outline;
        color = Colors.blue;
        break;
      case PostType.tip:
        icon = Icons.lightbulb_outline;
        color = Colors.orange;
        break;
      case PostType.success:
        icon = Icons.celebration;
        color = Colors.green;
        break;
      case PostType.alert:
        icon = Icons.warning_outlined;
        color = Colors.red;
        break;
      default:
        icon = Icons.forum_outlined;
        color = Colors.grey;
    }
    
    return Icon(icon, color: color, size: 20);
  }

  Widget _buildAlertsTab() {
    return Consumer<CommunityProvider>(
      builder: (context, provider, child) {
        if (provider.alerts.isEmpty) {
          return _buildEmptyState(context, 'No alerts at the moment');
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.alerts.length,
          itemBuilder: (context, index) {
            final alert = provider.alerts[index];
            return _buildAlertCard(context, alert);
          },
        );
      },
    );
  }

  Widget _buildAlertCard(BuildContext context, WeatherAlert alert) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      backgroundColor: _getAlertColor(alert.severity).withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getAlertIcon(alert.type),
                color: _getAlertColor(alert.severity),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  alert.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getAlertColor(alert.severity),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  alert.severity.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            alert.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (alert.actionAdvice != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      alert.actionAdvice!,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            'Affected Areas: ${alert.affectedAreas.join(', ')}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsTab() {
    return Consumer<CommunityProvider>(
      builder: (context, provider, child) {
        if (provider.events.isEmpty) {
          return _buildEmptyState(context, 'No upcoming events');
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.events.length,
          itemBuilder: (context, index) {
            final event = provider.events[index];
            return _buildEventCard(context, event);
          },
        );
      },
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${event.startDate.day}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      _getMonthName(event.startDate.month),
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          event.isOnline ? Icons.computer : Icons.location_on,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (event.fee != null)
                Text(
                  '₹${event.fee!.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'FREE',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            event.description,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.people, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${event.currentAttendees}/${event.maxAttendees > 0 ? event.maxAttendees : '∞'} attending',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              CustomButton(
                text: event.isFull ? 'Full' : 'Join',
                size: ButtonSize.small,
                onPressed: event.isFull ? null : () => _joinEvent(event),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: CustomCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.forum_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePostDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    PostCategory selectedCategory = PostCategory.general;
    PostType selectedType = PostType.discussion;
    final tagsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Post'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter post title',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  hintText: 'Write your post content',
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PostCategory>(
                initialValue: selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: PostCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(_getCategoryName(category)),
                  );
                }).toList(),
                onChanged: (value) => selectedCategory = value!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PostType>(
                initialValue: selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: PostType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_getTypeName(type)),
                  );
                }).toList(),
                onChanged: (value) => selectedType = value!,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags (comma separated)',
                  hintText: 'e.g., tomato, organic, tips',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                Navigator.pop(context);
                final tags = tagsController.text
                    .split(',')
                    .map((tag) => tag.trim())
                    .where((tag) => tag.isNotEmpty)
                    .toList();
                
                final success = await context.read<CommunityProvider>().createPost(
                  title: titleController.text,
                  content: contentController.text,
                  category: selectedCategory,
                  type: selectedType,
                  tags: tags,
                );
                
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Post created successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  void _joinEvent(Event event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Joined ${event.title}!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _getCategoryName(PostCategory category) {
    switch (category) {
      case PostCategory.general:
        return 'General';
      case PostCategory.cropAdvice:
        return 'Crop Advice';
      case PostCategory.pestControl:
        return 'Pest Control';
      case PostCategory.soilHealth:
        return 'Soil Health';
      case PostCategory.irrigation:
        return 'Irrigation';
      case PostCategory.harvesting:
        return 'Harvesting';
      case PostCategory.marketing:
        return 'Marketing';
      case PostCategory.equipment:
        return 'Equipment';
      case PostCategory.weather:
        return 'Weather';
      case PostCategory.success:
        return 'Success Stories';
    }
  }

  String _getTypeName(PostType type) {
    switch (type) {
      case PostType.discussion:
        return 'Discussion';
      case PostType.question:
        return 'Question';
      case PostType.tip:
        return 'Tip';
      case PostType.success:
        return 'Success Story';
      case PostType.alert:
        return 'Alert';
    }
  }

  Color _getCategoryColor(PostCategory category) {
    switch (category) {
      case PostCategory.general:
        return Colors.grey;
      case PostCategory.cropAdvice:
        return Colors.green;
      case PostCategory.pestControl:
        return Colors.red;
      case PostCategory.soilHealth:
        return Colors.brown;
      case PostCategory.irrigation:
        return Colors.blue;
      case PostCategory.harvesting:
        return Colors.orange;
      case PostCategory.marketing:
        return Colors.purple;
      case PostCategory.equipment:
        return Colors.indigo;
      case PostCategory.weather:
        return Colors.cyan;
      case PostCategory.success:
        return Colors.amber;
    }
  }

  Color _getAlertColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.low:
        return Colors.green;
      case AlertSeverity.medium:
        return Colors.orange;
      case AlertSeverity.high:
        return Colors.red;
      case AlertSeverity.critical:
        return Colors.red[900]!;
    }
  }

  IconData _getAlertIcon(AlertType type) {
    switch (type) {
      case AlertType.weather:
        return Icons.cloud;
      case AlertType.pest:
        return Icons.bug_report;
      case AlertType.disease:
        return Icons.healing;
      case AlertType.market:
        return Icons.trending_up;
      case AlertType.general:
        return Icons.info;
    }
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
