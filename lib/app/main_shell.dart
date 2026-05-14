import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../features/library/presentation/screens/library_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import 'theme/app_theme.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _pages = [
    LibraryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: _BrutalNavBar(
        currentIndex: _index,
        onTap: (i) {
          HapticFeedback.selectionClick();
          setState(() => _index = i);
        },
      ),
    );
  }
}

class _BrutalNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BrutalNavBar({required this.currentIndex, required this.onTap});

  static const _items = [
    _NavItem(icon: Icons.menu_book_rounded, label: 'BIBLIOTECA'),
    _NavItem(icon: Icons.settings,          label: 'AJUSTES'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: InkwellColors.background,
        border: Border(top: BorderSide(color: InkwellColors.border, width: 3)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(_items.length, (i) {
              final active = i == currentIndex;
              final isLast = i == _items.length - 1;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    decoration: BoxDecoration(
                      color: active ? InkwellColors.yellow : Colors.transparent,
                      border: Border(
                        right: isLast
                            ? BorderSide.none
                            : const BorderSide(
                                color: InkwellColors.border, width: 2),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _items[i].icon,
                          size: 22,
                          color: InkwellColors.textPrimary,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _items[i].label,
                          style: const TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: InkwellColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
