class MarketAnalysis {
  final String id;
  final String cropName;
  final double currentPrice;
  final double previousPrice;
  final double priceChange;
  final double priceChangePercentage;
  final String trend; // 'up', 'down', 'stable'
  final double demand;
  final double supply;
  final String season;
  final List<PriceHistory> priceHistory;
  final MarketForecast forecast;
  final List<String> majorMarkets;
  final String qualityGrade;
  final DateTime lastUpdated;

  MarketAnalysis({
    required this.id,
    required this.cropName,
    required this.currentPrice,
    required this.previousPrice,
    required this.priceChange,
    required this.priceChangePercentage,
    required this.trend,
    required this.demand,
    required this.supply,
    required this.season,
    required this.priceHistory,
    required this.forecast,
    required this.majorMarkets,
    required this.qualityGrade,
    required this.lastUpdated,
  });

  factory MarketAnalysis.fromJson(Map<String, dynamic> json) {
    return MarketAnalysis(
      id: json['id'],
      cropName: json['cropName'],
      currentPrice: json['currentPrice'].toDouble(),
      previousPrice: json['previousPrice'].toDouble(),
      priceChange: json['priceChange'].toDouble(),
      priceChangePercentage: json['priceChangePercentage'].toDouble(),
      trend: json['trend'],
      demand: json['demand'].toDouble(),
      supply: json['supply'].toDouble(),
      season: json['season'],
      priceHistory: (json['priceHistory'] as List)
          .map((item) => PriceHistory.fromJson(item))
          .toList(),
      forecast: MarketForecast.fromJson(json['forecast']),
      majorMarkets: List<String>.from(json['majorMarkets']),
      qualityGrade: json['qualityGrade'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cropName': cropName,
      'currentPrice': currentPrice,
      'previousPrice': previousPrice,
      'priceChange': priceChange,
      'priceChangePercentage': priceChangePercentage,
      'trend': trend,
      'demand': demand,
      'supply': supply,
      'season': season,
      'priceHistory': priceHistory.map((item) => item.toJson()).toList(),
      'forecast': forecast.toJson(),
      'majorMarkets': majorMarkets,
      'qualityGrade': qualityGrade,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

class PriceHistory {
  final DateTime date;
  final double price;
  final double volume;

  PriceHistory({
    required this.date,
    required this.price,
    required this.volume,
  });

  factory PriceHistory.fromJson(Map<String, dynamic> json) {
    return PriceHistory(
      date: DateTime.parse(json['date']),
      price: json['price'].toDouble(),
      volume: json['volume'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'price': price,
      'volume': volume,
    };
  }
}

class MarketForecast {
  final double predictedPrice;
  final double confidence;
  final String timeframe; // '1week', '1month', '3months'
  final List<String> factors;
  final String recommendation; // 'buy', 'sell', 'hold'

  MarketForecast({
    required this.predictedPrice,
    required this.confidence,
    required this.timeframe,
    required this.factors,
    required this.recommendation,
  });

  factory MarketForecast.fromJson(Map<String, dynamic> json) {
    return MarketForecast(
      predictedPrice: json['predictedPrice'].toDouble(),
      confidence: json['confidence'].toDouble(),
      timeframe: json['timeframe'],
      factors: List<String>.from(json['factors']),
      recommendation: json['recommendation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'predictedPrice': predictedPrice,
      'confidence': confidence,
      'timeframe': timeframe,
      'factors': factors,
      'recommendation': recommendation,
    };
  }
}

class MarketInsight {
  final String id;
  final String title;
  final String description;
  final String category; // 'price', 'demand', 'supply', 'weather', 'policy'
  final String severity; // 'low', 'medium', 'high'
  final DateTime publishedAt;
  final List<String> affectedCrops;

  MarketInsight({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.severity,
    required this.publishedAt,
    required this.affectedCrops,
  });

  factory MarketInsight.fromJson(Map<String, dynamic> json) {
    return MarketInsight(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      severity: json['severity'],
      publishedAt: DateTime.parse(json['publishedAt']),
      affectedCrops: List<String>.from(json['affectedCrops']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'severity': severity,
      'publishedAt': publishedAt.toIso8601String(),
      'affectedCrops': affectedCrops,
    };
  }
}

enum AnalysisTimeframe {
  oneWeek,
  oneMonth,
  threeMonths,
  sixMonths,
  oneYear,
}

enum MarketTrend {
  bullish,
  bearish,
  stable,
  volatile,
}
