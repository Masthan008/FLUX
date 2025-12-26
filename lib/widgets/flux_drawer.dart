import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Dynamic drawer that shows user's name and email from Supabase
class FluxDrawer extends StatefulWidget {
  final VoidCallback? onCodeCompiler;
  final VoidCallback? onLibrary;
  final VoidCallback? onVideoLibrary;
  final VoidCallback? onCodingContests;
  final VoidCallback? onLeaderboard;
  final VoidCallback? onSettings;
  final VoidCallback? onLogout;
  final VoidCallback? onSubscription;

  const FluxDrawer({
    super.key,
    this.onCodeCompiler,
    this.onLibrary,
    this.onVideoLibrary,
    this.onCodingContests,
    this.onLeaderboard,
    this.onSettings,
    this.onLogout,
    this.onSubscription,
  });

  @override
  State<FluxDrawer> createState() => _FluxDrawerState();
}

class _FluxDrawerState extends State<FluxDrawer> {
  String _userName = 'FluxFlow Student';
  String _userEmail = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      
      if (user != null) {
        // Try to get username from users table
        try {
          final data = await Supabase.instance.client
              .from('users')
              .select('username, email, full_name')
              .eq('id', user.id)
              .maybeSingle();
          
          if (data != null && mounted) {
            setState(() {
              _userName = data['full_name'] ?? 
                          data['username'] ?? 
                          user.email?.split('@').first ?? 
                          'FluxFlow Student';
              _userEmail = data['email'] ?? user.email ?? '';
            });
          } else if (mounted) {
            setState(() {
              _userName = user.email?.split('@').first ?? 'FluxFlow Student';
              _userEmail = user.email ?? '';
            });
          }
        } catch (e) {
          // Table might not exist, use auth user info
          if (mounted) {
            setState(() {
              _userName = user.email?.split('@').first ?? 'FluxFlow Student';
              _userEmail = user.email ?? '';
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1A1A2E),
      child: Column(
        children: [
          // Header with gradient and user info
          _buildHeader(),
          
          // Menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 8),
                _buildMenuItem(
                  icon: Icons.code,
                  title: 'Code Compiler',
                  color: Colors.cyan,
                  onTap: () {
                    Navigator.pop(context);
                    widget.onCodeCompiler?.call();
                  },
                ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
                
                _buildMenuItem(
                  icon: Icons.menu_book,
                  title: 'Library & Resources',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.pop(context);
                    widget.onLibrary?.call();
                  },
                ).animate().fadeIn(delay: 150.ms).slideX(begin: -0.2),
                
                _buildMenuItem(
                  icon: Icons.play_circle,
                  title: 'Video Library',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    widget.onVideoLibrary?.call();
                  },
                ).animate().fadeIn(delay: 175.ms).slideX(begin: -0.2),
                
                _buildMenuItem(
                  icon: Icons.emoji_events,
                  title: 'Coding Contests',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pop(context);
                    widget.onCodingContests?.call();
                  },
                ).animate().fadeIn(delay: 188.ms).slideX(begin: -0.2),
                
                _buildMenuItem(
                  icon: Icons.leaderboard,
                  title: 'Leaderboard',
                  color: Colors.amber,
                  onTap: () {
                    Navigator.pop(context);
                    widget.onLeaderboard?.call();
                  },
                ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(color: Colors.grey),
                ),
                
                // NEW: Subscription Plans
                _buildMenuItem(
                  icon: Icons.star,
                  title: 'Subscription Plans',
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    widget.onSubscription?.call();
                  },
                ).animate().fadeIn(delay: 225.ms).slideX(begin: -0.2),
                
                _buildMenuItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  color: Colors.grey,
                  onTap: () {
                    Navigator.pop(context);
                    widget.onSettings?.call();
                  },
                ).animate().fadeIn(delay: 250.ms).slideX(begin: -0.2),
              ],
            ),
          ),
          
          // Logout button at bottom
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        bottom: 24,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6200EA), Color(0xFFB388FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator(strokeWidth: 2)
                  : Text(
                      _userName.isNotEmpty 
                          ? _userName[0].toUpperCase() 
                          : 'F',
                      style: GoogleFonts.orbitron(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF6200EA),
                      ),
                    ),
            ),
          ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
          
          const SizedBox(height: 16),
          
          // Name
          Text(
            _userName,
            style: GoogleFonts.sourceCodePro(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
          
          const SizedBox(height: 4),
          
          // Email
          Text(
            _userEmail,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: GoogleFonts.sourceCodePro(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey.shade600,
      ),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: OutlinedButton.icon(
        onPressed: () async {
          Navigator.pop(context);
          await Supabase.instance.client.auth.signOut();
          widget.onLogout?.call();
        },
        icon: const Icon(Icons.logout, color: Colors.red),
        label: Text(
          'Logout',
          style: GoogleFonts.sourceCodePro(
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.red.withOpacity(0.5)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2);
  }
}
