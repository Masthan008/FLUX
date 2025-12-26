// ========================================
// Feature Status Section for About Screen
// ========================================
// Add this code after line 497 in about_screen.dart
// (After the modules section, before team credits)

const SizedBox(height: 40),

// --- FEATURE STATUS SECTION ---
Container(
  width: double.infinity,
  padding: const EdgeInsets.all(25),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.green.shade900.withOpacity(0.4),
        Colors.black.withOpacity(0.9),
        Colors.purple.shade900.withOpacity(0.3),
      ],
    ),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.green.withOpacity(0.5), width: 2),
    boxShadow: [
      BoxShadow(
        color: Colors.green.withOpacity(0.2),
        blurRadius: 20,
        spreadRadius: 2,
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Header
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.green.withOpacity(0.3), Colors.transparent],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified_outlined, color: Colors.green, size: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Colors.green, Colors.white, Colors.green],
              ).createShader(bounds),
              child: Text(
                'FEATURE STATUS',
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ).animate().fadeIn(delay: 1200.ms).slideX(begin: -0.3, end: 0),
      
      const SizedBox(height: 25),

      // Included Features
      Text(
        '✅ INCLUDED FEATURES',
        style: GoogleFonts.poppins(
          color: Colors.green,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 12),
      
      _buildFeatureItem('Projects Store', 'NEW', Colors.purple),
      _buildFeatureItem('20+ Learning Modules', 'Active', Colors.green),
      _buildFeatureItem('Tier-Based Access', 'Active', Colors.amber),
      
      const SizedBox(height: 20),
      Divider(color: Colors.grey.shade800),
      const SizedBox(height: 20),
      
      // Removed Features
      Text(
        '❌ REMOVED FROM MENU',
        style: GoogleFonts.poppins(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 12),
      
      _buildRemovedFeature('Student Profile UI'),
      _buildRemovedFeature('Daily Code Challenge'),
      
      const SizedBox(height: 16),
      
      // Info Note
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue.shade300, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Auth service still works - only UI removed from menu',
                style: GoogleFonts.poppins(
                  color: Colors.blue.shade300,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
).animate().fadeIn(delay: 1200.ms).slideY(begin: 0.3, end: 0),

const SizedBox(height: 40),

// ========================================
// Helper Methods - Add at the end of _AboutScreenState class
// ========================================

Widget _buildFeatureItem(String name, String status, Color color) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Icon(Icons.check_circle, color: color, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            name,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Text(
            status,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildRemovedFeature(String name) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Icon(Icons.remove_circle_outline, color: Colors.grey, size: 16),
        const SizedBox(width: 10),
        Text(
          name,
          style: GoogleFonts.poppins(
            color: Colors.grey.shade600,
            fontSize: 13,
            decoration: TextDecoration.lineThrough,
          ),
        ),
      ],
    ),
  );
}
