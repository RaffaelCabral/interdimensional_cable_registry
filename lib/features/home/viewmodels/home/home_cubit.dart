import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interdimensional_cable_registry/features/home/repositories/home_repository.dart';
import 'package:interdimensional_cable_registry/features/home/viewmodels/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;
  HomeCubit(this._homeRepository)
    : super(const HomeState(status: HomeStatus.initial));

  Future<void> getCharacters({int? page}) async {
    final targetPage = page ?? 1;
    emit(state.copyWith(status: HomeStatus.loading, currentPage: targetPage));

    try {
      final characters = await _homeRepository.getCharacters(page: targetPage);
      emit(
        state.copyWith(
          status: HomeStatus.success,
          characters: characters,
          currentPage: targetPage,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> nextPage() async {
    final apiInfo = state.characters.isNotEmpty
        ? state.characters.first.apiInfo
        : null;

    if (apiInfo != null && state.currentPage < apiInfo.pages) {
      await getCharacters(page: state.currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    if (state.currentPage > 1) {
      await getCharacters(page: state.currentPage - 1);
    }
  }

  Future<void> goToPage(int page) async {
    final apiInfo = state.characters.isNotEmpty
        ? state.characters.first.apiInfo
        : null;

    if (apiInfo != null && page >= 1 && page <= apiInfo.pages) {
      await getCharacters(page: page);
    }
  }

  Future<void> getCharacterById(int id) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final character = await _homeRepository.getCharacterById(id);
      emit(
        state.copyWith(
          status: HomeStatus.success,
          characters: [character],
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error, error: e.toString()));
    }
  }
}
