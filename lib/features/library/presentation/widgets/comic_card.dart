import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/theme/app_theme.dart';
import '../../domain/entities/comic.dart';

class ComicCard extends StatefulWidget {
  final Comic comic;
  final VoidCallback onTap;
  final int colorIndex;

  const ComicCard({
    super.key,
    required this.comic,
    required this.onTap,
    required this.colorIndex,
  });

  @override
  State<ComicCard> createState() => _ComicCardState();
}

class _ComicCardState extends State<ComicCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = InkwellColors.coverColorFor(widget.colorIndex);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        transform: Matrix4.translationValues(
          _pressed ? 4 : 0,
          _pressed ? 4 : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: InkwellColors.border, width: 3),
          borderRadius: BorderRadius.circular(4),
          boxShadow: _pressed
              ? []
              : const [BoxShadow(color: InkwellColors.shadow, offset: Offset(4, 4))],
        ),
        child: Stack(
          children: [
            _buildCover(),
            if (widget.comic.isNew) _buildNewBadge(),
            if (widget.comic.isInProgress) _buildProgressBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildCover() {
    final path = widget.comic.coverImagePath;
    final child = path.isNotEmpty && File(path).existsSync()
        ? ClipRRect(
            borderRadius: BorderRadius.circular(1),
            child: Image.file(
              File(path),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          )
        : Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                widget.comic.title.toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: InkwellColors.textOnDark,
                      shadows: [const Shadow(color: Colors.black45, blurRadius: 4)],
                    ),
              ),
            ),
          );

    return Hero(
      tag: 'cover_${widget.comic.id}',
      child: child,
    );
  }

  Widget _buildNewBadge() {
    return Positioned(
      top: 6,
      right: 6,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: InkwellColors.badgeNew,
          border: Border.all(color: InkwellColors.border, width: 2),
          borderRadius: BorderRadius.zero,
        ),
        child: const Text(
          'NEW',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: InkwellColors.textOnDark,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = widget.comic.progress!;
    final pct = progress.percentage(widget.comic.totalPages);
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 6,
        decoration: const BoxDecoration(
          color: InkwellColors.progressBg,
          border: Border(top: BorderSide(color: InkwellColors.border, width: 2)),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: pct.clamp(0.0, 1.0),
          child: Container(color: InkwellColors.progressFill),
        ),
      ),
    );
  }
}
