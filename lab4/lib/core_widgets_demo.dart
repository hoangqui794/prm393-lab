import 'package:flutter/material.dart';

/// Exercise 1: Core Widgets Demo
/// This screen demonstrates the usage of Flutter's core UI widgets:
/// [Text], [Icon], [Image.network], [Card], and [ListTile].
class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 1 – Core Widge...'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Headline Text
              // Displays a large, bold title to welcome users.
              Text(
                'Welcome to Flutter UI',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // 2. Material Icon
              // Displays a movie clapperboard icon with custom size and blue color.
              const Icon(
                Icons.movie,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),

              // 3. Image.network
              // Loads a sample image of a highway interchange from the internet.
              // Rounded corners are applied using ClipRRect for a polished look.
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://images.unsplash.com/photo-1524813686514-a57563d77d61?auto=format&fit=crop&w=600&q=80',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback widget if the network image fails to load
                    return Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // 4. Card containing a ListTile
              // Groups content visually with elevation and rounded corners.
              // The ListTile features a leading star icon, title, and subtitle.
              Card(
                elevation: 0,
                color: isDark 
                    ? theme.colorScheme.surfaceVariant 
                    : const Color(0xFFF4F2F7), // Match light grey background in mockups
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.star,
                      color: isDark ? Colors.amber : Colors.blueGrey,
                      size: 28,
                    ),
                    title: Text(
                      'Movie Item',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      'This is a sample ListTile inside a Card.',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
