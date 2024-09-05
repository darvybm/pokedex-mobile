class Move {
  final String name;
  final String url;

  Move({
    required this.name,
    required this.url,
  });

  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(
      name: json['move']['name'] as String,
      url: json['move']['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'move': {'name': name, 'url': url},
    };
  }
}