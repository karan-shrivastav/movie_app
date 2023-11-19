import 'package:application_movie/models/movie.dart';
import 'package:application_movie/provider/list_data_provider.dart';
import 'package:application_movie/widgets/card_widget.dart';
import 'package:application_movie/widgets/field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'movie_detail_screen.dart';

class MovieScreen extends ConsumerStatefulWidget {
  const MovieScreen({super.key});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  late Future<List<Movie>> futureMovies;
  final TextEditingController _searchController = TextEditingController();
  List<Movie> displayedMovies = [];

  @override
  void initState() {
    super.initState();
    futureMovies = ref.read(listDataProvider.notifier).fetchMovies(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void searchMovies(String query) async {
    List<Movie> allMovies = await futureMovies;
    setState(() {
      if (query.isEmpty) {
        displayedMovies = [];
      } else {
        displayedMovies = allMovies.where((movie) {
          final titleMatches =
              movie.title.toLowerCase().contains(query.toLowerCase());
          final yearMatches = movie.releaseYear.toString().contains(query);
          return titleMatches || yearMatches;
        }).toList();
      }
      if (displayedMovies.isEmpty) {
        displayedMovies = [
          Movie(
            id: '0',
            title: 'No matching data found',
            releaseYear: 0,
            imageUrl: '',
          ),
        ];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upcoming Movies',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            FieldWidget(
              controller: _searchController,
              onChanged: searchMovies,
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder<List<Movie>>(
                future: futureMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No movies available'));
                  } else {
                    if (_searchController.text.isNotEmpty &&
                        displayedMovies.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: displayedMovies.length,
                        itemBuilder: (context, index) {
                          final movie = displayedMovies[index];
                          return CardWidget(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailScreen(
                                    image: movie.imageUrl,
                                    movieName: movie.title,
                                    year: movie.releaseYear,
                                    id: movie.id,
                                  ),
                                ),
                              );
                            },
                            title: movie.title,
                            subtitle: movie.releaseYear,
                            image: movie.imageUrl,
                          );
                        },
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final movie = snapshot.data![index];
                          return CardWidget(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailScreen(
                                    image: movie.imageUrl,
                                    movieName: movie.title,
                                    year: movie.releaseYear,
                                    id: movie.id,
                                  ),
                                ),
                              );
                            },
                            title: movie.title,
                            subtitle: movie.releaseYear,
                            image: movie.imageUrl,
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
