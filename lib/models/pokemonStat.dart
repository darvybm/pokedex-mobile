class Stat {
  final String name;
  final String url;
  final int base_stat;
  final int effort;

  Stat({
    required this.name,
    required this.url,
    required this.base_stat,
    required this.effort,
  });

  factory Stat.fromJson(Map<String, dynamic> json) {
    return Stat(
      name: json['stat']['name'] as String,
      url: json['stat']['url'] as String,
      base_stat: json['base_stat'] as int,
      effort: json['effort'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stat': {'name': name, 'url': url},
      'base_stat': base_stat,
      'effort': effort,
    };
  }
}