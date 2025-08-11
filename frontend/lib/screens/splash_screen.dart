// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Spacer(),
//             // Logo
//             Image.asset(
//               'assets/onboarding_images/main.png',
//               height: 120,
//             ),
//             const SizedBox(height: 20),

//             const Spacer(),
//             // Next Button
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               // child: SizedBox(
//               //   width: double.infinity,
//               //   height: 50,
//               child: ElevatedButton(
//                 onPressed: () {
//                   context.go('/onboarding');
//                 },
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: Size(double.infinity, 48),
//                   backgroundColor: Color(0xFF6F43FF),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24),
//                   ),
//                 ),
//                 child: const Text(
//                   'Next',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top content section (same flex as onboarding)
            Expanded(
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/onboarding_images/main.png',
                    width: MediaQuery.of(context).size.width *
                        0.8, // 80% of screen width
                    height: MediaQuery.of(context).size.height *
                        0.35, // 35% of screen height
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

            // Keep the bottom structure same as Onboarding
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () {
                  context.go('/onboarding');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: const Color(0xFF6F43FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
