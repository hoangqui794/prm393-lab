import 'package:flutter/material.dart';

/// Exercise 4: App Structure and Theme
/// This screen demonstrates a complete screen structure using:
/// - [Scaffold] with [AppBar] and [FloatingActionButton].
/// - Dynamic Theme customization using [ThemeData].
/// - A Switch to toggle between Light and Dark mode globally.
class AppStructureDemo extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const AppStructureDemo({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Access the current theme for dynamic UI updates
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 4 – App Str...'),
        actions: [
          // Row containing the "Dark" label and the switch
          Row(
            children: [
              Text(
                'Dark',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 4),
              Switch(
                value: isDarkMode,
                activeColor: theme.colorScheme.primary,
                onChanged: onThemeChanged,
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display icon representing theme state
              Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                size: 80,
                color: isDarkMode ? Colors.amber : Colors.orange,
              ),
              const SizedBox(height: 16),
              // Body message describing theme toggle
              const Text(
                'This is a simple screen with theme toggle.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Triggers a snackbar to show action
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isDarkMode ? 'Dark Mode Active!' : 'Light Mode Active!',
              ),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        tooltip: 'Theme Info',
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        child: const Icon(Icons.info_outline),
      ),
    );
  }
}
