import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool _isFavorited = false;
  bool _isRated = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorited
              ? 'Added "${widget.movie.title}" to Favorites!'
              : 'Removed "${widget.movie.title}" from Favorites.',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleRate() {
    setState(() {
      _isRated = !_isRated;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isRated
              ? 'You rated "${widget.movie.title}" 5 stars!'
              : 'Cleared your rating for "${widget.movie.title}".',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareMovie() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing link for "${widget.movie.title}"...'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _playTrailer(String trailerName) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing trailer: "$trailerName"'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC), // Match Home page background color
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1D1B20)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          movie.title,
          style: const TextStyle(
            color: Color(0xFF1D1B20),
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner (Stack + Image.network + gradient)
            Stack(
              children: [
                Hero(
                  tag: 'movie-poster-${movie.id}',
                  child: Image.network(
                    movie.posterUrl,
                    width: double.infinity,
                    height: 230.0,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 230.0,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.movie, size: 64.0, color: Colors.grey),
                      );
                    },
                  ),
                ),
                // Gradient overlay at bottom
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0x1A000000),
                          const Color(0xD9000000),
                        ],
                      ),
                    ),
                  ),
                ),
                // Title overlay at the bottom-left
                Positioned(
                  left: 16.0,
                  bottom: 16.0,
                  right: 16.0,
                  child: Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Title & Genres (Column + Wrap + Custom Chips)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: movie.genres.map((genre) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: const Color(0xFFE5E1EC),
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      genre,
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: Color(0xFF49454F),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16.0),
            // Overview text with padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                movie.overview,
                style: const TextStyle(
                  fontSize: 15.0,
                  height: 1.5,
                  color: Color(0xFF49454F),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            // Row of Action Buttons (Favorite / Rate / Share)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: _isFavorited ? Icons.favorite : Icons.favorite_border,
                    iconColor: _isFavorited ? Colors.red : const Color(0xFF49454F),
                    label: 'Favorite',
                    onTap: _toggleFavorite,
                  ),
                  _buildActionButton(
                    icon: _isRated ? Icons.star : Icons.star_border,
                    iconColor: _isRated ? Colors.amber : const Color(0xFF49454F),
                    label: 'Rate',
                    onTap: _toggleRate,
                  ),
                  _buildActionButton(
                    icon: Icons.share,
                    iconColor: const Color(0xFF49454F),
                    label: 'Share',
                    onTap: _shareMovie,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            // List of Trailers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trailers',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1B20),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  // Render dividers and trailer rows
                  ...movie.trailers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final trailer = entry.value;
                    return Column(
                      children: [
                        if (index == 0)
                          const Divider(height: 1.0, color: Color(0xFFE5E1EC)),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.play_circle_fill,
                            size: 28.0,
                            color: Color(0xFF49454F),
                          ),
                          title: Text(
                            trailer,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Color(0xFF1D1B20),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () => _playTrailer(trailer),
                        ),
                        const Divider(height: 1.0, color: Color(0xFFE5E1EC)),
                      ],
                    );
                  }),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 26.0),
            const SizedBox(height: 6.0),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFF49454F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
