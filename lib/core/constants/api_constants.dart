class ApiConstants {
  static const String baseUrl = 'https://mamunuiux.com/flutter_task/api';

  static const String homeData = '$baseUrl';
  static const String productList = '$baseUrl/product';
  static String productDetail(String slug) => '$baseUrl/product/$slug';
  static String productsByCategory(int categoryId) =>
      '$baseUrl/product-by-category/$categoryId';
}