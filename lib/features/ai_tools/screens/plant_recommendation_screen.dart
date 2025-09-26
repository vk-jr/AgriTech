import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../core/theme/app_theme.dart';

class PlantRecommendationScreen extends StatefulWidget {
  const PlantRecommendationScreen({super.key});

  @override
  State<PlantRecommendationScreen> createState() => _PlantRecommendationScreenState();
}

class _PlantRecommendationScreenState extends State<PlantRecommendationScreen> {
  String _selectedEnvironment = '';
  String _selectedWeatherCondition = '';
  String _selectedCareTime = '';
  bool _showRecommendation = false;
  String _recommendedPlant = '';
  String _plantDescription = '';
  String _careInstructions = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              MdiIcons.flowerOutline,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text('Plant Recommendation'),
          ],
        ),
        backgroundColor: AppTheme.accentBrown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context),
            const SizedBox(height: 24),
            if (!_showRecommendation) ...[
              _buildAnalysisForm(context),
              const SizedBox(height: 24),
              _buildAnalyzeButton(context),
            ] else ...[
              _buildRecommendationResult(context),
              const SizedBox(height: 24),
              _buildARPlantLayoutButton(context),
              const SizedBox(height: 16),
              _buildTryAgainButton(context),
            ],
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return CustomCard(
      backgroundColor: AppTheme.accentBrown.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                MdiIcons.brain,
                color: AppTheme.accentBrown,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Smart Plant Recommendation',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.accentBrown,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Get personalized plant suggestions based on your conditions and care preferences',
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
                const Icon(
                  Icons.lightbulb_outline,
                  color: AppTheme.earthYellow,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Answer a few questions to get the perfect plant recommendation for you',
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

  Widget _buildAnalysisForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plant Analysis Form',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        
        // Environment Selection
        _buildSectionTitle('Growing Environment'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildOptionCard(
                'Indoor',
                MdiIcons.home,
                AppTheme.primaryGreen,
                _selectedEnvironment == 'Indoor',
                () => setState(() => _selectedEnvironment = 'Indoor'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOptionCard(
                'Outdoor',
                MdiIcons.tree,
                AppTheme.skyBlue,
                _selectedEnvironment == 'Outdoor',
                () => setState(() => _selectedEnvironment = 'Outdoor'),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Weather Condition Selection
        _buildSectionTitle('Weather Conditions'),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildWeatherOption('Sunny', MdiIcons.weatherSunny, Colors.orange),
            _buildWeatherOption('Rainy', MdiIcons.weatherRainy, Colors.blue),
            _buildWeatherOption('Humid', MdiIcons.waterPercent, AppTheme.skyBlue),
            _buildWeatherOption('Dry', MdiIcons.weatherPartlyCloudy, Colors.brown),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Care Time Selection
        _buildSectionTitle('Time Available for Plant Care'),
        const SizedBox(height: 12),
        Column(
          children: [
            _buildCareTimeOption('Low (5-10 min/week)', 'Low'),
            const SizedBox(height: 8),
            _buildCareTimeOption('Medium (15-30 min/week)', 'Medium'),
            const SizedBox(height: 8),
            _buildCareTimeOption('High (1+ hour/week)', 'High'),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.accentBrown,
          ),
    );
  }

  Widget _buildOptionCard(String title, IconData icon, Color color, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey[600],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? color : Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherOption(String title, IconData icon, Color color) {
    final isSelected = _selectedWeatherCondition == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedWeatherCondition = title),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : Colors.grey[600],
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCareTimeOption(String title, String value) {
    final isSelected = _selectedCareTime == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedCareTime = value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentBrown.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.accentBrown : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.schedule,
              color: isSelected ? AppTheme.accentBrown : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppTheme.accentBrown : Colors.grey[600],
                    ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppTheme.accentBrown,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzeButton(BuildContext context) {
    final canAnalyze = _selectedEnvironment.isNotEmpty && 
                      _selectedWeatherCondition.isNotEmpty && 
                      _selectedCareTime.isNotEmpty;
    
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: 'Analyze & Get Recommendation',
        onPressed: canAnalyze ? _performAnalysis : null,
        type: ButtonType.primary,
        icon: MdiIcons.brain,
      ),
    );
  }

  void _performAnalysis() {
    // Simulate AI analysis
    setState(() {
      _showRecommendation = true;
      _generateRecommendation();
    });
  }

  void _generateRecommendation() {
    // Simple recommendation logic based on selections
    if (_selectedEnvironment == 'Indoor') {
      if (_selectedCareTime == 'Low') {
        _recommendedPlant = 'Snake Plant (Sansevieria)';
        _plantDescription = 'Perfect for beginners! This hardy plant thrives in low light and requires minimal watering.';
        _careInstructions = '• Water every 2-3 weeks\n• Tolerates low light\n• Clean leaves monthly\n• Repot every 2-3 years';
      } else if (_selectedCareTime == 'Medium') {
        _recommendedPlant = 'Pothos (Devil\'s Ivy)';
        _plantDescription = 'A beautiful trailing plant that purifies air and grows quickly in various conditions.';
        _careInstructions = '• Water weekly when soil is dry\n• Bright, indirect light\n• Trim regularly for bushiness\n• Propagate easily in water';
      } else {
        _recommendedPlant = 'Fiddle Leaf Fig';
        _plantDescription = 'A stunning statement plant with large, glossy leaves that adds elegance to any space.';
        _careInstructions = '• Water when top soil is dry\n• Bright, indirect light\n• Rotate weekly\n• Dust leaves regularly\n• Fertilize monthly in growing season';
      }
    } else {
      if (_selectedWeatherCondition == 'Sunny') {
        _recommendedPlant = 'Marigold';
        _plantDescription = 'Bright, colorful flowers that love full sun and are perfect for outdoor gardens.';
        _careInstructions = '• Water daily in hot weather\n• Full sun exposure\n• Deadhead spent flowers\n• Plant after last frost';
      } else if (_selectedWeatherCondition == 'Rainy') {
        _recommendedPlant = 'Ferns';
        _plantDescription = 'Lush green plants that thrive in humid, shaded outdoor conditions.';
        _careInstructions = '• Keep soil consistently moist\n• Partial to full shade\n• High humidity preferred\n• Mulch around base';
      } else {
        _recommendedPlant = 'Lavender';
        _plantDescription = 'Fragrant herb that loves sun and well-drained soil, perfect for dry conditions.';
        _careInstructions = '• Water sparingly\n• Full sun exposure\n• Prune after flowering\n• Well-drained soil essential';
      }
    }
  }

  Widget _buildRecommendationResult(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Perfect Plant Match',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        
        CustomCard(
          backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      MdiIcons.leaf,
                      color: AppTheme.primaryGreen,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _recommendedPlant,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryGreen,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Recommended for you',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                _plantDescription,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Care Instructions:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentBrown,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                _careInstructions,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildARPlantLayoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: 'AR Plant Layout',
        onPressed: () => context.go('/ai-tools/ar-view'),
        type: ButtonType.secondary,
        icon: MdiIcons.cubeOutline,
      ),
    );
  }

  Widget _buildTryAgainButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: 'Try Another Recommendation',
        onPressed: () {
          setState(() {
            _showRecommendation = false;
            _selectedEnvironment = '';
            _selectedWeatherCondition = '';
            _selectedCareTime = '';
          });
        },
        type: ButtonType.secondary,
        icon: Icons.refresh,
      ),
    );
  }
}
