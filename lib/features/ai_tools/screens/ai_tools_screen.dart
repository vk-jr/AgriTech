import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../shared/widgets/custom_card.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class AIToolsScreen extends StatelessWidget {
  const AIToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.aiTools),
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
                      AppLocalizations.of(context)!.aiPoweredAgriculture,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryGreen,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.aiDescription,
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
              color: AppTheme.earthYellow.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.earthYellow.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: AppTheme.earthYellow,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.aiTip,
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
          AppLocalizations.of(context)!.mainAiTools,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        FeatureCard(
          title: AppLocalizations.of(context)!.cropSuggestionAi,
          subtitle: AppLocalizations.of(context)!.cropSuggestionAiDesc,
          icon: MdiIcons.sproutOutline,
          iconColor: AppTheme.primaryGreen,
          onTap: () => context.go('/ai-tools/crop-suggestion'),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.primaryGreen.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.popular,
              style: const TextStyle(
                color: AppTheme.primaryGreen,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        FeatureCard(
          title: AppLocalizations.of(context)!.plantRecommendation,
          subtitle: AppLocalizations.of(context)!.plantRecommendationDesc,
          icon: MdiIcons.flowerOutline,
          iconColor: AppTheme.accentBrown,
          onTap: () => context.go('/ai-tools/plant-recommendation'),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accentBrown.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.accentBrown.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.smart,
              style: const TextStyle(
                color: AppTheme.accentBrown,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        FeatureCard(
          title: AppLocalizations.of(context)!.plantDoctor,
          subtitle: AppLocalizations.of(context)!.plantDoctorDesc2,
          icon: MdiIcons.medicalBag,
          iconColor: AppTheme.errorRed,
          onTap: () => context.go('/ai-tools/plant-doctor'),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.errorRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.errorRed.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.newLabel,
              style: const TextStyle(
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
          AppLocalizations.of(context)!.additionalTools,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        FeatureCard(
          title: AppLocalizations.of(context)!.arPlantLayout,
          subtitle: AppLocalizations.of(context)!.arPlantLayoutDesc,
          icon: MdiIcons.cubeOutline,
          iconColor: AppTheme.skyBlue,
          onTap: () => context.go('/ai-tools/ar-view'),
        ),
        const SizedBox(height: 12),
        FeatureCard(
          title: AppLocalizations.of(context)!.weatherPrediction,
          subtitle: AppLocalizations.of(context)!.weatherPredictionDesc,
          icon: MdiIcons.weatherPartlyCloudy,
          iconColor: AppTheme.earthYellow,
          onTap: () => context.go('/weather-prediction'),
          isEnabled: true,
        ),
        const SizedBox(height: 12),
        FeatureCard(
          title: AppLocalizations.of(context)!.soilAnalysisTitle,
          subtitle: AppLocalizations.of(context)!.soilAnalysisDesc,
          icon: MdiIcons.earth,
          iconColor: AppTheme.accentBrown,
          onTap: () => context.go('/ai-tools/soil-analysis'),
          isEnabled: true,
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accentBrown.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.accentBrown.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Text(
              'NEW',
              style: TextStyle(
                color: AppTheme.accentBrown,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComingSoonSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.moreFeatures,
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
                      AppLocalizations.of(context)!.satelliteFarmAnalysis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.skyBlue,
                          ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.skyBlue,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context)!.satelliteFarmAnalysisDesc,
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
                      child: Text(AppLocalizations.of(context)!.exploreSatelliteAnalysis),
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
