// ignore_for_file: deprecated_member_use, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interdimensional_cable_registry/features/home/pages/home/home_cubit.dart';
import 'package:interdimensional_cable_registry/features/home/pages/home/home_state.dart';
import 'package:interdimensional_cable_registry/features/home/widgets/character_card.dart';
import 'package:interdimensional_cable_registry/features/home/widgets/pagination_widget.dart';

class HomePage extends StatefulWidget {
  final HomeCubit viewModel;
  const HomePage({super.key, required this.viewModel});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _titleAnimationController;
  late Animation<double> _titleAnimation;
  late AnimationController _particleController;

  static const Color _spaceDark = Color(0xFF0A0A0A);
  static const Color _rickMortyGreen = Color(0xFF44C855);
  static const Color _rickMortyBlue = Color(0xFF00A8E6);
  static const Color _rickMortyYellow = Color(0xFFFFE135);
  static const Color _rickMortyPurple = Color(0xFF8B5CF6);
  static const Color _darkGray = Color(0xFF1A1A1A);

  @override
  void initState() {
    super.initState();
    widget.viewModel.getCharacters();

    _titleAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _titleAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _titleAnimationController.forward();
  }

  @override
  void dispose() {
    _titleAnimationController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _spaceDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [
              _darkGray,
              _spaceDark,
              Colors.black,
            ],
          ),
        ),
        child: BlocBuilder<HomeCubit, HomeState>(
          bloc: widget.viewModel,
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              return _buildLoadingScreen();
            }

            if (state.status == HomeStatus.error) {
              return _buildErrorScreen(state);
            }

            final apiInfo = state.characters.isNotEmpty
                ? state.characters.first.apiInfo
                : null;

            return SafeArea(
              child: Column(
                children: [
                  _buildAnimatedTitle(),
                  Image.asset('assets/images/rick_and_morty.jpg'),
                  _buildCharacterGrid(state),
                  SizedBox(height: 20.h),
                  _buildFooterInfo(state, apiInfo),
                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _rickMortyGreen.withOpacity(0.8),
                      _rickMortyBlue.withOpacity(0.6),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.7, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _rickMortyGreen.withOpacity(0.5),
                      blurRadius: 20.r * (1 + _particleController.value * 0.5),
                      spreadRadius: 5.r,
                    ),
                  ],
                ),
                child: Transform.rotate(
                  angle: _particleController.value * 2 * 3.14159,
                  child: Icon(
                    Icons.sync,
                    size: 40.sp,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 24.h),
          Text(
            'Abrindo portal interdimensional...',
            style: TextStyle(
              color: _rickMortyGreen,
              fontSize: 16.spMax,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen(HomeState state) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: _darkGray,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.red.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.2),
              blurRadius: 10.r,
              spreadRadius: 2.r,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48.sp,
              color: Colors.red.shade400,
            ),
            SizedBox(height: 16.h),
            Text(
              'Aw, geez! Algo deu errado...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.spMax,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              state.error ?? 'Erro ao carregar personagens',
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 14.spMax,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () => widget.viewModel.getCharacters(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _rickMortyGreen,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
                elevation: 8,
                shadowColor: _rickMortyGreen.withOpacity(0.5),
              ),
              child: Text(
                'Tentar novamente',
                style: TextStyle(
                  fontSize: 16.spMax,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedTitle() {
    return AnimatedBuilder(
      animation: _titleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _titleAnimation.value,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 1.h),
            // decoration: BoxDecoration(
            //   gradient: const LinearGradient(
            //     colors: [
            //       _rickMortyGreen,
            //       _rickMortyBlue,
            //       _rickMortyPurple,
            //     ],
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //   ),
            //   borderRadius: BorderRadius.circular(15.r),
            //   boxShadow: [
            //     BoxShadow(
            //       color: _rickMortyGreen.withOpacity(0.3),
            //       blurRadius: 15.r,
            //       spreadRadius: 2.r,
            //     ),
            //   ],
            // ),
            child: Text(
              'Interdimensional Cable Registry',
              style: TextStyle(
                fontSize: 20.spMax,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(0, 2.h),
                    blurRadius: 4.r,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCharacterGrid(HomeState state) {
    return Expanded(
      child: AnimatedOpacity(
        opacity: state.status == HomeStatus.success ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        child: GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 2.0,
          ),
          itemCount: state.characters.length,
          itemBuilder: (context, index) {
            final character = state.characters[index];
            return AnimatedContainer(
              duration: Duration(milliseconds: 300 + (index * 100)),
              curve: Curves.easeOutBack,
              child: CharacterCard(
                imageUrl: character.image,
                name: character.name,

                lastKnownLocation: character.location.name,
                firstSeenIn: character.origin.name,
                onTap: () {
                  Modular.to.pushNamed('/home/character/${character.id}');
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFooterInfo(HomeState state, dynamic apiInfo) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),

      decoration: BoxDecoration(
        color: _darkGray.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _rickMortyBlue.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _rickMortyBlue.withOpacity(0.1),
            blurRadius: 8.r,
            spreadRadius: 1.r,
          ),
        ],
      ),
      child: Column(
        children: [
          if (apiInfo != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoChip(
                  'Nesta página',
                  '${state.characters.length}',
                  _rickMortyYellow,
                ),
                SizedBox(width: 16.w),
                PaginationWidget(
                  currentPage: state.currentPage,
                  totalPages: apiInfo.pages,
                  onPageChanged: widget.viewModel.goToPage,
                ),
                SizedBox(width: 16.w),
                _buildInfoChip(
                  'Total',
                  '${apiInfo.count}',
                  _rickMortyGreen,
                ),
              ],
            ),
          ] else ...[
            _buildInfoChip(
              'Total de personagens',
              '${state.characters.length}',
              _rickMortyGreen,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 12.spMax,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16.spMax,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
