import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interdimensional_cable_registry/features/home/enums/enums.dart';

class CharacterCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final CharStatus? status;
  final String? species;
  final String? lastKnownLocation;
  final String? firstSeenIn;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const CharacterCard({
    super.key,
    required this.imageUrl,
    required this.name,
    this.status,
    this.species,
    this.lastKnownLocation,
    this.firstSeenIn,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.symmetric(horizontal: 10.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF3C3C3C),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: Colors.grey.shade600,
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: SizedBox(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade700,
                          child: Icon(
                            Icons.person,
                            color: Colors.grey.shade500,
                            size: 40.sp,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 16.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16.spMax,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (status != null) ...[
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(status!),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            status!.name,
                            style: TextStyle(
                              fontSize: 12.spMax,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                      if (species != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          species!,
                          style: TextStyle(
                            fontSize: 12.spMax,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(CharStatus status) {
    switch (status) {
      case CharStatus.alive:
        return const Color(0xFF57EBA1); // Green
      case CharStatus.dead:
        return const Color(0xFFEB5757); // Red
      case CharStatus.unknown:
        return const Color(0xFFF2C94C); // Yellow
    }
  }
}
