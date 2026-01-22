import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import '../../screens/product_detail_screen.dart';
import '../../screens/product_list_screen.dart';
import '../../widgets/category_card.dart';
import '../../widgets/filter_chip_widget.dart';
import '../../widgets/filter_modal.dart';
import '../filter/filter_bloc.dart';
import '../filter/filter_event.dart';
import '../filter/filter_state.dart';
import '../product_detail/product_detail_bloc.dart';
import '../products/product_bloc.dart';
import 'home_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<CategoryModel> _categories = [];
  late List<ProductModel> _newArrivals = [];
  bool _isLoadingCategory = false;
  List<ProductModel>? _categoryProducts;

  @override
  void initState() {
    super.initState();
    // Load home data and reset filters on init
    context.read<HomeBloc>().add(LoadHomeData());
    context.read<FilterBloc>().add(ResetFilters());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: SizedBox(
          height: 40,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products',
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF9E9E9E),
                ),
                border: InputBorder.none,
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF9E9E9E),
                  size: 20,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

          // Update local state when data loads
          if (state is HomeLoaded) {
            _categories = state.categories;
            _newArrivals = state.newArrivals;
            _isLoadingCategory = false;
            _categoryProducts = null;
          }

          if (state is CategoryProductsLoading) {
            _isLoadingCategory = true;
          }

          if (state is CategoryProductsLoaded) {
            _categoryProducts = state.products;
            _isLoadingCategory = false;
          }
        },
        builder: (context, state) {
          if (state is HomeLoading && _categories.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          } else if (state is HomeError && _categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(LoadHomeData());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (_categoryProducts != null) {
            return _buildCategoryProducts(_categoryProducts!);
          } else {
            return _buildHomeContent();
          }
        },
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to all categories
                      },
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Categories Grid (2 rows, 4 columns)
                SizedBox(
                  height: 100,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: _categories.take(4).length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return CategoryCard(
                        category: category,
                        onTap: () {
                          context.read<HomeBloc>().add(
                            LoadCategoryProducts(category.id),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            color: Color(0xFFEEEEEE),
            thickness: 1,
            height: 32,
          ),

          // New Arrivals Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'New Arrivals',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                // Filter Bar Section
                BlocBuilder<FilterBloc, FilterState>(
                  builder: (context, filterState) {
                    return Column(
                      children: [
                        // Filter Chips Row
                        SizedBox(
                          height: 40,
                          child: Row(
                            children: [
                              Expanded(
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    // All Products Chip
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: FilterChipWidget(
                                        label: 'All',
                                        isSelected: filterState.categoryId == null,
                                        onTap: () {
                                          _applyCategoryFilter(context, null, _newArrivals);
                                        },
                                      ),
                                    ),
                                    // Category Chips
                                    ..._categories.take(4).map((category) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: FilterChipWidget(
                                          label: category.name,
                                          isSelected: filterState.categoryId == category.id,
                                          onTap: () {
                                            _applyCategoryFilter(context, category.id, _newArrivals);
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                              // Filter Button
                              IconButton(
                                onPressed: () {
                                  _showFilterModal(context, _categories);
                                },
                                icon: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.filter_list,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Active Filters Indicators
                        if (filterState.sortType != SortType.newest ||
                            filterState.minPrice != null ||
                            filterState.maxPrice != null ||
                            filterState.categoryId != null)
                          _buildActiveFilters(context, filterState, _newArrivals),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 8),

                // Products Grid with Filtering
                BlocBuilder<FilterBloc, FilterState>(
                  builder: (context, filterState) {
                    List<ProductModel> productsToShow = _newArrivals;

                    // Apply filters if any are active
                    if (filterState.filteredProducts.isNotEmpty) {
                      productsToShow = filterState.filteredProducts;
                    } else if (filterState.categoryId != null ||
                        filterState.minPrice != null ||
                        filterState.maxPrice != null ||
                        filterState.sortType != SortType.newest) {
                      // Manually filter products if filters are active but filteredProducts is empty
                      productsToShow = _applyFiltersManually(
                        _newArrivals,
                        filterState,
                      );
                    }

                    if (productsToShow.isEmpty) {
                      return _buildNoProductsFound();
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: productsToShow.length,
                      itemBuilder: (context, index) {
                        final product = productsToShow[index];
                        return _buildProductCard(product);
                      },
                    );
                  },
                ),

                // Show all products button
                if (_newArrivals.length > 4)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(
                                    value: context.read<ProductBloc>(),
                                  ),
                                  BlocProvider.value(
                                    value: context.read<FilterBloc>(),
                                  ),
                                ],
                                child: const ProductListScreen(),
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'View All Products',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          if (_isLoadingCategory)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters(BuildContext context, FilterState filterState, List<ProductModel> products) {
    List<Widget> activeFilterChips = [];

    // Add category filter chip if active
    if (filterState.categoryId != null) {
      activeFilterChips.add(
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    context.read<FilterBloc>().add(UpdateCategoryFilter(null));
                    context.read<FilterBloc>().add(ApplyFilters(products));
                  },
                  child: Icon(
                    Icons.close,
                    size: 14,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Add sort filter chip if not default
    if (filterState.sortType != SortType.newest) {
      activeFilterChips.add(
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sort: ${filterState.sortType.label}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    context.read<FilterBloc>().add(const UpdateSortType(SortType.newest));
                    context.read<FilterBloc>().add(ApplyFilters(products));
                  },
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Add price range filter chips
    if (filterState.minPrice != null) {
      activeFilterChips.add(
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Min: \$${filterState.minPrice!.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    context.read<FilterBloc>().add(const UpdateMinPrice(null));
                    context.read<FilterBloc>().add(ApplyFilters(products));
                  },
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (filterState.maxPrice != null) {
      activeFilterChips.add(
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Max: \$${filterState.maxPrice!.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    context.read<FilterBloc>().add(const UpdateMaxPrice(null));
                    context.read<FilterBloc>().add(ApplyFilters(products));
                  },
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Add clear all button if there are active filters
    if (activeFilterChips.isNotEmpty) {
      activeFilterChips.add(
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: GestureDetector(
            onTap: () {
              context.read<FilterBloc>().add(ResetFilters());
              context.read<FilterBloc>().add(ApplyFilters(products));
            },
            child: Text(
              'Clear all',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red[400],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    return Wrap(
      children: activeFilterChips,
    );
  }

  Widget _buildNoProductsFound() {
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildProductCard(ProductModel product) {
  //   return GestureDetector(
  //     onTap: () {
  //       // Navigate to product detail
  //     },
  //     child: Container(
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(12),
  //         color: Colors.white,
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.05),
  //             blurRadius: 8,
  //             offset: const Offset(0, 2),
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Product Image
  //           Container(
  //             height: 140,
  //             width: double.infinity,
  //             decoration: BoxDecoration(
  //               borderRadius: const BorderRadius.vertical(
  //                 top: Radius.circular(12),
  //               ),
  //               color: const Color(0xFFF5F5F5),
  //               image: DecorationImage(
  //                 image: NetworkImage(product.fullImageUrl),
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             child: product.isNewProduct
  //                 ? Align(
  //               alignment: Alignment.topLeft,
  //               child: Container(
  //                 margin: const EdgeInsets.all(8),
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 8,
  //                   vertical: 4,
  //                 ),
  //                 decoration: BoxDecoration(
  //                   color: Colors.red,
  //                   borderRadius: BorderRadius.circular(4),
  //                 ),
  //                 child: const Text(
  //                   'NEW',
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 10,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //             )
  //                 : null,
  //           ),
  //
  //           // Product Details
  //           Padding(
  //             padding: const EdgeInsets.all(12),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 // Rating Stars
  //                 Row(
  //                   children: List.generate(5, (index) {
  //                     if (index < product.averageRating.floor()) {
  //                       return const Icon(
  //                         Icons.star,
  //                         color: Colors.amber,
  //                         size: 16,
  //                       );
  //                     } else if (index == product.averageRating.floor() &&
  //                         product.averageRating % 1 >= 0.5) {
  //                       return const Icon(
  //                         Icons.star_half,
  //                         color: Colors.amber,
  //                         size: 16,
  //                       );
  //                     } else {
  //                       return const Icon(
  //                         Icons.star_border,
  //                         color: Colors.grey,
  //                         size: 16,
  //                       );
  //                     }
  //                   }),
  //                 ),
  //                 const SizedBox(height: 4),
  //
  //                 // Product Name
  //                 Text(
  //                   product.name,
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w600,
  //                     color: Colors.black87,
  //                     height: 1.3,
  //                   ),
  //                   maxLines: 2,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //                 const SizedBox(height: 8),
  //
  //                 // Price
  //                 Row(
  //                   children: [
  //                     Text(
  //                       '\$${product.offerPrice?.toStringAsFixed(0) ?? product.price.toStringAsFixed(0)}',
  //                       style: const TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                     if (product.offerPrice != null &&
  //                         product.offerPrice! < product.price)
  //                       Padding(
  //                         padding: const EdgeInsets.only(left: 8),
  //                         child: Text(
  //                           '\$${product.price.toStringAsFixed(0)}',
  //                           style: const TextStyle(
  //                             fontSize: 14,
  //                             color: Colors.grey,
  //                             decoration: TextDecoration.lineThrough,
  //                           ),
  //                         ),
  //                       ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget _buildProductCard(ProductModel product) {
    return GestureDetector(
      onTap: () {
        _navigateToProductDetail(context, product);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Hero animation
            Hero(
              tag: 'product-${product.id}',
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  color: const Color(0xFFF5F5F5),
                  image: DecorationImage(
                    image: NetworkImage(product.fullImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: product.isNewProduct
                    ? Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                    : null,
              ),
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating Stars
                  Row(
                    children: List.generate(5, (index) {
                      if (index < product.averageRating.floor()) {
                        return const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        );
                      } else if (index == product.averageRating.floor() &&
                          product.averageRating % 1 >= 0.5) {
                        return const Icon(
                          Icons.star_half,
                          color: Colors.amber,
                          size: 16,
                        );
                      } else {
                        return const Icon(
                          Icons.star_border,
                          color: Colors.grey,
                          size: 16,
                        );
                      }
                    }),
                  ),
                  const SizedBox(height: 4),

                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Row(
                    children: [
                      Text(
                        '\$${product.offerPrice?.toStringAsFixed(0) ?? product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      if (product.offerPrice != null &&
                          product.offerPrice! < product.price)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            '\$${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Add this helper method to HomeScreen class
  void _navigateToProductDetail(BuildContext context, ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ProductDetailBloc(
            repository: RepositoryProvider.of<ProductRepository>(context),
          ),
          child: ProductDetailScreen(product: product),
        ),
      ),
    );
  }
  Widget _buildCategoryProducts(List<ProductModel> products) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            context.read<HomeBloc>().add(LoadHomeData());
            context.read<FilterBloc>().add(ResetFilters());
          },
        ),
        title: const Text(
          'Category Products',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  // Helper Methods
  void _applyCategoryFilter(BuildContext context, int? categoryId, List<ProductModel> products) {
    context.read<FilterBloc>().add(UpdateCategoryFilter(categoryId));
    context.read<FilterBloc>().add(ApplyFilters(products));
  }

  void _showFilterModal(BuildContext context, List<CategoryModel> categories) {
    final currentFilterState = context.read<FilterBloc>().state;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: FilterModal(
            categories: categories,
            currentState: currentFilterState,
          ),
        );
      },
    ).then((_) {
      // Apply filters with current products after modal closes
      context.read<FilterBloc>().add(ApplyFilters(_newArrivals));
    });
  }

  List<ProductModel> _applyFiltersManually(
      List<ProductModel> products,
      FilterState filterState,
      ) {
    List<ProductModel> filteredProducts = List.from(products);

    // Apply category filter
    if (filterState.categoryId != null) {
      filteredProducts = filteredProducts
          .where((product) => product.categoryId == filterState.categoryId)
          .toList();
    }

    // Apply price filters
    if (filterState.minPrice != null && filterState.minPrice! > 0) {
      filteredProducts = filteredProducts
          .where((product) {
        final priceToCheck = product.offerPrice ?? product.price;
        return priceToCheck >= filterState.minPrice!;
      })
          .toList();
    }

    if (filterState.maxPrice != null && filterState.maxPrice! > 0) {
      filteredProducts = filteredProducts
          .where((product) {
        final priceToCheck = product.offerPrice ?? product.price;
        return priceToCheck <= filterState.maxPrice!;
      })
          .toList();
    }

    // Apply sorting
    switch (filterState.sortType) {
      case SortType.priceLowToHigh:
        filteredProducts.sort((a, b) {
          final priceA = a.offerPrice ?? a.price;
          final priceB = b.offerPrice ?? b.price;
          return priceA.compareTo(priceB);
        });
        break;
      case SortType.priceHighToLow:
        filteredProducts.sort((a, b) {
          final priceA = a.offerPrice ?? a.price;
          final priceB = b.offerPrice ?? b.price;
          return priceB.compareTo(priceA);
        });
        break;
      case SortType.topRated:
        filteredProducts.sort((a, b) => b.averageRating.compareTo(a.averageRating));
        break;
      case SortType.bestSelling:
        filteredProducts.sort((a, b) => b.totalSold.compareTo(a.totalSold));
        break;
      case SortType.newest:
      default:
      // Keep original order
        break;
    }

    return filteredProducts;
  }
}


