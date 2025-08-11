import 'package:flutter/material.dart';
import 'package:frontend/providers/onboarding_provider.dart';
import 'package:frontend/screens/onboarding_screen.dart';
import 'package:frontend/screens/splash_screen.dart';
// import 'package:frontend/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => SplashScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => OnboardingScreen(),
        )
        // Add other routes later
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Expenz Tracker',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
    );
  }
}
