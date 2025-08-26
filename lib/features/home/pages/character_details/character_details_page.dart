// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interdimensional_cable_registry/features/home/enums/enums.dart';
import 'package:interdimensional_cable_registry/features/home/models/character_model.dart';
import 'package:interdimensional_cable_registry/features/home/pages/character_details/character_details_cubit.dart';
import 'package:interdimensional_cable_registry/features/home/pages/character_details/character_details_state.dart';

class CharacterDetailsPage extends StatefulWidget {
  final int characterId;
  const CharacterDetailsPage({super.key, required this.characterId});

  @override
  State<CharacterDetailsPage> createState() => _CharacterDetailsPageState();
}

class _CharacterDetailsPageState extends State<CharacterDetailsPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _portalController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _portalAnimation;
  late CharacterDetailsCubit viewModel;

  static const Color _spaceDark = Color(0xFF0A0A0A);
  static const Color _rickMortyGreen = Color(0xFF44C855);
  static const Color _rickMortyBlue = Color(0xFF00A8E6);
  static const Color _rickMortyYellow = Color(0xFFFFE135);
  static const Color _rickMortyPurple = Color(0xFF8B5CF6);
  static const Color _darkGray = Color(0xFF1A1A1A);
  static const Color _cardBg = Color(0xFF2D2D2D);

  @override
  void initState() {
    super.initState();

    viewModel = Modular.get<CharacterDetailsCubit>();
    viewModel.getCharacterDetails(widget.characterId);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _portalController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );

    _portalAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_portalController);

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _portalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CharacterDetailsCubit, CharacterDetailsState>(
        bloc: viewModel,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: _spaceDark,
            extendBodyBehindAppBar: true,
            appBar: _buildAppBar(context),
            body: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [
                    _darkGray,
                    _spaceDark,
                    Colors.black,
                  ],
                ),
              ),
              child: _buildBody(context, state),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: _cardBg.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: _rickMortyGreen.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: _rickMortyGreen.withOpacity(0.2),
              blurRadius: 8.r,
              spreadRadius: 1.r,
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: _rickMortyGreen,
            size: 20.sp,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _rickMortyGreen.withOpacity(0.8),
              _rickMortyBlue.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: _rickMortyGreen.withOpacity(0.3),
              blurRadius: 10.r,
              spreadRadius: 1.r,
            ),
          ],
        ),
        child: Text(
          'Portal de Detalhes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.spMax,
            fontWeight: FontWeight.w700,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                offset: Offset(0, 1.h),
                blurRadius: 2.r,
              ),
            ],
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context, CharacterDetailsState state) {
    switch (state.status) {
      case CharacterDetailsStatus.loading:
        return _buildLoadingScreen();

      case CharacterDetailsStatus.error:
        return _buildErrorScreen(state);

      case CharacterDetailsStatus.success:
        final character = state.character;
        if (character == null) {
          return _buildNotFoundScreen();
        }
        return _buildCharacterDetails(character);

      case CharacterDetailsStatus.initial:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _portalAnimation,
            builder: (context, child) {
              return Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _rickMortyGreen.withOpacity(0.9),
                      _rickMortyBlue.withOpacity(0.7),
                      _rickMortyPurple.withOpacity(0.5),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.4, 0.7, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _rickMortyGreen.withOpacity(0.6),
                      blurRadius: 30.r * (1 + _portalAnimation.value * 0.5),
                      spreadRadius: 8.r,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: _portalAnimation.value * 2 * 3.14159,
                      child: Container(
                        width: 60.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.8),
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                    Transform.rotate(
                      angle: -_portalAnimation.value * 2 * 3.14159,
                      child: Icon(
                        Icons.auto_awesome,
                        size: 30.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 32.h),
          Text(
            'Escaneando dimensões...',
            style: TextStyle(
              color: _rickMortyGreen,
              fontSize: 18.spMax,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Localizando personagem',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14.spMax,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen(CharacterDetailsState state) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.red.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.3),
              blurRadius: 20.r,
              spreadRadius: 2.r,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 64.sp,
                color: Colors.red.shade400,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Aw, geez Rick!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.spMax,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Falha na conexão interdimensional',
              style: TextStyle(
                color: _rickMortyYellow,
                fontSize: 16.spMax,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              state.error ?? 'Tente acessar outra dimensão',
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 14.spMax,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => Modular.get<CharacterDetailsCubit>()
                  .getCharacterDetails(widget.characterId),
              style: ElevatedButton.styleFrom(
                backgroundColor: _rickMortyGreen,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
                elevation: 8,
                shadowColor: _rickMortyGreen.withOpacity(0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh_rounded, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Reabrir Portal',
                    style: TextStyle(
                      fontSize: 16.spMax,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFoundScreen() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: _rickMortyPurple.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64.sp,
              color: _rickMortyPurple,
            ),
            SizedBox(height: 16.h),
            Text(
              'Personagem não encontrado',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.spMax,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Pode ter sido apagado da realidade',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14.spMax,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterDetails(Character character) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: kToolbarHeight + 40.h,
            bottom: 32.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCharacterHeader(character),
              SizedBox(height: 32.h),
              _buildInfoSection('Dados Biológicos', [
                _buildInfoRow(
                  'Status',
                  character.status.name,
                  _getStatusColor(character.status),
                ),
                _buildInfoRow('Espécie', character.species, _rickMortyGreen),
                _buildInfoRow(
                  'Tipo',
                  character.type.isEmpty ? 'Padrão' : character.type,
                  _rickMortyBlue,
                ),
                _buildInfoRow('Gênero', character.gender, _rickMortyYellow),
              ], Icons.science_rounded),
              SizedBox(height: 20.h),
              _buildInfoSection('Coordenadas Dimensionais', [
                _buildInfoRow(
                  'Origem',
                  character.origin.name,
                  _rickMortyYellow,
                ),
                _buildInfoRow(
                  'Última localização',
                  character.location.name,
                  _rickMortyPurple,
                ),
              ], Icons.location_on_rounded),
              SizedBox(height: 20.h),
              _buildEpisodesSection(character),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterHeader(Character character) {
    return Center(
      child: Column(
        children: [
          Hero(
            tag: 'character-${character.id}',
            child: Container(
              width: 400.w,
              height: 400.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                gradient: LinearGradient(
                  colors: [
                    _rickMortyGreen.withOpacity(0.3),
                    _rickMortyBlue.withOpacity(0.3),
                    _rickMortyPurple.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _rickMortyGreen.withOpacity(0.4),
                    blurRadius: 30.r,
                    spreadRadius: 5.r,
                  ),
                  BoxShadow(
                    color: _rickMortyBlue.withOpacity(0.2),
                    blurRadius: 50.r,
                    spreadRadius: 10.r,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.network(
                    character.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: _cardBg,
                        child: Icon(
                          Icons.person_rounded,
                          size: 100.sp,
                          color: Colors.grey.shade400,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),

            child: Text(
              character.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.spMax,
                fontWeight: FontWeight.w900,
                shadows: [
                  Shadow(
                    color: _rickMortyGreen.withOpacity(0.5),
                    offset: Offset(0, 2.h),
                    blurRadius: 4.r,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children, IconData icon) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: _cardBg.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: _rickMortyGreen.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _rickMortyGreen.withOpacity(0.1),
            blurRadius: 15.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: _rickMortyGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  color: _rickMortyGreen,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: TextStyle(
                  color: _rickMortyGreen,
                  fontSize: 18.spMax,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: valueColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 350.w,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14.spMax,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 15.spMax,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodesSection(Character character) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: _cardBg.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: _rickMortyPurple.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _rickMortyPurple.withOpacity(0.1),
            blurRadius: 15.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: _rickMortyPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.tv_rounded,
                  color: _rickMortyPurple,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Episódios',
                style: TextStyle(
                  color: _rickMortyPurple,
                  fontSize: 18.spMax,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: _rickMortyPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${character.episode.length}',
                  style: TextStyle(
                    color: _rickMortyPurple,
                    fontSize: 16.spMax,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (character.episode.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: _rickMortyPurple.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: character.episode.asMap().entries.map((entry) {
                  final index = entry.key;
                  final episodeUrl = entry.value;
                  final episodeNumber = episodeUrl.split('/').last;

                  return Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _rickMortyPurple.withOpacity(0.1),
                          _rickMortyBlue.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: _rickMortyPurple.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28.w,
                          height: 28.w,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [_rickMortyPurple, _rickMortyBlue],
                            ),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.spMax,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            'Episódio $episodeNumber',
                            style: TextStyle(
                              color: Colors.grey.shade200,
                              fontSize: 14.spMax,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(CharStatus status) {
    switch (status) {
      case CharStatus.alive:
        return _rickMortyGreen;
      case CharStatus.dead:
        return Colors.red.shade400;
      case CharStatus.unknown:
        return Colors.orange.shade400;
    }
  }
}
