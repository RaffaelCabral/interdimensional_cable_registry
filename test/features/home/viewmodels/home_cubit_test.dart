import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:interdimensional_cable_registry/features/home/repositories/home_repository.dart';
import 'package:interdimensional_cable_registry/features/home/pages/home/home_cubit.dart';
import 'package:interdimensional_cable_registry/features/home/pages/home/home_state.dart';
import 'package:interdimensional_cable_registry/features/home/models/character_model.dart';
import 'package:interdimensional_cable_registry/features/home/models/api_info.dart';
import 'package:interdimensional_cable_registry/features/home/models/origin_and_location_model.dart';
import 'package:interdimensional_cable_registry/features/home/enums/enums.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late HomeCubit homeCubit;
  late MockHomeRepository mockRepository;

  setUp(() {
    mockRepository = MockHomeRepository();
    homeCubit = HomeCubit(mockRepository);
  });

  tearDown(() {
    homeCubit.close();
  });

  group('HomeCubit', () {
    final tApiInfo = ApiInfo(
      count: 826,
      pages: 42,
      next: 'https://rickandmortyapi.com/api/character/?page=2',
      prev: null,
    );

    final tCharacter = Character(
      id: 1,
      name: 'Rick Sanchez',
      status: CharStatus.alive,
      species: 'Human',
      type: '',
      gender: 'Male',
      origin: OriginAndLocationModel(
        name: 'Earth (C-137)',
        url: 'https://rickandmortyapi.com/api/location/1',
      ),
      location: OriginAndLocationModel(
        name: 'Earth (Replacement Dimension)',
        url: 'https://rickandmortyapi.com/api/location/20',
      ),
      image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
      episode: [
        'https://rickandmortyapi.com/api/episode/1',
        'https://rickandmortyapi.com/api/episode/2',
      ],
      url: 'https://rickandmortyapi.com/api/character/1',
      created: '2017-11-04T18:48:46.250Z',
      apiInfo: tApiInfo,
    );

    final tCharacters = [tCharacter];

    test('initial state should be HomeState with initial status', () {
      expect(homeCubit.state, const HomeState(status: HomeStatus.initial));
    });

    group('getCharacters', () {
      blocTest<HomeCubit, HomeState>(
        'should emit [loading, success] when getCharacters succeeds',
        build: () {
          when(
            () => mockRepository.getCharacters(page: 1),
          ).thenAnswer((_) async => tCharacters);
          return homeCubit;
        },
        act: (cubit) => cubit.getCharacters(page: 1),
        expect: () => [
          const HomeState(status: HomeStatus.loading, currentPage: 1),
          HomeState(
            status: HomeStatus.success,
            characters: tCharacters,
            currentPage: 1,
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.getCharacters(page: 1)).called(1);
        },
      );

      blocTest<HomeCubit, HomeState>(
        'should use page 1 as default when no page is provided',
        build: () {
          when(
            () => mockRepository.getCharacters(page: 1),
          ).thenAnswer((_) async => tCharacters);
          return homeCubit;
        },
        act: (cubit) => cubit.getCharacters(),
        expect: () => [
          const HomeState(status: HomeStatus.loading, currentPage: 1),
          HomeState(
            status: HomeStatus.success,
            characters: tCharacters,
            currentPage: 1,
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.getCharacters(page: 1)).called(1);
        },
      );

      blocTest<HomeCubit, HomeState>(
        'should emit [loading, error] when getCharacters fails',
        build: () {
          when(
            () => mockRepository.getCharacters(page: 1),
          ).thenThrow(Exception('Network error'));
          return homeCubit;
        },
        act: (cubit) => cubit.getCharacters(page: 1),
        expect: () => [
          const HomeState(status: HomeStatus.loading, currentPage: 1),
          const HomeState(
            status: HomeStatus.error,
            error: 'Exception: Network error',
            currentPage: 1,
          ),
        ],
      );
    });

    group('nextPage', () {
      blocTest<HomeCubit, HomeState>(
        'should call getCharacters with next page when current page is less than total pages',
        build: () {
          when(
            () => mockRepository.getCharacters(page: 2),
          ).thenAnswer((_) async => tCharacters);
          return homeCubit;
        },
        seed: () => HomeState(
          status: HomeStatus.success,
          characters: tCharacters,
          currentPage: 1,
        ),
        act: (cubit) => cubit.nextPage(),
        expect: () => [
          HomeState(
            status: HomeStatus.loading,
            characters: tCharacters,
            currentPage: 2,
          ),
          HomeState(
            status: HomeStatus.success,
            characters: tCharacters,
            currentPage: 2,
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.getCharacters(page: 2)).called(1);
        },
      );

      blocTest<HomeCubit, HomeState>(
        'should not call getCharacters when current page equals total pages',
        build: () => homeCubit,
        seed: () => HomeState(
          status: HomeStatus.success,
          characters: [
            tCharacter.copyWith(
              apiInfo: tApiInfo.copyWith(pages: 1),
            ),
          ],
          currentPage: 1,
        ),
        act: (cubit) => cubit.nextPage(),
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => mockRepository.getCharacters(page: any(named: 'page')),
          );
        },
      );

      blocTest<HomeCubit, HomeState>(
        'should not call getCharacters when characters list is empty',
        build: () => homeCubit,
        seed: () => const HomeState(
          status: HomeStatus.success,
          characters: [],
          currentPage: 1,
        ),
        act: (cubit) => cubit.nextPage(),
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => mockRepository.getCharacters(page: any(named: 'page')),
          );
        },
      );
    });

    group('previousPage', () {
      blocTest<HomeCubit, HomeState>(
        'should call getCharacters with previous page when current page is greater than 1',
        build: () {
          when(
            () => mockRepository.getCharacters(page: 1),
          ).thenAnswer((_) async => tCharacters);
          return homeCubit;
        },
        seed: () => HomeState(
          status: HomeStatus.success,
          characters: tCharacters,
          currentPage: 2,
        ),
        act: (cubit) => cubit.previousPage(),
        expect: () => [
          HomeState(
            status: HomeStatus.loading,
            characters: tCharacters,
            currentPage: 1,
          ),
          HomeState(
            status: HomeStatus.success,
            characters: tCharacters,
            currentPage: 1,
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.getCharacters(page: 1)).called(1);
        },
      );

      blocTest<HomeCubit, HomeState>(
        'should not call getCharacters when current page is 1',
        build: () => homeCubit,
        seed: () => HomeState(
          status: HomeStatus.success,
          characters: tCharacters,
          currentPage: 1,
        ),
        act: (cubit) => cubit.previousPage(),
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => mockRepository.getCharacters(page: any(named: 'page')),
          );
        },
      );
    });

    group('goToPage', () {
      blocTest<HomeCubit, HomeState>(
        'should call getCharacters with specified page when page is valid',
        build: () {
          when(
            () => mockRepository.getCharacters(page: 5),
          ).thenAnswer((_) async => tCharacters);
          return homeCubit;
        },
        seed: () => HomeState(
          status: HomeStatus.success,
          characters: tCharacters,
          currentPage: 1,
        ),
        act: (cubit) => cubit.goToPage(5),
        expect: () => [
          HomeState(
            status: HomeStatus.loading,
            characters: tCharacters,
            currentPage: 5,
          ),
          HomeState(
            status: HomeStatus.success,
            characters: tCharacters,
            currentPage: 5,
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.getCharacters(page: 5)).called(1);
        },
      );

      blocTest<HomeCubit, HomeState>(
        'should not call getCharacters when page is less than 1',
        build: () => homeCubit,
        seed: () => HomeState(
          status: HomeStatus.success,
          characters: tCharacters,
          currentPage: 1,
        ),
        act: (cubit) => cubit.goToPage(0),
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => mockRepository.getCharacters(page: any(named: 'page')),
          );
        },
      );

      blocTest<HomeCubit, HomeState>(
        'should not call getCharacters when page is greater than total pages',
        build: () => homeCubit,
        seed: () => HomeState(
          status: HomeStatus.success,
          characters: [
            tCharacter.copyWith(
              apiInfo: tApiInfo.copyWith(pages: 10),
            ),
          ],
          currentPage: 1,
        ),
        act: (cubit) => cubit.goToPage(15),
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => mockRepository.getCharacters(page: any(named: 'page')),
          );
        },
      );

      blocTest<HomeCubit, HomeState>(
        'should not call getCharacters when characters list is empty',
        build: () => homeCubit,
        seed: () => const HomeState(
          status: HomeStatus.success,
          characters: [],
          currentPage: 1,
        ),
        act: (cubit) => cubit.goToPage(2),
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => mockRepository.getCharacters(page: any(named: 'page')),
          );
        },
      );
    });

    group('getCharacterById', () {
      const tCharacterId = 1;

      blocTest<HomeCubit, HomeState>(
        'should emit [loading, success] when getCharacterById succeeds',
        build: () {
          when(
            () => mockRepository.getCharacterById(tCharacterId),
          ).thenAnswer((_) async => tCharacter);
          return homeCubit;
        },
        act: (cubit) => cubit.getCharacterById(tCharacterId),
        expect: () => [
          const HomeState(status: HomeStatus.loading),
          HomeState(
            status: HomeStatus.success,
            characters: [tCharacter],
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.getCharacterById(tCharacterId)).called(1);
        },
      );

      blocTest<HomeCubit, HomeState>(
        'should emit [loading, error] when getCharacterById fails',
        build: () {
          when(
            () => mockRepository.getCharacterById(tCharacterId),
          ).thenThrow(Exception('Character not found'));
          return homeCubit;
        },
        act: (cubit) => cubit.getCharacterById(tCharacterId),
        expect: () => [
          const HomeState(status: HomeStatus.loading),
          const HomeState(
            status: HomeStatus.error,
            error: 'Exception: Character not found',
          ),
        ],
      );
    });
  });
}
