import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/book_service.dart';
import '../services/subscription_service.dart';
import '../services/student_auth_service.dart';
import '../widgets/payment_dialog.dart';
import '../widgets/user_badge.dart';
import '../services/link_launcher.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await BookService.getCategories();
    setState(() {
      _categories = ['All', ...categories];
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.purple, Colors.blue],
          ).createShader(bounds),
          child: Text(
            'Student Library',
            style: GoogleFonts.orbitron(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.withOpacity(0.1),
                    Colors.blue.withOpacity(0.1),
                  ],
                ),
                border: Border.all(color: Colors.purple.withOpacity(0.3)),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search books...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  prefixIcon: const Icon(Icons.search, color: Colors.purple),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ).animate().fadeIn().slideY(begin: -0.2),

          // Category Chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = category);
                    },
                    backgroundColor: Colors.grey.shade900,
                    selectedColor: Colors.purple.withOpacity(0.3),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.purple : Colors.white70,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected ? Colors.purple : Colors.grey.shade700,
                    ),
                  ),
                );
              },
            ),
          ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.2),

          const SizedBox(height: 16),

          // Books List
          Expanded(
            child: StreamBuilder<List<Book>>(
              stream: BookService.streamBooks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.purple),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.library_books_outlined,
                          size: 80,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No books available',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Books will appear here when added',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                var books = snapshot.data!;

                // Filter by category
                if (_selectedCategory != 'All') {
                  books = books
                      .where((b) => b.category == _selectedCategory)
                      .toList();
                }

                // Filter by search
                if (_searchQuery.isNotEmpty) {
                  books = books
                      .where((b) => b.title
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
                      .toList();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    return _buildBookCard(books[index], index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(Book book, int index) {
    // Check access permission for styling
    final userTier = SubscriptionService.currentTier;
    final bookTierStr = book.minTierRequired.toLowerCase();
    final bookTierEnum = SubscriptionService.stringToTier(bookTierStr);
    
    // Determine if locked
    bool isLocked = false;
    if (bookTierStr.isNotEmpty && bookTierStr != 'free') {
      isLocked = userTier.level < bookTierEnum.level;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isLocked ? Colors.grey.shade900.withOpacity(0.6) : const Color(0xFF1E1E2C),
            isLocked ? Colors.grey.shade900.withOpacity(0.4) : const Color(0xFF2D2D44),
          ],
        ),
        border: Border.all(
          color: isLocked
              ? Colors.grey.withOpacity(0.2)
              : book.isPremium
                  ? Colors.amber.withOpacity(0.3)
                  : Colors.purple.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openBook(book),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover Image / Placeholder Section
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (book.coverUrl != null && book.coverUrl!.isNotEmpty)
                        Image.network(
                          book.coverUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildPlaceholderCover(book),
                        )
                      else
                        _buildPlaceholderCover(book),
                        
                      // Gradient Overlay for text readability
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 60,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // Lock Overlay
                      if (isLocked)
                        Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.withOpacity(0.5)),
                              ),
                              child: const Icon(Icons.lock, color: Colors.white70, size: 32),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Expanded(
                          child: Text(
                            book.title,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              color: isLocked ? Colors.grey : Colors.white,
                              fontSize: 18,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Premium Badge
                        if (book.isPremium) ...[
                          const SizedBox(width: 8),
                          UserBadge(tier: book.minTierRequired, compact: true),
                        ],
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Description
                    if (book.description != null && book.description!.isNotEmpty)
                      Text(
                        book.description!,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                    const SizedBox(height: 16),
                    
                    // Footer: Category & Action
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.purple.withOpacity(0.3)),
                          ),
                          child: Text(
                            book.category,
                            style: const TextStyle(
                              color: Colors.purpleAccent,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // Action Button (View/Download/Lock)
                        if (!isLocked)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.green.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.download_rounded, color: Colors.greenAccent, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  'READ',
                                  style: GoogleFonts.orbitron(
                                    color: Colors.greenAccent,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Row(
                            children: [
                              Icon(Icons.lock_outline, size: 14, color: bookTierEnum.color),
                              const SizedBox(width: 4),
                              Text(
                                'LOCKED',
                                style: GoogleFonts.orbitron(
                                  color: bookTierEnum.color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: 50 * index)).fadeIn().slideY(begin: 0.1);
  }

  Widget _buildPlaceholderCover(Book book) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: book.isPremium
              ? [Colors.amber.shade900, Colors.deepOrange.shade900]
              : [Colors.indigo.shade900, Colors.purple.shade900],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_stories,
              color: Colors.white.withOpacity(0.3),
              size: 40,
            ),
          ],
        ),
      ),
    );
  }



  Future<void> _openBook(Book book) async {
    // Check access permission
    final userTier = SubscriptionService.currentTier;
    final bookTierStr = book.minTierRequired.toLowerCase();
    
    // Free books are always accessible
    if (bookTierStr.isEmpty || bookTierStr == 'free') {
      await LinkLauncher.openLink(context, book.pdfDriveLink);
      return;
    }
    
    // Check tier level
    final bookTierEnum = SubscriptionService.stringToTier(bookTierStr);
    
    if (userTier.level >= bookTierEnum.level) {
      // User has access
      await LinkLauncher.openLink(context, book.pdfDriveLink);
    } else {
      // Access denied - show payment dialog
      showDialog(
        context: context,
        builder: (context) => PaymentDialog(plan: bookTierEnum),
      );
    }
  }
}
