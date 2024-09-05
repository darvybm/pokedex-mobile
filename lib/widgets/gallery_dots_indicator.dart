import 'package:flutter/material.dart';

class CustomDotsIndicator extends StatelessWidget {
  final int dotsCount;
  final int activeIndex;
  final Widget activeDot;
  final Widget inactiveDot;
  final double spacing;

  const CustomDotsIndicator({super.key,
    required this.dotsCount,
    required this.activeIndex,
    required this.activeDot,
    required this.inactiveDot,
    this.spacing = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> dots = List.generate(dotsCount, (index) {
      return Container(
        margin: EdgeInsets.only(right: spacing),
        child: index == activeIndex ? activeDot : inactiveDot,
      );
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: dots,
    );
  }
}
