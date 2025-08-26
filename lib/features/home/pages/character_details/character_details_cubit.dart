import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interdimensional_cable_registry/features/home/repositories/home_repository.dart';
import 'package:interdimensional_cable_registry/features/home/pages/character_details/character_details_state.dart';

class CharacterDetailsCubit extends Cubit<CharacterDetailsState> {
  final HomeRepository _homeRepository;

  CharacterDetailsCubit(this._homeRepository)
    : super(
        const CharacterDetailsState(status: CharacterDetailsStatus.initial),
      );

  Future<void> getCharacterDetails(int id) async {
    emit(state.copyWith(status: CharacterDetailsStatus.loading));

    try {
      final character = await _homeRepository.getCharacterById(id);
      emit(
        state.copyWith(
          status: CharacterDetailsStatus.success,
          character: character,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CharacterDetailsStatus.error,
          error: e.toString(),
        ),
      );
    }
  }
}
