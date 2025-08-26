import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class OriginAndLocationModel {
  final String name;
  final String url;
  OriginAndLocationModel({
    required this.name,
    required this.url,
  });

  OriginAndLocationModel copyWith({
    String? name,
    String? url,
  }) {
    return OriginAndLocationModel(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'url': url,
    };
  }

  factory OriginAndLocationModel.fromMap(Map<String, dynamic> map) {
    return OriginAndLocationModel(
      name: map['name']?.toString() ?? '',
      url: map['url']?.toString() ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OriginAndLocationModel.fromJson(String source) =>
      OriginAndLocationModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() => 'Location(name: $name, url: $url)';

  @override
  bool operator ==(covariant OriginAndLocationModel other) {
    if (identical(this, other)) return true;

    return other.name == name && other.url == url;
  }

  @override
  int get hashCode => name.hashCode ^ url.hashCode;
}
