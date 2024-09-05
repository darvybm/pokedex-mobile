class Pokemon {
  final int id;
  final String name;
  final String url;

  Pokemon({
    required this.id,
    required this.name,
    required this.url,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // Extrayendo el ID del pokemon desde su URL
    final urlParts = json['url'].split('/');
    final id = int.parse(urlParts[urlParts.length - 2]);

    return Pokemon(
      id: id,
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
    };
  }
}
