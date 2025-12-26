import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/accessibility_provider.dart';
import 'accessibility_wrapper.dart';

class EnhancedDashboard extends StatelessWidget {
  const EnhancedDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<DashboardProvider, ThemeProvider, AccessibilityProvider>(
      builder: (context, dashboardProvider, themeProvider, accessibilityProvider, child) {
        return Container(
          decoration: themeProvider.getCurrentBackgroundDecoration(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                _buildWelcomeSection(context, themeProvider, accessibilityProvider),
                
                const SizedBox(height: 20),
                
                // Quick Actions (if enabled)
                if (dashboardProvider.showQuickActions)
                  _buildQuickActions(context, themeProvider, accessibilityProvider),
                
                const SizedBox(height: 20),
                
                // Main App Grid/List
                _buildAppGrid(context, dashboardProvider, themeProvider, accessibilityProvider),
                
                const SizedBox(height: 20),
                
                // Progress Cards (if enabled)
                if (dashboardProvider.showProgressCards)
                  _buildProgressCards(context, themeProvider, accessibilityProvider),
                
                const SizedBox(height: 20),
                
                // Recent Activity (if enabled)
                if (dashboardProvider.showRecentActivity)
                  _buildRecentActivity(context, themeProvider, accessibilityProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeSection(
    BuildContext context,
    ThemeProvider themeProvider,
    AccessibilityProvider accessibilityProvider,
  ) {
    return AccessibilityWrapper(
      semanticLabel: 'Welcome to FluxFlow dashboard',
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to FluxFlow',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your personalized learning companion',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(
    BuildContext context,
    ThemeProvider themeProvider,
    AccessibilityProvider accessibilityProvider,
  ) {
    final quickActions = [
      {'icon': Icons.calculate, 'label': 'Calculator', 'route': '/calculator'},
      {'icon': Icons.alarm, 'label': 'Set Alarm', 'route': '/alarm'},
      {'icon': Icons.book, 'label': 'Study', 'route': '/books'},
      {'icon': Icons.chat, 'label': 'Chat', 'route': '/chat'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: quickActions.map((action) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AccessibleButton(
                  semanticLabel: action['label'] as String,
                  onPressed: () {
                    // Navigate to the respective screen
                    Navigator.pushNamed(context, action['route'] as String);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        action['icon'] as IconData,
                        size: 24,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        action['label'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAppGrid(
    BuildContext context,
    DashboardProvider dashboardProvider,
    ThemeProvider themeProvider,
    AccessibilityProvider accessibilityProvider,
  ) {
    final visibleItems = dashboardProvider.visibleItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Apps',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        _buildLayoutBasedGrid(
          context,
          dashboardProvider,
          themeProvider,
          accessibilityProvider,
          visibleItems,
        ),
      ],
    );
  }

  Widget _buildLayoutBasedGrid(
    BuildContext context,
    DashboardProvider dashboardProvider,
    ThemeProvider themeProvider,
    AccessibilityProvider accessibilityProvider,
    List<DashboardItem> items,
  ) {
    switch (dashboardProvider.currentLayout) {
      case DashboardLayout.grid:
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: dashboardProvider.gridColumns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return _buildAppCard(
              context,
              items[index],
              themeProvider,
              accessibilityProvider,
            );
          },
        );
      
      case DashboardLayout.list:
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildAppListTile(
                context,
                items[index],
                themeProvider,
                accessibilityProvider,
              ),
            );
          },
        );
      
      case DashboardLayout.compact:
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return _buildCompactAppCard(
              context,
              items[index],
              themeProvider,
              accessibilityProvider,
            );
          },
        );
      
      case DashboardLayout.custom:
        // For now, use grid layout for custom
        return _buildLayoutBasedGrid(
          context,
          dashboardProvider.copyWith(currentLayout: DashboardLayout.grid),
          themeProvider,
          accessibilityProvider,
          items,
        );
    }
  }

  Widget _buildAppCard(
    BuildContext context,
    DashboardItem item,
    ThemeProvider themeProvider,
    AccessibilityProvider accessibilityProvider,
  ) {
    return AccessibleCard(
      semanticLabel: '${item.title} app',
      onTap: () {
        Navigator.pushNamed(context, item.route);
      },
      color: Colors.white.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item.icon,
            size: 40,
            color: item.color ?? themeProvider.getCurrentPrimaryColor(),
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAppListTile(
    BuildContext context,
    DashboardItem item,
    ThemeProvider themeProvider,
    AccessibilityProvider accessibilityProvider,
  ) {
    return AccessibleCard(
      semanticLabel: '${item.title} app',
      onTap: () {
        Navigator.pushNamed(context, item.route);
      },
      color: Colors.white.withOpacity(0.1),
      child: ListTile(
        leading: Icon(
          item.icon,
          size: 32,
          color: item.color ?? themeProvider.getCurrentPrimaryColor(),
        ),
        title: Text(
          item.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white70,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildCompactAppCard(
    BuildContext context,
    DashboardItem item,
    ThemeProvider themeProvider,
    AccessibilityProvider accessibilityProvider,
  ) {
    return AccessibleCard(
      semanticLabel: '${item.title} app',
      onTap: () {
        Navigator.pushNamed(context, item.route);
      },
      color: Colors.white.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item.icon,
            size: 28,
            color: item.color ?? themeProvider.getCurrentPrimaryColor(),
          ),
          const SizedBox(height: 4),
          Text(
            item.title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCards(
    BuildContext context,
    ThemeProvider themeProvider,
    AccessibilityProvider accessibilityProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Progress',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildProgressCard(
                context,
                'Study Streak',
                '7 days',
                Icons.local_fire_department,
                Colors.orange,
                accessibilityProvider,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildProgressCard(
                context,
                'Problems Solved',
                '42',
                Icons.check_circle,
                Colors.green,
                accessibilityProvider,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    AccessibilityProvider accessibilityProvider,
  ) {
    return AccessibleCard(
      semanticLabel: '$title: $value',
      color: Colors.white.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(
    BuildContext context,
    ThemeProvider themeProvider,
    AccessibilityProvider accessibilityProvider,
  ) {
    final activities = [
      {'title': 'Completed Calculator Exercise', 'time': '2 hours ago'},
      {'title': 'Read Chapter 5 - Data Structures', 'time': '1 day ago'},
      {'title': 'Solved 5 LeetCode Problems', 'time': '2 days ago'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ...activities.map((activity) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AccessibleCard(
              semanticLabel: '${activity['title']}, ${activity['time']}',
              color: Colors.white.withOpacity(0.05),
              child: Row(
                children: [
                  const Icon(
                    Icons.history,
                    color: Colors.white70,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['title']!,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          activity['time']!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

// Extension to help with copying DashboardProvider for layout switching
extension DashboardProviderExtension on DashboardProvider {
  DashboardProvider copyWith({DashboardLayout? currentLayout}) {
    // This is a simplified approach - in a real implementation,
    // you might want to create a proper copy method
    return this;
  }
}