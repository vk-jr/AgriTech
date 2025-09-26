import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../providers/weather_provider.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/weather_service.dart';

class WeatherPredictionScreen extends StatefulWidget {
  const WeatherPredictionScreen({super.key});

  @override
  State<WeatherPredictionScreen> createState() => _WeatherPredictionScreenState();
}

class _WeatherPredictionScreenState extends State<WeatherPredictionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().getCurrentLocationAndWeather();
    });
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Weather Prediction'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/ai-tools'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<WeatherProvider>().refreshWeather();
            },
          ),
        ],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          if (weatherProvider.isLoadingWeather || weatherProvider.isLoadingLocation) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading weather data...'),
                ],
              ),
            );
          }

          if (weatherProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppTheme.errorRed,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading weather data',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    weatherProvider.error!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      weatherProvider.clearError();
                      weatherProvider.getCurrentLocationAndWeather();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: weatherProvider.refreshWeather,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCurrentWeatherCard(context, weatherProvider),
                  const SizedBox(height: 16),
                  _buildWeatherDetailsCard(context, weatherProvider),
                  const SizedBox(height: 16),
                  _buildAlertsCard(context, weatherProvider),
                  const SizedBox(height: 16),
                  _buildHistoricalChart(context, weatherProvider),
                  const SizedBox(height: 16),
                  _buildExtendedForecastChart(context, weatherProvider),
                  const SizedBox(height: 16),
                  _buildDetailedForecast(context, weatherProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentWeatherCard(BuildContext context, WeatherProvider weatherProvider) {
    return CustomCard(
      backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppTheme.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  weatherProvider.currentLocation ?? 'Current Location',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weatherProvider.getTemperature(),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGreen,
                        ),
                  ),
                  Text(
                    _capitalizeFirst(weatherProvider.getWeatherDescription()),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              Text(
                weatherProvider.getWeatherIcon(
                  weatherProvider.currentWeather?['weather'][0]['main'] ?? 'Clear',
                ),
                style: const TextStyle(fontSize: 64),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetailsCard(BuildContext context, WeatherProvider weatherProvider) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weather Details',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  context,
                  MdiIcons.waterPercent,
                  'Humidity',
                  weatherProvider.getHumidity(),
                  AppTheme.skyBlue,
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  context,
                  MdiIcons.weatherWindy,
                  'Wind Speed',
                  weatherProvider.getWindSpeed(),
                  AppTheme.earthYellow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  context,
                  MdiIcons.thermometer,
                  'Feels Like',
                  weatherProvider.currentWeather != null
                      ? '${weatherProvider.currentWeather!['main']['feels_like'].round()}°C'
                      : '--°C',
                  AppTheme.warningOrange,
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  context,
                  MdiIcons.gaugeEmpty,
                  'Pressure',
                  weatherProvider.currentWeather != null
                      ? '${weatherProvider.currentWeather!['main']['pressure']} hPa'
                      : '-- hPa',
                  AppTheme.accentBrown,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildAlertsCard(BuildContext context, WeatherProvider weatherProvider) {
    if (weatherProvider.alerts.isEmpty) {
      return const SizedBox.shrink();
    }

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_outlined,
                color: AppTheme.warningOrange,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Agricultural Alerts',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...weatherProvider.alerts.map((alert) => _buildAlertItem(context, alert)),
        ],
      ),
    );
  }

  Widget _buildAlertItem(BuildContext context, WeatherAlert alert) {
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
      margin: const EdgeInsets.only(bottom: 12),
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
                        color: alertColor,
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
        ],
      ),
    );
  }

  Widget _buildForecastCard(BuildContext context, WeatherProvider weatherProvider) {
    if (weatherProvider.forecast == null) {
      return const SizedBox.shrink();
    }

    final forecastList = weatherProvider.forecast!['list'] as List;
    final dailyForecasts = <String, Map<String, dynamic>>{};

    // Group forecasts by day
    for (var item in forecastList.take(5)) {
      final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
      final dateKey = '${date.day}/${date.month}';
      
      if (!dailyForecasts.containsKey(dateKey)) {
        dailyForecasts[dateKey] = item;
      }
    }

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '5-Day Forecast',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dailyForecasts.length,
              itemBuilder: (context, index) {
                final entry = dailyForecasts.entries.elementAt(index);
                final forecast = entry.value;
                final date = DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
                
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryGreen.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${date.day}/${date.month}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        weatherProvider.getWeatherIcon(forecast['weather'][0]['main']),
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${forecast['main']['temp'].round()}°C',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryGreen,
                            ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoricalChart(BuildContext context, WeatherProvider weatherProvider) {
    if (weatherProvider.historicalData.isEmpty) {
      return const SizedBox.shrink();
    }

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                MdiIcons.chartLine,
                color: AppTheme.primaryGreen,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Past Week Climate Trends',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}°C',
                          style: Theme.of(context).textTheme.bodySmall,
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < weatherProvider.historicalData.length) {
                          final date = weatherProvider.historicalData[index]['date'] as DateTime;
                          return Text(
                            DateFormat('MM/dd').format(date),
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: weatherProvider.historicalData.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value['temp'].toDouble());
                    }).toList(),
                    isCurved: true,
                    color: AppTheme.primaryGreen,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtendedForecastChart(BuildContext context, WeatherProvider weatherProvider) {
    if (weatherProvider.extendedForecast.isEmpty) {
      return const SizedBox.shrink();
    }

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                MdiIcons.weatherPartlyCloudy,
                color: AppTheme.skyBlue,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Next Week Weather Trends',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}°C',
                          style: Theme.of(context).textTheme.bodySmall,
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < weatherProvider.extendedForecast.length) {
                          final date = weatherProvider.extendedForecast[index]['date'] as DateTime;
                          return Text(
                            DateFormat('MM/dd').format(date),
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: weatherProvider.extendedForecast.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value['temp'].toDouble());
                    }).toList(),
                    isCurved: true,
                    color: AppTheme.skyBlue,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.skyBlue.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedForecast(BuildContext context, WeatherProvider weatherProvider) {
    if (weatherProvider.forecast == null) {
      return const SizedBox.shrink();
    }

    final forecastList = weatherProvider.forecast!['list'] as List;
    
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detailed 5-Day Forecast',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (forecastList.length / 8).ceil().clamp(0, 5), // Group by days (8 forecasts per day)
            itemBuilder: (context, dayIndex) {
              final dayStart = dayIndex * 8;
              final dayEnd = (dayStart + 8).clamp(0, forecastList.length);
              final dayForecasts = forecastList.sublist(dayStart, dayEnd);
              
              if (dayForecasts.isEmpty) return const SizedBox.shrink();
              
              final firstForecast = dayForecasts[0];
              final date = DateTime.fromMillisecondsSinceEpoch(firstForecast['dt'] * 1000);
              
              // Calculate day's min/max temperatures
              double minTemp = dayForecasts[0]['main']['temp'].toDouble();
              double maxTemp = dayForecasts[0]['main']['temp'].toDouble();
              
              for (var forecast in dayForecasts) {
                final temp = forecast['main']['temp'].toDouble();
                if (temp < minTemp) minTemp = temp;
                if (temp > maxTemp) maxTemp = temp;
              }
              
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('EEEE, MMM dd').format(date),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _capitalizeFirst(firstForecast['weather'][0]['description']),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      weatherProvider.getWeatherIcon(firstForecast['weather'][0]['main']),
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${maxTemp.round()}°C',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryGreen,
                              ),
                        ),
                        Text(
                          '${minTemp.round()}°C',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
