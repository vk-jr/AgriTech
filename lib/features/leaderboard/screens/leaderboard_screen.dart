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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryGreen,
      appBar: AppBar(
        title: const Text('Leaderboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/profile'),
        ),
        actions: [
          Consumer<LeaderboardProvider>(
            builder: (context, provider, child) {
              return Container(
                margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(MdiIcons.calendarMonth, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    const Text('MONTHLY', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTopSection(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGlobalTab(),
                  _buildLocalTab(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    return Consumer<LeaderboardProvider>(
      builder: (context, provider, child) {
        final topEntries = provider.globalLeaderboard.take(3).toList();
        if (topEntries.length < 3) {
          return Container(
            height: 200,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Tab selector
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: AppTheme.primaryGreen,
                  unselectedLabelColor: Colors.white,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                  tabs: const [
                    Tab(text: 'GLOBAL'),
                    Tab(text: 'LOCAL'),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              // Podium
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 2nd place
                  _buildPodiumItem(topEntries[1], 2, 80),
                  const SizedBox(width: 20),
                  // 1st place
                  _buildPodiumItem(topEntries[0], 1, 100),
                  const SizedBox(width: 20),
                  // 3rd place
                  _buildPodiumItem(topEntries[2], 3, 60),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPodiumItem(LeaderboardEntry entry, int position, double height) {
    Color podiumColor;
    IconData crownIcon;
    
    switch (position) {
      case 1:
        podiumColor = const Color(0xFFFFD700); // Gold
        crownIcon = MdiIcons.crown;
        break;
      case 2:
        podiumColor = const Color(0xFFC0C0C0); // Silver
        crownIcon = MdiIcons.medal;
        break;
      case 3:
        podiumColor = const Color(0xFFCD7F32); // Bronze
        crownIcon = MdiIcons.medal;
        break;
      default:
        podiumColor = Colors.grey;
        crownIcon = MdiIcons.numeric;
    }

    return Column(
      children: [
        // Avatar with crown
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: podiumColor, width: 3),
              ),
              child: Center(
                child: Text(
                  entry.userName.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            if (position == 1)
              Positioned(
                top: -10,
                left: 15,
                child: Icon(
                  crownIcon,
                  color: podiumColor,
                  size: 30,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        
        // Name
        Text(
          entry.userName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        
        // Points
        Text(
          '${_formatNumber(entry.points)}',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        
        // Podium base
        Container(
          width: 60,
          height: height,
          decoration: BoxDecoration(
            color: podiumColor.withOpacity(0.3),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            border: Border.all(color: podiumColor, width: 2),
          ),
          child: Center(
            child: Text(
              '$position',
              style: TextStyle(
                color: podiumColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildGlobalTab() {
    return Consumer<LeaderboardProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.globalLeaderboard.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final entries = provider.globalLeaderboard.skip(3).toList(); // Skip top 3 (shown in podium)

        if (entries.isEmpty) {
          return _buildEmptyState('No farmers found', 'Try adjusting your search criteria');
        }

        return Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return _buildModernLeaderboardCard(entry, index + 4); // Start from rank 4
                },
              ),
            ),
          ],
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

        final entries = provider.localLeaderboard.skip(3).toList(); // Skip top 3 (shown in podium)

        if (entries.isEmpty) {
          return _buildEmptyState('No local farmers found', 'Try adjusting your search criteria');
        }

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(MdiIcons.mapMarker, color: AppTheme.primaryGreen, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Kerala, India',
                    style: TextStyle(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
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
                  return _buildModernLeaderboardCard(entry, index + 4); // Start from rank 4
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildModernLeaderboardCard(LeaderboardEntry entry, int displayRank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '$displayRank',
                style: TextStyle(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.primaryGreen.withOpacity(0.2),
            child: Text(
              entry.userName.substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: AppTheme.primaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
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
                        overflow: TextOverflow.ellipsis,
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
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Points
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_formatNumber(entry.points)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
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

}
