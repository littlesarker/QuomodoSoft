import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdrahim/screens/bottom_nav_screen.dart';
import 'package:http/http.dart' as http;
import 'bloc/filter/filter_bloc.dart';
import 'bloc/home/home_bloc.dart';
import 'bloc/home/home_event.dart';
import 'bloc/product_detail/product_detail_bloc.dart';
import 'bloc/products/product_bloc.dart';
import 'data/repositories/home_repository.dart';
import 'data/repositories/product_repository.dart';
import 'data/services/api_service.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => ApiService(client: http.Client()),
        ),
        RepositoryProvider(
          create: (context) => HomeRepository(
            apiService: RepositoryProvider.of<ApiService>(context),
          ),
        ),
        RepositoryProvider(
          create: (context) => ProductRepository(
            apiService: RepositoryProvider.of<ApiService>(context),
          ),
        ),

      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(
              repository: RepositoryProvider.of<HomeRepository>(context),
            )..add(LoadHomeData()),
          ),
          BlocProvider(
            create: (context) => ProductBloc(
              repository: RepositoryProvider.of<ProductRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => ProductDetailBloc(
              repository: RepositoryProvider.of<ProductRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => FilterBloc(),
          ),
        ],
        child: MaterialApp(
          title: 'E-Commerce App',
          theme: AppTheme.lightTheme,
          home: const BottomNavScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

// Theme configuration (same as before)
class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: TextStyle(fontSize: 12),
      unselectedLabelStyle: TextStyle(fontSize: 12),
      type: BottomNavigationBarType.fixed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    textTheme: const TextTheme(
      headline6: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyText1: TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
      bodyText2: TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}