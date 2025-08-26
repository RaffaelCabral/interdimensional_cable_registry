import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../constants/splash_constants.dart';
import '../widgets/splash_background.dart';
import '../widgets/portal_animation.dart';
import '../widgets/particle_system.dart';
import '../widgets/title_animation.dart';

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

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimationSequence();
  }

  void _setupAnimations() {
    _portalController = AnimationController(
      duration: SplashConstants.portalDuration,
      vsync: this,
    );

    _portalRotation = Tween<double>(begin: 0, end: 4 * math.pi).animate(
      CurvedAnimation(parent: _portalController, curve: Curves.easeInOut),
    );

    _portalScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _portalController, curve: Curves.elasticOut),
    );

    _textController = AnimationController(
      duration: SplashConstants.textDuration,
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
      duration: SplashConstants.particleDuration,
      vsync: this,
    );

    _particleRotation = Tween<double>(begin: 0, end: 8 * math.pi).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    _rickController = AnimationController(
      duration: SplashConstants.rickDuration,
      vsync: this,
    );

    _rickSlide = Tween<double>(begin: 1.5, end: 0).animate(
      CurvedAnimation(parent: _rickController, curve: Curves.easeOutBack),
    );

    _glitchController = AnimationController(
      duration: SplashConstants.glitchDuration,
      vsync: this,
    )..repeat(reverse: true);

    _glitchOffset = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _glitchController, curve: Curves.elasticInOut),
    );

    _finalController = AnimationController(
      duration: SplashConstants.finalDuration,
      vsync: this,
    );

    _finalFade = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _finalController, curve: Curves.easeInOut),
    );
  }

  void _startAnimationSequence() async {
    _portalController.forward();

    await Future.delayed(Duration(milliseconds: SplashConstants.animationDelays[0]));
    if (mounted) _textController.forward();

    await Future.delayed(Duration(milliseconds: SplashConstants.animationDelays[1]));
    if (mounted) _particleController.forward();

    await Future.delayed(Duration(milliseconds: SplashConstants.animationDelays[2]));
    if (mounted) _rickController.forward();

    await Future.delayed(Duration(milliseconds: SplashConstants.animationDelays[3]));
    if (mounted) _finalController.forward();

    await Future.delayed(Duration(milliseconds: SplashConstants.animationDelays[4]));
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
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const SplashBackground(),
                
                ParticleSystem(particleController: _particleController),

                SecondaryPortals(portalRotation: _portalRotation),

                PortalAnimation(
                  portalRotation: _portalRotation,
                  portalScale: _portalScale,
                ),

                RickSilhouette(
                  rickSlide: _rickSlide,
                  rickController: _rickController,
                ),

                PortalParticles(particleRotation: _particleRotation),

                TitleAnimation(
                  textOpacity: _textOpacity,
                  textScale: _textScale,
                  textSlide: _textSlide,
                  textController: _textController,
                ),

                SubtitleAnimation(textController: _textController),

                GlitchOverlay(
                  glitchController: _glitchController,
                  rickController: _rickController,
                  glitchOffset: _glitchOffset,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}
