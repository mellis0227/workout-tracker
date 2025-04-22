import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      context.go('/auth'); // Navigate to auth screen after splash
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6E0),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Image(
              image: AssetImage('assets/images/dumbbell_dashboard.png'),
              width: 150,
              height: 150,
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xFF124559)),
            ),
          ],
        ),
      ),
    );
  }
}
