import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension BExt on BuildContext {
  bool get isDesktop => MediaQuery.of(this).size.width > 800;
}

Page<dynamic> noTransition(LocalKey key, Widget child) {
  return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          child);
}

Page<dynamic> pageTransition(LocalKey key, Widget child) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 120),
    reverseTransitionDuration: const Duration(milliseconds: 120),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        context.isDesktop
            ? child
            : MaterialPageTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child),
  );
}

class MaterialPageTransition extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const MaterialPageTransition({
    Key? key,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1, end: 1.08).animate(
        CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOut),
      ),
      child: FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOut),
          ),
          child: child,
        ),
      ),
    );
  }
}
