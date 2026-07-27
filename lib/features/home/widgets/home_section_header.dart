import 'package:business_catalog_app/core/widgets/aurora_components.dart';
import 'package:flutter/material.dart';

class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({required this.title, this.action, super.key});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return AuroraSectionHeader(title: title, action: action);
  }
}
