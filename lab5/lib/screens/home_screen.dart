import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../data/sample_data.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> _filteredMovies = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredMovies = sampleMovies;
  }

  void _filterMovies(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMovies = sampleMovies;
      } else {
        _filteredMovies = sampleMovies
            .where((movie) =>
                movie.title.toLowerCase().contains(query.toLowerCase()) ||
                movie.genres.any((genre) =>
                    genre.toLowerCase().contains(query.toLowerCase())))
            .toList();
      }
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
      backgroundColor: const Color(0xFFF8F7FC), // Cool light grey/lavender background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24.0),
              // App Title "Movies"
              const Text(
                'Movies',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C1B1F),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16.0),
              // Search Bar (Optional Enhancement)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x08000000),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterMovies,
                  decoration: InputDecoration(
                    hintText: 'Search movies or genres...',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15.0),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              _filterMovies('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              // Movie List
              Expanded(
                child: _filteredMovies.isEmpty
                    ? const Center(
                        child: Text(
                          'No movies found',
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredMovies.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final movie = _filteredMovies[index];
                          return _buildMovieCard(context, movie);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieCard(BuildContext context, Movie movie) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F0F8), // Matches the light purple-grey card background in screenshot
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFFE5E1EC), // Light border matching the mockup
          width: 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {
            // Navigator.push with MaterialPageRoute passing the Movie object
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(movie: movie),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Movie Poster Image (Landscape aspect ratio with rounded corners)
                Hero(
                  tag: 'movie-poster-${movie.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      movie.posterUrl,
                      width: 100.0,
                      height: 60.0,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100.0,
                          height: 60.0,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.movie, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                // Title and Genres / Rating details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D1B20),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        '☆ ${movie.rating} • ${movie.genres.join(', ')}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Arrow Right chevron icon
                const SizedBox(width: 8.0),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF49454F),
                  size: 24.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
