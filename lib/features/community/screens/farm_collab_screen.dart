import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../providers/farm_collab_provider.dart';
import '../../../core/models/farm_collab_model.dart';
import '../../../core/theme/app_theme.dart';

class FarmCollabScreen extends StatefulWidget {
  const FarmCollabScreen({super.key});

  @override
  State<FarmCollabScreen> createState() => _FarmCollabScreenState();
}

class _FarmCollabScreenState extends State<FarmCollabScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FarmCollabProvider>().loadCollaborations();
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
        title: const Text('Farm Collaboration'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/community'),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              text: 'Apply',
              icon: Icon(MdiIcons.handshake),
            ),
            Tab(
              text: 'Pending',
              icon: Icon(MdiIcons.clockOutline),
            ),
            Tab(
              text: 'Active',
              icon: Icon(MdiIcons.checkCircle),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildCollaborationToggle(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildApplyTab(),
                _buildPendingTab(),
                _buildActiveTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollaborationToggle() {
    return Consumer<FarmCollabProvider>(
      builder: (context, provider, child) {
        final preference = provider.userPreference;
        if (preference == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(16),
          color: AppTheme.primaryGreen.withOpacity(0.1),
          child: Row(
            children: [
              Icon(MdiIcons.handshake, color: AppTheme.primaryGreen),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Ready to Collaborate?',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ),
              Switch(
                value: preference.isOpenForCollaboration,
                onChanged: (_) => provider.toggleCollaborationAvailability(),
                activeThumbColor: AppTheme.primaryGreen,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildApplyTab() {
    return Consumer<FarmCollabProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: provider.isLoading && provider.allCollaborations.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : provider.allCollaborations.isEmpty
                      ? _buildEmptyState('No collaborations available', 'Check back later for new opportunities')
                      : _buildCollaborationsList(provider.searchCollaborations(_searchQuery)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search farms...',
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
          ),
          const SizedBox(width: 12),
          PopupMenuButton<CollabType?>(
            icon: Icon(MdiIcons.filterVariant),
            onSelected: (type) {
              // Filter by type logic can be added here
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Text('All Types'),
              ),
              ...CollabType.values.map((type) => PopupMenuItem(
                value: type,
                child: Text(context.read<FarmCollabProvider>().getCollabTypeDisplayName(type)),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCollaborationsList(List<FarmCollaboration> collaborations) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: collaborations.length,
      itemBuilder: (context, index) {
        final collab = collaborations[index];
        return _buildCollaborationCard(collab);
      },
    );
  }

  Widget _buildCollaborationCard(FarmCollaboration collab) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.primaryGreen.withOpacity(0.2),
                child: Text(
                  collab.ownerAvatar,
                  style: const TextStyle(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collab.farmName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          collab.location,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (collab.isUrgent)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'URGENT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Title and Description
          Text(
            collab.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            collab.description,
            style: TextStyle(color: Colors.grey[700]),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // Type and Budget
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  context.read<FarmCollabProvider>().getCollabTypeDisplayName(collab.type),
                  style: const TextStyle(
                    color: AppTheme.primaryGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              if (collab.budget != null)
                Text(
                  '₹${collab.budget!.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Skills Needed
          if (collab.skillsNeeded.isNotEmpty) ...[
            Text(
              'Skills Needed:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: collab.skillsNeeded.take(3).map((skill) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  skill,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.blue,
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 12),
          ],

          // Participants and Apply Button
          Row(
            children: [
              Icon(MdiIcons.accountGroup, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${collab.currentParticipants}/${collab.maxParticipants} participants',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              CustomButton(
                text: 'Apply',
                size: ButtonSize.small,
                onPressed: () => _showApplicationDialog(collab),
                backgroundColor: AppTheme.primaryGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPendingTab() {
    return Consumer<FarmCollabProvider>(
      builder: (context, provider, child) {
        final pendingApps = provider.pendingApplications;
        
        if (pendingApps.isEmpty) {
          return _buildEmptyState('No pending applications', 'Apply to collaborations to see them here');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pendingApps.length,
          itemBuilder: (context, index) {
            final application = pendingApps[index];
            final collab = provider.allCollaborations.firstWhere(
              (c) => c.id == application.collabId,
              orElse: () => provider.allCollaborations.first,
            );
            return _buildApplicationCard(application, collab, provider);
          },
        );
      },
    );
  }

  Widget _buildActiveTab() {
    return Consumer<FarmCollabProvider>(
      builder: (context, provider, child) {
        final activeCollabs = provider.activeCollaborations;
        
        if (activeCollabs.isEmpty) {
          return _buildEmptyState('No active collaborations', 'Join collaborations to see them here');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: activeCollabs.length,
          itemBuilder: (context, index) {
            final collab = activeCollabs[index];
            return _buildActiveCollabCard(collab);
          },
        );
      },
    );
  }

  Widget _buildApplicationCard(CollabApplication application, FarmCollaboration collab, FarmCollabProvider provider) {
    Color statusColor = application.status == ApplicationStatus.pending
        ? Colors.orange
        : application.status == ApplicationStatus.accepted
            ? Colors.green
            : Colors.red;

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  collab.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  provider.getApplicationStatusDisplayName(application.status).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            collab.farmName,
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            collab.location,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 12),
          Text(
            'Your Message:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          Text(
            application.message,
            style: TextStyle(color: Colors.grey[700]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Applied ${_formatTimeAgo(application.appliedAt)}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              if (application.status == ApplicationStatus.pending)
                TextButton(
                  onPressed: () => _withdrawApplication(application.id, provider),
                  child: const Text('Withdraw', style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveCollabCard(FarmCollaboration collab) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      backgroundColor: AppTheme.primaryGreen.withOpacity(0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(MdiIcons.checkCircle, color: AppTheme.primaryGreen),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  collab.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            collab.farmName,
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            collab.location,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 12),
          Text(
            collab.description,
            style: TextStyle(color: Colors.grey[700]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(MdiIcons.accountGroup, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${collab.currentParticipants} participants',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              if (collab.contactInfo != null)
                CustomButton(
                  text: 'Contact',
                  size: ButtonSize.small,
                  onPressed: () => _showContactInfo(collab.contactInfo!),
                  backgroundColor: AppTheme.primaryGreen,
                ),
            ],
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
              MdiIcons.handshakeOutline,
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

  void _showApplicationDialog(FarmCollaboration collab) {
    final messageController = TextEditingController();
    final experienceController = TextEditingController();
    final skillsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Apply to ${collab.farmName}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  hintText: 'Why do you want to collaborate?',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: skillsController,
                decoration: const InputDecoration(
                  labelText: 'Your Skills',
                  hintText: 'e.g., Organic Farming, Irrigation',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: experienceController,
                decoration: const InputDecoration(
                  labelText: 'Experience',
                  hintText: 'Brief description of your experience',
                ),
                maxLines: 2,
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
              if (messageController.text.isNotEmpty) {
                Navigator.pop(context);
                final skills = skillsController.text
                    .split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList();
                
                final success = await context.read<FarmCollabProvider>().applyForCollaboration(
                  collab.id,
                  messageController.text,
                  skills,
                  experienceController.text,
                );
                
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Application submitted successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _withdrawApplication(String applicationId, FarmCollabProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw Application'),
        content: const Text('Are you sure you want to withdraw this application?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await provider.withdrawApplication(applicationId);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Application withdrawn'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );
  }

  void _showContactInfo(String contactInfo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Information'),
        content: Text(contactInfo),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inMinutes} minutes ago';
    }
  }
}
