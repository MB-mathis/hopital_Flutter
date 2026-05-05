import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
    initAuth();
  }

  Future<void> initAuth() async {
    final isLogged = await auth.isLoggedIn();

    if (!mounted) return;

    if (!isLogged) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final success = await auth.fetchMe();

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      await auth.logout(); // sécurité
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}