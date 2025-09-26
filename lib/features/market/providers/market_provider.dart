import 'package:flutter/foundation.dart';
import '../../../core/models/market_model.dart';
import '../../../core/models/market_analysis_model.dart';

class MarketProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<CartItem> _cartItems = [];
  List<Order> _orders = [];
  List<MarketAnalysis> _marketAnalysis = [];
  List<MarketInsight> _marketInsights = [];
  bool _isLoading = false;
  bool _isAnalysisLoading = false;
  String? _errorMessage;
  ProductCategory? _selectedCategory;
  String _searchQuery = '';
  SortOption _sortOption = SortOption.newest;
  AnalysisTimeframe _selectedTimeframe = AnalysisTimeframe.oneMonth;

  // Getters
  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _products;
  List<CartItem> get cartItems => _cartItems;
  List<Order> get orders => _orders;
  List<MarketAnalysis> get marketAnalysis => _marketAnalysis;
  List<MarketInsight> get marketInsights => _marketInsights;
  bool get isLoading => _isLoading;
  bool get isAnalysisLoading => _isAnalysisLoading;
  String? get errorMessage => _errorMessage;
  ProductCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  SortOption get sortOption => _sortOption;
  AnalysisTimeframe get selectedTimeframe => _selectedTimeframe;

  int get cartItemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get cartTotal => _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  MarketProvider() {
    _initializeMockData();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> loadProducts() async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // In a real app, this would fetch from an API
      _initializeMockData();
      _applyFilters();
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load products: $e');
      _setLoading(false);
    }
  }

  void searchProducts(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void filterByCategory(ProductCategory? category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void sortProducts(SortOption option) {
    _sortOption = option;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredProducts = List.from(_products);

    // Apply category filter
    if (_selectedCategory != null) {
      _filteredProducts = _filteredProducts
          .where((product) => product.category == _selectedCategory)
          .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      _filteredProducts = _filteredProducts
          .where((product) =>
              product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              product.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              product.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase())))
          .toList();
    }

    // Apply sorting
    switch (_sortOption) {
      case SortOption.newest:
        _filteredProducts.sort((a, b) => b.harvestDate.compareTo(a.harvestDate));
        break;
      case SortOption.priceLowToHigh:
        _filteredProducts.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
        break;
      case SortOption.priceHighToLow:
        _filteredProducts.sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
        break;
      case SortOption.rating:
        _filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.popularity:
        _filteredProducts.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
    }
  }

  void addToCart(Product product, int quantity) {
    final existingItemIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex >= 0) {
      // Update existing item
      final existingItem = _cartItems[existingItemIndex];
      _cartItems[existingItemIndex] = CartItem(
        id: existingItem.id,
        product: product,
        quantity: existingItem.quantity + quantity,
        addedAt: existingItem.addedAt,
        notes: existingItem.notes,
      );
    } else {
      // Add new item
      _cartItems.add(CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        product: product,
        quantity: quantity,
        addedAt: DateTime.now(),
      ));
    }

    notifyListeners();
  }

  void removeFromCart(String cartItemId) {
    _cartItems.removeWhere((item) => item.id == cartItemId);
    notifyListeners();
  }

  void updateCartItemQuantity(String cartItemId, int quantity) {
    final itemIndex = _cartItems.indexWhere((item) => item.id == cartItemId);
    if (itemIndex >= 0) {
      if (quantity <= 0) {
        _cartItems.removeAt(itemIndex);
      } else {
        final item = _cartItems[itemIndex];
        _cartItems[itemIndex] = CartItem(
          id: item.id,
          product: item.product,
          quantity: quantity,
          addedAt: item.addedAt,
          notes: item.notes,
        );
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  Future<bool> placeOrder({
    required String deliveryAddress,
    String? deliveryInstructions,
    required PaymentMethod paymentMethod,
  }) async {
    if (_cartItems.isEmpty) return false;

    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        buyerId: 'current_user_id', // In real app, get from auth
        buyerName: 'Current User', // In real app, get from auth
        items: List.from(_cartItems),
        totalAmount: cartTotal,
        deliveryFee: 50.0, // Calculate based on location
        orderDate: DateTime.now(),
        deliveryAddress: deliveryAddress,
        deliveryInstructions: deliveryInstructions,
        paymentMethod: paymentMethod,
        updates: [
          OrderUpdate(
            id: '1',
            status: OrderStatus.pending,
            message: 'Order placed successfully',
            timestamp: DateTime.now(),
          ),
        ],
      );

      _orders.insert(0, order);
      _cartItems.clear();
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to place order: $e');
      _setLoading(false);
      return false;
    }
  }

  Product? getProductById(String productId) {
    try {
      return _products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  void _initializeMockData() {
    _products = [
      Product(
        id: '1',
        name: 'Fresh Tomatoes',
        description: 'Organic red tomatoes, freshly harvested from our farm. Perfect for salads and cooking.',
        price: 80.0,
        unit: 'kg',
        category: ProductCategory.vegetables,
        sellerId: 'seller1',
        sellerName: 'Green Valley Farm',
        sellerLocation: 'Pune, Maharashtra',
        imageUrls: ['https://images.unsplash.com/photo-1546470427-e26264be0b0d?w=400&h=300&fit=crop', 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400&h=300&fit=crop'],
        rating: 4.5,
        reviewCount: 23,
        stockQuantity: 50,
        isOrganic: true,
        harvestDate: DateTime.now().subtract(const Duration(days: 1)),
        expiryDate: DateTime.now().add(const Duration(days: 5)),
        tags: ['fresh', 'organic', 'local'],
        discount: 10.0,
      ),
      Product(
        id: '2',
        name: 'Fresh Lettuce',
        description: 'Crisp and fresh lettuce leaves, perfect for salads and sandwiches.',
        price: 60.0,
        unit: 'bunch',
        category: ProductCategory.vegetables,
        sellerId: 'seller2',
        sellerName: 'Organic Greens',
        sellerLocation: 'Nashik, Maharashtra',
        imageUrls: ['https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=400&h=300&fit=crop'],
        rating: 4.2,
        reviewCount: 15,
        stockQuantity: 30,
        isOrganic: true,
        harvestDate: DateTime.now().subtract(const Duration(hours: 12)),
        expiryDate: DateTime.now().add(const Duration(days: 3)),
        tags: ['fresh', 'organic', 'leafy'],
      ),
      Product(
        id: '3',
        name: 'Sweet Mangoes',
        description: 'Alphonso mangoes from Ratnagiri. Sweet and juicy, perfect for the season.',
        price: 200.0,
        unit: 'dozen',
        category: ProductCategory.fruits,
        sellerId: 'seller3',
        sellerName: 'Mango Paradise',
        sellerLocation: 'Ratnagiri, Maharashtra',
        imageUrls: ['https://images.unsplash.com/photo-1553279768-865429fa0078?w=400&h=300&fit=crop', 'https://images.unsplash.com/photo-1601493700631-2b16ec4b4716?w=400&h=300&fit=crop'],
        rating: 4.8,
        reviewCount: 45,
        stockQuantity: 20,
        isOrganic: false,
        harvestDate: DateTime.now().subtract(const Duration(days: 2)),
        expiryDate: DateTime.now().add(const Duration(days: 7)),
        tags: ['sweet', 'seasonal', 'alphonso'],
        discount: 5.0,
      ),
      Product(
        id: '4',
        name: 'Basmati Rice',
        description: 'Premium quality basmati rice, aged for perfect aroma and taste.',
        price: 120.0,
        unit: 'kg',
        category: ProductCategory.grains,
        sellerId: 'seller4',
        sellerName: 'Golden Grains',
        sellerLocation: 'Delhi',
        imageUrls: ['https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&h=300&fit=crop'],
        rating: 4.3,
        reviewCount: 67,
        stockQuantity: 100,
        isOrganic: false,
        harvestDate: DateTime.now().subtract(const Duration(days: 30)),
        expiryDate: DateTime.now().add(const Duration(days: 365)),
        tags: ['premium', 'aged', 'aromatic'],
      ),
      Product(
        id: '5',
        name: 'Fresh Mint',
        description: 'Aromatic fresh mint leaves, perfect for teas, garnishing, and cooking.',
        price: 20.0,
        unit: 'bunch',
        category: ProductCategory.herbs,
        sellerId: 'seller5',
        sellerName: 'Herb Garden',
        sellerLocation: 'Bangalore, Karnataka',
        imageUrls: ['https://images.unsplash.com/photo-1628556270448-4d4e4148e1b1?w=400&h=300&fit=crop'],
        rating: 4.6,
        reviewCount: 12,
        stockQuantity: 25,
        isOrganic: true,
        harvestDate: DateTime.now().subtract(const Duration(hours: 6)),
        expiryDate: DateTime.now().add(const Duration(days: 2)),
        tags: ['aromatic', 'fresh', 'organic'],
      ),
    ];

    _filteredProducts = List.from(_products);
    _initializeMarketAnalysisData();
  }

  void _initializeMarketAnalysisData() {
    _marketAnalysis = [
      MarketAnalysis(
        id: '1',
        cropName: 'Tomato',
        currentPrice: 45.0,
        previousPrice: 42.0,
        priceChange: 3.0,
        priceChangePercentage: 7.14,
        trend: 'up',
        demand: 85.0,
        supply: 78.0,
        season: 'Peak',
        priceHistory: _generatePriceHistory('Tomato', 45.0),
        forecast: MarketForecast(
          predictedPrice: 48.0,
          confidence: 0.82,
          timeframe: '1week',
          factors: ['High demand', 'Weather conditions', 'Festival season'],
          recommendation: 'hold',
        ),
        majorMarkets: ['Mumbai', 'Delhi', 'Bangalore'],
        qualityGrade: 'Grade A',
        lastUpdated: DateTime.now(),
      ),
      MarketAnalysis(
        id: '2',
        cropName: 'Rice',
        currentPrice: 120.0,
        previousPrice: 125.0,
        priceChange: -5.0,
        priceChangePercentage: -4.0,
        trend: 'down',
        demand: 70.0,
        supply: 85.0,
        season: 'Off-season',
        priceHistory: _generatePriceHistory('Rice', 120.0),
        forecast: MarketForecast(
          predictedPrice: 115.0,
          confidence: 0.75,
          timeframe: '1month',
          factors: ['Excess supply', 'Import policies', 'Storage costs'],
          recommendation: 'sell',
        ),
        majorMarkets: ['Delhi', 'Kolkata', 'Chennai'],
        qualityGrade: 'Premium',
        lastUpdated: DateTime.now(),
      ),
      MarketAnalysis(
        id: '3',
        cropName: 'Wheat',
        currentPrice: 28.0,
        previousPrice: 28.0,
        priceChange: 0.0,
        priceChangePercentage: 0.0,
        trend: 'stable',
        demand: 75.0,
        supply: 75.0,
        season: 'Regular',
        priceHistory: _generatePriceHistory('Wheat', 28.0),
        forecast: MarketForecast(
          predictedPrice: 29.0,
          confidence: 0.68,
          timeframe: '3months',
          factors: ['Stable demand', 'Government policies', 'Export trends'],
          recommendation: 'hold',
        ),
        majorMarkets: ['Punjab', 'Haryana', 'UP'],
        qualityGrade: 'Grade A',
        lastUpdated: DateTime.now(),
      ),
    ];

    _marketInsights = [
      MarketInsight(
        id: '1',
        title: 'Tomato Prices Expected to Rise',
        description: 'Due to recent weather conditions and increased demand during festival season, tomato prices are expected to increase by 10-15% in the coming weeks.',
        category: 'price',
        severity: 'medium',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        affectedCrops: ['Tomato', 'Onion'],
      ),
      MarketInsight(
        id: '2',
        title: 'Rice Export Policy Changes',
        description: 'New government policies on rice exports may affect domestic prices. Farmers are advised to monitor market trends closely.',
        category: 'policy',
        severity: 'high',
        publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
        affectedCrops: ['Rice', 'Basmati Rice'],
      ),
      MarketInsight(
        id: '3',
        title: 'Seasonal Demand for Vegetables',
        description: 'With the approaching winter season, demand for leafy vegetables and root crops is expected to increase significantly.',
        category: 'demand',
        severity: 'low',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        affectedCrops: ['Spinach', 'Carrot', 'Cabbage'],
      ),
    ];
  }

  List<PriceHistory> _generatePriceHistory(String crop, double currentPrice) {
    final List<PriceHistory> history = [];
    final random = DateTime.now().millisecond;
    
    for (int i = 30; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      final variation = (random % 10 - 5) / 100; // ±5% variation
      final price = currentPrice * (1 + variation);
      final volume = 100 + (random % 50); // Random volume
      
      history.add(PriceHistory(
        date: date,
        price: price,
        volume: volume.toDouble(),
      ));
    }
    
    return history;
  }

  // Market Analysis Methods
  Future<void> loadMarketAnalysis() async {
    _isAnalysisLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      // Data is already initialized in _initializeMarketAnalysisData
      _isAnalysisLoading = false;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load market analysis: $e');
      _isAnalysisLoading = false;
      notifyListeners();
    }
  }

  void updateTimeframe(AnalysisTimeframe timeframe) {
    _selectedTimeframe = timeframe;
    notifyListeners();
    // In a real app, this would trigger a new API call
    loadMarketAnalysis();
  }

  List<MarketAnalysis> getTopPerformers() {
    final sorted = List<MarketAnalysis>.from(_marketAnalysis);
    sorted.sort((a, b) => b.priceChangePercentage.compareTo(a.priceChangePercentage));
    return sorted.take(3).toList();
  }

  List<MarketAnalysis> getTopDecliners() {
    final sorted = List<MarketAnalysis>.from(_marketAnalysis);
    sorted.sort((a, b) => a.priceChangePercentage.compareTo(b.priceChangePercentage));
    return sorted.take(3).toList();
  }

  List<MarketInsight> getHighPriorityInsights() {
    return _marketInsights.where((insight) => insight.severity == 'high').toList();
  }
}

enum SortOption {
  newest,
  priceLowToHigh,
  priceHighToLow,
  rating,
  popularity,
}
