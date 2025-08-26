// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/splash_constants.dart';

class PortalAnimation extends StatelessWidget {
  final Animation<double> portalRotation;
  final Animation<double> portalScale;

  const PortalAnimation({
    super.key,
    required this.portalRotation,
    required this.portalScale,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([portalRotation, portalScale]),
          builder: (context, child) {
            return Transform.scale(
              scale: portalScale.value,
              child: Transform.rotate(
                angle: portalRotation.value,
                child: Container(
                  width: SplashConstants.mainPortalSize.w,
                  height: SplashConstants.mainPortalSize.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        SplashConstants.acidGreen,
                        SplashConstants.portalGreen,
                        SplashConstants.rickBlue,
                        SplashConstants.dimensionPurple,
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.2, 0.5, 0.8, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: SplashConstants.portalGreen.withOpacity(0.8),
                        blurRadius: 40.r,
                        spreadRadius: 10.r,
                      ),
                      BoxShadow(
                        color: SplashConstants.acidGreen.withOpacity(0.4),
                        blurRadius: 60.r,
                        spreadRadius: 20.r,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ...List.generate(SplashConstants.portalRingCount, (
                        index,
                      ) {
                        return Transform.rotate(
                          angle: portalRotation.value * (index + 1) * 0.3,
                          child: Container(
                            width: (180 - index * 30).w,
                            height: (180 - index * 30).w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SecondaryPortals extends StatelessWidget {
  final Animation<double> portalRotation;

  const SecondaryPortals({
    super.key,
    required this.portalRotation,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top Right Portal
        Positioned(
          top: 100.h,
          right: 50.w,
          child: AnimatedBuilder(
            animation: portalRotation,
            builder: (context, child) {
              return Transform.rotate(
                angle: -portalRotation.value * 0.7,
                child: Container(
                  width: SplashConstants.secondaryPortalSize.w,
                  height: SplashConstants.secondaryPortalSize.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        SplashConstants.rickBlue,
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: SplashConstants.rickBlue.withOpacity(0.5),
                        blurRadius: 15.r,
                        spreadRadius: 3.r,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Bottom Left Portal
        Positioned(
          bottom: 150.h,
          left: 30.w,
          child: AnimatedBuilder(
            animation: portalRotation,
            builder: (context, child) {
              return Transform.rotate(
                angle: portalRotation.value * 0.5,
                child: Container(
                  width: SplashConstants.smallPortalSize.w,
                  height: SplashConstants.smallPortalSize.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        SplashConstants.dimensionPurple,
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: SplashConstants.dimensionPurple.withOpacity(0.5),
                        blurRadius: 10.r,
                        spreadRadius: 2.r,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
