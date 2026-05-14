import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/app_theme.dart';
import '../../domain/entities/app_settings.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AJUSTES')),
      body: Consumer<SettingsProvider>(
        builder: (context, provider, _) => ListView(
          children: [
            _SectionHeader(label: 'LECTURA'),
            _ToggleRow(
              label: 'Dirección RTL',
              subtitle: 'Leer de derecha a izquierda (manga)',
              value: provider.settings.readingDirection == ReadingDirection.rtl,
              onChanged: (v) => provider.update(
                provider.settings.copyWith(
                  readingDirection: v ? ReadingDirection.rtl : ReadingDirection.ltr,
                ),
              ),
            ),
            _SectionHeader(label: 'APARIENCIA'),
            _ToggleRow(
              label: 'Tema Sepia',
              subtitle: 'Fondo sepia para reducir fatiga visual',
              value: provider.settings.theme == AppTheme.sepia,
              onChanged: (v) => provider.update(
                provider.settings.copyWith(
                  theme: v ? AppTheme.sepia : AppTheme.normal,
                ),
              ),
            ),
            _SectionHeader(label: 'SOBRE LA APP'),
            _InfoRow(label: 'Versión', value: '0.1.0'),
            _InfoRow(label: 'Formatos', value: 'CBZ • CBR • PDF'),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: const BoxDecoration(
        color: InkwellColors.yellow,
        border: Border.symmetric(
          horizontal: BorderSide(color: InkwellColors.border, width: 3),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 2),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: InkwellColors.border, width: 2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 2),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => onChanged(!value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 48,
                height: 28,
                decoration: BoxDecoration(
                  color: value ? InkwellColors.yellow : InkwellColors.progressBg,
                  border: Border.all(color: InkwellColors.border, width: 3),
                  borderRadius: BorderRadius.zero,
                ),
                child: Align(
                  alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 20,
                    height: 22,
                    color: InkwellColors.border,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: InkwellColors.border, width: 2),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
