import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../domain/entities/comic.dart';

class ContinueReadingRow extends StatelessWidget {
  final List<Comic> comics;
  final void Function(Comic) onTap;

  const ContinueReadingRow({
    super.key,
    required this.comics,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text(
            'CONTINUAR',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  letterSpacing: 2,
                  color: InkwellColors.textPrimary,
                ),
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: comics.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                _ContinueCard(comic: comics[index], onTap: () => onTap(comics[index])),
          ),
        ),
      ],
    );
  }
}

class _ContinueCard extends StatelessWidget {
  final Comic comic;
  final VoidCallback onTap;

  const _ContinueCard({required this.comic, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final pct = comic.progress?.percentage(comic.totalPages) ?? 0.0;
    final bgColor = InkwellColors.coverColorFor(comic.title.length);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: InkwellColors.border, width: 3),
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [InkwellShadows.card],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _cover()),
            _progressSection(context, pct),
          ],
        ),
      ),
    );
  }

  Widget _cover() {
    final path = comic.coverImagePath;
    if (path.isNotEmpty && File(path).existsSync()) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(1)),
        child: Image.file(File(path), fit: BoxFit.cover, width: double.infinity),
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Text(
          comic.title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: InkwellColors.textOnDark,
          ),
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _progressSection(BuildContext context, double pct) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: InkwellColors.background,
        border: Border(top: BorderSide(color: InkwellColors.border, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${(pct * 100).toInt()}%',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: InkwellColors.progressBg,
              border: Border.all(color: InkwellColors.border, width: 1.5),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: pct.clamp(0.0, 1.0),
              child: Container(color: InkwellColors.progressFill),
            ),
          ),
        ],
      ),
    );
  }
}
