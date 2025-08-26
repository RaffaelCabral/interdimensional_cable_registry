import 'package:flutter/material.dart';

class SplashConstants {
  static const Color spaceBlack = Color(0xFF000000);
  static const Color spaceDark = Color(0xFF0A0A0A);
  static const Color portalGreen = Color(0xFF44C855);
  static const Color rickBlue = Color(0xFF00A8E6);
  static const Color mortYellow = Color(0xFFFFE135);
  static const Color dimensionPurple = Color(0xFF8B5CF6);
  static const Color rickLabCoat = Color(0xFFF0F0F0);
  static const Color acidGreen = Color(0xFF39FF14);

  static const List<Color> portalColors = [
    portalGreen,
    rickBlue,
    mortYellow,
    dimensionPurple,
  ];

  static const Duration portalDuration = Duration(milliseconds: 3500);
  static const Duration textDuration = Duration(milliseconds: 3000);
  static const Duration particleDuration = Duration(milliseconds: 6000);
  static const Duration rickDuration = Duration(milliseconds: 3500);
  static const Duration glitchDuration = Duration(milliseconds: 1500);
  static const Duration finalDuration = Duration(milliseconds: 2000);

  static const int backgroundParticleCount = 30;
  static const int portalParticleCount = 12;
  static const int portalRingCount = 3;

  static const double mainPortalSize = 250.0;
  static const double secondaryPortalSize = 60.0;
  static const double smallPortalSize = 40.0;
  static const double rickSilhouetteWidth = 100.0;
  static const double rickSilhouetteHeight = 160.0;

  static const String titleMain = 'INTERDIMENSIONAL';
  static const String titleSub = 'CABLE REGISTRY';
  static const String subtitle = 'Loading infinite realities...';

  static const List<int> animationDelays = [2500, 1000, 1500, 3000, 2000];
}
