import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../providers/dashboard_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: RefreshIndicator(
        onRefresh: () => context.read<DashboardProvider>().refreshData(),
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildWelcomeSection(context),
                  const SizedBox(height: 16),
                  _buildStatsSection(context),
                  const SizedBox(height: 24),
                  _buildAlertsSection(context),
                  const SizedBox(height: 24),
                  _buildQuickActionsSection(context),
                  const SizedBox(height: 24),
                  _buildSustainabilitySection(context),
                  const SizedBox(height: 24), // Bottom padding
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: AppTheme.primaryGreen,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          AppLocalizations.of(context)!.agritechDashboard,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.primaryGreen, AppTheme.darkGreen],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {
            // TODO: Show notifications
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
          onPressed: () => context.go('/profile/settings'),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        if (user == null) return const SizedBox.shrink();

        return CustomCard(
          backgroundColor: AppTheme.lightGreen.withOpacity(0.1),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppTheme.primaryGreen,
                child: Text(
                  user.name.split(' ').map((n) => n[0]).take(2).join(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.welcomeBack(user.name.split(' ')[0]),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${AppLocalizations.of(context)!.level} ${user.gamificationStats.level} • ${user.gamificationStats.totalXP} XP',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    if (user.location != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            user.location!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final stats = provider.stats;
        return CustomCard(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.farmOverview,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  StatCard(
                    title: AppLocalizations.of(context)!.activeCrops,
                    value: '${stats.activeCrops}',
                    icon: MdiIcons.sprout,
                    color: AppTheme.primaryGreen,
                  ),
                  StatCard(
                    title: AppLocalizations.of(context)!.totalYield,
                    value: '${stats.totalYield}T',
                    icon: MdiIcons.weight,
                    color: AppTheme.earthYellow,
                  ),
                  StatCard(
                    title: AppLocalizations.of(context)!.monthlyRevenue,
                    value: '₹${(stats.monthlyRevenue / 1000).toStringAsFixed(0)}K',
                    icon: MdiIcons.currencyInr,
                    color: AppTheme.lightGreen,
                  ),
                  StatCard(
                    title: AppLocalizations.of(context)!.waterSaved,
                    value: '${stats.waterSaved}L',
                    icon: MdiIcons.waterOutline,
                    color: AppTheme.skyBlue,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAlertsSection(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        final weatherAlerts = provider.weatherAlerts;
        final irrigationAlerts = provider.irrigationAlerts;
        
        if (weatherAlerts.isEmpty && irrigationAlerts.isEmpty) {
          return const SizedBox.shrink();
        }

        return CustomCard(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.alertsNotifications,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Show all alerts
                    },
                    child: Text(AppLocalizations.of(context)!.viewAll),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...weatherAlerts.take(2).map((alert) => _buildWeatherAlert(context, alert)),
              ...irrigationAlerts.take(2).map((alert) => _buildIrrigationAlert(context, alert)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeatherAlert(BuildContext context, WeatherAlert alert) {
    Color alertColor;
    IconData alertIcon;
    
    switch (alert.severity) {
      case AlertSeverity.low:
        alertColor = Colors.blue;
        alertIcon = Icons.info_outline;
        break;
      case AlertSeverity.medium:
        alertColor = AppTheme.warningOrange;
        alertIcon = Icons.warning_outlined;
        break;
      case AlertSeverity.high:
        alertColor = AppTheme.errorRed;
        alertIcon = Icons.error_outline;
        break;
      case AlertSeverity.critical:
        alertColor = Colors.red[800]!;
        alertIcon = Icons.dangerous_outlined;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: alertColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: alertColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(alertIcon, color: alertColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () => context.read<DashboardProvider>()
                .dismissAlert(alert.id, AlertType.weather),
          ),
        ],
      ),
    );
  }

  Widget _buildIrrigationAlert(BuildContext context, IrrigationAlert alert) {
    Color urgencyColor;
    
    switch (alert.urgency) {
      case AlertUrgency.low:
        urgencyColor = Colors.green;
        break;
      case AlertUrgency.medium:
        urgencyColor = AppTheme.warningOrange;
        break;
      case AlertUrgency.high:
        urgencyColor = AppTheme.errorRed;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: urgencyColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: urgencyColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(MdiIcons.waterOutline, color: urgencyColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${alert.cropName} - ${alert.fieldLocation}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Moisture: ${alert.moistureLevel}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: urgencyColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.recommendedAction,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () => context.read<DashboardProvider>()
                .dismissAlert(alert.id, AlertType.irrigation),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return CustomCard(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: provider.quickActions.map((action) {
                  return _buildQuickActionCard(context, action);
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActionCard(BuildContext context, QuickAction action) {
    IconData icon;
    Color color;
    
    switch (action.icon) {
      case 'brain':
        icon = MdiIcons.brain;
        color = AppTheme.primaryGreen;
        break;
      case 'medical-bag':
        icon = MdiIcons.medicalBag;
        color = AppTheme.errorRed;
        break;
      case 'chart-line':
        icon = MdiIcons.chartLine;
        color = AppTheme.earthYellow;
        break;
      case 'forum':
        icon = MdiIcons.forum;
        color = AppTheme.skyBlue;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
    }

    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => context.go(action.route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  action.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  action.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSustainabilitySection(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        final tips = provider.sustainabilityTips;
        if (tips.isEmpty) return const SizedBox.shrink();

        return CustomCard(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sustainability Tips',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Show all tips
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tips.length,
                  itemBuilder: (context, index) {
                    final tip = tips[index];
                    return Container(
                      width: 280,
                      margin: const EdgeInsets.only(right: 12),
                      child: CustomCard(
                        backgroundColor: AppTheme.lightGreen.withOpacity(0.1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    tip.title,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryGreen,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${tip.impactScore}/10',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              tip.category,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.primaryGreen,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                tip.description,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
