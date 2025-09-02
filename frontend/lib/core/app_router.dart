// import 'package:go_router/go_router.dart';
// import '../screens/splash_screen.dart';
// import '../screens/onboarding_screen.dart';
// import '../screens/auth_screen.dart';
// import '../screens/home_screen.dart';

// final GoRouter appRouter = GoRouter(
//   initialLocation: '/',
//   routes: [
//     GoRoute(
//       path: '/',
//       builder: (context, state) => SplashScreen(),
//     ),
//     GoRoute(
//       path: '/onboarding',
//       builder: (context, state) => OnboardingScreen(),
//     ),
//     GoRoute(
//       path: '/auth',
//       builder: (context, state) {
//         return AuthScreen(
//           mode: state.uri.queryParameters['mode'] == 'register'
//               ? FormMode.register
//               : FormMode.login,
//         );
//       },
//     ),
//     GoRoute(
//       path: '/home',
//       builder: (context, state) => const HomeScreen(),
//     ),
//   ],
// );

// lib/core/app_router.dart
// import 'package:flutter/material.dart';
import 'package:frontend/screens/add_transaction_screen.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
// import '../screens/transaction_screen.dart';
// import '../screens/budget_screen.dart';
import '../widgets/bottom_nav_bar.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        // return Scaffold(
        //   body: child,
        //   bottomNavigationBar: const CustomBottomNavBar(),
        // );
        return CustomBottomNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        // GoRoute(
        //   path: '/transaction',
        //   name: 'transaction',
        //   builder: (context, state) => const TransactionScreen(),
        // ),
        // GoRoute(
        //   path: '/budget',
        //   name: 'budget',
        //   builder: (context, state) => const BudgetScreen(),
        // ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/add',
          builder: (context, state) => const AddTransactionScreen(),
        ),
      ],
    ),
  ],
);
