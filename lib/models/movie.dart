class Movie {
  final String id;
  final String title;
  final int releaseYear;
  final String imageUrl;

  Movie({
    required this.id,
    required this.title,
    required this.releaseYear,
    required this.imageUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['titleText']['text'],
      releaseYear: json['releaseYear']['year'],
      imageUrl: json['primaryImage']['url'],
    );
  }
}
