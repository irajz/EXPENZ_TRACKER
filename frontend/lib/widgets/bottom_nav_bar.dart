// // lib/widgets/bottom_nav_bar.dart
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class BottomNavBar extends StatelessWidget {
//   const BottomNavBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final String location = GoRouterState.of(context).uri.toString();

//     int currentIndex = 0;
//     if (location.startsWith('/home')) {
//       currentIndex = 0;
//     } else if (location.startsWith('/transaction')) {
//       currentIndex = 1;
//     } else if (location.startsWith('/budget')) {
//       currentIndex = 2;
//     } else if (location.startsWith('/profile')) {
//       currentIndex = 3;
//     }

//     return BottomNavigationBar(
//       currentIndex: currentIndex,
//       onTap: (index) {
//         switch (index) {
//           case 0:
//             context.go('/home');
//             break;
//           case 1:
//             context.go('/transaction');
//             break;
//           case 2:
//             context.go('/budget');
//             break;
//           case 3:
//             context.go('/profile');
//             break;
//         }
//       },
//       selectedItemColor: Colors.purple,
//       unselectedItemColor: Colors.grey,
//       type: BottomNavigationBarType.fixed,
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//         BottomNavigationBarItem(icon: Icon(Icons.list), label: "Transaction"),
//         BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: "Budget"),
//         BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//       ],
//     );
//   }
// }

// 2
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class CustomBottomNavBar extends StatelessWidget {
//   const CustomBottomNavBar({super.key, required this.child});
//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     final String location = GoRouterState.of(context).uri.toString();

//     int currentIndex = 0;
//     if (location.startsWith('/home')) {
//       currentIndex = 0;
//     } else if (location.startsWith('/transaction')) {
//       currentIndex = 1;
//     } else if (location.startsWith('/budget')) {
//       currentIndex = 3; // skip index 2 because of the FAB
//     } else if (location.startsWith('/profile')) {
//       currentIndex = 4;
//     }

//     return Scaffold(
//       body: child,
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Color.fromRGBO(127, 61, 255, 100),
//         onPressed: () {
//           // Navigate to add transaction or some "new action"
//           context.go('/add');
//         },
//         child: const Icon(Icons.add, size: 30),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: BottomAppBar(
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 8,
//         child: SizedBox(
//           height: 60,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildNavItem(
//                   context, Icons.home, "Home", '/home', currentIndex == 0),
//               _buildNavItem(context, Icons.list, "Transaction", '/transaction',
//                   currentIndex == 1),

//               const SizedBox(width: 48), // gap for FAB

//               _buildNavItem(context, Icons.pie_chart, "Budget", '/budget',
//                   currentIndex == 3),
//               _buildNavItem(context, Icons.person, "Profile", '/profile',
//                   currentIndex == 4),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(BuildContext context, IconData icon, String label,
//       String route, bool isActive) {
//     return GestureDetector(
//       onTap: () => context.go(route),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, color: isActive ? Colors.purple : Colors.grey),
//           Text(label,
//               style: TextStyle(
//                   color: isActive ? Colors.purple : Colors.grey, fontSize: 12)),
//         ],
//       ),
//     );
//   }
// }

// 3
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;
    if (location.startsWith('/home')) {
      currentIndex = 0;
    } else if (location.startsWith('/transaction')) {
      currentIndex = 1;
    } else if (location.startsWith('/add')) {
      currentIndex = 2;
    } else if (location.startsWith('/budget')) {
      currentIndex = 3;
    } else if (location.startsWith('/profile')) {
      currentIndex = 4;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 65,
          child: Row(
            children: [
              Expanded(
                child: _buildNavItem(
                    context, Icons.home, "Home", '/home', currentIndex == 0),
              ),
              Expanded(
                child: _buildNavItem(context, Icons.list, "Transaction",
                    '/transaction', currentIndex == 1),
              ),

              // Center "Add" button without label
              Expanded(
                child: GestureDetector(
                  onTap: () => context.go('/add'),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(127, 61, 255, 1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 22),
                  ),
                ),
              ),

              Expanded(
                child: _buildNavItem(context, Icons.pie_chart, "Budget",
                    '/budget', currentIndex == 3),
              ),
              Expanded(
                child: _buildNavItem(context, Icons.person, "Profile",
                    '/profile', currentIndex == 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label,
      String route, bool isActive) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? Colors.purple : Colors.grey, size: 24),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.purple : Colors.grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
