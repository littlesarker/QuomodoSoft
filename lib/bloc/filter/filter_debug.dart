import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product_model.dart';
import 'filter_bloc.dart';
import 'filter_state.dart';


class FilterDebugWidget extends StatelessWidget {
  final List<ProductModel> products;

  const FilterDebugWidget({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Debug Info:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Total Products: ${products.length}'),
                Text('Filtered Products: ${state.filteredProducts.length}'),
                Text('Sort Type: ${state.sortType.label}'),
                Text('Min Price: ${state.minPrice ?? "Not set"}'),
                Text('Max Price: ${state.maxPrice ?? "Not set"}'),
                Text('Category ID: ${state.categoryId ?? "All"}'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    print('=== FILTER DEBUG ===');
                    print('Products count: ${products.length}');
                    print('Filtered count: ${state.filteredProducts.length}');
                    print('Sort: ${state.sortType}');
                    print('Min Price: ${state.minPrice}');
                    print('Max Price: ${state.maxPrice}');
                    print('Category ID: ${state.categoryId}');
                    print('====================');
                  },
                  child: const Text('Print Debug Info'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}