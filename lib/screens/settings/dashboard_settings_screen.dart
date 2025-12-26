import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/accessibility_provider.dart';
import '../../providers/theme_provider.dart';

class DashboardSettingsScreen extends StatelessWidget {
  const DashboardSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<DashboardProvider, AccessibilityProvider, ThemeProvider>(
      builder: (context, dashboardProvider, accessibilityProvider, themeProvider, child) {
        return Container(
          decoration: themeProvider.getCurrentBackgroundDecoration(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                'Dashboard Settings',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  accessibilityProvider.provideFeedback(text: 'Going back');
                  Navigator.pop(context);
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    _showResetDialog(context, dashboardProvider, accessibilityProvider);
                  },
                  tooltip: 'Reset to defaults',
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Layout Settings
                  _buildSectionCard(
                    context,
                    'Layout Style',
                    [
                      ...DashboardLayout.values.map((layout) {
                        return RadioListTile<DashboardLayout>(
                          title: Text(
                            _getLayoutDisplayName(layout),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: Text(
                            _getLayoutDescription(layout),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          value: layout,
                          groupValue: dashboardProvider.currentLayout,
                          onChanged: (value) {
                            if (value != null) {
                              dashboardProvider.setLayout(value);
                              accessibilityProvider.provideFeedback(
                                text: '${_getLayoutDisplayName(value)} layout selected',
                              );
                            }
                          },
                        );
                      }).toList(),
                      if (dashboardProvider.currentLayout == DashboardLayout.grid)
                        ListTile(
                          title: Text(
                            'Grid Columns',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${dashboardProvider.gridColumns} columns',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Slider(
                                value: dashboardProvider.gridColumns.toDouble(),
                                min: 1,
                                max: 4,
                                divisions: 3,
                                onChanged: (value) {
                                  dashboardProvider.setGridColumns(value.toInt());
                                },
                                onChangeEnd: (value) {
                                  accessibilityProvider.provideFeedback(
                                    text: '${value.toInt()} columns selected',
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Widget Visibility
                  _buildSectionCard(
                    context,
                    'Dashboard Widgets',
                    [
                      SwitchListTile(
                        title: Text(
                          'Quick Actions',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          'Show quick action buttons',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        value: dashboardProvider.showQuickActions,
                        onChanged: (value) {
                          dashboardProvider.toggleQuickActions();
                          accessibilityProvider.provideFeedback(
                            text: value ? 'Quick actions enabled' : 'Quick actions disabled',
                          );
                        },
                      ),
                      SwitchListTile(
                        title: Text(
                          'Recent Activity',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          'Show recent activity section',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        value: dashboardProvider.showRecentActivity,
                        onChanged: (value) {
                          dashboardProvider.toggleRecentActivity();
                          accessibilityProvider.provideFeedback(
                            text: value ? 'Recent activity enabled' : 'Recent activity disabled',
                          );
                        },
                      ),
                      SwitchListTile(
                        title: Text(
                          'Progress Cards',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          'Show progress tracking cards',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        value: dashboardProvider.showProgressCards,
                        onChanged: (value) {
                          dashboardProvider.toggleProgressCards();
                          accessibilityProvider.provideFeedback(
                            text: value ? 'Progress cards enabled' : 'Progress cards disabled',
                          );
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // App Items Management
                  _buildSectionCard(
                    context,
                    'App Items',
                    [
                      Text(
                        'Customize which apps appear on your dashboard',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      ...dashboardProvider.dashboardItems.map((item) {
                        return ListTile(
                          leading: Icon(
                            item.icon,
                            color: item.color ?? Theme.of(context).primaryColor,
                          ),
                          title: Text(
                            item.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Switch(
                                value: item.isVisible,
                                onChanged: (value) {
                                  dashboardProvider.toggleItemVisibility(item.id);
                                  accessibilityProvider.provideFeedback(
                                    text: '${item.title} ${value ? 'enabled' : 'disabled'}',
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.color_lens),
                                onPressed: () => _showColorPicker(
                                  context,
                                  item,
                                  dashboardProvider,
                                  accessibilityProvider,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Reorder Items
                  _buildSectionCard(
                    context,
                    'Reorder Items',
                    [
                      Text(
                        'Drag and drop to reorder dashboard items',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      ReorderableListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        onReorder: (oldIndex, newIndex) {
                          dashboardProvider.reorderItems(oldIndex, newIndex);
                          accessibilityProvider.provideFeedback(text: 'Items reordered');
                        },
                        children: dashboardProvider.visibleItems.map((item) {
                          return ListTile(
                            key: ValueKey(item.id),
                            leading: Icon(
                              item.icon,
                              color: item.color ?? Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              item.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            trailing: const Icon(Icons.drag_handle),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionCard(BuildContext context, String title, List<Widget> children) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  String _getLayoutDisplayName(DashboardLayout layout) {
    switch (layout) {
      case DashboardLayout.grid:
        return 'Grid Layout';
      case DashboardLayout.list:
        return 'List Layout';
      case DashboardLayout.compact:
        return 'Compact Layout';
      case DashboardLayout.custom:
        return 'Custom Layout';
    }
  }

  String _getLayoutDescription(DashboardLayout layout) {
    switch (layout) {
      case DashboardLayout.grid:
        return 'Apps arranged in a grid pattern';
      case DashboardLayout.list:
        return 'Apps arranged in a vertical list';
      case DashboardLayout.compact:
        return 'Smaller icons, more apps visible';
      case DashboardLayout.custom:
        return 'Fully customizable layout';
    }
  }

  void _showColorPicker(
    BuildContext context,
    DashboardItem item,
    DashboardProvider dashboardProvider,
    AccessibilityProvider accessibilityProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose Color for ${item.title}'),
        content: SizedBox(
          width: 300,
          height: 400,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: Colors.primaries.length,
            itemBuilder: (context, index) {
              final color = Colors.primaries[index];
              return GestureDetector(
                onTap: () {
                  dashboardProvider.updateItemColor(item.id, color);
                  accessibilityProvider.provideFeedback(
                    text: 'Color updated for ${item.title}',
                  );
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: item.color == color
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(
    BuildContext context,
    DashboardProvider dashboardProvider,
    AccessibilityProvider accessibilityProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Dashboard'),
        content: const Text(
          'This will reset all dashboard settings to their default values. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              dashboardProvider.resetToDefaults();
              accessibilityProvider.provideFeedback(text: 'Dashboard reset to defaults');
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}