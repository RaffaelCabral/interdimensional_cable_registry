// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class SplashPage extends StatefulWidget {
  final VoidCallback? onAnimationComplete;

  const SplashPage({
    super.key,
    this.onAnimationComplete,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _portalController;
  late AnimationController _textController;
  late AnimationController _particleController;
  late AnimationController _rickController;
  late AnimationController _glitchController;
  late AnimationController _finalController;

  late Animation<double> _portalRotation;
  late Animation<double> _portalScale;
  late Animation<double> _textOpacity;
  late Animation<double> _textScale;
  late Animation<Offset> _textSlide;
  late Animation<double> _particleRotation;
  late Animation<double> _rickSlide;
  late Animation<double> _glitchOffset;
  late Animation<double> _finalFade;

  static const Color _spaceBlack = Color(0xFF000000);
  static const Color _spaceDark = Color(0xFF0A0A0A);
  static const Color _portalGreen = Color(0xFF44C855);
  static const Color _rickBlue = Color(0xFF00A8E6);
  static const Color _mortYellow = Color(0xFFFFE135);
  static const Color _dimensionPurple = Color(0xFF8B5CF6);
  static const Color _rickLabCoat = Color(0xFFF0F0F0);
  static const Color _acidGreen = Color(0xFF39FF14);

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimationSequence();
  }

  void _setupAnimations() {
    _portalController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _portalRotation = Tween<double>(begin: 0, end: 4 * math.pi).animate(
      CurvedAnimation(parent: _portalController, curve: Curves.easeInOut),
    );

    _portalScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _portalController, curve: Curves.elasticOut),
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _textScale = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _textController,
            curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
          ),
        );

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _particleRotation = Tween<double>(begin: 0, end: 8 * math.pi).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    _rickController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _rickSlide = Tween<double>(begin: 1.5, end: 0).animate(
      CurvedAnimation(parent: _rickController, curve: Curves.easeOutBack),
    );

    _glitchController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _glitchOffset = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _glitchController, curve: Curves.elasticInOut),
    );

    _finalController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _finalFade = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _finalController, curve: Curves.easeInOut),
    );
  }

  void _startAnimationSequence() async {
    _portalController.forward();

    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) _textController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) _particleController.forward();

    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) _rickController.forward();

    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) _finalController.forward();

    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) widget.onAnimationComplete?.call();
  }

  @override
  void dispose() {
    _portalController.dispose();
    _textController.dispose();
    _particleController.dispose();
    _rickController.dispose();
    _glitchController.dispose();
    _finalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _portalController,
          _textController,
          _particleController,
          _rickController,
          _glitchController,
          _finalController,
        ]),
        builder: (context, child) {
          return FadeTransition(
            opacity: Tween<double>(begin: 1, end: 0).animate(_finalFade),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    _spaceDark,
                    _spaceBlack,
                    Colors.black,
                  ],
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _buildBackgroundParticles(),

                  _buildSecondaryPortals(),

                  _buildMainPortal(),

                  _buildRickSilhouette(),

                  _buildPortalParticles(),

                  _buildTitleText(),

                  _buildSubtitle(),

                  _buildGlitchOverlay(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackgroundParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Stack(
          children: List.generate(30, (index) {
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
                    (math.sin((_particleController.value + delay) * math.pi) *
                            0.8)
                        .clamp(0.0, 1.0),
                child: Container(
                  width: 2.w + random.nextDouble() * 3.w,
                  height: 2.w + random.nextDouble() * 3.w,
                  decoration: BoxDecoration(
                    color: [
                      _portalGreen,
                      _rickBlue,
                      _mortYellow,
                      _dimensionPurple,
                    ][index % 4].withOpacity(0.6),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: [
                          _portalGreen,
                          _rickBlue,
                          _mortYellow,
                          _dimensionPurple,
                        ][index % 4].withOpacity(0.3),
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

  Widget _buildMainPortal() {
    return Positioned.fill(
      child: Center(
        child: AnimatedBuilder(
          animation: _portalController,
          builder: (context, child) {
            return Transform.scale(
              scale: _portalScale.value,
              child: Transform.rotate(
                angle: _portalRotation.value,
                child: Container(
                  width: 250.w,
                  height: 250.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        _acidGreen,
                        _portalGreen,
                        _rickBlue,
                        _dimensionPurple,
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.2, 0.5, 0.8, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _portalGreen.withOpacity(0.8),
                        blurRadius: 40.r,
                        spreadRadius: 10.r,
                      ),
                      BoxShadow(
                        color: _acidGreen.withOpacity(0.4),
                        blurRadius: 60.r,
                        spreadRadius: 20.r,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ...List.generate(3, (index) {
                        return Transform.rotate(
                          angle: _portalRotation.value * (index + 1) * 0.3,
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

  Widget _buildSecondaryPortals() {
    return Stack(
      children: [
        Positioned(
          top: 100.h,
          right: 50.w,
          child: AnimatedBuilder(
            animation: _portalController,
            builder: (context, child) {
              return Transform.rotate(
                angle: -_portalRotation.value * 0.7,
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        _rickBlue,
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _rickBlue.withOpacity(0.5),
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
            animation: _portalController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _portalRotation.value * 0.5,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        _dimensionPurple,
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _dimensionPurple.withOpacity(0.5),
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

  Widget _buildRickSilhouette() {
    return Positioned(
      right: 20.w,
      top: MediaQuery.of(context).size.height * 0.25,
      child: AnimatedBuilder(
        animation: _rickController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              _rickSlide.value * MediaQuery.of(context).size.width,
              0,
            ),
            child: Opacity(
              opacity: _rickController.value,
              child: SizedBox(
                width: 100.w,
                height: 160.h,
                child: Stack(
                  children: [
                    Container(
                      width: 100.w,
                      height: 140.h,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.r),
                          topRight: Radius.circular(50.r),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 20.h,
                      left: 10.w,
                      right: 10.w,
                      child: Container(
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: _rickLabCoat.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 60.h,
                      right: 5.w,
                      child: Container(
                        width: 20.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: _portalGreen,
                          borderRadius: BorderRadius.circular(3.r),
                          boxShadow: [
                            BoxShadow(
                              color: _portalGreen,
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

  Widget _buildTitleText() {
    return Positioned.fill(
      child: Center(
        child: AnimatedBuilder(
          animation: _textController,
          builder: (context, child) {
            return SlideTransition(
              position: _textSlide,
              child: FadeTransition(
                opacity: _textOpacity,
                child: Transform.scale(
                  scale: _textScale.value,
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
                              _portalGreen.withOpacity(0.3),
                              _rickBlue.withOpacity(0.3),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(
                            color: _portalGreen.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          'INTERDIMENSIONAL',
                          style: TextStyle(
                            fontSize: 22.spMax,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 2.w,
                            shadows: [
                              Shadow(
                                color: _portalGreen,
                                offset: const Offset(0, 0),
                                blurRadius: 8.r,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'CABLE REGISTRY',
                        style: TextStyle(
                          fontSize: 18.spMax,
                          fontWeight: FontWeight.w700,
                          color: _mortYellow,
                          letterSpacing: 1.5.w,
                          shadows: [
                            Shadow(
                              color: _mortYellow.withOpacity(0.8),
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

  Widget _buildSubtitle() {
    return Positioned(
      bottom: 100.h,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _textController,
        builder: (context, child) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: _textController,
                curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
              ),
            ),
            child: Center(
              child: Text(
                'Loading infinite realities...',
                style: TextStyle(
                  fontSize: 14.spMax,
                  fontWeight: FontWeight.w500,
                  color: _rickBlue,
                  letterSpacing: 1.w,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPortalParticles() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _particleController,
        builder: (context, child) {
          final centerX = MediaQuery.of(context).size.width / 2;
          final centerY = MediaQuery.of(context).size.height / 2;

          return Stack(
            children: List.generate(12, (index) {
              final angle = (index * 30.0) * (math.pi / 180);
              final radius =
                  120.w + math.sin(_particleRotation.value + index) * 15.w;
              final x =
                  centerX + math.cos(angle + _particleRotation.value) * radius;
              final y =
                  centerY + math.sin(angle + _particleRotation.value) * radius;

              return Positioned(
                left: x - 3.w,
                top: y - 3.w,
                child: Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: [
                      _portalGreen,
                      _rickBlue,
                      _mortYellow,
                      _dimensionPurple,
                    ][index % 4],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: [
                          _portalGreen,
                          _rickBlue,
                          _mortYellow,
                          _dimensionPurple,
                        ][index % 4],
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

  Widget _buildGlitchOverlay() {
    return AnimatedBuilder(
      animation: _glitchController,
      builder: (context, child) {
        if (_rickController.value < 0.8) return const SizedBox.shrink();

        return Transform.translate(
          offset: Offset(_glitchOffset.value, 0),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  _acidGreen.withOpacity(0.03),
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
