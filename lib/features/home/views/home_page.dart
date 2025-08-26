import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interdimensional_cable_registry/features/home/viewmodels/home/home_cubit.dart';
import 'package:interdimensional_cable_registry/features/home/viewmodels/home/home_state.dart';
import 'package:interdimensional_cable_registry/features/home/widgets/character_card.dart';
import 'package:interdimensional_cable_registry/features/home/widgets/pagination_widget.dart';

class HomePage extends StatefulWidget {
  final HomeCubit viewModel;
  const HomePage({super.key, required this.viewModel});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.getCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<HomeCubit, HomeState>(
        bloc: widget.viewModel,
        builder: (context, state) {
          if (state.status == HomeStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status == HomeStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error ?? 'Erro ao carregar dados'),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => widget.viewModel.getCharacters(),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final apiInfo = state.characters.isNotEmpty
              ? state.characters.first.apiInfo
              : null;

          return SafeArea(
            child: Column(
              children: [
                SizedBox(height: 40.h),
                Center(
                  child: Text(
                    'Interdimensional Cable Registry',
                    style: TextStyle(
                      fontSize: 20.spMax,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Expanded(
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
                      return CharacterCard(
                        imageUrl: character.image,
                        name: character.name,
                        onTap: () {},
                      );
                    },
                  ),
                ),
                SizedBox(height: 20.h),

                if (apiInfo != null) ...[
                  Text(
                    'Personagens nesta página: ${state.characters.length}',
                    style: TextStyle(fontSize: 14.spMax),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Total de personagens: ${apiInfo.count}',
                    style: TextStyle(fontSize: 14.spMax),
                  ),
                  SizedBox(height: 16.h),

                  PaginationWidget(
                    currentPage: state.currentPage,
                    totalPages: apiInfo.pages,
                    onPageChanged: widget.viewModel.goToPage,
                  ),
                ] else ...[
                  Text(
                    'Total de personagens: ${state.characters.length}',
                    style: TextStyle(fontSize: 16.spMax),
                  ),
                ],
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
