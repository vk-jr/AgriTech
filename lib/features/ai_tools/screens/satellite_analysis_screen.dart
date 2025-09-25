import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../shared/widgets/custom_card.dart';
import '../../../core/theme/app_theme.dart';

class SatelliteAnalysisScreen extends StatefulWidget {
  const SatelliteAnalysisScreen({super.key});

  @override
  State<SatelliteAnalysisScreen> createState() => _SatelliteAnalysisScreenState();
}

class _SatelliteAnalysisScreenState extends State<SatelliteAnalysisScreen>
    with TickerProviderStateMixin {
  late AnimationController _earthAnimationController;
  late Animation<double> _earthRotationAnimation;

  @override
  void initState() {
    super.initState();
    _earthAnimationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _earthRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _earthAnimationController,
      curve: Curves.linear,
    ));
    _earthAnimationController.repeat();
  }

  @override
  void dispose() {
    _earthAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              MdiIcons.satelliteVariant,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text('Farm Satellite Analysis'),
          ],
        ),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSatelliteViewSection(context),
            _buildAnalysisCardsSection(context),
            _buildSmartRecommendationButton(context),
            _buildHowItHelpsSection(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSatelliteViewSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryGreen.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Satellite View of My Farm',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          
          // Animated Earth with Farm Location
          SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow rings
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryGreen.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                ),
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryGreen.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                
                // Rotating Earth
                AnimatedBuilder(
                  animation: _earthRotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _earthRotationAnimation.value * 2 * 3.14159,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF4CAF50),
                              const Color(0xFF2196F3),
                              const Color(0xFF1976D2),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryGreen.withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.public,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),
                
                // Farm location indicator
                Positioned(
                  top: 45,
                  right: 35,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 10,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'My Farm',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Satellite indicators with orbiting animation
                AnimatedBuilder(
                  animation: _earthRotationAnimation,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        Transform.rotate(
                          angle: _earthRotationAnimation.value * 2 * 3.14159 * 0.5,
                          child: Transform.translate(
                            offset: const Offset(0, -90),
                            child: _buildSatelliteIndicator(),
                          ),
                        ),
                        Transform.rotate(
                          angle: _earthRotationAnimation.value * 2 * 3.14159 * 0.7 + 3.14159,
                          child: Transform.translate(
                            offset: const Offset(0, -90),
                            child: _buildSatelliteIndicator(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          Text(
            'Live satellite monitoring of your 0.2 hectare farm',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Live',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSatelliteIndicator() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.yellow,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.yellow.withOpacity(0.5),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.satellite_alt,
        color: Colors.black,
        size: 10,
      ),
    );
  }

  Widget _buildAnalysisCardsSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                MdiIcons.chartBox,
                color: AppTheme.primaryGreen,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Choose Analysis for My Farm',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 0.9,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildAnalysisCard(
                'Carbon Intelligence',
                MdiIcons.leaf,
                AppTheme.primaryGreen,
                'Monitor carbon footprint and sustainability metrics',
              ),
              _buildAnalysisCard(
                'Biodiversity Mapping',
                MdiIcons.butterfly,
                AppTheme.skyBlue,
                'Track wildlife and ecosystem health indicators',
              ),
              _buildAnalysisCard(
                'Soil Health',
                MdiIcons.earth,
                AppTheme.accentBrown,
                'Analyze soil composition and nutrient levels',
              ),
              _buildAnalysisCard(
                'Crop Monitoring',
                MdiIcons.sproutOutline,
                AppTheme.earthYellow,
                'Real-time crop growth and health assessment',
              ),
              _buildAnalysisCard(
                'Water Management',
                MdiIcons.water,
                Colors.blue,
                'Irrigation efficiency and water usage analysis',
              ),
              _buildAnalysisCard(
                'Weather Patterns',
                MdiIcons.weatherPartlyCloudy,
                Colors.orange,
                'Micro-climate analysis and weather forecasting',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard(String title, IconData icon, Color color, String description) {
    return CustomCard(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title analysis selected'),
            backgroundColor: color,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 9,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartRecommendationButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Generating smart recommendations based on satellite data...'),
              backgroundColor: AppTheme.primaryGreen,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MdiIcons.brain,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Get Smart Recommendations for My Farm',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItHelpsSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: CustomCard(
        backgroundColor: AppTheme.skyBlue.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.skyBlue,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'How This Helps Your Farm',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.skyBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Our satellite analysis uses real-time data and AI to give you personalized recommendations. Each analysis provides specific actions you can take to improve your farm\'s productivity, sustainability, and profitability.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppTheme.primaryGreen,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Real-time monitoring and alerts',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppTheme.primaryGreen,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Precision agriculture recommendations',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppTheme.primaryGreen,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Data-driven decision making',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
