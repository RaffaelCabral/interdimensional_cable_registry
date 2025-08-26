import 'package:flutter_modular/flutter_modular.dart';
import 'package:interdimensional_cable_registry/core/services/http_service.dart';
import 'package:interdimensional_cable_registry/features/home/repositories/home_repository.dart';
import 'package:interdimensional_cable_registry/features/home/viewmodels/home/home_cubit.dart';
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
  }

  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (context) => HomePage(
        viewModel: Modular.get<HomeCubit>(),
      ),
    );
  }
}
