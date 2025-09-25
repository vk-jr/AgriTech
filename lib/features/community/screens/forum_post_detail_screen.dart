import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../providers/community_provider.dart';
import '../../../core/models/community_model.dart';

class ForumPostDetailScreen extends StatefulWidget {
  final String postId;

  const ForumPostDetailScreen({
    super.key,
    required this.postId,
  });

  @override
  State<ForumPostDetailScreen> createState() => _ForumPostDetailScreenState();
}

class _ForumPostDetailScreenState extends State<ForumPostDetailScreen> {
  final _commentController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLiked = false;

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityProvider>(
      builder: (context, provider, child) {
        final post = provider.getPostById(widget.postId);
        
        if (post == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Post Not Found'),
            ),
            body: const Center(
              child: Text('Post not found'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Post Details'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _sharePost(post),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'report',
                    child: Text('Report Post'),
                  ),
                  const PopupMenuItem(
                    value: 'save',
                    child: Text('Save Post'),
                  ),
                ],
                onSelected: (value) => _handleMenuAction(value, post),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPostHeader(context, post, provider),
                      _buildPostContent(context, post),
                      _buildPostActions(context, post, provider),
                      const Divider(thickness: 8),
                      _buildCommentsSection(context, post),
                    ],
                  ),
                ),
              ),
              _buildCommentInput(context, post),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPostHeader(BuildContext context, ForumPost post, CommunityProvider provider) {
    return CustomCard(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Text(
                  post.authorName[0].toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
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
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.verified,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(post.category).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getCategoryName(post.category),
                            style: TextStyle(
                              fontSize: 12,
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
          if (post.isPinned) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.push_pin,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Pinned Post',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPostContent(BuildContext context, ForumPost post) {
    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            post.content,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (post.location != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  post.location!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
          if (post.tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: post.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '#$tag',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPostActions(BuildContext context, ForumPost post, CommunityProvider provider) {
    return CustomCard(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildActionButton(
            icon: _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
            label: '${post.likes + (_isLiked ? 1 : 0)}',
            color: _isLiked ? Theme.of(context).colorScheme.primary : Colors.grey[600],
            onTap: () {
              setState(() {
                _isLiked = !_isLiked;
              });
              if (_isLiked) {
                provider.likePost(post.id);
              }
            },
          ),
          const SizedBox(width: 24),
          _buildActionButton(
            icon: Icons.comment_outlined,
            label: '${post.commentCount}',
            color: Colors.grey[600],
            onTap: () => _scrollToComments(),
          ),
          const SizedBox(width: 24),
          _buildActionButton(
            icon: Icons.visibility_outlined,
            label: '${post.views}',
            color: Colors.grey[600],
            onTap: null,
          ),
          const Spacer(),
          if (post.isResolved)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'RESOLVED',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color? color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection(BuildContext context, ForumPost post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'Comments (${post.commentCount})',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                icon: const Icon(Icons.sort),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'newest', child: Text('Newest First')),
                  const PopupMenuItem(value: 'oldest', child: Text('Oldest First')),
                  const PopupMenuItem(value: 'most_liked', child: Text('Most Liked')),
                ],
                onSelected: (value) {
                  // Handle comment sorting
                },
              ),
            ],
          ),
        ),
        if (post.commentCount == 0)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.comment_outlined,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No comments yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Be the first to comment!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ..._buildMockComments(context),
      ],
    );
  }

  List<Widget> _buildMockComments(BuildContext context) {
    // Mock comments for demonstration
    return [
      _buildCommentItem(
        context,
        'Rajesh Kumar',
        'Great post! I had similar issues with my tomatoes last season. Your tips are very helpful.',
        DateTime.now().subtract(const Duration(hours: 2)),
        12,
        true,
      ),
      _buildCommentItem(
        context,
        'Priya Sharma',
        'Thanks for sharing this. I\'ll definitely try the organic fertilizer method you mentioned.',
        DateTime.now().subtract(const Duration(hours: 4)),
        8,
        false,
      ),
      _buildCommentItem(
        context,
        'Dr. Amit Patel',
        'As an agricultural expert, I can confirm this approach is scientifically sound. Well done!',
        DateTime.now().subtract(const Duration(hours: 6)),
        25,
        true,
        isExpert: true,
      ),
    ];
  }

  Widget _buildCommentItem(
    BuildContext context,
    String authorName,
    String content,
    DateTime createdAt,
    int likes,
    bool isLiked, {
    bool isExpert = false,
  }) {
    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: isExpert 
                    ? Colors.amber.withOpacity(0.2)
                    : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Text(
                  authorName[0].toUpperCase(),
                  style: TextStyle(
                    color: isExpert ? Colors.amber[700] : Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          authorName,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isExpert) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.verified,
                            size: 14,
                            color: Colors.amber[700],
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Expert',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.amber[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      _formatTimeAgo(createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_vert, size: 16, color: Colors.grey[600]),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'reply', child: Text('Reply')),
                  const PopupMenuItem(value: 'report', child: Text('Report')),
                ],
                onSelected: (value) => _handleCommentAction(value, authorName),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Handle like comment
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                      size: 16,
                      color: isLiked ? Theme.of(context).colorScheme.primary : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$likes',
                      style: TextStyle(
                        fontSize: 12,
                        color: isLiked ? Theme.of(context).colorScheme.primary : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => _replyToComment(authorName),
                child: Text(
                  'Reply',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context, ForumPost post) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Icon(
              Icons.person,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _commentController.text.isNotEmpty ? _postComment : null,
            icon: Icon(
              Icons.send,
              color: _commentController.text.isNotEmpty
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[400],
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
    
    return Icon(icon, color: color, size: 24);
  }

  void _scrollToComments() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _postComment() {
    if (_commentController.text.isNotEmpty) {
      // In a real app, this would post the comment to the backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comment posted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      _commentController.clear();
    }
  }

  void _replyToComment(String authorName) {
    _commentController.text = '@$authorName ';
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _sharePost(ForumPost post) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing "${post.title}"...'),
      ),
    );
  }

  void _handleMenuAction(String action, ForumPost post) {
    switch (action) {
      case 'report':
        _showReportDialog(post);
        break;
      case 'save':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post saved to your bookmarks'),
          ),
        );
        break;
    }
  }

  void _handleCommentAction(String action, String authorName) {
    switch (action) {
      case 'reply':
        _replyToComment(authorName);
        break;
      case 'report':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comment reported'),
          ),
        );
        break;
    }
  }

  void _showReportDialog(ForumPost post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Post'),
        content: const Text('Why are you reporting this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Post reported. Thank you for your feedback.'),
                ),
              );
            },
            child: const Text('Report'),
          ),
        ],
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

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
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
