import 'package:business_catalog_app/core/constants/app_strings.dart';
import 'package:business_catalog_app/core/widgets/placeholder_screen.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(title: AppStrings.cartTitle);
  }
}
