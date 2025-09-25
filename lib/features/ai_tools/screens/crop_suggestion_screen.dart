import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../providers/crop_suggestion_provider.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class CropSuggestionScreen extends StatefulWidget {
  const CropSuggestionScreen({super.key});

  @override
  State<CropSuggestionScreen> createState() => _CropSuggestionScreenState();
}

class _CropSuggestionScreenState extends State<CropSuggestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _landSizeController = TextEditingController();
  final _budgetController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    _landSizeController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.cropSuggestionAi),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Consumer<CropSuggestionProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                ),
                child: Column(
                  children: [
                    Icon(
                      MdiIcons.brain,
                      color: AppTheme.primaryGreen,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Crop Recommendation Assistant',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tell us about your farm to get personalized crop suggestions',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              // Chat Area
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: provider.chatMessages.isEmpty
                      ? _buildFormInterface(context, provider)
                      : ListView.builder(
                          itemCount: provider.chatMessages.length,
                          itemBuilder: (context, index) {
                            final message = provider.chatMessages[index];
                            return _buildChatMessage(context, message);
                          },
                        ),
                ),
              ),
              
              // Bottom Action Area
              if (provider.chatMessages.isEmpty)
                _buildSubmitArea(context, provider)
              else
                _buildNewSearchArea(context, provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFormView(BuildContext context, CropSuggestionProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(context),
            const SizedBox(height: 24),
            _buildSoilTypeSection(context, provider),
            const SizedBox(height: 20),
            _buildClimateSection(context, provider),
            const SizedBox(height: 20),
            _buildLocationSection(context, provider),
            const SizedBox(height: 20),
            _buildLandSizeSection(context, provider),
            const SizedBox(height: 20),
            _buildBudgetSection(context, provider),
            const SizedBox(height: 20),
            _buildPreferencesSection(context, provider),
            const SizedBox(height: 32),
            _buildSubmitButton(context, provider),
            if (provider.errorMessage != null) ...[
              const SizedBox(height: 16),
              _buildErrorMessage(context, provider.errorMessage!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
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
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'AI Crop Recommendation',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Provide information about your farming conditions to get personalized crop recommendations powered by AI.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoilTypeSection(BuildContext context, CropSuggestionProvider provider) {
    final soilTypes = ['Clay', 'Sandy', 'Loam', 'Clay Loam', 'Sandy Loam', 'Silty Clay', 'Black Cotton'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Soil Type',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: soilTypes.map((soil) {
            final isSelected = provider.soilType == soil;
            return FilterChip(
              label: Text(soil),
              selected: isSelected,
              onSelected: (selected) {
                provider.updateSoilType(selected ? soil : '');
              },
              selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryGreen,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildClimateSection(BuildContext context, CropSuggestionProvider provider) {
    final climates = ['Tropical', 'Subtropical', 'Temperate', 'Arid', 'Semi-arid', 'Humid'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Climate Type',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: climates.map((climate) {
            final isSelected = provider.climate == climate;
            return FilterChip(
              label: Text(climate),
              selected: isSelected,
              onSelected: (selected) {
                provider.updateClimate(selected ? climate : '');
              },
              selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryGreen,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLocationSection(BuildContext context, CropSuggestionProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _locationController,
          decoration: const InputDecoration(
            hintText: 'Enter your location (e.g., Punjab, India)',
            prefixIcon: Icon(Icons.location_on_outlined),
          ),
          onChanged: provider.updateLocation,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your location';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLandSizeSection(BuildContext context, CropSuggestionProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Land Size (Acres)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _landSizeController,
          decoration: InputDecoration(
            hintText: 'Enter land size in acres',
            prefixIcon: Icon(Icons.landscape),
            suffixText: 'acres',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final size = double.tryParse(value) ?? 0.0;
            provider.updateLandSize(size);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter land size';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBudgetSection(BuildContext context, CropSuggestionProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Budget (₹)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _budgetController,
          decoration: InputDecoration(
            hintText: 'Enter your budget',
            prefixIcon: const Icon(Icons.currency_rupee),
            suffixText: '₹',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final budget = double.tryParse(value) ?? 0.0;
            provider.updateBudget(budget);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your budget';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(BuildContext context, CropSuggestionProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferences',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          title: const Text('Prefer Organic Farming'),
          subtitle: const Text('Get recommendations for organic-friendly crops'),
          value: provider.isOrganicPreferred,
          onChanged: (value) {
            provider.updateOrganicPreference(value ?? false);
          },
          activeColor: AppTheme.primaryGreen,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, CropSuggestionProvider provider) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: 'Get AI Recommendations',
        onPressed: provider.isLoading ? null : () => _submitForm(provider),
        isLoading: provider.isLoading,
        icon: MdiIcons.brain,
        size: ButtonSize.large,
      ),
    );
  }

  Widget _buildErrorMessage(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.errorRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.errorRed.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppTheme.errorRed,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: AppTheme.errorRed,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView(BuildContext context, CropSuggestionProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResultsHeader(context, provider),
          const SizedBox(height: 20),
          ...provider.suggestions.map((suggestion) => _buildSuggestionCard(context, suggestion)),
          const SizedBox(height: 20),
          _buildNewSearchButton(context, provider),
        ],
      ),
    );
  }

  Widget _buildResultsHeader(BuildContext context, CropSuggestionProvider provider) {
    return CustomCard(
      backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: AppTheme.primaryGreen,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'AI Recommendations Ready',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Based on your inputs, here are the best crop recommendations for your farm:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(BuildContext context, suggestion) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  MdiIcons.sprout,
                  color: AppTheme.primaryGreen,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion.crop.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      suggestion.crop.scientificName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildScoreChip(
                          'Match: ${(suggestion.suitabilityScore * 100).toInt()}%',
                          AppTheme.primaryGreen,
                        ),
                        const SizedBox(width: 8),
                        _buildScoreChip(
                          'Profit: ${(suggestion.profitabilityScore * 100).toInt()}%',
                          AppTheme.earthYellow,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            suggestion.reason,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          _buildCropDetails(context, suggestion.crop),
          const SizedBox(height: 12),
          _buildTipsSection(context, suggestion.tips),
        ],
      ),
    );
  }

  Widget _buildScoreChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCropDetails(BuildContext context, crop) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  'Growth Period',
                  '${crop.growthDurationDays} days',
                  Icons.schedule,
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  'Expected Yield',
                  '${crop.expectedYieldPerSqMeter} kg/m²',
                  MdiIcons.weight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  'Market Price',
                  '₹${crop.marketPricePerKg}/kg',
                  MdiIcons.currencyInr,
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  'Difficulty',
                  crop.difficulty.name.toUpperCase(),
                  Icons.trending_up,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipsSection(BuildContext context, List<String> tips) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expert Tips:',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        ...tips.map((tip) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 16,
                    color: AppTheme.earthYellow,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tip,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildNewSearchButton(BuildContext context, CropSuggestionProvider provider) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: 'New Search',
        type: ButtonType.secondary,
        onPressed: () {
          provider.clearSuggestions();
          _clearForm();
        },
        icon: Icons.refresh,
      ),
    );
  }

  void _submitForm(CropSuggestionProvider provider) {
    // Basic validation
    if (provider.soilType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a soil type')),
      );
      return;
    }
    if (provider.climate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a climate type')),
      );
      return;
    }
    if (provider.location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your location')),
      );
      return;
    }
    if (provider.landSize <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid land size')),
      );
      return;
    }
    if (provider.budget <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your budget')),
      );
      return;
    }
    
    // All validations passed, send to webhook
    provider.getCropSuggestions();
  }

  void _clearForm() {
    _locationController.clear();
    _landSizeController.clear();
    _budgetController.clear();
  }

  Widget _buildFormInterface(BuildContext context, CropSuggestionProvider provider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSoilTypeSection(context, provider),
          const SizedBox(height: 20),
          _buildClimateSection(context, provider),
          const SizedBox(height: 20),
          _buildLocationSection(context, provider),
          const SizedBox(height: 20),
          _buildLandSizeSection(context, provider),
          const SizedBox(height: 20),
          _buildBudgetSection(context, provider),
          const SizedBox(height: 20),
          _buildPreferencesSection(context, provider),
        ],
      ),
    );
  }

  Widget _buildChatMessage(BuildContext context, ChatMessage message) {
    bool isLoading = message.content.contains("🤔 Analyzing");
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: message.isUser 
                  ? AppTheme.primaryGreen
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: isLoading 
                ? _buildLoadingContent(context, message)
                : _buildFormattedText(context, message),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent(BuildContext context, ChatMessage message) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            message.content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black87,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormattedText(BuildContext context, ChatMessage message) {
    return _parseFormattedText(context, message.content, message.isUser);
  }

  Widget _parseFormattedText(BuildContext context, String text, bool isUser) {
    List<TextSpan> spans = [];
    List<String> parts = text.split(RegExp(r'(\*\*.*?\*\*|\*.*?\*|###.*?)'));
    
    for (String part in parts) {
      if (part.startsWith('**') && part.endsWith('**')) {
        // Bold text
        spans.add(TextSpan(
          text: part.substring(2, part.length - 2),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ));
      } else if (part.startsWith('*') && part.endsWith('*')) {
        // Italic text
        spans.add(TextSpan(
          text: part.substring(1, part.length - 1),
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: isUser ? Colors.white : Colors.black87,
          ),
        ));
      } else if (part.startsWith('###')) {
        // Header text
        spans.add(TextSpan(
          text: part.substring(3).trim(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isUser ? Colors.white : AppTheme.primaryGreen,
          ),
        ));
      } else if (part.trim().isNotEmpty) {
        // Regular text
        spans.add(TextSpan(
          text: part,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
          ),
        ));
      }
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildSubmitArea(BuildContext context, CropSuggestionProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (provider.isLoading) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Getting crop recommendations...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            if (provider.errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        provider.errorMessage!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.red[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: provider.isLoading ? null : () => _submitForm(provider),
                icon: Icon(MdiIcons.brain),
                label: const Text('Get AI Recommendations'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewSearchArea(BuildContext context, CropSuggestionProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              provider.resetForm();
              _clearForm();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('New Search'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
