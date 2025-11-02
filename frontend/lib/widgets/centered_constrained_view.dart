import 'package:flutter/material.dart';

class CenteredConstrainedView extends StatelessWidget {
  final Widget child;
  const CenteredConstrainedView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: child,
      ),
    );
  }
}