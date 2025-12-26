import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/subscription_service.dart';

/// Visual badge showing user's subscription tier
class UserBadge extends StatelessWidget {
  final String tier;
  final bool compact;
  final bool animate;

  const UserBadge({
    super.key,
    required this.tier,
    this.compact = false,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final tierEnum = SubscriptionService.stringToTier(tier);
    
    Color color;
    String text;
    IconData icon;
    List<Color> gradientColors;

    switch (tierEnum) {
      case SubscriptionTier.ultra:
        color = Colors.purple;
        text = 'ULTRA';
        icon = Icons.diamond;
        gradientColors = [Colors.purple, Colors.deepPurple, Colors.purpleAccent];
        break;
      case SubscriptionTier.pro:
        color = Colors.amber;
        text = 'PRO';
        icon = Icons.star;
        gradientColors = [Colors.amber, Colors.orange, Colors.yellow];
        break;
      default:
        color = Colors.grey;
        text = 'FREE';
        icon = Icons.person;
        gradientColors = [Colors.grey.shade600, Colors.grey.shade700];
    }

    Widget badge = Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors.map((c) => c.withOpacity(0.3)).toList(),
        ),
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: compact ? 14 : 18),
          if (!compact) ...[
            const SizedBox(width: 5),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: compact ? 10 : 12,
                letterSpacing: 1,
              ),
            ),
          ],
        ],
      ),
    );

    if (animate && tierEnum != SubscriptionTier.free) {
      badge = badge
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .shimmer(
            duration: const Duration(seconds: 3),
            color: color.withOpacity(0.3),
          );
    }

    return badge;
  }
}

/// Large tier card for profile or subscription screen
class TierCard extends StatelessWidget {
  final SubscriptionTier tier;
  final bool isCurrentTier;
  final VoidCallback? onTap;

  const TierCard({
    super.key,
    required this.tier,
    this.isCurrentTier = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isCurrentTier ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              tier.color.withOpacity(0.2),
              tier.color.withOpacity(0.1),
            ],
          ),
          border: Border.all(
            color: isCurrentTier ? tier.color : tier.color.withOpacity(0.5),
            width: isCurrentTier ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isCurrentTier
              ? [
                  BoxShadow(
                    color: tier.color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(tier.icon, color: tier.color, size: 40),
            const SizedBox(height: 8),
            Text(
              tier.displayName,
              style: TextStyle(
                color: tier.color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              tier.price,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            if (isCurrentTier) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: tier.color.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'CURRENT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
