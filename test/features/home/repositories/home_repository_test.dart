import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:interdimensional_cable_registry/core/services/http_service.dart';
import 'package:interdimensional_cable_registry/features/home/repositories/home_repository.dart';
import 'package:interdimensional_cable_registry/features/home/models/character_model.dart';
import 'package:interdimensional_cable_registry/features/home/models/location_model.dart';
import 'package:interdimensional_cable_registry/features/home/models/episode_model.dart';
import 'package:interdimensional_cable_registry/features/home/models/api_info.dart';
import 'package:interdimensional_cable_registry/features/home/enums/enums.dart';

class MockHttpService extends Mock implements HttpService {}

void main() {
  late HomeRepositoryImp repository;
  late MockHttpService mockHttpService;

  setUp(() {
    mockHttpService = MockHttpService();
    repository = HomeRepositoryImp(mockHttpService);
  });

  group('HomeRepositoryImp', () {
    group('getCharacters', () {
      const tPage = 1;
      final tApiInfo = ApiInfo(
        count: 826,
        pages: 42,
        next: 'https://rickandmortyapi.com/api/character/?page=2',
        prev: null,
      );

      final tCharacterData = {
        'id': 1,
        'name': 'Rick Sanchez',
        'status': 'Alive',
        'species': 'Human',
        'type': '',
        'gender': 'Male',
        'origin': {
          'name': 'Earth (C-137)',
          'url': 'https://rickandmortyapi.com/api/location/1'
        },
        'location': {
          'name': 'Earth (Replacement Dimension)',
          'url': 'https://rickandmortyapi.com/api/location/20'
        },
        'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
        'episode': [
          'https://rickandmortyapi.com/api/episode/1',
          'https://rickandmortyapi.com/api/episode/2'
        ],
        'url': 'https://rickandmortyapi.com/api/character/1',
        'created': '2017-11-04T18:48:46.250Z'
      };

      final tResponseData = {
        'info': {
          'count': 826,
          'pages': 42,
          'next': 'https://rickandmortyapi.com/api/character/?page=2',
          'prev': null
        },
        'results': [tCharacterData]
      };

      test('should return list of characters when API call is successful', () async {
        // Arrange
        when(() => mockHttpService.get(
              'character',
              queryParameters: {'page': tPage},
            )).thenAnswer(
          (_) async => Response(
            data: tResponseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await repository.getCharacters(page: tPage);

        // Assert
        expect(result, isA<List<Character>>());
        expect(result.length, 1);
        expect(result.first.name, 'Rick Sanchez');
        expect(result.first.status, CharStatus.alive);
        expect(result.first.apiInfo, isNotNull);
        expect(result.first.apiInfo!.count, 826);
        expect(result.first.apiInfo!.pages, 42);
        
        verify(() => mockHttpService.get(
              'character',
              queryParameters: {'page': tPage},
            )).called(1);
      });

      test('should return list without page parameter when page is null', () async {
        // Arrange
        when(() => mockHttpService.get(
              'character',
              queryParameters: {'page': null},
            )).thenAnswer(
          (_) async => Response(
            data: tResponseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await repository.getCharacters();

        // Assert
        expect(result, isA<List<Character>>());
        expect(result.length, 1);
        
        verify(() => mockHttpService.get(
              'character',
              queryParameters: {'page': null},
            )).called(1);
      });

      test('should handle empty results list', () async {
        // Arrange
        final emptyResponseData = {
          'info': {
            'count': 0,
            'pages': 0,
            'next': null,
            'prev': null
          },
          'results': []
        };

        when(() => mockHttpService.get(
              'character',
              queryParameters: {'page': tPage},
            )).thenAnswer(
          (_) async => Response(
            data: emptyResponseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await repository.getCharacters(page: tPage);

        // Assert
        expect(result, isA<List<Character>>());
        expect(result.isEmpty, true);
      });

      test('should throw exception when API returns non-200 status code', () async {
        // Arrange
        when(() => mockHttpService.get(
              'character',
              queryParameters: {'page': tPage},
            )).thenAnswer(
          (_) async => Response(
            data: null,
            statusCode: 404,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act & Assert
        expect(
          () => repository.getCharacters(page: tPage),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Erro ao buscar personagens: 404'),
          )),
        );
      });

      test('should throw exception when HTTP service throws', () async {
        // Arrange
        when(() => mockHttpService.get(
              'character',
              queryParameters: {'page': tPage},
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ));

        // Act & Assert
        expect(
          () => repository.getCharacters(page: tPage),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Erro ao buscar personagens:'),
          )),
        );
      });
    });

    group('getCharacterById', () {
      const tCharacterId = 1;
      final tCharacterData = {
        'id': 1,
        'name': 'Rick Sanchez',
        'status': 'Alive',
        'species': 'Human',
        'type': '',
        'gender': 'Male',
        'origin': {
          'name': 'Earth (C-137)',
          'url': 'https://rickandmortyapi.com/api/location/1'
        },
        'location': {
          'name': 'Earth (Replacement Dimension)',
          'url': 'https://rickandmortyapi.com/api/location/20'
        },
        'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
        'episode': [
          'https://rickandmortyapi.com/api/episode/1',
          'https://rickandmortyapi.com/api/episode/2'
        ],
        'url': 'https://rickandmortyapi.com/api/character/1',
        'created': '2017-11-04T18:48:46.250Z'
      };

      test('should return character when API call is successful', () async {
        // Arrange
        when(() => mockHttpService.get('character/$tCharacterId')).thenAnswer(
          (_) async => Response(
            data: tCharacterData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await repository.getCharacterById(tCharacterId);

        // Assert
        expect(result, isA<Character>());
        expect(result.id, 1);
        expect(result.name, 'Rick Sanchez');
        expect(result.status, CharStatus.alive);
        expect(result.species, 'Human');
        
        verify(() => mockHttpService.get('character/$tCharacterId')).called(1);
      });

      test('should throw exception when API returns non-200 status code', () async {
        // Arrange
        when(() => mockHttpService.get('character/$tCharacterId')).thenAnswer(
          (_) async => Response(
            data: null,
            statusCode: 404,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act & Assert
        expect(
          () => repository.getCharacterById(tCharacterId),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Erro ao buscar personagem: 404'),
          )),
        );
      });

      test('should throw exception when HTTP service throws', () async {
        // Arrange
        when(() => mockHttpService.get('character/$tCharacterId')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // Act & Assert
        expect(
          () => repository.getCharacterById(tCharacterId),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Erro ao buscar personagem:'),
          )),
        );
      });
    });

    group('getLocations', () {
      const tPage = 1;
      final tLocationData = {
        'id': 1,
        'name': 'Earth (C-137)',
        'type': 'Planet',
        'dimension': 'Dimension C-137',
        'residents': [
          'https://rickandmortyapi.com/api/character/38',
          'https://rickandmortyapi.com/api/character/45'
        ],
        'url': 'https://rickandmortyapi.com/api/location/1',
        'created': '2017-11-04T18:48:46.250Z'
      };

      final tResponseData = {
        'info': {
          'count': 126,
          'pages': 7,
          'next': 'https://rickandmortyapi.com/api/location/?page=2',
          'prev': null
        },
        'results': [tLocationData]
      };

      test('should return list of locations when API call is successful', () async {
        // Arrange
        when(() => mockHttpService.get(
              'location',
              queryParameters: {'page': tPage},
            )).thenAnswer(
          (_) async => Response(
            data: tResponseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await repository.getLocations(page: tPage);

        // Assert
        expect(result, isA<List<Location>>());
        expect(result.length, 1);
        expect(result.first.name, 'Earth (C-137)');
        expect(result.first.type, 'Planet');
        expect(result.first.dimension, 'Dimension C-137');
        
        verify(() => mockHttpService.get(
              'location',
              queryParameters: {'page': tPage},
            )).called(1);
      });

      test('should throw exception when API returns non-200 status code', () async {
        // Arrange
        when(() => mockHttpService.get(
              'location',
              queryParameters: {'page': tPage},
            )).thenAnswer(
          (_) async => Response(
            data: null,
            statusCode: 500,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act & Assert
        expect(
          () => repository.getLocations(page: tPage),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Erro ao buscar localizações: 500'),
          )),
        );
      });

      test('should throw exception when HTTP service throws', () async {
        // Arrange
        when(() => mockHttpService.get(
              'location',
              queryParameters: {'page': tPage},
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.receiveTimeout,
        ));

        // Act & Assert
        expect(
          () => repository.getLocations(page: tPage),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Erro ao buscar localizações:'),
          )),
        );
      });
    });

    group('getEpisodes', () {
      const tPage = 1;
      final tEpisodeData = {
        'id': 1,
        'name': 'Pilot',
        'air_date': 'December 2, 2013',
        'episode': 'S01E01',
        'characters': [
          'https://rickandmortyapi.com/api/character/1',
          'https://rickandmortyapi.com/api/character/2'
        ],
        'url': 'https://rickandmortyapi.com/api/episode/1',
        'created': '2017-11-04T18:48:46.250Z'
      };

      final tResponseData = {
        'info': {
          'count': 51,
          'pages': 3,
          'next': 'https://rickandmortyapi.com/api/episode/?page=2',
          'prev': null
        },
        'results': [tEpisodeData]
      };

      test('should return list of episodes when API call is successful', () async {
        // Arrange
        when(() => mockHttpService.get(
              'episode',
              queryParameters: {'page': tPage},
            )).thenAnswer(
          (_) async => Response(
            data: tResponseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await repository.getEpisodes(page: tPage);

        // Assert
        expect(result, isA<List<Episode>>());
        expect(result.length, 1);
        expect(result.first.name, 'Pilot');
        expect(result.first.airDate, 'December 2, 2013');
        expect(result.first.episode, 'S01E01');
        
        verify(() => mockHttpService.get(
              'episode',
              queryParameters: {'page': tPage},
            )).called(1);
      });

      test('should throw exception when API returns non-200 status code', () async {
        // Arrange
        when(() => mockHttpService.get(
              'episode',
              queryParameters: {'page': tPage},
            )).thenAnswer(
          (_) async => Response(
            data: null,
            statusCode: 403,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act & Assert
        expect(
          () => repository.getEpisodes(page: tPage),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Erro ao buscar episódios: 403'),
          )),
        );
      });

      test('should throw exception when HTTP service throws', () async {
        // Arrange
        when(() => mockHttpService.get(
              'episode',
              queryParameters: {'page': tPage},
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.sendTimeout,
        ));

        // Act & Assert
        expect(
          () => repository.getEpisodes(page: tPage),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Erro ao buscar episódios:'),
          )),
        );
      });
    });
  });
}