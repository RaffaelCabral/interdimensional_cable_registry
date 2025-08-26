import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:interdimensional_cable_registry/features/home/models/origin_and_location_model.dart';
import 'package:interdimensional_cable_registry/features/home/models/api_info.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final OriginAndLocationModel origin;
  final OriginAndLocationModel location;
  final String image;
  final List<String> episode;
  final String url;
  final String created;
  final ApiInfo? apiInfo;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
    this.apiInfo,
  });

  Character copyWith({
    int? id,
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
    OriginAndLocationModel? origin,
    OriginAndLocationModel? location,
    String? image,
    List<String>? episode,
    String? url,
    String? created,
    ApiInfo? apiInfo,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      origin: origin ?? this.origin,
      location: location ?? this.location,
      image: image ?? this.image,
      episode: episode ?? this.episode,
      url: url ?? this.url,
      created: created ?? this.created,
      apiInfo: apiInfo ?? this.apiInfo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'origin': origin.toMap(),
      'location': location.toMap(),
      'image': image,
      'episode': episode,
      'url': url,
      'created': created,
      'apiInfo': apiInfo?.toMap(),
    };
  }

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'] as int,
      url: map['url']?.toString() ?? '',
      created: map['created']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
      species: map['species']?.toString() ?? '',
      type: map['type']?.toString() ?? '',
      gender: map['gender']?.toString() ?? '',
      origin: OriginAndLocationModel.fromMap(
        map['origin'] as Map<String, dynamic>? ?? {},
      ),
      location: OriginAndLocationModel.fromMap(
        map['location'] as Map<String, dynamic>? ?? {},
      ),
      image: map['image']?.toString() ?? '',
      episode: List<String>.from((map['episode'] as List? ?? [])),
    );
  }

  String toJson() => json.encode(toMap());

  factory Character.fromJson(String source) =>
      Character.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Character(id: $id, name: $name, status: $status, species: $species, type: $type, gender: $gender, origin: $origin, location: $location, image: $image, episode: $episode, url: $url, created: $created)';
  }

  @override
  bool operator ==(covariant Character other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.status == status &&
        other.species == species &&
        other.type == type &&
        other.gender == gender &&
        other.origin == origin &&
        other.location == location &&
        other.image == image &&
        listEquals(other.episode, episode) &&
        other.url == url &&
        other.created == created;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        status.hashCode ^
        species.hashCode ^
        type.hashCode ^
        gender.hashCode ^
        origin.hashCode ^
        location.hashCode ^
        image.hashCode ^
        episode.hashCode ^
        url.hashCode ^
        created.hashCode;
  }
}
