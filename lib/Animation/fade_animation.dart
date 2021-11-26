import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeAnimation extends StatelessWidget {
  final int milliseconds;
  final Widget child;

  FadeAnimation(this.milliseconds, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity")
          .add(Duration(milliseconds: milliseconds), Tween(begin: 0.0, end: 1.0)),
      Track("translateY").add(
          Duration(milliseconds: milliseconds), Tween(begin: 30.0, end: 0.0),
          curve: Curves.easeOut)
    ]);

    return ControlledAnimation(
      delay: Duration(microseconds: (500 * 1.0).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child:Transform.translate(
                offset: Offset(0, animation["translateY"]),
                child: child,
            ),
      ),
    );
  }
}
