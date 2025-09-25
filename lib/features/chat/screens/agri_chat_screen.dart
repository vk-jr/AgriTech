import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../shared/widgets/custom_card.dart';
import '../providers/chat_provider.dart';
import '../../../core/models/chat_model.dart';
import '../../../core/theme/app_theme.dart';

class AgriChatScreen extends StatefulWidget {
  const AgriChatScreen({super.key});

  @override
  State<AgriChatScreen> createState() => _AgriChatScreenState();
}

class _AgriChatScreenState extends State<AgriChatScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().loadChats();
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
        title: const Text('AgriChat'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/main'),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              text: 'Groups',
              icon: Icon(MdiIcons.accountGroup),
            ),
            Tab(
              text: 'Channels',
              icon: Icon(MdiIcons.bullhorn),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGroupsTab(),
                _buildChannelsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(),
        backgroundColor: AppTheme.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surface,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search groups and channels...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildGroupsTab() {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.groups.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final groups = provider.searchGroups(_searchQuery);

        if (groups.isEmpty) {
          return _buildEmptyState(
            'No groups found',
            'Try adjusting your search or create a new group',
            MdiIcons.accountGroup,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            return _buildGroupCard(group);
          },
        );
      },
    );
  }

  Widget _buildChannelsTab() {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.channels.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final channels = provider.searchChannels(_searchQuery);

        if (channels.isEmpty) {
          return _buildEmptyState(
            'No channels found',
            'Try adjusting your search or subscribe to new channels',
            MdiIcons.bullhorn,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: channels.length,
          itemBuilder: (context, index) {
            final channel = channels[index];
            return _buildChannelCard(channel);
          },
        );
      },
    );
  }

  Widget _buildGroupCard(ChatGroup group) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () => _openGroupChat(group),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Group Avatar
            CircleAvatar(
              radius: 25,
              backgroundColor: AppTheme.primaryGreen.withOpacity(0.2),
              child: Icon(
                MdiIcons.accountGroup,
                color: AppTheme.primaryGreen,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            
            // Group Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          group.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (group.isPrivate)
                        Icon(
                          MdiIcons.lock,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    group.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        MdiIcons.account,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${group.memberCount} members',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (group.lastMessage != null) ...[
                        Icon(
                          MdiIcons.clockOutline,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(group.lastMessage!.timestamp),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (group.lastMessage != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${group.lastMessage!.senderName}: ',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              group.lastMessage!.content,
                              style: const TextStyle(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Join/Options Button
            IconButton(
              icon: Icon(MdiIcons.dotsVertical),
              onPressed: () => _showGroupOptions(group),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelCard(ChatChannel channel) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () => _openChannelChat(channel),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Channel Avatar
            CircleAvatar(
              radius: 25,
              backgroundColor: AppTheme.skyBlue.withOpacity(0.2),
              child: Icon(
                MdiIcons.bullhorn,
                color: AppTheme.skyBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            
            // Channel Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          channel.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (channel.isVerified)
                        Icon(
                          MdiIcons.checkDecagram,
                          size: 16,
                          color: Colors.blue,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    channel.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.skyBlue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          channel.category,
                          style: TextStyle(
                            color: AppTheme.skyBlue,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        MdiIcons.account,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${_formatSubscriberCount(channel.subscriberCount)} subscribers',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (channel.lastMessage != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              channel.lastMessage!.content,
                              style: const TextStyle(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatTime(channel.lastMessage!.timestamp),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Subscribe/Options Button
            IconButton(
              icon: Icon(MdiIcons.dotsVertical),
              onPressed: () => _showChannelOptions(channel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: CustomCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _openGroupChat(ChatGroup group) {
    // Navigate to group chat screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${group.name} chat...')),
    );
  }

  void _openChannelChat(ChatChannel channel) {
    // Navigate to channel chat screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${channel.name} channel...')),
    );
  }

  void _showGroupOptions(ChatGroup group) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(MdiIcons.login),
              title: const Text('Join Group'),
              onTap: () {
                Navigator.pop(context);
                context.read<ChatProvider>().joinGroup(group.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Joined ${group.name}')),
                );
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.information),
              title: const Text('Group Info'),
              onTap: () {
                Navigator.pop(context);
                _showGroupInfo(group);
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.share),
              title: const Text('Share Group'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Group link copied to clipboard')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChannelOptions(ChatChannel channel) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(MdiIcons.bellPlus),
              title: const Text('Subscribe'),
              onTap: () {
                Navigator.pop(context);
                context.read<ChatProvider>().subscribeToChannel(channel.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Subscribed to ${channel.name}')),
                );
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.information),
              title: const Text('Channel Info'),
              onTap: () {
                Navigator.pop(context);
                _showChannelInfo(channel);
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.share),
              title: const Text('Share Channel'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Channel link copied to clipboard')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(MdiIcons.accountGroup),
              title: const Text('Create Group'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Create group feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.bullhorn),
              title: const Text('Create Channel'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Create channel feature coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showGroupInfo(ChatGroup group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(group.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${group.description}'),
            const SizedBox(height: 8),
            Text('Members: ${group.memberCount}'),
            const SizedBox(height: 8),
            Text('Created: ${_formatDate(group.createdAt)}'),
            if (group.tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Tags: ${group.tags.join(', ')}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showChannelInfo(ChatChannel channel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Expanded(child: Text(channel.name)),
            if (channel.isVerified)
              Icon(MdiIcons.checkDecagram, color: Colors.blue, size: 20),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${channel.description}'),
            const SizedBox(height: 8),
            Text('Category: ${channel.category}'),
            const SizedBox(height: 8),
            Text('Subscribers: ${_formatSubscriberCount(channel.subscriberCount)}'),
            const SizedBox(height: 8),
            Text('Created: ${_formatDate(channel.createdAt)}'),
            if (channel.tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Tags: ${channel.tags.join(', ')}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _formatSubscriberCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }
}
