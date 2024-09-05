class Ability {
  final String name;
  final String url;
  final int slot;
  final bool isHidden;

  Ability({
    required this.name,
    required this.url,
    required this.slot,
    required this.isHidden,
  });

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      name: json['ability']['name'] as String,
      url: json['ability']['url'] as String,
      slot: json['slot'] as int,
      isHidden: json['is_hidden'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ability': {'name': name, 'url': url},
      'slot': slot,
      'is_hidden': isHidden,
    };
  }
}