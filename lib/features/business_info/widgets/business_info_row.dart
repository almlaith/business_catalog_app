import 'package:flutter/material.dart';

class BusinessInfoRow extends StatelessWidget {
  const BusinessInfoRow({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
      trailing: onTap == null ? null : const Icon(Icons.open_in_new),
      onTap: onTap,
    );
  }
}
