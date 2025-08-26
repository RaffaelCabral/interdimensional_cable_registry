import 'package:equatable/equatable.dart';
import 'package:interdimensional_cable_registry/features/home/models/character_model.dart';

enum CharacterDetailsStatus { initial, loading, success, error }

class CharacterDetailsState extends Equatable {
  final CharacterDetailsStatus status;
  final Character? character;
  final String? error;

  const CharacterDetailsState({
    this.status = CharacterDetailsStatus.initial,
    this.character,
    this.error,
  });

  @override
  List<Object?> get props => [status, character, error];

  CharacterDetailsState copyWith({
    CharacterDetailsStatus? status,
    Character? character,
    String? error,
  }) {
    return CharacterDetailsState(
      status: status ?? this.status,
      character: character ?? this.character,
      error: error ?? this.error,
    );
  }
}
