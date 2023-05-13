import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import 'product.dart';
import 'utils/b_colors.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final double? width;
  const ProductItem({required this.product, this.width, super.key});

  @override
  Widget build(BuildContext context) {
    bool isDiscounted = (product.discount ?? 0) != 0;

    return Center(
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
        width: width ?? 156,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExtendedImage.network(
              product.image.isNotEmpty ? product.image.first : 'https://nayemdevs.com/wp-content/uploads/2020/03/default-product-image.png',
              height: 156,
              width: width ?? 156,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: isDiscounted ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: BColors.primaryNavyBlack),
                  ),
                  Text(
                    'MNT. ${product.price - (product.discount ?? 0)}',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: BColors.secondaryRedVelvet),
                  ),
                  if (isDiscounted)
                    Text(
                      'MNT. ${product.price}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: BColors.secondaryHalfGrey,
                        decoration: TextDecoration.lineThrough,
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
}
