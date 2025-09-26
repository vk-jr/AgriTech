import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../providers/soil_analysis_provider.dart';
import '../../../core/models/soil_analysis_model.dart';
import '../../../core/theme/app_theme.dart';

class SoilAnalysisScreen extends StatefulWidget {
  const SoilAnalysisScreen({super.key});

  @override
  State<SoilAnalysisScreen> createState() => _SoilAnalysisScreenState();
}

class _SoilAnalysisScreenState extends State<SoilAnalysisScreen> {
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soil Analysis'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/ai-tools'),
        ),
      ),
      body: Consumer<SoilAnalysisProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAnalysisInput(context, provider),
                const SizedBox(height: 24),
                if (provider.currentAnalysis != null) ...[
                  _buildAnalysisResults(context, provider.currentAnalysis!),
                  const SizedBox(height: 24),
                ],
                if (provider.analysisHistory.isNotEmpty)
                  _buildAnalysisHistory(context, provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnalysisInput(BuildContext context, SoilAnalysisProvider provider) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(MdiIcons.earth, color: AppTheme.accentBrown, size: 24),
              const SizedBox(width: 12),
              Text(
                'New Soil Analysis',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: 'Farm Location',
              hintText: 'Enter your farm location',
              prefixIcon: const Icon(Icons.location_on),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (provider.isAnalyzing)
            const Center(child: CircularProgressIndicator())
          else
            CustomButton(
              text: 'Analyze Soil',
              icon: MdiIcons.testTube,
              onPressed: () {
                if (_locationController.text.isNotEmpty) {
                  provider.analyzeSoil(location: _locationController.text);
                }
              },
              backgroundColor: AppTheme.accentBrown,
            ),
          if (provider.errorMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                provider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnalysisResults(BuildContext context, SoilAnalysisResult analysis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analysis Results',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildQualityScore(context, analysis.qualityScore),
        const SizedBox(height: 16),
        _buildNutrientLevels(context, analysis.nutrients),
        const SizedBox(height: 16),
        _buildSoilProperties(context, analysis.properties),
        const SizedBox(height: 16),
        _buildRecommendations(context, analysis.recommendations),
      ],
    );
  }

  Widget _buildQualityScore(BuildContext context, SoilQualityScore score) {
    return CustomCard(
      backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
      child: Column(
        children: [
          Text(
            'Soil Quality Score',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                score.overall.toStringAsFixed(0),
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Text('/100', style: Theme.of(context).textTheme.bodyLarge),
                  Text(score.grade, style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                  )),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildScoreBar('Fertility', score.fertility)),
              const SizedBox(width: 12),
              Expanded(child: _buildScoreBar('Structure', score.structure)),
              const SizedBox(width: 12),
              Expanded(child: _buildScoreBar('Health', score.health)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBar(String label, double value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value / 100,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
        ),
        Text('${value.toInt()}%', style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildNutrientLevels(BuildContext context, SoilNutrients nutrients) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrient Levels',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildNutrientRow('Nitrogen (N)', nutrients.nitrogen, 'ppm'),
          _buildNutrientRow('Phosphorus (P)', nutrients.phosphorus, 'ppm'),
          _buildNutrientRow('Potassium (K)', nutrients.potassium, 'ppm'),
          _buildNutrientRow('Organic Matter', nutrients.organicMatter, '%'),
        ],
      ),
    );
  }

  Widget _buildNutrientRow(String name, double value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Text('${value.toStringAsFixed(1)} $unit', 
               style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSoilProperties(BuildContext context, SoilProperties properties) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Soil Properties',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildPropertyRow('pH Level', properties.ph.toStringAsFixed(1)),
          _buildPropertyRow('Moisture', '${properties.moisture.toStringAsFixed(1)}%'),
          _buildPropertyRow('Temperature', '${properties.temperature.toStringAsFixed(1)}°C'),
        ],
      ),
    );
  }

  Widget _buildPropertyRow(String name, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildRecommendations(BuildContext context, List<SoilRecommendation> recommendations) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommendations',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...recommendations.take(3).map((rec) => _buildRecommendationItem(rec)),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(SoilRecommendation recommendation) {
    Color priorityColor = recommendation.priority == RecommendationPriority.high
        ? Colors.red
        : recommendation.priority == RecommendationPriority.medium
            ? Colors.orange
            : Colors.blue;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: priorityColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: priorityColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  recommendation.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  recommendation.priority.toString().split('.').last.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            recommendation.description,
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            'Expected outcome: ${recommendation.expectedOutcome}',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisHistory(BuildContext context, SoilAnalysisProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analysis History',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...provider.analysisHistory.map((analysis) => _buildHistoryItem(analysis, provider)),
      ],
    );
  }

  Widget _buildHistoryItem(SoilAnalysisResult analysis, SoilAnalysisProvider provider) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 8),
      onTap: () => provider.selectAnalysis(analysis),
      child: Row(
        children: [
          Icon(MdiIcons.earth, color: AppTheme.accentBrown),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  analysis.location,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${analysis.analyzedAt.day}/${analysis.analyzedAt.month}/${analysis.analyzedAt.year}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            analysis.qualityScore.grade,
            style: const TextStyle(
              color: AppTheme.primaryGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
