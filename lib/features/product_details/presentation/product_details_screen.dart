import 'package:business_catalog_app/core/constants/app_strings.dart';
import 'package:business_catalog_app/core/widgets/placeholder_screen.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: AppStrings.productDetailsTitle,
      subtitle: productId,
    );
  }
}
