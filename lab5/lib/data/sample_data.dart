import '../models/movie.dart';

final List<Movie> sampleMovies = [
  Movie(
    id: '1',
    title: 'Dune: Part Two',
    posterUrl: 'https://image.tmdb.org/t/p/w500/uhUO7vQQKvCTfQWubOt5MAKokbL.jpg',
    overview: 'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.',
    rating: 8.6,
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    trailers: ['Official Trailer #1', 'IMAX Sneak Peek'],
  ),
  Movie(
    id: '2',
    title: 'Deadpool & Wolverine',
    posterUrl: 'https://image.tmdb.org/t/p/w500/mbY234XwMwEofAdX8yddNcK82wi.jpg',
    overview: 'The multiverse gets messy when Wade Wilson teams up with Wolverine for a not-so-family-friendly mission.',
    rating: 8.3,
    genres: ['Action', 'Comedy'],
    trailers: ['Red Band Trailer', 'Behind the Scenes'],
  ),
];
