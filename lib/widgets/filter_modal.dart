import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/filter/filter_bloc.dart';
import '../bloc/filter/filter_event.dart';
import '../bloc/filter/filter_state.dart';
import '../data/models/category_model.dart';
import 'filter_chip_widget.dart';


class FilterModal extends StatefulWidget {
  final List<CategoryModel> categories;
  final FilterState currentState;

  const FilterModal({
    super.key,
    required this.categories,
    required this.currentState,
  });

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late SortType _selectedSortType;
  late double? _minPrice;
  late double? _maxPrice;
  late int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedSortType = widget.currentState.sortType;
    _minPrice = widget.currentState.minPrice;
    _maxPrice = widget.currentState.maxPrice;
    _selectedCategoryId = widget.currentState.categoryId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter & Sort',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Sort Options
          const Text(
            'Sort By',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: SortType.values.map((sortType) {
              return FilterChipWidget(
                label: sortType.label,
                isSelected: _selectedSortType == sortType,
                onTap: () {
                  setState(() {
                    _selectedSortType = sortType;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Price Range
          const Text(
            'Price Range',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Min Price',
                    prefixText: '\$',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _minPrice = double.tryParse(value);
                  },
                  controller: TextEditingController(
                    text: _minPrice?.toString() ?? '',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Max Price',
                    prefixText: '\$',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _maxPrice = double.tryParse(value);
                  },
                  controller: TextEditingController(
                    text: _maxPrice?.toString() ?? '',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Categories
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChipWidget(
                label: 'All',
                isSelected: _selectedCategoryId == null,
                onTap: () {
                  setState(() {
                    _selectedCategoryId = null;
                  });
                },
              ),
              ...widget.categories.map((category) {
                return FilterChipWidget(
                  label: category.name,
                  isSelected: _selectedCategoryId == category.id,
                  onTap: () {
                    setState(() {
                      _selectedCategoryId = category.id;
                    });
                  },
                );
              }).toList(),
            ],
          ),
          const SizedBox(height: 30),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.read<FilterBloc>().add(ResetFilters());
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Reset All'),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  // Apply all filters
                  context.read<FilterBloc>().add(
                    UpdateSortType(_selectedSortType),
                  );
                  context.read<FilterBloc>().add(
                    UpdateMinPrice(_minPrice),
                  );
                  context.read<FilterBloc>().add(
                    UpdateMaxPrice(_maxPrice),
                  );
                  context.read<FilterBloc>().add(
                    UpdateCategoryFilter(_selectedCategoryId),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}