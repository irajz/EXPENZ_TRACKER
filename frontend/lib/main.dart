// import 'package:flutter/material.dart';
// import 'package:frontend/providers/auth_provider.dart';
// import 'package:frontend/providers/onboarding_provider.dart';
// import 'package:frontend/screens/auth_screen.dart';
// import 'package:frontend/screens/home_screen.dart';
// import 'package:frontend/screens/onboarding_screen.dart';
// import 'package:frontend/screens/splash_screen.dart';
// // import 'package:frontend/screens/splash_screen.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => OnboardingProvider()),
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final router = GoRouter(
//       initialLocation: '/',
//       routes: [
//         GoRoute(
//           path: '/',
//           builder: (context, state) => SplashScreen(),
//         ),
//         GoRoute(
//           path: '/onboarding',
//           builder: (context, state) => OnboardingScreen(),
//         ),
//         GoRoute(
//             path: '/auth',
//             builder: (context, state) {
//               return AuthScreen(
//                 mode: state.uri.queryParameters['mode'] == 'register'
//                     ? FormMode.register
//                     : FormMode.login,
//               );
//             }),
//         GoRoute(
//           path: '/home',
//           builder: (context, state) => const HomeScreen(),
//         ),
//         // Add other routes later
//       ],
//     );

//     return MaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       routerConfig: router,
//       title: 'Expenz Tracker',
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/onboarding_provider.dart';
import 'package:frontend/providers/transaction_provider.dart';
import 'package:provider/provider.dart';
import 'core/app_router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      title: 'Expenz Tracker',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
    );
  }
}
