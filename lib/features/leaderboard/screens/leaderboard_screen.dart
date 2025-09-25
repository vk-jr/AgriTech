import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../shared/widgets/custom_card.dart';
import '../providers/leaderboard_provider.dart';
import '../../../core/models/leaderboard_model.dart';
import '../../../core/theme/app_theme.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaderboardProvider>().loadLeaderboards();
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
        title: const Text('Leaderboard'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/profile'),
        ),
        actions: [
          Consumer<LeaderboardProvider>(
            builder: (context, provider, child) {
              return PopupMenuButton<LeaderboardTimeframe>(
                icon: const Icon(Icons.filter_list, color: Colors.white),
                onSelected: (timeframe) => provider.updateTimeframe(timeframe),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: LeaderboardTimeframe.weekly,
                    child: Row(
                      children: [
                        Icon(MdiIcons.calendarWeek),
                        const SizedBox(width: 8),
                        const Text('This Week'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: LeaderboardTimeframe.monthly,
                    child: Row(
                      children: [
                        Icon(MdiIcons.calendarMonth),
                        const SizedBox(width: 8),
                        const Text('This Month'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: LeaderboardTimeframe.allTime,
                    child: Row(
                      children: [
                        Icon(MdiIcons.calendarClock),
                        const SizedBox(width: 8),
                        const Text('All Time'),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              text: 'Global',
              icon: Icon(MdiIcons.earth),
            ),
            Tab(
              text: 'Local',
              icon: Icon(MdiIcons.mapMarker),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildStatsSection(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGlobalTab(),
                _buildLocalTab(),
              ],
            ),
          ),
        ],
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
          hintText: 'Search farmers...',
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

  Widget _buildStatsSection() {
    return Consumer<LeaderboardProvider>(
      builder: (context, provider, child) {
        if (provider.stats == null) return const SizedBox.shrink();
        
        final stats = provider.stats!;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Users',
                  '${_formatNumber(stats.totalUsers)}',
                  MdiIcons.accountGroup,
                  AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  'Active Users',
                  '${_formatNumber(stats.activeUsers)}',
                  MdiIcons.accountCheck,
                  AppTheme.skyBlue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  'Top Region',
                  stats.topRegion,
                  MdiIcons.trophy,
                  AppTheme.earthYellow,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalTab() {
    return Consumer<LeaderboardProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.globalLeaderboard.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final entries = provider.searchEntries(LeaderboardType.global, _searchQuery);

        if (entries.isEmpty) {
          return _buildEmptyState('No farmers found', 'Try adjusting your search criteria');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return _buildLeaderboardCard(entry, index);
          },
        );
      },
    );
  }

  Widget _buildLocalTab() {
    return Consumer<LeaderboardProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.localLeaderboard.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final entries = provider.searchEntries(LeaderboardType.local, _searchQuery);

        if (entries.isEmpty) {
          return _buildEmptyState('No local farmers found', 'Try adjusting your search criteria');
        }

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(MdiIcons.mapMarker, color: AppTheme.primaryGreen),
                  const SizedBox(width: 8),
                  Text(
                    'Showing farmers in ${provider.userLocation}',
                    style: TextStyle(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return _buildLeaderboardCard(entry, index);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLeaderboardCard(LeaderboardEntry entry, int index) {
    Color rankColor;
    IconData rankIcon;
    
    switch (entry.rank) {
      case 1:
        rankColor = Colors.amber;
        rankIcon = MdiIcons.trophy;
        break;
      case 2:
        rankColor = Colors.grey[400]!;
        rankIcon = MdiIcons.medal;
        break;
      case 3:
        rankColor = Colors.brown[400]!;
        rankIcon = MdiIcons.medal;
        break;
      default:
        rankColor = Colors.grey[600]!;
        rankIcon = MdiIcons.numeric;
    }

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Rank
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: rankColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: rankColor),
              ),
              child: Center(
                child: entry.rank <= 3
                    ? Icon(rankIcon, color: rankColor, size: 20)
                    : Text(
                        '${entry.rank}',
                        style: TextStyle(
                          color: rankColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Avatar
            CircleAvatar(
              radius: 25,
              backgroundColor: AppTheme.primaryGreen.withOpacity(0.2),
              child: Text(
                entry.userName.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (entry.isVerified)
                        Icon(
                          MdiIcons.checkDecagram,
                          color: Colors.blue,
                          size: 16,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.location,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${entry.farmType} • ${entry.farmSize} acres',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildMetric(MdiIcons.post, entry.postsCount.toString()),
                      const SizedBox(width: 12),
                      _buildMetric(MdiIcons.thumbUp, entry.helpfulCount.toString()),
                      const SizedBox(width: 12),
                      _buildMetric(MdiIcons.shoppingOutline, entry.ordersCount.toString()),
                    ],
                  ),
                ],
              ),
            ),
            
            // Points
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_formatNumber(entry.points)} pts',
                    style: TextStyle(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimeAgo(entry.lastActive),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: CustomCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              MdiIcons.trophyOutline,
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

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
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
}
