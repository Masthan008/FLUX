import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/accessibility_provider.dart';

class AccessibilityWrapper extends StatelessWidget {
  final Widget child;
  final String? semanticLabel;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final bool enableGestures;

  const AccessibilityWrapper({
    super.key,
    required this.child,
    this.semanticLabel,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.enableGestures = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AccessibilityProvider>(
      builder: (context, accessibilityProvider, _) {
        Widget wrappedChild = child;

        // Add semantic label if provided
        if (semanticLabel != null) {
          wrappedChild = Semantics(
            label: semanticLabel,
            child: wrappedChild,
          );
        }

        // Add gesture controls if enabled
        if (enableGestures && accessibilityProvider.gestureControlsEnabled) {
          wrappedChild = GestureDetector(
            onTap: () {
              if (onTap != null) {
                accessibilityProvider.provideFeedback(
                  text: semanticLabel,
                  haptic: true,
                );
                onTap!();
              }
            },
            onLongPress: () {
              if (onLongPress != null) {
                accessibilityProvider.provideFeedback(
                  text: semanticLabel != null ? '$semanticLabel options' : 'Options',
                  haptic: true,
                );
                onLongPress!();
              }
            },
            onDoubleTap: () {
              if (onDoubleTap != null) {
                accessibilityProvider.provideFeedback(
                  text: semanticLabel != null ? '$semanticLabel activated' : 'Activated',
                  haptic: true,
                );
                onDoubleTap!();
              }
            },
            child: wrappedChild,
          );
        }

        return wrappedChild;
      },
    );
  }
}

class AccessibleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  final ButtonStyle? style;

  const AccessibleButton({
    super.key,
    required this.child,
    this.onPressed,
    this.semanticLabel,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AccessibilityProvider>(
      builder: (context, accessibilityProvider, _) {
        return ElevatedButton(
          onPressed: onPressed != null
              ? () {
                  accessibilityProvider.provideFeedback(
                    text: semanticLabel ?? 'Button pressed',
                    haptic: true,
                  );
                  onPressed!();
                }
              : null,
          style: style,
          child: Semantics(
            label: semanticLabel,
            button: true,
            child: child,
          ),
        );
      },
    );
  }
}

class AccessibleCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const AccessibleCard({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
    this.color,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AccessibilityProvider>(
      builder: (context, accessibilityProvider, _) {
        return Card(
          color: color,
          margin: margin,
          child: InkWell(
            onTap: onTap != null
                ? () {
                    accessibilityProvider.provideFeedback(
                      text: semanticLabel ?? 'Card selected',
                      haptic: true,
                    );
                    onTap!();
                  }
                : null,
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16.0),
              child: Semantics(
                label: semanticLabel,
                button: onTap != null,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}

class SwipeGestureDetector extends StatelessWidget {
  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeUp;
  final VoidCallback? onSwipeDown;

  const SwipeGestureDetector({
    super.key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onSwipeUp,
    this.onSwipeDown,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AccessibilityProvider>(
      builder: (context, accessibilityProvider, _) {
        if (!accessibilityProvider.gestureControlsEnabled) {
          return child;
        }

        return GestureDetector(
          onPanEnd: (details) {
            final velocity = details.velocity.pixelsPerSecond;
            final dx = velocity.dx;
            final dy = velocity.dy;

            // Determine swipe direction based on velocity
            if (dx.abs() > dy.abs()) {
              // Horizontal swipe
              if (dx > 0 && onSwipeRight != null) {
                accessibilityProvider.provideFeedback(
                  text: 'Swiped right',
                  haptic: true,
                );
                onSwipeRight!();
              } else if (dx < 0 && onSwipeLeft != null) {
                accessibilityProvider.provideFeedback(
                  text: 'Swiped left',
                  haptic: true,
                );
                onSwipeLeft!();
              }
            } else {
              // Vertical swipe
              if (dy > 0 && onSwipeDown != null) {
                accessibilityProvider.provideFeedback(
                  text: 'Swiped down',
                  haptic: true,
                );
                onSwipeDown!();
              } else if (dy < 0 && onSwipeUp != null) {
                accessibilityProvider.provideFeedback(
                  text: 'Swiped up',
                  haptic: true,
                );
                onSwipeUp!();
              }
            }
          },
          child: child,
        );
      },
    );
  }
}