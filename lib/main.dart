import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // เพิ่ม Import superbase 5/12/2026
import 'core/constants.dart'; // เพิ่มการนำเข้า key ที่เก็บไว้จากไฟล์ constants.dart 5/12/2026
import 'auth_gate.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';

void main() 
  async { // เพิ่มการเชื่อมต่อกับ Supabase 5/12/2026
  WidgetsFlutterBinding.ensureInitialized(); 
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );
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
