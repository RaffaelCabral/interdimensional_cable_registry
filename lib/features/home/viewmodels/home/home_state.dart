// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:interdimensional_cable_registry/features/home/models/character_model.dart';
import 'package:interdimensional_cable_registry/features/home/models/episode_model.dart';
import 'package:interdimensional_cable_registry/features/home/models/location_model.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Character> characters;
  final List<Location> locations;
  final List<Episode> episodes;
  final int currentPage;
  final String? error;

  const HomeState({
    this.status = HomeStatus.initial,
    this.characters = const [],
    this.locations = const [],
    this.episodes = const [],
    this.currentPage = 1,
    this.error,
  });

  @override
  List<Object?> get props => [
    status,
    characters,
    locations,
    episodes,
    currentPage,
    error,
  ];

  HomeState copyWith({
    HomeStatus? status,
    List<Character>? characters,
    List<Location>? locations,
    List<Episode>? episodes,
    int? currentPage,
    String? error,
  }) {
    return HomeState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      locations: locations ?? this.locations,
      episodes: episodes ?? this.episodes,
      currentPage: currentPage ?? this.currentPage,
      error: error ?? this.error,
    );
  }
}
