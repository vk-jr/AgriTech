import 'package:flutter/foundation.dart';
import '../../../core/models/market_model.dart';

class MarketProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<CartItem> _cartItems = [];
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;
  ProductCategory? _selectedCategory;
  String _searchQuery = '';
  SortOption _sortOption = SortOption.newest;

  // Getters
  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _products;
  List<CartItem> get cartItems => _cartItems;
  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ProductCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  SortOption get sortOption => _sortOption;

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
        imageUrls: ['https://example.com/tomato1.jpg', 'https://example.com/tomato2.jpg'],
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
        imageUrls: ['https://example.com/lettuce1.jpg'],
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
        imageUrls: ['https://example.com/mango1.jpg', 'https://example.com/mango2.jpg'],
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
        imageUrls: ['https://example.com/rice1.jpg'],
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
        imageUrls: ['https://example.com/mint1.jpg'],
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
  }
}

enum SortOption {
  newest,
  priceLowToHigh,
  priceHighToLow,
  rating,
  popularity,
}
