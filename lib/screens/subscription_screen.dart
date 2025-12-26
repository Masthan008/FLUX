import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/subscription_service.dart';
import '../services/student_auth_service.dart';
import '../widgets/payment_dialog.dart';
import '../widgets/user_badge.dart';

/// Screen showing subscription plans (Free / Pro / Ultra)
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _hasPendingRequest = false;
  
  @override
  void initState() {
    super.initState();
    _checkPendingRequest();
  }
  
  Future<void> _checkPendingRequest() async {
    final pending = await SubscriptionService.hasPendingRequest();
    if (mounted) {
      setState(() => _hasPendingRequest = pending);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTier = SubscriptionService.currentTier;
    final student = StudentAuthService.currentStudent;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.purple, Colors.cyanAccent],
          ).createShader(bounds),
          child: Text(
            'Subscription Plans',
            style: GoogleFonts.orbitron(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Current Plan Badge
            if (student != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      currentTier.color.withOpacity(0.2),
                      Colors.grey.shade900,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: currentTier.color.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: currentTier.color.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(currentTier.icon, color: currentTier.color, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Plan',
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                currentTier.displayName.toUpperCase(),
                                style: TextStyle(
                                  color: currentTier.color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(width: 8),
                              UserBadge(tier: currentTier.displayName.toLowerCase(), compact: true),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: -0.2),
              
              const SizedBox(height: 24),
            ],
            
            // Pending Request Banner
            if (_hasPendingRequest) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.hourglass_top, color: Colors.orange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your upgrade request is pending approval. Please wait 1-2 hours.',
                        style: TextStyle(color: Colors.orange.shade200),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().shake(),
              const SizedBox(height: 24),
            ],
            
            // Plan Cards
            _buildPlanCard(
              tier: SubscriptionTier.free,
              features: [
                '✅ Access to free books',
                '✅ Basic calculators',
                '✅ News feed',
                '✅ 3 Free projects',
                '❌ Pro/Ultra projects locked',
                '❌ No priority support',
              ],
              isCurrentPlan: currentTier == SubscriptionTier.free,
            ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
            
            const SizedBox(height: 16),
            
            _buildPlanCard(
              tier: SubscriptionTier.pro,
              features: [
                '✅ All Free features',
                '✅ Pro books unlocked',
                '✅ 7 Pro projects (total 10)',
                '✅ Advanced tools',
                '⭐ Pro badge',
                '❌ Ultra content locked',
              ],
              isCurrentPlan: currentTier == SubscriptionTier.pro,
              isRecommended: true,
            ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
            
            const SizedBox(height: 16),
            
            _buildPlanCard(
              tier: SubscriptionTier.ultra,
              features: [
                '✅ All Pro features',
                '✅ ALL books unlocked',
                '✅ 5 Ultra projects (total 15)',
                '✅ Exclusive content',
                '💎 Ultra badge',
                '🚀 Priority support',
              ],
              isCurrentPlan: currentTier == SubscriptionTier.ultra,
            ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2),
            
            const SizedBox(height: 32),
            
            // Payment info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey.shade500),
                      const SizedBox(width: 8),
                      Text(
                        'How to Upgrade',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '1. Tap on Pro or Ultra plan\n'
                    '2. Scan QR code to pay via PhonePe/GPay\n'
                    '3. Enter UTR/Transaction ID\n'
                    '4. Wait for admin approval (1-2 hrs)',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPlanCard({
    required SubscriptionTier tier,
    required List<String> features,
    required bool isCurrentPlan,
    bool isRecommended = false,
  }) {
    final canUpgrade = !isCurrentPlan && SubscriptionService.currentTier.level < tier.level;
    
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                tier.color.withOpacity(isCurrentPlan ? 0.3 : 0.1),
                Colors.grey.shade900,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCurrentPlan ? tier.color : tier.color.withOpacity(0.3),
              width: isCurrentPlan ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(tier.icon, color: tier.color, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tier.displayName,
                          style: TextStyle(
                            color: tier.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          tier.price,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isCurrentPlan)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: tier.color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'CURRENT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              ...features.map((f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(f, style: TextStyle(color: Colors.grey.shade400)),
              )),
              if (canUpgrade && !_hasPendingRequest) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      HapticFeedback.mediumImpact();
                      final result = await PaymentDialog.show(context, tier);
                      if (result == true) {
                        _checkPendingRequest(); // Refresh pending status
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tier.color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Upgrade to ${tier.displayName}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (isRecommended)
          Positioned(
            top: -1,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'RECOMMENDED',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
