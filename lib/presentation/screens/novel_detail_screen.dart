import 'dart:convert';
import 'package:flutter/material.dart';
import '../../domain/entities/novel.dart';

class NovelDetailScreen extends StatelessWidget {
  final Novel novel;

  const NovelDetailScreen({super.key, required this.novel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(novel.titleEnglish, overflow: TextOverflow.ellipsis),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 12),
            Text('Penulis: ${novel.author}', style: theme.textTheme.titleMedium),
            Text(
              'Status: ${novel.status} • Ch. Terakhir: ${novel.currentChapter}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.star, color: Colors.amber),
                title: const Text('Rating Novel'),
                subtitle: Text('${novel.ratingValue} ★'),
              ),
            ),
            const SizedBox(height: 8),
            _infoCard(
              theme,
              icon: Icons.person,
              iconColor: Colors.blue,
              title: 'Nama & Kepribadian MC',
              content: '${novel.mcName} (${novel.mcPersonality})',
            ),
            const SizedBox(height: 8),
            _infoCard(
              theme,
              icon: Icons.bolt,
              iconColor: Colors.amber,
              title: 'Kemampuan MC',
              content: novel.mcAbilities,
            ),
            const SizedBox(height: 8),
            _infoCard(
              theme,
              icon: Icons.public,
              iconColor: Colors.green,
              title: 'Setting & Lore Dunia',
              content: novel.worldLore,
            ),
            const SizedBox(height: 8),
            _infoCard(
              theme,
              icon: Icons.auto_awesome,
              iconColor: Colors.purple,
              title: 'Ekspektasi Cerita Selanjutnya',
              content: novel.nextExpectation,
            ),
            if (novel.dropReason != null && novel.dropReason!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              _infoCard(
                theme,
                icon: Icons.cancel_outlined,
                iconColor: Colors.red,
                title: 'Alasan Drop',
                content: novel.dropReason!,
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
    ThemeData theme, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(content),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    if (novel.imageUrl.startsWith('data:image')) {
      try {
        final base64Str = novel.imageUrl.split(',').last;
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            base64Decode(base64Str),
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _buildPlaceholderHeader(theme),
          ),
        );
      } catch (_) {
        return _buildPlaceholderHeader(theme);
      }
    }

    if (novel.imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          novel.imageUrl,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _buildPlaceholderHeader(theme),
        ),
      );
    }

    return _buildPlaceholderHeader(theme);
  }

  Widget _buildPlaceholderHeader(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '📖 ${novel.titleEnglish}',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (novel.titleOriginal.isNotEmpty)
            Text(
              '(${novel.titleOriginal})',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }
}