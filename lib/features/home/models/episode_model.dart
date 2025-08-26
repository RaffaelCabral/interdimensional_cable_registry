// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Episode {
  final int id;
  final String name;
  final String airDate;
  final String episode;
  final List<String> characters;
  final String url;
  final String created;

  Episode({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episode,
    required this.characters,
    required this.url,
    required this.created,
  });

  Episode copyWith({
    int? id,
    String? name,
    String? airDate,
    String? episode,
    List<String>? characters,
    String? url,
    String? created,
  }) {
    return Episode(
      id: id ?? this.id,
      name: name ?? this.name,
      airDate: airDate ?? this.airDate,
      episode: episode ?? this.episode,
      characters: characters ?? this.characters,
      url: url ?? this.url,
      created: created ?? this.created,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'airDate': airDate,
      'episode': episode,
      'characters': characters,
      'url': url,
      'created': created,
    };
  }

  factory Episode.fromMap(Map<String, dynamic> map) {
    return Episode(
      id: map['id'] as int,
      name: map['name'] as String,
      airDate: map['airDate'] as String,
      episode: map['episode'] as String,
      url: map['url'] as String,
      created: map['created'] as String,
      characters: List<String>.from((map['characters'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Episode.fromJson(String source) =>
      Episode.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Episode(id: $id, name: $name, airDate: $airDate, episode: $episode, characters: $characters, url: $url, created: $created)';
  }

  @override
  bool operator ==(covariant Episode other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.airDate == airDate &&
        other.episode == episode &&
        listEquals(other.characters, characters) &&
        other.url == url &&
        other.created == created;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        airDate.hashCode ^
        episode.hashCode ^
        characters.hashCode ^
        url.hashCode ^
        created.hashCode;
  }
}
