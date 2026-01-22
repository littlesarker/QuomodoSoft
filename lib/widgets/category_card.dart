import 'package:flutter/material.dart';

import '../data/models/category_model.dart';



class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _getCategoryColor(category.name),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: category.image != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://mamunuiux.com/flutter_task/${category.image!}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      _getCategoryIcon(category.icon),
                      color: Colors.white,
                      size: 24,
                    ),
                  );
                },
              ),
            )
                : Center(
              child: Icon(
                _getCategoryIcon(category.icon),
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'mobile':
        return const Color(0xFF4CAF50);
      case 'gaming':
        return const Color(0xFF2196F3);
      case 'images':
        return const Color(0xFF9C27B0);
      case 'vehicles':
        return const Color(0xFFFF9800);
      case 'electronics':
        return const Color(0xFF607D8B);
      case 'game':
        return const Color(0xFF795548);
      case 'lifestyle':
        return const Color(0xFF00BCD4);
      case 'babies & toys':
        return const Color(0xFFE91E63);
      case 'bike':
        return const Color(0xFFFF5722);
      case "men's fasion":
        return const Color(0xFF3F51B5);
      case 'woman fashion':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF2196F3);
    }
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'fas fa-mobile-alt':
        return Icons.phone_android;
      case 'fas fa-gamepad':
        return Icons.sports_esports;
      case 'fas fa-image':
        return Icons.image;
      case 'fas fa-car':
        return Icons.directions_car;
      case 'fas fa-anchor':
        return Icons.devices;
      case 'fas fa-home':
        return Icons.home;
      case 'fas fa-basketball-ball':
        return Icons.sports_basketball;
      case 'fas fa-bicycle':
        return Icons.directions_bike;
      case 'fas fa-street-view':
        return Icons.man;
      case 'fab fa-android':
        return Icons.woman;
      default:
        return Icons.category;
    }
  }
}