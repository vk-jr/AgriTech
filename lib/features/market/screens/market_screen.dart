import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../providers/market_provider.dart';
import '../../../core/models/market_model.dart';
import '../../../core/models/market_analysis_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketProvider>().loadProducts();
      context.read<MarketProvider>().loadMarketAnalysis();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.market),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        actions: [
          Consumer<MarketProvider>(
            builder: (context, provider, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () => _showCartBottomSheet(context),
                  ),
                  if (provider.cartItemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${provider.cartItemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Products', icon: Icon(Icons.shopping_bag)),
            Tab(text: 'Market Analysis', icon: Icon(Icons.analytics)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProductsTab(),
          _buildMarketAnalysisTab(),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    return Consumer<MarketProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            _buildSearchAndFilters(context, provider),
            Expanded(
              child: provider.products.isEmpty
                  ? _buildEmptyState(context)
                  : _buildProductGrid(context, provider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMarketAnalysisTab() {
    return Consumer<MarketProvider>(
      builder: (context, provider, child) {
        if (provider.isAnalysisLoading && provider.marketAnalysis.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMarketOverview(context, provider),
              const SizedBox(height: 24),
              _buildTopPerformers(context, provider),
              const SizedBox(height: 24),
              _buildTopDecliners(context, provider),
              const SizedBox(height: 24),
              _buildMarketInsights(context, provider),
              const SizedBox(height: 24),
              _buildDetailedAnalysis(context, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilters(BuildContext context, MarketProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        provider.searchProducts('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: provider.searchProducts,
          ),
          const SizedBox(height: 16),
          
          // Category and Sort Filters
          Row(
            children: [
              Expanded(
                child: _buildCategoryFilter(context, provider),
              ),
              const SizedBox(width: 16),
              _buildSortFilter(context, provider),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context, MarketProvider provider) {
    return DropdownButtonFormField<ProductCategory?>(
      value: provider.selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Category',
        prefixIcon: Icon(Icons.category),
      ),
      items: [
        const DropdownMenuItem<ProductCategory?>(
          value: null,
          child: Text('All Categories'),
        ),
        ...ProductCategory.values.map((category) {
          return DropdownMenuItem<ProductCategory?>(
            value: category,
            child: Text(_getCategoryName(category)),
          );
        }),
      ],
      onChanged: provider.filterByCategory,
    );
  }

  Widget _buildSortFilter(BuildContext context, MarketProvider provider) {
    return PopupMenuButton<SortOption>(
      icon: const Icon(Icons.sort),
      onSelected: provider.sortProducts,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: SortOption.newest,
          child: Text('Newest First'),
        ),
        const PopupMenuItem(
          value: SortOption.priceLowToHigh,
          child: Text('Price: Low to High'),
        ),
        const PopupMenuItem(
          value: SortOption.priceHighToLow,
          child: Text('Price: High to Low'),
        ),
        const PopupMenuItem(
          value: SortOption.rating,
          child: Text('Highest Rated'),
        ),
        const PopupMenuItem(
          value: SortOption.popularity,
          child: Text('Most Popular'),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: CustomCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context, MarketProvider provider) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: provider.products.length,
      itemBuilder: (context, index) {
        final product = provider.products[index];
        return _buildProductCard(context, product, provider);
      },
    );
  }

  Widget _buildProductCard(BuildContext context, Product product, MarketProvider provider) {
    return CustomCard(
      onTap: () => context.go('/market/product/${product.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      _getCategoryIcon(product.category),
                      size: 48,
                      color: Colors.grey[400],
                    ),
                  ),
                  if (product.discount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${product.discount.toInt()}% OFF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (product.isOrganic)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'ORGANIC',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Product Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 2),
                  Flexible(
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 12),
                        const SizedBox(width: 2),
                        Text(
                          '${product.rating}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            '(${product.reviewCount})',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              fontSize: 10,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (product.discount > 0) ...[
                              Text(
                                '₹${product.price.toStringAsFixed(0)}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey[600],
                                  fontSize: 9,
                                ),
                              ),
                            ],
                            Flexible(
                              child: Text(
                                '₹${product.discountedPrice.toStringAsFixed(0)}/${product.unit}',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 11,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart, size: 16),
                        onPressed: () => _addToCart(context, product, provider),
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(28, 28),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context, Product product, MarketProvider provider) {
    provider.addToCart(product, 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => _showCartBottomSheet(context),
        ),
      ),
    );
  }

  void _showCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Consumer<MarketProvider>(
            builder: (context, provider, child) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Shopping Cart',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(),
                    if (provider.cartItems.isEmpty)
                      const Expanded(
                        child: Center(
                          child: Text('Your cart is empty'),
                        ),
                      )
                    else ...[
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: provider.cartItems.length,
                          itemBuilder: (context, index) {
                            final item = provider.cartItems[index];
                            return _buildCartItem(context, item, provider);
                          },
                        ),
                      ),
                      const Divider(),
                      _buildCartSummary(context, provider),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item, MarketProvider provider) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getCategoryIcon(item.product.category),
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '₹${item.product.discountedPrice.toStringAsFixed(0)}/${item.product.unit}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () => provider.updateCartItemQuantity(
                  item.id,
                  item.quantity - 1,
                ),
              ),
              Text('${item.quantity}'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => provider.updateCartItemQuantity(
                  item.id,
                  item.quantity + 1,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => provider.removeFromCart(item.id),
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context, MarketProvider provider) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: ₹${provider.cartTotal.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: 'Proceed to Checkout',
            onPressed: provider.cartItems.isNotEmpty
                ? () {
                    Navigator.pop(context);
                    _showCheckoutDialog(context);
                  }
                : null,
          ),
        ),
      ],
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    final addressController = TextEditingController();
    final instructionsController = TextEditingController();
    PaymentMethod selectedPayment = PaymentMethod.cash;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Delivery Address',
                  hintText: 'Enter your delivery address',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: instructionsController,
                decoration: const InputDecoration(
                  labelText: 'Delivery Instructions (Optional)',
                  hintText: 'Any special instructions',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PaymentMethod>(
                value: selectedPayment,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                ),
                items: PaymentMethod.values.map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(_getPaymentMethodName(method)),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedPayment = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (addressController.text.isNotEmpty) {
                Navigator.pop(context);
                final success = await context.read<MarketProvider>().placeOrder(
                  deliveryAddress: addressController.text,
                  deliveryInstructions: instructionsController.text.isNotEmpty
                      ? instructionsController.text
                      : null,
                  paymentMethod: selectedPayment,
                );
                
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order placed successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: const Text('Place Order'),
          ),
        ],
      ),
    );
  }

  String _getCategoryName(ProductCategory category) {
    switch (category) {
      case ProductCategory.vegetables:
        return 'Vegetables';
      case ProductCategory.fruits:
        return 'Fruits';
      case ProductCategory.grains:
        return 'Grains';
      case ProductCategory.herbs:
        return 'Herbs';
      case ProductCategory.dairy:
        return 'Dairy';
      case ProductCategory.meat:
        return 'Meat';
      case ProductCategory.seeds:
        return 'Seeds';
      case ProductCategory.tools:
        return 'Tools';
      case ProductCategory.fertilizers:
        return 'Fertilizers';
      case ProductCategory.equipment:
        return 'Equipment';
    }
  }

  IconData _getCategoryIcon(ProductCategory category) {
    switch (category) {
      case ProductCategory.vegetables:
        return Icons.eco;
      case ProductCategory.fruits:
        return Icons.apple;
      case ProductCategory.grains:
        return Icons.grain;
      case ProductCategory.herbs:
        return Icons.local_florist;
      case ProductCategory.dairy:
        return Icons.local_drink;
      case ProductCategory.meat:
        return Icons.set_meal;
      case ProductCategory.seeds:
        return Icons.scatter_plot;
      case ProductCategory.tools:
        return Icons.build;
      case ProductCategory.fertilizers:
        return Icons.science;
      case ProductCategory.equipment:
        return Icons.agriculture;
    }
  }

  String _getPaymentMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash on Delivery';
      case PaymentMethod.card:
        return 'Credit/Debit Card';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.netBanking:
        return 'Net Banking';
      case PaymentMethod.wallet:
        return 'Digital Wallet';
    }
  }

  // Market Analysis Widgets
  Widget _buildMarketOverview(BuildContext context, MarketProvider provider) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Market Overview',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<AnalysisTimeframe>(
                value: provider.selectedTimeframe,
                onChanged: (timeframe) {
                  if (timeframe != null) {
                    provider.updateTimeframe(timeframe);
                  }
                },
                items: AnalysisTimeframe.values.map((timeframe) {
                  return DropdownMenuItem(
                    value: timeframe,
                    child: Text(_getTimeframeName(timeframe)),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildOverviewCard(
                  'Total Crops',
                  '${provider.marketAnalysis.length}',
                  Icons.agriculture,
                  AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildOverviewCard(
                  'Avg Price Change',
                  '${_calculateAveragePriceChange(provider).toStringAsFixed(1)}%',
                  Icons.trending_up,
                  AppTheme.skyBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildOverviewCard(
                  'High Demand',
                  '${_getHighDemandCount(provider)}',
                  Icons.local_fire_department,
                  AppTheme.errorRed,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildOverviewCard(
                  'Market Insights',
                  '${provider.marketInsights.length}',
                  Icons.insights,
                  AppTheme.accentBrown,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTopPerformers(BuildContext context, MarketProvider provider) {
    final topPerformers = provider.getTopPerformers();
    
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(MdiIcons.trendingUp, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                'Top Performers',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...topPerformers.map((analysis) => _buildAnalysisItem(analysis, true)),
        ],
      ),
    );
  }

  Widget _buildTopDecliners(BuildContext context, MarketProvider provider) {
    final topDecliners = provider.getTopDecliners();
    
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(MdiIcons.trendingDown, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                'Top Decliners',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...topDecliners.map((analysis) => _buildAnalysisItem(analysis, false)),
        ],
      ),
    );
  }

  Widget _buildAnalysisItem(MarketAnalysis analysis, bool isPositive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (isPositive ? Colors.green : Colors.red).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  analysis.cropName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '₹${analysis.currentPrice.toStringAsFixed(0)}/kg',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isPositive ? '+' : ''}${analysis.priceChangePercentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '₹${analysis.priceChange.toStringAsFixed(0)}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarketInsights(BuildContext context, MarketProvider provider) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(MdiIcons.lightbulbOutline, color: AppTheme.earthYellow),
              const SizedBox(width: 8),
              Text(
                'Market Insights',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...provider.marketInsights.take(3).map((insight) => _buildInsightItem(insight)),
          if (provider.marketInsights.length > 3)
            TextButton(
              onPressed: () {
                // Navigate to full insights page
              },
              child: const Text('View All Insights'),
            ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(MarketInsight insight) {
    Color severityColor;
    IconData severityIcon;
    
    switch (insight.severity) {
      case 'high':
        severityColor = Colors.red;
        severityIcon = MdiIcons.alertCircle;
        break;
      case 'medium':
        severityColor = Colors.orange;
        severityIcon = MdiIcons.alert;
        break;
      default:
        severityColor = Colors.blue;
        severityIcon = MdiIcons.informationOutline;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: severityColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: severityColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(severityIcon, color: severityColor, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  insight.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                _formatTimeAgo(insight.publishedAt),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            insight.description,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
            ),
          ),
          if (insight.affectedCrops.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              children: insight.affectedCrops.take(3).map((crop) {
                return Chip(
                  label: Text(crop),
                  backgroundColor: severityColor.withOpacity(0.2),
                  labelStyle: TextStyle(
                    fontSize: 10,
                    color: severityColor,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailedAnalysis(BuildContext context, MarketProvider provider) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detailed Analysis',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...provider.marketAnalysis.map((analysis) => _buildDetailedAnalysisItem(analysis)),
        ],
      ),
    );
  }

  Widget _buildDetailedAnalysisItem(MarketAnalysis analysis) {
    return ExpansionTile(
      title: Text(analysis.cropName),
      subtitle: Text('₹${analysis.currentPrice.toStringAsFixed(0)}/kg'),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getTrendColor(analysis.trend).withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '${analysis.priceChangePercentage >= 0 ? '+' : ''}${analysis.priceChangePercentage.toStringAsFixed(1)}%',
          style: TextStyle(
            color: _getTrendColor(analysis.trend),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildAnalysisMetric('Demand', '${analysis.demand.toInt()}%'),
                  ),
                  Expanded(
                    child: _buildAnalysisMetric('Supply', '${analysis.supply.toInt()}%'),
                  ),
                  Expanded(
                    child: _buildAnalysisMetric('Season', analysis.season),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Forecast',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Predicted Price: ₹${analysis.forecast.predictedPrice.toStringAsFixed(0)}'),
                    Text('Confidence: ${(analysis.forecast.confidence * 100).toInt()}%'),
                    Text('Recommendation: ${analysis.forecast.recommendation.toUpperCase()}'),
                    const SizedBox(height: 8),
                    Text('Factors:', style: const TextStyle(fontWeight: FontWeight.w500)),
                    ...analysis.forecast.factors.map((factor) => Text('• $factor')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Helper methods
  String _getTimeframeName(AnalysisTimeframe timeframe) {
    switch (timeframe) {
      case AnalysisTimeframe.oneWeek:
        return '1 Week';
      case AnalysisTimeframe.oneMonth:
        return '1 Month';
      case AnalysisTimeframe.threeMonths:
        return '3 Months';
      case AnalysisTimeframe.sixMonths:
        return '6 Months';
      case AnalysisTimeframe.oneYear:
        return '1 Year';
    }
  }

  double _calculateAveragePriceChange(MarketProvider provider) {
    if (provider.marketAnalysis.isEmpty) return 0.0;
    final total = provider.marketAnalysis.fold(0.0, (sum, analysis) => sum + analysis.priceChangePercentage);
    return total / provider.marketAnalysis.length;
  }

  int _getHighDemandCount(MarketProvider provider) {
    return provider.marketAnalysis.where((analysis) => analysis.demand > 80).length;
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case 'up':
        return Colors.green;
      case 'down':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}
