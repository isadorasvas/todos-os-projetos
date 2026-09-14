import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/add_product_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const NavegacaoApp());
}

class NavegacaoApp extends StatelessWidget {
  const NavegacaoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Navegação',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),

      initialRoute: '/',

      routes: {
        '/': (context) => const HomeScreen(),
        '/detalhes': (context) => const DetailScreen(),
        '/adicionar': (context) => const AddProductScreen(),
        '/configuracoes': (context) => const SettingsScreen(),
      },
    );
  }
}