import 'package:flutter/material.dart';

class OnboardingDots extends StatelessWidget {
  final int count;
  final int currentIndex;

  const OnboardingDots({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  Widget _dot(bool active) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 6),
      width: active ? 16 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? Color(0xFF6F43FF) : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) => _dot(index == currentIndex)),
    );
  }
}
