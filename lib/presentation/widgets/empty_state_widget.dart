import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onReset;
  final String title;
  final String subtitle;
  final String buttonLabel;

  const EmptyStateWidget({
    super.key,
    required this.onReset,
    this.title = 'Novel tidak ditemukan',
    this.subtitle = 'Coba ubah kata kunci pencarian atau bersihkan filter.',
    this.buttonLabel = 'Reset Filter',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: theme.colorScheme.secondary),
            const SizedBox(height: 12),
            Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(subtitle, textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh, size: 16),
              label: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}