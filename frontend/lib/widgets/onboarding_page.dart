import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String subtitle;

  const OnboardingPage({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Image.asset(
              imageAsset,
              fit: BoxFit.contain,
              width: mq.size.width * 0.7,
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black, // purple accent
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
