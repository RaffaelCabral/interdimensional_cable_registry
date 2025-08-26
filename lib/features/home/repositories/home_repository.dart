import 'package:interdimensional_cable_registry/core/services/http_service.dart';
import 'package:interdimensional_cable_registry/features/home/models/character_model.dart';
import 'package:interdimensional_cable_registry/features/home/models/episode_model.dart';
import 'package:interdimensional_cable_registry/features/home/models/location_model.dart';
import 'package:interdimensional_cable_registry/features/home/models/api_info.dart';

abstract class HomeRepository {
  Future<List<Character>> getCharacters({int? page});
  Future<List<Location>> getLocations({int? page});
  Future<List<Episode>> getEpisodes({int? page});
  Future<Character> getCharacterById(int id);
}

class HomeRepositoryImp implements HomeRepository {
  final HttpService _httpService;

  HomeRepositoryImp(this._httpService);

  @override
  Future<List<Character>> getCharacters({int? page}) async {
    try {
      final response = await _httpService.get(
        'character',
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final apiInfo = ApiInfo.fromMap(data['info']);

        final results = (data['results'] as List)
            .map((e) => Character.fromMap(e))
            .toList();

        if (results.isNotEmpty) {
          results[0] = results[0].copyWith(apiInfo: apiInfo);
        }

        return results;
      } else {
        throw Exception('Erro ao buscar personagens: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar personagens: $e');
    }
  }

  @override
  Future<Character> getCharacterById(int id) async {
    try {
      final response = await _httpService.get('character/$id');

      if (response.statusCode == 200) {
        return Character.fromMap(response.data);
      } else {
        throw Exception('Erro ao buscar personagem: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar personagem: $e');
    }
  }

  @override
  Future<List<Location>> getLocations({int? page}) async {
    try {
      final response = await _httpService.get(
        'location',
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final results = (data['results'] as List)
            .map((e) => Location.fromMap(e))
            .toList();
        return results;
      } else {
        throw Exception('Erro ao buscar localizações: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar localizações: $e');
    }
  }

  @override
  Future<List<Episode>> getEpisodes({int? page}) async {
    try {
      final response = await _httpService.get(
        'episode',
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final results = (data['results'] as List)
            .map((e) => Episode.fromMap(e))
            .toList();
        return results;
      } else {
        throw Exception('Erro ao buscar episódios: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar episódios: $e');
    }
  }
}
