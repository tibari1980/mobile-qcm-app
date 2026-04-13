import 'package:flutter/material.dart';

class BackgroundParticles extends StatelessWidget {
  final Color? accentColor;
  const BackgroundParticles({super.key, this.accentColor});

  @override
  Widget build(BuildContext context) {
    // Nuclear Reset: Disabling particles completely to restore Web rendering
    return const SizedBox.shrink();
  }
}
