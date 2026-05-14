import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../library/domain/entities/comic.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../providers/reader_provider.dart';

class ReaderScreen extends StatefulWidget {
  final Comic comic;
  const ReaderScreen({super.key, required this.comic});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<ReaderProvider>();
      await provider.openComic(widget.comic);
      if (mounted && provider.currentPage > 0) {
        _pageController.jumpToPage(provider.currentPage);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    context.read<ReaderProvider>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<ReaderProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: InkwellColors.yellow),
            );
          }
          if (provider.error != null || !provider.hasSession) {
            return _buildError(context, provider.error ?? 'Error al abrir cómic');
          }
          return Column(
            children: [
              _buildTopBar(context, provider),
              Expanded(child: _buildPageView(provider)),
              _buildControls(context, provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, ReaderProvider provider) {
    return Container(
      height: 56 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        color: InkwellColors.yellow,
        border: Border(bottom: BorderSide(color: InkwellColors.border, width: 3)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: InkwellColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              widget.comic.title.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              'PÁG. ${provider.currentPage + 1} DE ${provider.totalPages}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageView(ReaderProvider provider) {
    final session = provider.session!;
    final isRtl = context.read<SettingsProvider>().settings.readingDirection ==
        ReadingDirection.rtl;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: PageView.builder(
        controller: _pageController,
        reverse: isRtl,
        itemCount: session.totalPages,
        onPageChanged: (index) => provider.goToPage(index),
        itemBuilder: (context, index) {
          return _ComicPage(
            comic: widget.comic,
            pageName: session.pages[index],
          );
        },
      ),
    );
  }

  Widget _buildControls(BuildContext context, ReaderProvider provider) {
    final pct = provider.totalPages > 0
        ? provider.currentPage / provider.totalPages
        : 0.0;

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: InkwellColors.background,
        border: Border(top: BorderSide(color: InkwellColors.border, width: 3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: InkwellColors.progressBg,
              border: Border.all(color: InkwellColors.border, width: 2),
              boxShadow: const [InkwellShadows.small],
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: pct.clamp(0.0, 1.0),
              child: Container(color: InkwellColors.progressFill),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _NavButton(
                  label: 'ANTERIOR',
                  onTap: provider.currentPage > 0
                      ? () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                          );
                        }
                      : null,
                  highlighted: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _NavButton(
                  label: 'SIGUIENTE',
                  onTap: provider.currentPage < provider.totalPages - 1
                      ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                          );
                        }
                      : null,
                  highlighted: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('ERROR', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: InkwellColors.coverRed)),
          const SizedBox(height: 8),
          Text(message, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('VOLVER', style: TextStyle(color: InkwellColors.yellow)),
          ),
        ],
      ),
    );
  }
}

class _ComicPage extends StatefulWidget {
  final Comic comic;
  final String pageName;
  const _ComicPage({required this.comic, required this.pageName});

  @override
  State<_ComicPage> createState() => _ComicPageState();
}

class _ComicPageState extends State<_ComicPage> {
  late Future<List<int>?> _bytesFuture;

  @override
  void initState() {
    super.initState();
    _bytesFuture = context.read<ReaderProvider>().loadPageBytes(widget.pageName);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.comic.format == ComicFormat.pdf) {
      return Center(
        child: Text(
          'PÁG. ${int.parse(widget.pageName) + 1}',
          style: const TextStyle(color: Colors.white54),
        ),
      );
    }
    return FutureBuilder<List<int>?>(
      future: _bytesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: InkwellColors.yellow),
          );
        }
        if (!snapshot.hasData || snapshot.hasError || snapshot.data == null) {
          return const Center(
            child: Icon(Icons.broken_image, color: Colors.white54, size: 64),
          );
        }
        return PhotoView(
          imageProvider: MemoryImage(Uint8List.fromList(snapshot.data!)),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 4,
          backgroundDecoration: const BoxDecoration(color: Colors.black),
        );
      },
    );
  }
}

class _NavButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final bool highlighted;
  const _NavButton({required this.label, required this.onTap, required this.highlighted});

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final bg = widget.highlighted ? InkwellColors.yellow : InkwellColors.surface;

    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled
          ? (_) {
              setState(() => _pressed = false);
              HapticFeedback.lightImpact();
              widget.onTap!();
            }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        transform: Matrix4.translationValues(_pressed ? 3 : 0, _pressed ? 3 : 0, 0),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: enabled ? bg : InkwellColors.progressBg,
          border: Border.all(
            color: enabled ? InkwellColors.border : InkwellColors.textMuted,
            width: 3,
          ),
          boxShadow: (_pressed || !enabled) ? [] : const [InkwellShadows.button],
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: enabled ? InkwellColors.textPrimary : InkwellColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
