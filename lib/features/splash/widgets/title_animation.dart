// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/splash_constants.dart';

class TitleAnimation extends StatelessWidget {
  final Animation<double> textOpacity;
  final Animation<double> textScale;
  final Animation<Offset> textSlide;
  final AnimationController textController;

  const TitleAnimation({
    super.key,
    required this.textOpacity,
    required this.textScale,
    required this.textSlide,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Center(
        child: AnimatedBuilder(
          animation: textController,
          builder: (context, child) {
            return SlideTransition(
              position: textSlide,
              child: FadeTransition(
                opacity: textOpacity,
                child: Transform.scale(
                  scale: textScale.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              SplashConstants.portalGreen.withOpacity(0.3),
                              SplashConstants.rickBlue.withOpacity(0.3),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(
                            color: SplashConstants.portalGreen.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          SplashConstants.titleMain,
                          style: TextStyle(
                            fontSize: 22.spMax,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 2.w,
                            shadows: [
                              Shadow(
                                color: SplashConstants.portalGreen,
                                offset: const Offset(0, 0),
                                blurRadius: 8.r,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        SplashConstants.titleSub,
                        style: TextStyle(
                          fontSize: 18.spMax,
                          fontWeight: FontWeight.w700,
                          color: SplashConstants.mortYellow,
                          letterSpacing: 1.5.w,
                          shadows: [
                            Shadow(
                              color: SplashConstants.mortYellow.withOpacity(
                                0.8,
                              ),
                              offset: const Offset(0, 0),
                              blurRadius: 12.r,
                            ),
                          ],
                        ),
                      ),
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

class SubtitleAnimation extends StatelessWidget {
  final AnimationController textController;

  const SubtitleAnimation({
    super.key,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100.h,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: textController,
        builder: (context, child) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: textController,
                curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
              ),
            ),
            child: Center(
              child: Text(
                SplashConstants.subtitle,
                style: TextStyle(
                  fontSize: 14.spMax,
                  fontWeight: FontWeight.w500,
                  color: SplashConstants.rickBlue,
                  letterSpacing: 1.w,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
