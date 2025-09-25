import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../shared/widgets/custom_card.dart';
import '../../../core/theme/app_theme.dart';

class AIToolsScreen extends StatelessWidget {
  const AIToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('AI Tools'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context),
            const SizedBox(height: 24),
            _buildMainToolsSection(context),
            const SizedBox(height: 24),
            _buildAdditionalToolsSection(context),
            const SizedBox(height: 24),
            _buildComingSoonSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return CustomCard(
      backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                MdiIcons.brain,
                color: AppTheme.primaryGreen,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI-Powered Agriculture',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryGreen,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Leverage artificial intelligence to make smarter farming decisions',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.earthYellow.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: AppTheme.earthYellow,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tip: Take clear, well-lit photos for better AI analysis results',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainToolsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Main AI Tools',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        FeatureCard(
          title: 'Crop Suggestion AI',
          subtitle: 'Get personalized crop recommendations based on your soil, climate, and market conditions',
          icon: MdiIcons.sproutOutline,
          iconColor: AppTheme.primaryGreen,
          onTap: () => context.go('/ai-tools/crop-suggestion'),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Popular',
              style: TextStyle(
                color: AppTheme.primaryGreen,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        FeatureCard(
          title: 'Plant Recommendation',
          subtitle: 'Get personalized plant suggestions perfect for your conditions and small-scale growing',
          icon: MdiIcons.flowerOutline,
          iconColor: AppTheme.accentBrown,
          onTap: () => context.go('/ai-tools/plant-recommendation'),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accentBrown.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Smart',
              style: TextStyle(
                color: AppTheme.accentBrown,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        FeatureCard(
          title: 'Plant Doctor',
          subtitle: 'Upload photos of diseased plants to get instant AI diagnosis and treatment recommendations',
          icon: MdiIcons.medicalBag,
          iconColor: AppTheme.errorRed,
          onTap: () => context.go('/ai-tools/plant-doctor'),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.errorRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'New',
              style: TextStyle(
                color: AppTheme.errorRed,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalToolsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Tools',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        FeatureCard(
          title: 'AR Plant Layout',
          subtitle: 'Visualize crop layouts in your space using augmented reality',
          icon: MdiIcons.cubeOutline,
          iconColor: AppTheme.skyBlue,
          onTap: () => context.go('/ai-tools/ar-view'),
        ),
        const SizedBox(height: 12),
        FeatureCard(
          title: 'Weather Prediction',
          subtitle: 'AI-powered weather forecasts for better farming decisions',
          icon: MdiIcons.weatherPartlyCloudy,
          iconColor: AppTheme.earthYellow,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Weather prediction feature coming soon!'),
              ),
            );
          },
          isEnabled: false,
        ),
        const SizedBox(height: 12),
        FeatureCard(
          title: 'Soil Analysis',
          subtitle: 'Upload soil photos for AI-powered nutrient analysis',
          icon: MdiIcons.earth,
          iconColor: AppTheme.accentBrown,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Soil analysis feature coming soon!'),
              ),
            );
          },
          isEnabled: false,
        ),
      ],
    );
  }

  Widget _buildComingSoonSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'More Features',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        CustomCard(
          onTap: () => context.go('/ai-tools/satellite-analysis'),
          backgroundColor: AppTheme.skyBlue.withOpacity(0.1),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    MdiIcons.satelliteVariant,
                    color: AppTheme.skyBlue,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Satellite Farm Analysis',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.skyBlue,
                          ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.skyBlue,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Get real-time satellite monitoring and AI-powered analysis of your farm. Monitor crop health, soil conditions, and get smart recommendations.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.go('/ai-tools/satellite-analysis'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.skyBlue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Explore Satellite Analysis'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
