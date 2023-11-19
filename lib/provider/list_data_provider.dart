import 'dart:convert';
import 'package:application_movie/models/movie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final listDataProvider = ChangeNotifierProvider<ListDataNotifier>((ref) {
  return ListDataNotifier();
});

class ListDataNotifier extends ChangeNotifier {
  Future<List<Movie>> fetchMovies(BuildContext context) async {
    const String url =
        'https://moviesdatabase.p.rapidapi.com/titles/x/upcoming';
    final Map<String, String> headers = {
      'X-RapidAPI-Key': '87cb70cbc2msh43111ad89638925p12329ajsn2e8a1c1900a7',
      'X-RapidAPI-Host': 'moviesdatabase.p.rapidapi.com',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<Movie> movies = (jsonData['results'] as List)
            .map((data) => Movie.fromJson(data))
            .toList();
        return movies;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Error: $error',
          style: const TextStyle(fontSize: 11),
        ),
      ));
      return [];
    }
  }
}
