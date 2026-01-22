import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/product_detail/product_detail_bloc.dart';
import '../bloc/product_detail/product_detail_event.dart';
import '../bloc/product_detail/product_detail_state.dart';
import '../data/models/product_model.dart';
import '../data/repositories/product_repository.dart';
import '../widgets/product_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedColorIndex = 0;
  int _selectedStorageIndex = 0;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    // Load product details using slug
    context.read<ProductDetailBloc>().add(
      LoadProductDetail(widget.product.slug),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                // App Bar with back button
                SliverAppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  expandedHeight: 300,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildProductImage(state),
                  ),
                ),
                // Product Details
                SliverToBoxAdapter(
                  child: state is ProductDetailLoading
                      ? _buildLoadingContent()
                      : state is ProductDetailError
                      ? _buildErrorContent(state.message)
                      : state is ProductDetailLoaded
                      ? _buildLoadedContent(state)
                      : _buildBasicContent(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductImage(ProductDetailState state) {
    // Use product from state if available, otherwise use widget product
    final product = state is ProductDetailLoaded
        ? state.productDetail.product
        : widget.product;

    // Get gallery images if available
    final galleryImages = state is ProductDetailLoaded
        ? state.productDetail.gallery
        : [];

    final totalImages = galleryImages.length + 1;

    return Stack(
      children: [
        Hero(
          tag: 'product-${product.id}',
          child: PageView.builder(
            itemCount: totalImages,
            itemBuilder: (context, index) {
              String imageUrl;
              if (index == 0) {
                imageUrl = product.fullImageUrl;
              } else if (index - 1 < galleryImages.length) {
                final galleryImage = galleryImages[index - 1];
                imageUrl = 'https://mamunuiux.com/flutter_task/${galleryImage.image}';
              } else {
                imageUrl = product.fullImageUrl;
              }

              return Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        // Image counter indicator
        if (totalImages > 1)
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '1/$totalImages',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        // New badge
        if (product.isNewProduct)
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'NEW',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skeleton for product name
          Container(
            width: double.infinity,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          // Skeleton for rating
          Row(
            children: List.generate(5, (index) {
              return Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          // Skeleton for price
          Container(
            width: 100,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 16),
          // Skeleton for description
          ...List.generate(3, (index) {
            return Container(
              width: double.infinity,
              height: 16,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildErrorContent(String message) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load product details',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ProductDetailBloc>().add(
                LoadProductDetail(widget.product.slug),
              );
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Text(
            widget.product.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // Rating
          Row(
            children: [
              ...List.generate(5, (index) {
                if (index < widget.product.averageRating.floor()) {
                  return const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 20,
                  );
                } else {
                  return const Icon(
                    Icons.star_border,
                    color: Colors.grey,
                    size: 20,
                  );
                }
              }),
              const SizedBox(width: 8),
              Text(
                '(${widget.product.totalSold} sold)',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Price
          Row(
            children: [
              Text(
                '\$${widget.product.offerPrice?.toStringAsFixed(0) ?? widget.product.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (widget.product.offerPrice != null &&
                  widget.product.offerPrice! < widget.product.price)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    '\$${widget.product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          // Add to Cart Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                _addToCart(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add To Cart',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedContent(ProductDetailLoaded state) {
    final product = state.productDetail.product;
    final features = state.productDetail.features;
    final longDescription = state.productDetail.longDescription;
    final relatedProducts = state.relatedProducts;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Rating and Reviews
          Row(
            children: [
              ...List.generate(5, (index) {
                if (index < product.averageRating.floor()) {
                  return const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 20,
                  );
                } else if (index == product.averageRating.floor() &&
                    product.averageRating % 1 >= 0.5) {
                  return const Icon(
                    Icons.star_half,
                    color: Colors.amber,
                    size: 20,
                  );
                } else {
                  return const Icon(
                    Icons.star_border,
                    color: Colors.grey,
                    size: 20,
                  );
                }
              }),
              const SizedBox(width: 8),
              Text(
                '(${product.totalSold} sold)',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Price
          Row(
            children: [
              Text(
                '\$${product.offerPrice?.toStringAsFixed(0) ?? product.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (product.offerPrice != null &&
                  product.offerPrice! < product.price)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Text(
                        '${product.discountPercentage.toInt()}% OFF',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Color Options
          const Text(
            'Color:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                final colors = [
                  Colors.black,
                  Colors.blue,
                  Colors.white,
                ];
                final colorNames = ['Black', 'Blue', 'White'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColorIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _selectedColorIndex == index
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _selectedColorIndex == index
                            ? Colors.blue
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: colors[index],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          colorNames[index],
                          style: TextStyle(
                            color: _selectedColorIndex == index
                                ? Colors.blue
                                : Colors.black,
                            fontWeight: _selectedColorIndex == index
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Storage Options
          const Text(
            'Storage:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                final storageOptions = ['128GB', '256GB', '512GB'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStorageIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _selectedStorageIndex == index
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _selectedStorageIndex == index
                            ? Colors.blue
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      storageOptions[index],
                      style: TextStyle(
                        color: _selectedStorageIndex == index
                            ? Colors.blue
                            : Colors.black,
                        fontWeight: _selectedStorageIndex == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Quantity Selector
          const Text(
            'Quantity:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {
                    if (_quantity > 1) {
                      setState(() {
                        _quantity--;
                      });
                    }
                  },
                  icon: const Icon(Icons.remove, size: 20),
                  padding: EdgeInsets.zero,
                ),
              ),
              Container(
                width: 60,
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  _quantity.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _quantity++;
                    });
                  },
                  icon: const Icon(Icons.add, size: 20),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Description
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            longDescription?.isNotEmpty == true
                ? _stripHtmlTags(longDescription!)
                : 'No description available.',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Features
          if (features.isNotEmpty) ...[
            const Text(
              'Features:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features.map((feature) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Add to Cart Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                _addToCart(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add To Cart',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Related Products
          if (relatedProducts.isNotEmpty) ...[
            const Text(
              'Related Products',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: relatedProducts.length,
                itemBuilder: (context, index) {
                  final relatedProduct = relatedProducts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => ProductDetailBloc(
                              repository: context.read<ProductRepository>(),
                            ),
                            child: ProductDetailScreen(
                              product: relatedProduct,
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 180,
                      margin: const EdgeInsets.only(right: 16),
                      child: ProductCard(product: relatedProduct),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Helper method to strip HTML tags from description
  String _stripHtmlTags(String htmlText) {
    final regex = RegExp(r'<[^>]*>');
    return htmlText.replaceAll(regex, '');
  }

  void _addToCart(BuildContext context) {
    // Get selected color and storage
    final colors = ['Black', 'Blue', 'White'];
    final storageOptions = ['128GB', '256GB', '512GB'];

    final selectedColor = colors[_selectedColorIndex];
    final selectedStorage = storageOptions[_selectedStorageIndex];

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added $_quantity ${widget.product.name} ($selectedColor, $selectedStorage) to cart!',
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // TODO: Implement actual cart logic
    // You would typically dispatch an event to your CartBloc here
  }
}