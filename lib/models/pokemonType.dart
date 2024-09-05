class Type {
  final String name;
  final String url;
  final int slot;

  Type({
    required this.name,
    required this.url,
    required this.slot,
  });

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      name: json['type']['name'] as String,
      url: json['type']['url'] as String,
      slot: json['slot'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': {'name': name, 'url': url},
      'slot': slot,
    };
  }
}