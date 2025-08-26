// ignore_for_file: deprecated_member_use, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? activeTextColor;
  final Color? inactiveTextColor;
  final Color? activeBorderColor;
  final Color? inactiveBorderColor;
  final double? buttonSpacing;
  final EdgeInsetsGeometry? buttonPadding;
  final double? fontSize;
  final int maxVisiblePages;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.activeColor,
    this.inactiveColor,
    this.activeTextColor,
    this.inactiveTextColor,
    this.activeBorderColor,
    this.inactiveBorderColor,
    this.buttonSpacing,
    this.buttonPadding,
    this.fontSize,
    this.maxVisiblePages = 7,
  });

  static const Color _rickMortyGreen = Color(0xFF44C855);
  static const Color _rickMortyBlue = Color(0xFF00A8E6);
  static const Color _rickMortyDark = Color(0xFF1A1A1A);
  static const Color _rickMortyGray = Color(0xFF2D2D2D);
  static const Color _rickMortyYellow = Color(0xFFFFE135);
  static const Color _rickMortyPurple = Color(0xFF8B5CF6);

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildPaginationItems(),
    );
  }

  List<Widget> _buildPaginationItems() {
    final List<Widget> paginationItems = [];

    paginationItems.add(
      _buildPageButton(
        1,
        currentPage == 1,
      ),
    );

    if (totalPages <= maxVisiblePages) {
      for (int i = 2; i <= totalPages; i++) {
        paginationItems.add(
          _buildPageButton(
            i,
            currentPage == i,
          ),
        );
      }
    } else {
      if (currentPage <= 4) {
        for (int i = 2; i <= 5; i++) {
          paginationItems.add(
            _buildPageButton(
              i,
              currentPage == i,
            ),
          );
        }
        paginationItems.add(_buildEllipsis());
        paginationItems.add(
          _buildPageButton(
            totalPages,
            false,
          ),
        );
      } else if (currentPage >= totalPages - 3) {
        paginationItems.add(_buildEllipsis());
        for (int i = totalPages - 4; i <= totalPages; i++) {
          paginationItems.add(
            _buildPageButton(
              i,
              currentPage == i,
            ),
          );
        }
      } else {
        paginationItems.add(_buildEllipsis());
        for (int i = currentPage - 1; i <= currentPage + 1; i++) {
          paginationItems.add(
            _buildPageButton(
              i,
              currentPage == i,
            ),
          );
        }
        paginationItems.add(_buildEllipsis());
        paginationItems.add(
          _buildPageButton(
            totalPages,
            false,
          ),
        );
      }
    }

    return paginationItems;
  }

  Widget _buildPageButton(int page, bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: buttonSpacing ?? 4.w),
      child: InkWell(
        onTap: () => onPageChanged(page),
        borderRadius: BorderRadius.circular(
          12.r,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding:
              buttonPadding ??
              EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            gradient: isCurrentPage
                ? LinearGradient(
                    colors: [
                      activeColor ?? _rickMortyGreen,
                      (activeColor ?? _rickMortyGreen).withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: !isCurrentPage ? (inactiveColor ?? _rickMortyGray) : null,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isCurrentPage
                  ? (activeBorderColor ?? _rickMortyBlue)
                  : (inactiveBorderColor ?? _rickMortyGray.withOpacity(0.5)),
              width: isCurrentPage ? 2 : 1,
            ),
            boxShadow: isCurrentPage
                ? [
                    BoxShadow(
                      color: (activeColor ?? _rickMortyGreen).withOpacity(0.3),
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
                    ),
                  ]
                : null,
          ),
          child: Text(
            '$page',
            style: TextStyle(
              color: isCurrentPage
                  ? (activeTextColor ?? Colors.white)
                  : (inactiveTextColor ?? Colors.grey.shade300),
              fontWeight: isCurrentPage ? FontWeight.w700 : FontWeight.w500,
              fontSize: fontSize ?? 14.spMax,
              shadows: isCurrentPage
                  ? [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, 1.h),
                        blurRadius: 2.r,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: buttonSpacing ?? 4.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      child: Text(
        '•••',
        style: TextStyle(
          color: _rickMortyBlue,
          fontSize: (fontSize ?? 14.spMax) + 2,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.w,
        ),
      ),
    );
  }
}
