import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/app_theme.dart';
import '../providers/library_provider.dart';
import '../widgets/comics_grid.dart';
import '../widgets/continue_reading_row.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LibraryProvider>().loadComics();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LibraryProvider>(
        builder: (context, provider, _) {
          final filtered = _query.isEmpty
              ? provider.comics
              : provider.comics
                  .where((c) =>
                      c.title.toLowerCase().contains(_query.toLowerCase()))
                  .toList();

          return CustomScrollView(
            slivers: [
              _buildHeader(context, provider),
              _buildSearchBar(),
              if (provider.inProgress.isNotEmpty)
                SliverToBoxAdapter(
                  child: ContinueReadingRow(
                    comics: provider.inProgress,
                    onTap: (c) =>
                        Navigator.pushNamed(context, '/reader', arguments: c),
                  ),
                ),
              _buildGridHeader(context, filtered.length),
              if (provider.isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: InkwellColors.yellow)),
                )
              else if (filtered.isEmpty)
                SliverFillRemaining(child: _buildEmptyState(context))
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  sliver: ComicsGrid(
                    comics: filtered,
                    onComicTap: (c) =>
                        Navigator.pushNamed(context, '/detail', arguments: c),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildHeader(BuildContext context, LibraryProvider provider) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 70,
      backgroundColor: InkwellColors.yellow,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        title: Row(
          children: [
            Text(
              'INKWELL',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: InkwellColors.border,
                borderRadius: BorderRadius.zero,
                border: Border.all(color: InkwellColors.border, width: 2),
              ),
              child: Text(
                '${provider.comics.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: InkwellColors.textOnDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Container(
          decoration: BoxDecoration(
            color: InkwellColors.surface,
            border: Border.all(color: InkwellColors.border, width: 3),
            boxShadow: const [InkwellShadows.small],
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _query = v),
            style: const TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            decoration: const InputDecoration(
              hintText: 'BUSCAR CÓMICS...',
              hintStyle: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: InkwellColors.textMuted,
              ),
              prefixIcon: Icon(Icons.search, color: InkwellColors.textPrimary),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridHeader(BuildContext context, int count) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Row(
          children: [
            Text(
              'BIBLIOTECA',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 2),
            ),
            const Spacer(),
            Text(
              '$count CÓMICS',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'SIN CÓMICS',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'IMPORTA TU PRIMERA HISTORIA',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 32),
          _BrutalButton(
            label: 'IMPORTAR CÓMIC',
            onTap: () => _pickAndImport(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickAndImport(context),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: InkwellColors.yellow,
          border: Border.all(color: InkwellColors.border, width: 3),
          borderRadius: BorderRadius.zero,
          boxShadow: const [InkwellShadows.button],
        ),
        child: const Icon(Icons.add, color: InkwellColors.textPrimary, size: 28),
      ),
    );
  }

  Future<void> _pickAndImport(BuildContext context) async {
    final provider = context.read<LibraryProvider>();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['cbz', 'cbr', 'pdf'],
    );
    if (result == null || result.files.single.path == null) return;
    if (!mounted) return;
    await provider.import(result.files.single.path!);
  }
}

class _BrutalButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _BrutalButton({required this.label, required this.onTap});

  @override
  State<_BrutalButton> createState() => _BrutalButtonState();
}

class _BrutalButtonState extends State<_BrutalButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        transform: Matrix4.translationValues(_pressed ? 3 : 0, _pressed ? 3 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: InkwellColors.yellow,
          border: Border.all(color: InkwellColors.border, width: 3),
          boxShadow: _pressed ? [] : const [InkwellShadows.button],
        ),
        child: Text(
          widget.label,
          style: const TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: InkwellColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
