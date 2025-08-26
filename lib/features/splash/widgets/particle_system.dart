// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import '../constants/splash_constants.dart';

class ParticleSystem extends StatelessWidget {
  final Animation<double> particleController;

  const ParticleSystem({
    super.key,
    required this.particleController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: particleController,
      builder: (context, child) {
        return Stack(
          children: List.generate(SplashConstants.backgroundParticleCount, (
            index,
          ) {
            final random = math.Random(index + 42);
            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;

            final x = random.nextDouble() * screenWidth;
            final y = random.nextDouble() * screenHeight;
            final delay = random.nextDouble() * 2;

            return Positioned(
              left: x,
              top: y,
              child: Opacity(
                opacity:
                    (math.sin((particleController.value + delay) * math.pi) *
                            0.8)
                        .clamp(0.0, 1.0),
                child: Container(
                  width: 2.w + random.nextDouble() * 3.w,
                  height: 2.w + random.nextDouble() * 3.w,
                  decoration: BoxDecoration(
                    color: SplashConstants.portalColors[index % 4].withOpacity(
                      0.6,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: SplashConstants.portalColors[index % 4]
                            .withOpacity(0.3),
                        blurRadius: 4.r,
                        spreadRadius: 1.r,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class PortalParticles extends StatelessWidget {
  final Animation<double> particleRotation;

  const PortalParticles({
    super.key,
    required this.particleRotation,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: particleRotation,
        builder: (context, child) {
          final centerX = MediaQuery.of(context).size.width / 2;
          final centerY = MediaQuery.of(context).size.height / 2;

          return Stack(
            children: List.generate(SplashConstants.portalParticleCount, (
              index,
            ) {
              final angle = (index * 30.0) * (math.pi / 180);
              final radius =
                  120.w + math.sin(particleRotation.value + index) * 15.w;
              final x =
                  centerX + math.cos(angle + particleRotation.value) * radius;
              final y =
                  centerY + math.sin(angle + particleRotation.value) * radius;

              return Positioned(
                left: x - 3.w,
                top: y - 3.w,
                child: Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: SplashConstants.portalColors[index % 4],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: SplashConstants.portalColors[index % 4],
                        blurRadius: 6.r,
                        spreadRadius: 1.r,
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
