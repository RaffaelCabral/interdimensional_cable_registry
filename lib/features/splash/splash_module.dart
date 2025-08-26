import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:interdimensional_cable_registry/features/splash/view/splash_page.dart';

class SplashModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (context) => SplashPage(
        onAnimationComplete: () {
          Modular.to.navigate('/home');
        },
      ),
    );
  }
}
