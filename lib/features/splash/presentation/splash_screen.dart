import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/theme/animations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _letters = ['I', 'N', 'K', 'W', 'E', 'L', 'L'];

  @override
  void initState() {
    super.initState();
    Future.delayed(InkwellAnimations.splash + const Duration(milliseconds: 300), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/library');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InkwellColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_letters.length, (i) {
                return Text(
                  _letters[i],
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 64,
                        letterSpacing: 4,
                      ),
                )
                    .animate(delay: Duration(milliseconds: 80 + i * 120))
                    .slideY(
                      begin: -1.5,
                      end: 0,
                      duration: InkwellAnimations.slow,
                      curve: InkwellAnimations.springy,
                    )
                    .fadeIn(duration: InkwellAnimations.normal);
              }),
            ),
            const SizedBox(height: 12),
            Container(
              height: 3,
              width: 260,
              color: InkwellColors.border,
            )
                .animate(delay: const Duration(milliseconds: 1100))
                .scaleX(
                  begin: 0,
                  end: 1,
                  duration: InkwellAnimations.normal,
                  curve: InkwellAnimations.snappy,
                ),
            const SizedBox(height: 14),
            Text(
              'COMIC READER',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 4),
            )
                .animate(delay: const Duration(milliseconds: 1200))
                .fadeIn(duration: InkwellAnimations.normal),
          ],
        ),
      ),
    );
  }
}
