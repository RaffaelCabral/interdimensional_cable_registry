import 'package:flutter_modular/flutter_modular.dart';
import 'package:interdimensional_cable_registry/core/services/http_service.dart';
import 'package:interdimensional_cable_registry/features/home/repositories/home_repository.dart';
import 'package:interdimensional_cable_registry/features/home/viewmodels/character_details/character_details_cubit.dart';
import 'package:interdimensional_cable_registry/features/home/viewmodels/home/home_cubit.dart';
import 'package:interdimensional_cable_registry/features/home/views/character_details_page.dart';
import 'package:interdimensional_cable_registry/features/home/views/home_page.dart';

class HomeModule extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton<HomeRepository>(
      () => HomeRepositoryImp(Modular.get<HttpService>()),
    );

    i.addLazySingleton<HomeCubit>(
      () => HomeCubit(Modular.get<HomeRepository>()),
    );

    i.addLazySingleton<CharacterDetailsCubit>(
      () => CharacterDetailsCubit(Modular.get<HomeRepository>()),
    );
  }

  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (context) => HomePage(
        viewModel: Modular.get<HomeCubit>(),
      ),
    );
    r.child(
      '/character/:id',
      child: (context) {
        final id = int.parse(r.args.params['id'] ?? '1');
        return CharacterDetailsPage(characterId: id);
      },
    );
  }
}
