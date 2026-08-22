import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_theme.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;

  const ProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    int columns;
    if (Breakpoints.isExpanded(width)) {
      columns = 4;
    } else if (Breakpoints.isMedium(width)) {
      columns = 3;
    } else if (!Breakpoints.isCompact(width)) {
      columns = 2;
    } else {
      columns = width < 420 ? 1 : 2;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) => ProductCard(product: products[index]),
    );
  }
}
