import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/animations.dart';
import '../../domain/entities/comic.dart';
import 'comic_card.dart';

class ComicsGrid extends StatelessWidget {
  final List<Comic> comics;
  final void Function(Comic) onComicTap;

  const ComicsGrid({
    super.key,
    required this.comics,
    required this.onComicTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final comic = comics[index];
          return ComicCard(
            comic: comic,
            colorIndex: index,
            onTap: () => onComicTap(comic),
          )
              .animate(delay: InkwellAnimations.stagger(index))
              .slideY(
                begin: -0.4,
                end: 0,
                duration: InkwellAnimations.slow,
                curve: InkwellAnimations.springy,
              )
              .fadeIn(duration: InkwellAnimations.normal);
        },
        childCount: comics.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
    );
  }
}
