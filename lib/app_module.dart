import 'package:flutter_modular/flutter_modular.dart';
import 'package:interdimensional_cable_registry/features/home/home_module.dart';
import 'package:interdimensional_cable_registry/features/splash/splash_module.dart';
import 'core/services/http_service.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton<HttpService>(() => HttpService());
  }

  @override
  void routes(r) {
    r.module('/', module: SplashModule());
    r.module('/home', module: HomeModule());
  }
}
