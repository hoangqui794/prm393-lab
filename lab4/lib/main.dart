import 'package:flutter/material.dart';
import 'core_widgets_demo.dart';
import 'input_controls_demo.dart';
import 'layout_demo.dart';
import 'app_structure_demo.dart';
import 'common_ui_fixes_demo.dart';

void main() {
  runApp(const MyApp());
}

/// The root application widget.
/// Manages global theme mode (Light/Dark) to fulfill Exercise 4 requirements.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ThemeMode state variable (Light by default)
  ThemeMode _themeMode = ThemeMode.light;

  // Toggle theme callback
  void _toggleThemeMode(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PRM393 Lab 4',
      debugShowCheckedModeBanner: false,
      
      // Define Light Theme Scheme (Material 3)
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5A628F),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
        ),
      ),
      
      // Define Dark Theme Scheme (Material 3)
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5A628F),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
      ),
      themeMode: _themeMode,
      home: DashboardScreen(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeChanged: _toggleThemeMode,
      ),
    );
  }
}

/// The Main Dashboard / Menu screen listing the 5 exercises.
class DashboardScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const DashboardScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Exercise items data containing navigation titles and target screens
    final List<Map<String, dynamic>> menuItems = [
      {
        'title': 'Exercise 1 – Core Widgets Demo',
        'destination': const CoreWidgetsDemo(),
      },
      {
        'title': 'Exercise 2 – Input Controls Demo',
        'destination': const InputControlsDemo(),
      },
      {
        'title': 'Exercise 3 – Layout Demo',
        'destination': const LayoutDemo(),
      },
      {
        'title': 'Exercise 4 – App Structure & Theme',
        'destination': AppStructureDemo(
          isDarkMode: isDarkMode,
          onThemeChanged: onThemeChanged,
        ),
      },
      {
        'title': 'Exercise 5 – Common UI Fixes',
        'destination': const CommonUiFixesDemo(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lab 4 – Flutter UI Fundament...',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListView.builder(
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Card(
                elevation: 0,
                // Background color changes based on theme mode to match screenshots
                color: isDarkMode 
                    ? theme.colorScheme.surfaceVariant 
                    : const Color(0xFFF4F2F7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    // Navigate to the selected exercise screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => item['destination']),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item['title'],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
