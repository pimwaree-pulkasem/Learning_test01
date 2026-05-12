import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'auth_gate.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const AuthGate(child: DashboardScreen()),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LearnLab',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      routerConfig: _router,
    );
  }
}
