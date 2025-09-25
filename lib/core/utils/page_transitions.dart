import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom page transitions for smooth navigation
class PageTransitions {
  /// Slide transition from right to left (default forward navigation)
  static Page<T> slideFromRight<T extends Object?>(
    Widget child,
    GoRouterState state, {
    String? name,
    Object? arguments,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      name: name,
      arguments: arguments,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        var offsetAnimation = animation.drive(tween);

        // Add fade effect for smoother transition
        var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
          ),
        );

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }

  /// Slide transition from left to right (back navigation)
  static Page<T> slideFromLeft<T extends Object?>(
    Widget child,
    GoRouterState state, {
    String? name,
    Object? arguments,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      name: name,
      arguments: arguments,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        var offsetAnimation = animation.drive(tween);

        var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
          ),
        );

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }

  /// Slide transition from bottom to top (modal-like)
  static Page<T> slideFromBottom<T extends Object?>(
    Widget child,
    GoRouterState state, {
    String? name,
    Object? arguments,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      name: name,
      arguments: arguments,
      child: child,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        var offsetAnimation = animation.drive(tween);

        // Scale effect for more dynamic feel
        var scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
        );

        return SlideTransition(
          position: offsetAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        );
      },
    );
  }

  /// Fade transition with scale effect
  static Page<T> fadeWithScale<T extends Object?>(
    Widget child,
    GoRouterState state, {
    String? name,
    Object? arguments,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      name: name,
      arguments: arguments,
      child: child,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutQuart,
          ),
        );

        var scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        );
      },
    );
  }

  /// Smooth fade transition
  static Page<T> smoothFade<T extends Object?>(
    Widget child,
    GoRouterState state, {
    String? name,
    Object? arguments,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      name: name,
      arguments: arguments,
      child: child,
      transitionDuration: const Duration(milliseconds: 250),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      },
    );
  }

  /// Navigation-aware slide transition
  /// Determines direction based on navigation hierarchy
  static Page<T> navigationSlide<T extends Object?>(
    Widget child,
    GoRouterState state, {
    String? name,
    Object? arguments,
    bool isForward = true,
  }) {
    return isForward 
        ? slideFromRight(child, state, name: name, arguments: arguments)
        : slideFromLeft(child, state, name: name, arguments: arguments);
  }

  /// Hero-like transition for detailed views
  static Page<T> heroTransition<T extends Object?>(
    Widget child,
    GoRouterState state, {
    String? name,
    Object? arguments,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      name: name,
      arguments: arguments,
      child: child,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Combine slide and scale for hero-like effect
        var slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
        );

        var scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
        );

        var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
          ),
        );

        return SlideTransition(
          position: slideAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
