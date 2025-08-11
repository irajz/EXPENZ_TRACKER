import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_page.dart';
import '../widgets/onboarding_dots.dart';

class OnboardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/onboarding_images/onboarding1.png',
      'title': 'Gain total control \n of your money',
      'subtitle': 'Become your own money manager \n and make every cent count',
    },
    {
      'image': 'assets/onboarding_images/onboarding2.png',
      'title': 'Know where your \n money goes',
      'subtitle':
          'Track your transaction easily, \n with categories and financial report',
    },
    {
      'image': 'assets/onboarding_images/onboarding3.png',
      'title': 'Planning ahead',
      'subtitle': 'Setup your budget for each category \n so you in control',
    },
  ];

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingProvider(),
      child: Consumer<OnboardingProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 8,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: pages.length,
                      onPageChanged: provider.setPage,
                      itemBuilder: (context, index) {
                        final page = pages[index];
                        return OnboardingPage(
                          imageAsset: page['image']!,
                          title: page['title']!,
                          subtitle: page['subtitle']!,
                        );
                      },
                    ),
                  ),
                  OnboardingDots(
                    count: pages.length,
                    currentIndex: provider.currentPage,
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      onPressed: () {
                        if (provider.currentPage < pages.length - 1) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          // TODO: Navigate to next screen (login/dashboard)
                        }
                      },
                      child: Text(
                        provider.currentPage < pages.length - 1
                            ? 'Next'
                            : 'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                        backgroundColor: Color(0xFF6F43FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
