import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.automaticallyImplyLeading = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: automaticallyImplyLeading,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              subtitle ?? context.l10n.placeholderLabel,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (actions.isNotEmpty) ...[const SizedBox(height: 24), ...actions],
          ],
        ),
      ),
    );
  }
}
