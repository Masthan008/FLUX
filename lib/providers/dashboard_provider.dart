import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum DashboardLayout {
  grid,
  list,
  compact,
  custom,
}

class DashboardItem {
  final String id;
  final String title;
  final IconData icon;
  final String route;
  final Color? color;
  bool isVisible;
  int position;

  DashboardItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
    this.color,
    this.isVisible = true,
    this.position = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'iconCodePoint': icon.codePoint,
      'route': route,
      'color': color?.value,
      'isVisible': isVisible,
      'position': position,
    };
  }

  factory DashboardItem.fromMap(Map<String, dynamic> map) {
    return DashboardItem(
      id: map['id'],
      title: map['title'],
      icon: _getIconFromCodePoint(map['iconCodePoint']),
      route: map['route'],
      color: map['color'] != null ? Color(map['color']) : null,
      isVisible: map['isVisible'] ?? true,
      position: map['position'] ?? 0,
    );
  }

  static IconData _getIconFromCodePoint(int? codePoint) {
    // Map common codePoints to their corresponding Icons constants
    switch (codePoint) {
      case 0xe1ae: return Icons.calculate;
      case 0xe855: return Icons.alarm;
      case 0xe55b: return Icons.map;
      case 0xe86f: return Icons.code;
      case 0xe865: return Icons.book;
      case 0xe0b7: return Icons.chat;
      case 0xe2e8: return Icons.forest;
      case 0xe86c: return Icons.check_circle;
      case 0xe1eb: return Icons.newspaper;
      case 0xe7fd: return Icons.person;
      default: return Icons.apps; // Default fallback icon
    }
  }
}

class DashboardProvider extends ChangeNotifier {
  static const String _dashboardBoxKey = 'dashboard_settings';
  late Box _dashboardBox;
  
  DashboardLayout _currentLayout = DashboardLayout.grid;
  List<DashboardItem> _dashboardItems = [];
  bool _showQuickActions = true;
  bool _showRecentActivity = true;
  bool _showProgressCards = true;
  int _gridColumns = 2;
  
  // Getters
  DashboardLayout get currentLayout => _currentLayout;
  List<DashboardItem> get dashboardItems => _dashboardItems;
  List<DashboardItem> get visibleItems => _dashboardItems.where((item) => item.isVisible).toList()
    ..sort((a, b) => a.position.compareTo(b.position));
  bool get showQuickActions => _showQuickActions;
  bool get showRecentActivity => _showRecentActivity;
  bool get showProgressCards => _showProgressCards;
  int get gridColumns => _gridColumns;

  DashboardProvider() {
    _initializeDashboard();
  }

  Future<void> _initializeDashboard() async {
    try {
      _dashboardBox = await Hive.openBox(_dashboardBoxKey);
      _loadDashboardSettings();
      if (_dashboardItems.isEmpty) {
        _createDefaultItems();
      }
    } catch (e) {
      debugPrint('Error initializing dashboard: $e');
      _createDefaultItems();
    }
  }

  void _loadDashboardSettings() {
    // Load layout
    final layoutIndex = _dashboardBox.get('currentLayout', defaultValue: 0);
    _currentLayout = DashboardLayout.values[layoutIndex];
    
    // Load dashboard items
    final itemsData = _dashboardBox.get('dashboardItems', defaultValue: <Map<String, dynamic>>[]);
    _dashboardItems = (itemsData as List).map((item) => DashboardItem.fromMap(Map<String, dynamic>.from(item))).toList();
    
    // Load other settings
    _showQuickActions = _dashboardBox.get('showQuickActions', defaultValue: true);
    _showRecentActivity = _dashboardBox.get('showRecentActivity', defaultValue: true);
    _showProgressCards = _dashboardBox.get('showProgressCards', defaultValue: true);
    _gridColumns = _dashboardBox.get('gridColumns', defaultValue: 2);
    
    notifyListeners();
  }

  Future<void> _saveDashboardSettings() async {
    try {
      await _dashboardBox.put('currentLayout', _currentLayout.index);
      await _dashboardBox.put('dashboardItems', _dashboardItems.map((item) => item.toMap()).toList());
      await _dashboardBox.put('showQuickActions', _showQuickActions);
      await _dashboardBox.put('showRecentActivity', _showRecentActivity);
      await _dashboardBox.put('showProgressCards', _showProgressCards);
      await _dashboardBox.put('gridColumns', _gridColumns);
    } catch (e) {
      debugPrint('Error saving dashboard settings: $e');
    }
  }

  void _createDefaultItems() {
    _dashboardItems = [
      DashboardItem(
        id: 'calculator',
        title: 'Calculator',
        icon: Icons.calculate,
        route: '/calculator',
        color: Colors.blue,
        position: 0,
      ),
      DashboardItem(
        id: 'alarm',
        title: 'Alarm',
        icon: Icons.alarm,
        route: '/alarm',
        color: Colors.orange,
        position: 1,
      ),
      DashboardItem(
        id: 'roadmaps',
        title: 'Roadmaps',
        icon: Icons.map,
        route: '/roadmaps',
        color: Colors.green,
        position: 2,
      ),
      DashboardItem(
        id: 'coding',
        title: 'Coding',
        icon: Icons.code,
        route: '/coding',
        color: Colors.purple,
        position: 3,
      ),
      DashboardItem(
        id: 'books',
        title: 'Books',
        icon: Icons.book,
        route: '/books',
        color: Colors.brown,
        position: 4,
      ),
      DashboardItem(
        id: 'chat',
        title: 'Chat Hub',
        icon: Icons.chat,
        route: '/chat',
        color: Colors.teal,
        position: 5,
      ),
      DashboardItem(
        id: 'focus',
        title: 'Focus Forest',
        icon: Icons.forest,
        route: '/focus',
        color: Colors.green[700],
        position: 6,
      ),

      DashboardItem(
        id: 'news',
        title: 'News',
        icon: Icons.newspaper,
        route: '/news',
        color: Colors.red,
        position: 8,
      ),
      DashboardItem(
        id: 'profile',
        title: 'Profile',
        icon: Icons.person,
        route: '/profile',
        color: Colors.grey,
        position: 9,
      ),
    ];
    _saveDashboardSettings();
  }

  // Layout Management
  void setLayout(DashboardLayout layout) {
    _currentLayout = layout;
    _saveDashboardSettings();
    notifyListeners();
  }

  void setGridColumns(int columns) {
    _gridColumns = columns.clamp(1, 4);
    _saveDashboardSettings();
    notifyListeners();
  }

  // Item Management
  void toggleItemVisibility(String itemId) {
    final item = _dashboardItems.firstWhere((item) => item.id == itemId);
    item.isVisible = !item.isVisible;
    _saveDashboardSettings();
    notifyListeners();
  }

  void reorderItems(int oldIndex, int newIndex) {
    final visibleItems = this.visibleItems;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    
    final item = visibleItems.removeAt(oldIndex);
    visibleItems.insert(newIndex, item);
    
    // Update positions
    for (int i = 0; i < visibleItems.length; i++) {
      visibleItems[i].position = i;
    }
    
    _saveDashboardSettings();
    notifyListeners();
  }

  void updateItemColor(String itemId, Color color) {
    final itemIndex = _dashboardItems.indexWhere((item) => item.id == itemId);
    if (itemIndex != -1) {
      _dashboardItems[itemIndex] = DashboardItem(
        id: _dashboardItems[itemIndex].id,
        title: _dashboardItems[itemIndex].title,
        icon: _dashboardItems[itemIndex].icon,
        route: _dashboardItems[itemIndex].route,
        color: color,
        isVisible: _dashboardItems[itemIndex].isVisible,
        position: _dashboardItems[itemIndex].position,
      );
      _saveDashboardSettings();
      notifyListeners();
    }
  }

  // Widget Visibility
  void toggleQuickActions() {
    _showQuickActions = !_showQuickActions;
    _saveDashboardSettings();
    notifyListeners();
  }

  void toggleRecentActivity() {
    _showRecentActivity = !_showRecentActivity;
    _saveDashboardSettings();
    notifyListeners();
  }

  void toggleProgressCards() {
    _showProgressCards = !_showProgressCards;
    _saveDashboardSettings();
    notifyListeners();
  }

  // Reset to defaults
  void resetToDefaults() {
    _currentLayout = DashboardLayout.grid;
    _showQuickActions = true;
    _showRecentActivity = true;
    _showProgressCards = true;
    _gridColumns = 2;
    _createDefaultItems();
    notifyListeners();
  }
}