import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../providers/profile_provider.dart';
import '../../../core/models/profile_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.message_outlined),
            onPressed: () => context.go('/agri-chat'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/profile/settings'),
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.userProfile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.userProfile == null) {
            return _buildNotLoggedIn(context);
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(context, provider.userProfile!, provider),
                _buildStatsSection(context, provider.userProfile!),
                _buildFarmingSection(context, provider.userProfile!),
                _buildAchievementsSection(context, provider.userProfile!),
                _buildLeaderboardButton(context),
                _buildActivitySection(context, provider.userProfile!),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotLoggedIn(BuildContext context) {
    return Center(
      child: CustomCard(
        margin: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Not Logged In',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please log in to view your profile',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Login',
              onPressed: () => context.go('/login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProfile profile, ProfileProvider provider) {
    return CustomCard(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Avatar and basic info
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    child: profile.avatarUrl != null
                        ? ClipOval(
                            child: Image.network(
                              profile.avatarUrl!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Text(
                                  profile.initials,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                );
                              },
                            ),
                          )
                        : Text(
                            profile.initials,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                        onPressed: _changeAvatar,
                        iconSize: 16,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            profile.displayName,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (profile.isVerified)
                          Icon(
                            Icons.verified,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                      ],
                    ),
                    Text(
                      provider.getUserTypeDisplayName(profile.userType),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    if (profile.location != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              profile.location!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          
          if (profile.bio != null) ...[
            const SizedBox(height: 16),
            Text(
              profile.bio!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          
          const SizedBox(height: 16),
          
          // Profile completion
          _buildProfileCompletion(context, provider),
          
          const SizedBox(height: 16),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Edit Profile',
                  type: ButtonType.secondary,
                  onPressed: _editProfile,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: 'Share Profile',
                  type: ButtonType.secondary,
                  onPressed: _shareProfile,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCompletion(BuildContext context, ProfileProvider provider) {
    final completion = provider.getProfileCompletionPercentage();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Profile Completion',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${(completion * 100).toInt()}%',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: completion,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, UserProfile profile) {
    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatItem('Posts', '${profile.stats.postsCount}', Icons.forum),
              _buildStatItem('Comments', '${profile.stats.commentsCount}', Icons.comment),
              _buildStatItem('Likes', '${profile.stats.likesReceived}', Icons.thumb_up),
              _buildStatItem('Helpful', '${profile.stats.helpfulAnswers}', Icons.help),
              _buildStatItem('Orders', '${profile.stats.ordersPlaced}', Icons.shopping_cart),
              _buildStatItem('Streak', '${profile.stats.streakDays} days', Icons.local_fire_department),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 18,
          ),
          const SizedBox(height: 2),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmingSection(BuildContext context, UserProfile profile) {
    if (profile.farmingProfile == null) return const SizedBox.shrink();
    
    final farming = profile.farmingProfile!;
    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Farming Profile',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: _editFarmingProfile,
                child: const Text('Edit'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Farm Name', farming.farmName ?? 'Not specified'),
          _buildInfoRow('Farm Size', '${farming.farmSize} ${farming.farmSizeUnit}'),
          _buildInfoRow('Farm Type', context.read<ProfileProvider>().getFarmTypeDisplayName(farming.farmType)),
          _buildInfoRow('Experience', '${farming.yearsOfExperience} years (${farming.experienceLevel})'),
          if (farming.cropsGrown.isNotEmpty)
            _buildInfoRow('Crops Grown', farming.cropsGrown.join(', ')),
          if (farming.isOrganic)
            _buildInfoRow('Certification', 'Organic Certified'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection(BuildContext context, UserProfile profile) {
    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Achievements',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${context.read<ProfileProvider>().getTotalAchievementPoints()} pts',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (profile.achievements.isEmpty)
            const Center(
              child: Text('No achievements yet'),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: profile.achievements.length,
              itemBuilder: (context, index) {
                final achievement = profile.achievements[index];
                return _buildAchievementItem(context, achievement);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(BuildContext context, Achievement achievement) {
    return GestureDetector(
      onTap: () => _showAchievementDetail(achievement),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _getAchievementColor(achievement.rarity).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getAchievementColor(achievement.rarity).withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getAchievementIcon(achievement.category),
              color: _getAchievementColor(achievement.rarity),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              achievement.title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: _getAchievementColor(achievement.rarity),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitySection(BuildContext context, UserProfile profile) {
    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildActivityItem(
            'Posted in Crop Advice',
            'Best practices for tomato cultivation',
            '2 hours ago',
            Icons.forum,
          ),
          _buildActivityItem(
            'Helped a farmer',
            'Answered question about pest control',
            '1 day ago',
            Icons.help,
          ),
          _buildActivityItem(
            'Made a purchase',
            'Ordered organic fertilizer',
            '3 days ago',
            Icons.shopping_cart,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String action, String description, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _changeAvatar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Avatar change feature will be implemented'),
      ),
    );
  }

  void _editProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit profile feature will be implemented'),
      ),
    );
  }

  void _editFarmingProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit farming profile feature will be implemented'),
      ),
    );
  }

  void _shareProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing profile...'),
      ),
    );
  }

  void _showAchievementDetail(Achievement achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(achievement.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(achievement.description),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Rarity: ${context.read<ProfileProvider>().getAchievementRarityDisplayName(achievement.rarity)}'),
                const Spacer(),
                Text('${achievement.points} pts'),
              ],
            ),
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

  Color _getAchievementColor(AchievementRarity rarity) {
    switch (rarity) {
      case AchievementRarity.common:
        return Colors.grey;
      case AchievementRarity.uncommon:
        return Colors.green;
      case AchievementRarity.rare:
        return Colors.blue;
      case AchievementRarity.epic:
        return Colors.purple;
      case AchievementRarity.legendary:
        return Colors.orange;
    }
  }

  IconData _getAchievementIcon(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.general:
        return Icons.star;
      case AchievementCategory.community:
        return Icons.people;
      case AchievementCategory.farming:
        return Icons.agriculture;
      case AchievementCategory.marketplace:
        return Icons.shopping_cart;
      case AchievementCategory.learning:
        return Icons.school;
    }
  }

  Widget _buildLeaderboardButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: CustomButton(
        text: 'View Leaderboard',
        icon: Icons.leaderboard,
        onPressed: () => context.go('/leaderboard'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
