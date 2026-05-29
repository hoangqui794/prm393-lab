import 'package:flutter/material.dart';

/// Movie item model to store data for the list
class MovieItem {
  final String title;
  final String description;

  const MovieItem({required this.title, required this.description});
}

/// Exercise 3: Layout Basics
/// This screen demonstrates using structural layout widgets:
/// [Column], [Row], [Padding], [SizedBox], and [ListView.builder].
class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  // Sample static movie list data matching the mockup
  final List<MovieItem> movies = const [
    MovieItem(title: 'Avatar', description: 'Sample description'),
    MovieItem(title: 'Inception', description: 'Sample description'),
    MovieItem(title: 'Interstellar', description: 'Sample description'),
    MovieItem(title: 'Joker', description: 'Sample description'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 3 – Layout De...'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Column Section: Headline Title
            // A centered text banner indicating the section content.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Now Playing',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Consistent Spacing (12 px) using SizedBox
            const SizedBox(height: 12),

            // 2. ListView.builder Section wrapped in Expanded
            // This is required to prevent layout crash from unbounded height.
            // Displays a scrollable list of movies with leading CircleAvatars.
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  // Extract first character of movie title for avatar
                  final String initial = movie.title.isNotEmpty ? movie.title[0] : '';
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0), // Spacing between items
                    child: Card(
                      elevation: 0,
                      color: isDark ? theme.colorScheme.surfaceVariant : const Color(0xFFF4F2F7), // Soft background to match screenshot
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isDark 
                                ? theme.colorScheme.primaryContainer 
                                : const Color(0xFFD6DBF5), // Light bluish-purple
                            child: Text(
                              initial,
                              style: TextStyle(
                                color: isDark 
                                    ? theme.colorScheme.onPrimaryContainer 
                                    : const Color(0xFF5A628F),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            movie.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          subtitle: Text(
                            movie.description,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
