import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final double size;

  const Loading({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const FlareActor(
        'assets/animations/loading_circle.flr',
        animation: 'load',
        snapToEnd: true,
      ),
    );
  }
}
