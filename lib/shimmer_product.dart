
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/b_colors.dart';

class ShimmerProduct extends StatelessWidget {
  const ShimmerProduct({super.key});

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 63) / 2;

    return Shimmer.fromColors(
      enabled: true,
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: BColors.primaryPureWhite,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              offset: const Offset(0, 1),
              color: BColors.secondarySoftGrey,
            ),
          ],
        ),
        height: 238,
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 156, width: width),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: BColors.primaryNavyBlack),
                  ),
                  Text(
                    '',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: BColors.secondaryRedVelvet),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
