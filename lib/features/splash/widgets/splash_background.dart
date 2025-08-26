// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/splash_constants.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            SplashConstants.spaceDark,
            SplashConstants.spaceBlack,
            Colors.black,
          ],
        ),
      ),
    );
  }
}

class RickSilhouette extends StatelessWidget {
  final Animation<double> rickSlide;
  final AnimationController rickController;

  const RickSilhouette({
    super.key,
    required this.rickSlide,
    required this.rickController,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20.w,
      top: MediaQuery.of(context).size.height * 0.25,
      child: AnimatedBuilder(
        animation: rickController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              rickSlide.value * MediaQuery.of(context).size.width,
              0,
            ),
            child: Opacity(
              opacity: rickController.value,
              child: SizedBox(
                width: SplashConstants.rickSilhouetteWidth.w,
                height: SplashConstants.rickSilhouetteHeight.h,
                child: Stack(
                  children: [
                    // Body silhouette
                    Container(
                      width: SplashConstants.rickSilhouetteWidth.w,
                      height: 140.h,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.r),
                          topRight: Radius.circular(50.r),
                        ),
                      ),
                    ),
                    // Lab coat
                    Positioned(
                      bottom: 20.h,
                      left: 10.w,
                      right: 10.w,
                      child: Container(
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: SplashConstants.rickLabCoat.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                    ),
                    // Portal gun glow
                    Positioned(
                      bottom: 60.h,
                      right: 5.w,
                      child: Container(
                        width: 20.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: SplashConstants.portalGreen,
                          borderRadius: BorderRadius.circular(3.r),
                          boxShadow: [
                            BoxShadow(
                              color: SplashConstants.portalGreen,
                              blurRadius: 8.r,
                              spreadRadius: 1.r,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class GlitchOverlay extends StatelessWidget {
  final AnimationController glitchController;
  final AnimationController rickController;
  final Animation<double> glitchOffset;

  const GlitchOverlay({
    super.key,
    required this.glitchController,
    required this.rickController,
    required this.glitchOffset,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glitchController,
      builder: (context, child) {
        if (rickController.value < 0.8) return const SizedBox.shrink();

        return Transform.translate(
          offset: Offset(glitchOffset.value, 0),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  SplashConstants.acidGreen.withOpacity(0.03),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        );
      },
    );
  }
}
