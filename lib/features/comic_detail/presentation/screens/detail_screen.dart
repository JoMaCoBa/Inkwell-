import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../library/domain/entities/comic.dart';

class DetailScreen extends StatelessWidget {
  final Comic comic;
  const DetailScreen({super.key, required this.comic});

  @override
  Widget build(BuildContext context) {
    final bgColor = InkwellColors.coverColorFor(comic.title.length);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildCoverAppBar(context, bgColor),
          SliverToBoxAdapter(child: _buildTitleBar(context)),
          SliverToBoxAdapter(child: _buildStats(context)),
          SliverToBoxAdapter(child: _buildFormatBadge(context)),
          SliverToBoxAdapter(child: _buildCTA(context)),
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }

  Widget _buildCoverAppBar(BuildContext context, Color bgColor) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: InkwellColors.yellow,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: InkwellColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            _buildCoverImage(bgColor),
            // Halftone dots overlay
            Positioned.fill(
              child: CustomPaint(painter: _HalftonePainter()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage(Color bgColor) {
    final path = comic.coverImagePath;
    if (path.isNotEmpty && File(path).existsSync()) {
      return Hero(
        tag: 'cover_${comic.id}',
        child: Image.file(File(path), fit: BoxFit.cover),
      );
    }
    return Hero(
      tag: 'cover_${comic.id}',
      child: Container(color: bgColor),
    );
  }

  Widget _buildTitleBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: InkwellColors.yellow,
        border: Border.symmetric(
          horizontal: BorderSide(color: InkwellColors.border, width: 3),
        ),
      ),
      child: Text(
        comic.title.toUpperCase(),
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    final progress = comic.progress;
    final pct = progress != null
        ? '${(progress.percentage(comic.totalPages) * 100).toInt()}%'
        : '0%';

    return IntrinsicHeight(
      child: Row(
        children: [
          _StatCell(label: 'PÁGINAS', value: '${comic.totalPages}', context: context),
          const VerticalDivider(color: InkwellColors.border, width: 2, thickness: 2),
          _StatCell(label: 'LEÍDO', value: pct, context: context),
          const VerticalDivider(color: InkwellColors.border, width: 2, thickness: 2),
          _StatCell(
            label: 'FORMATO',
            value: comic.format.name.toUpperCase(),
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildFormatBadge(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _Badge(label: comic.format.name.toUpperCase(), color: InkwellColors.badgeInfo),
          if (comic.isNew) const _Badge(label: 'NEW', color: InkwellColors.badgeNew),
          if (comic.isFinished) const _Badge(label: 'TERMINADO', color: InkwellColors.coverTeal),
        ],
      ),
    );
  }

  Widget _buildCTA(BuildContext context) {
    final label = comic.isNew ? 'LEER AHORA' : 'CONTINUAR LECTURA';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
      child: _CTAButton(
        label: label,
        onTap: () => Navigator.pushNamed(context, '/reader', arguments: comic),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final BuildContext context;

  const _StatCell({
    required this.label,
    required this.value,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: InkwellColors.border, width: 2),
        borderRadius: BorderRadius.zero,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: InkwellColors.textPrimary,
        ),
      ),
    );
  }
}

class _CTAButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _CTAButton({required this.label, required this.onTap});

  @override
  State<_CTAButton> createState() => _CTAButtonState();
}

class _CTAButtonState extends State<_CTAButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        HapticFeedback.mediumImpact();
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        transform: Matrix4.translationValues(_pressed ? 5 : 0, _pressed ? 5 : 0, 0),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: InkwellColors.yellow,
          border: Border.all(color: InkwellColors.border, width: 3),
          boxShadow: _pressed
              ? []
              : const [BoxShadow(color: InkwellColors.shadow, offset: Offset(5, 5))],
        ),
        child: Center(
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class _HalftonePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    const spacing = 12.0;
    const radius = 2.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
