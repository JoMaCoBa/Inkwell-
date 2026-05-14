# Inkwell — Comic Reader App

## Vision
Inkwell is a **premium comic reader for Android** built with Flutter. The goal is to create an app so visually stunning that users feel the excitement of comics before they even open one. Every screen should feel like stepping into a comic book store — alive, vibrant, and full of personality.

> "If the app itself doesn't make you want to read comics, we haven't done our job."

---

## Design Philosophy

### Aesthetic Direction: Neo-Brutalism
La UI de Inkwell sigue el estilo **Neo-Brutalism** — raw, bold, sin pretensiones. Cómics y brutalismo son la combinación perfecta: ambos abrazan el contraste agresivo, los bordes duros y la energía visual sin filtros.

**Principios fundamentales:**
- **Fondo crema** — `#FFFDF7` como base. Evoca papel de cómic antiguo, no blanco puro ni negro
- **Bordes sólidos de 3px en `#111111`** en absolutamente todo — cards, botones, inputs, nav, separadores
- **Box-shadow offset** — `4px 4px 0 #111111` en cards y botones. Es LA firma del neo-brutalism
- **Amarillo primario** — `#FFE500` como acento dominante (header, botón CTA, tab activo, progress fill)
- **Colores planos y saturados** para portadas — `#FF6B6B`, `#4ECDC4`, `#A78BFA`, `#FF9F43`, `#48CAE4`. Sin gradientes
- **Tipografía doble personalidad** — `Bangers` para títulos/números (energía de cómic), `Space Grotesk 700` para UI (raw y técnico)
- **Todo en mayúsculas** en labels de navegación, badges, tags, encabezados de sección
- **Sin border-radius suave** — esquinas en `4px` máximo. Nada de pills ni rounded moderno

### Reglas de componentes

**Cards de cómic:**
```
border: 3px solid #111
box-shadow: 4px 4px 0 #111
border-radius: 4px
background: color plano saturado (sin gradiente)
```

**Botones:**
```
border: 3px solid #111
box-shadow: 3px 3px 0 #111
border-radius: 0
font: Space Grotesk 700, uppercase
// Al presionar: translate(3px, 3px) + box-shadow 0 — efecto "hundir"
```

**Progress bars:**
```
height: 6-8px
border: 2px solid #111
box-shadow: 2px 2px 0 #111
fill: #FFE500
border-radius: 0
```

**Bottom navigation:**
```
border-top: 3px solid #111
cada tab separado por: border-right: 2px solid #111
tab activo: background #FFE500
```

**Badges / tags:**
```
border: 2px solid #111
padding: 2px 8px
border-radius: 0
font-weight: 700, uppercase
colores: #FFE500 (acción), #FF6B6B (nuevo/alerta), #4ECDC4 (info)
```

### Motion & Animation Principles
Las animaciones en neo-brutalism se sienten **mecánicas y con peso físico**, no fluidas ni suaves:

1. **Library entrance** — Cards caen desde arriba con rebote (`Curves.elasticOut`), staggered por índice
2. **Cover press** — Efecto "hundir": `Transform.translate(Offset(3,3))` + eliminar box-shadow al presionar
3. **Page turn** — Swipe horizontal con `PageView`. Corte limpio y directo, sin curl
4. **Progress bar** — Fill animado izquierda a derecha con `Curves.easeOutExpo`
5. **Splash screen** — Logo `INKWELL` aparece letra por letra, cada una cae como un sello de tinta
6. **Hero transitions** — Cover se expande con borde visible que crece, no fade suave
7. **Button feedback** — Haptic obligatorio + translate visual en cada botón

### NO to generic UI
- ❌ No `border-radius` mayor a 4px (excepto avatares circulares)
- ❌ No gradientes — ni en covers, ni en overlays, ni en fondos
- ❌ No Material Design `elevation` shadows — solo box-shadow offset 2D
- ❌ No `Inter`, `Roboto`, `SF Pro` ni fuentes de sistema
- ❌ No colores pastel ni paletas suaves
- ❌ No `Curves.easeInOut` — usar `elasticOut` o `easeOutExpo`
- ✅ Todo custom: nav, cards, botones, sliders, inputs, badges

---

## Arquitectura: Clean Architecture

Inkwell sigue **Clean Architecture** con 3 capas bien separadas. La regla de oro: **las dependencias solo apuntan hacia adentro**. La UI no sabe nada de sqflite. El dominio no sabe nada de Flutter.

```
┌─────────────────────────────────────────┐
│           PRESENTATION (UI)             │  ← Flutter widgets, providers
├─────────────────────────────────────────┤
│              DOMAIN                     │  ← Entities, Use Cases, contratos
├─────────────────────────────────────────┤
│               DATA                      │  ← Repositorios, modelos, BD, archivos
└─────────────────────────────────────────┘
```

---

## Estructura de carpetas

```
lib/
├── main.dart
├── injection_container.dart          # GetIt: registro de dependencias
│
├── core/
│   ├── error/
│   │   ├── failures.dart             # Failure, DatabaseFailure, FileFailure...
│   │   └── exceptions.dart           # ComicParseException, etc.
│   ├── usecases/
│   │   └── usecase.dart              # abstract class UseCase<Type, Params>
│   ├── parsers/
│   │   ├── cbz_parser.dart
│   │   ├── cbr_parser.dart
│   │   └── pdf_parser.dart
│   └── utils/
│       ├── file_utils.dart
│       └── image_cache_manager.dart
│
├── features/
│   │
│   ├── library/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── comic.dart                    # Entidad pura (sin imports de Flutter/sqflite)
│   │   │   ├── repositories/
│   │   │   │   └── comic_repository.dart         # abstract interface
│   │   │   └── usecases/
│   │   │       ├── get_all_comics.dart
│   │   │       ├── import_comic.dart
│   │   │       └── delete_comic.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── comic_model.dart              # extiende Comic, añade toJson/fromJson
│   │   │   ├── datasources/
│   │   │   │   ├── comic_local_datasource.dart   # sqflite
│   │   │   │   └── comic_file_datasource.dart    # lectura de archivos
│   │   │   └── repositories/
│   │   │       └── comic_repository_impl.dart    # implementa el contrato del dominio
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── library_provider.dart         # ChangeNotifier
│   │       ├── screens/
│   │       │   └── library_screen.dart
│   │       └── widgets/
│   │           ├── comic_card.dart
│   │           ├── comics_grid.dart
│   │           └── continue_reading_row.dart
│   │
│   ├── reader/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── reading_session.dart
│   │   │   ├── repositories/
│   │   │   │   └── reader_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_comic_pages.dart
│   │   │       ├── save_progress.dart
│   │   │       └── get_progress.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── reading_progress_model.dart
│   │   │   ├── datasources/
│   │   │   │   └── reader_local_datasource.dart
│   │   │   └── repositories/
│   │   │       └── reader_repository_impl.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── reader_provider.dart
│   │       ├── screens/
│   │       │   └── reader_screen.dart
│   │       └── widgets/
│   │           ├── page_viewer.dart
│   │           ├── page_turn_animation.dart
│   │           └── reader_controls_overlay.dart
│   │
│   ├── comic_detail/
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       └── get_comic_detail.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── detail_screen.dart
│   │       └── widgets/
│   │           ├── hero_cover.dart
│   │           ├── chapter_list.dart
│   │           └── info_panel.dart
│   │
│   └── settings/
│       ├── domain/
│       │   ├── entities/
│       │   │   └── app_settings.dart
│       │   └── usecases/
│       │       └── save_settings.dart
│       └── presentation/
│           └── screens/
│               └── settings_screen.dart
│
└── app/
    ├── theme/
    │   ├── app_theme.dart
    │   └── animations.dart
    └── router.dart
```

---

## Cómo fluye la información

```
UI (widget) → Provider → UseCase → Repository (interfaz) → RepositoryImpl → DataSource
```

Ejemplo: el usuario abre la biblioteca

1. `LibraryScreen` llama a `libraryProvider.loadComics()`
2. `LibraryProvider` ejecuta el use case `GetAllComics()`
3. `GetAllComics` llama a `ComicRepository.getAll()` (interfaz del dominio)
4. `ComicRepositoryImpl` consulta `ComicLocalDataSource.getAll()`
5. `ComicLocalDataSource` hace la query en sqflite y devuelve `List<ComicModel>`
6. `ComicRepositoryImpl` convierte `ComicModel` → `Comic` (entidad)
7. El resultado llega al provider → notifica a la UI → se reconstruye la grilla

---

## Ejemplos de código clave

### Entidad del dominio (sin dependencias externas)
```dart
// features/library/domain/entities/comic.dart
class Comic {
  final String id;
  final String title;
  final String filePath;
  final String coverPath;
  final ComicFormat format;
  final int totalPages;
  final DateTime dateAdded;

  const Comic({
    required this.id,
    required this.title,
    required this.filePath,
    required this.coverPath,
    required this.format,
    required this.totalPages,
    required this.dateAdded,
  });
}

enum ComicFormat { cbz, cbr, pdf }
```

### Contrato del repositorio (dominio)
```dart
// features/library/domain/repositories/comic_repository.dart
abstract class ComicRepository {
  Future<Either<Failure, List<Comic>>> getAll();
  Future<Either<Failure, Comic>> importComic(String filePath);
  Future<Either<Failure, Unit>> deleteComic(String id);
}
```

### Use Case
```dart
// features/library/domain/usecases/get_all_comics.dart
class GetAllComics extends UseCase<List<Comic>, NoParams> {
  final ComicRepository repository;
  GetAllComics(this.repository);

  @override
  Future<Either<Failure, List<Comic>>> call(NoParams params) {
    return repository.getAll();
  }
}
```

### Implementación del repositorio (data)
```dart
// features/library/data/repositories/comic_repository_impl.dart
class ComicRepositoryImpl implements ComicRepository {
  final ComicLocalDataSource localDataSource;
  final ComicFileDataSource fileDataSource;

  ComicRepositoryImpl({
    required this.localDataSource,
    required this.fileDataSource,
  });

  @override
  Future<Either<Failure, List<Comic>>> getAll() async {
    try {
      final models = await localDataSource.getAll();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
```

### Provider (presentación)
```dart
// features/library/presentation/providers/library_provider.dart
class LibraryProvider extends ChangeNotifier {
  final GetAllComics getAllComics;
  final ImportComic importComic;

  List<Comic> comics = [];
  bool isLoading = false;
  String? error;

  LibraryProvider({required this.getAllComics, required this.importComic});

  Future<void> loadComics() async {
    isLoading = true;
    notifyListeners();

    final result = await getAllComics(NoParams());
    result.fold(
      (failure) => error = failure.message,
      (data) => comics = data,
    );

    isLoading = false;
    notifyListeners();
  }
}
```

### Inyección de dependencias (GetIt)
```dart
// injection_container.dart
final sl = GetIt.instance;

Future<void> init() async {
  // Providers
  sl.registerFactory(() => LibraryProvider(
    getAllComics: sl(), importComic: sl(),
  ));

  // Use cases
  sl.registerLazySingleton(() => GetAllComics(sl()));
  sl.registerLazySingleton(() => ImportComic(sl()));

  // Repositories
  sl.registerLazySingleton<ComicRepository>(
    () => ComicRepositoryImpl(localDataSource: sl(), fileDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ComicLocalDataSource>(
    () => ComicLocalDataSourceImpl(database: sl()),
  );

  // External
  final database = await openDatabase('inkwell.db');
  sl.registerLazySingleton(() => database);
}
```

---

## Screens & UX

### 1. Splash Screen
- Fondo `#FFFDF7`, logo `INKWELL` en `Bangers` aparece letra por letra, cada una cae como sello
- Borde inferior grueso `3px #111` aparece después del texto
- Duración: 1.8s → transición corte directo a Library (sin fade suave)

### 2. Library Screen (Home)
- **Header**: Fondo `#FFE500`, logo + contador de cómics en badge negro
- **Barra de búsqueda**: `border: 3px solid #111`, `box-shadow: 3px 3px 0 #111`
- **"Continuar" carousel**: Cards horizontales con borde 3px + shadow offset + progress bar brutalista
- **Grid de biblioteca**: 3 columnas, covers con color plano saturado, borde negro, shadow offset
- **Badge "NEW"**: Rojo `#FF6B6B`, borde negro, sin border-radius, posición absoluta top-right
- **Empty state**: Texto `SIN CÓMICS` en Bangers gigante + botón importar con shadow offset
- **FAB de importar**: Cuadrado (no circular), `background: #FFE500`, `border: 3px solid #111`, `box-shadow: 4px 4px 0 #111`

### 3. Comic Detail Screen
- **Cover**: Color plano saturado, patrón de puntos halftone superpuesto (`opacity: 0.08`)
- **Barra de título**: `background: #FFE500`, `border-top/bottom: 3px solid #111`, título en Bangers
- **Stats**: 3 columnas separadas por `border-right: 2px solid #111`, números en Bangers
- **Tags de género**: `border: 2px solid #111`, sin border-radius, uppercase
- **Lista de capítulos**: Cada item con `border: 3px solid #111`, `box-shadow: 3px 3px 0 #111`
  - Número de capítulo: fondo negro, texto blanco/amarillo
  - Estado: dot cuadrado con borde (vacío = pendiente, teal = leído, rojo = leyendo)
- **Botón CTA**: Full-width, `background: #FFE500`, `border: 3px solid #111`, `box-shadow: 5px 5px 0 #111`, Bangers 22px uppercase

### 4. Reader Screen
- **Top bar**: `background: #FFE500`, `border-bottom: 3px solid #111` — siempre visible (no auto-hide)
- **Área de página**: Fondo negro `#111`, página centrada
- **Controls bottom**: `background: #FFFDF7`, `border-top: 3px solid #111`
- **Progress bar**: `border: 2px solid #111`, `box-shadow: 2px 2px 0 #111`, fill amarillo
- **Botones Anterior/Siguiente**: Side by side, border 3px, shadow offset, "Siguiente" en amarillo
- **Paginación**: `Bangers` — "PÁG. 28 DE 64"
- Swipe horizontal entre páginas, pinch-to-zoom

### 5. Settings Screen
- Lista de opciones con `border-bottom: 2px solid #111` entre cada item
- Toggles cuadrados (no Material switches), `border: 3px solid #111`
- Secciones con header en `background: #FFE500`, `border: 3px solid #111`
- Dirección de lectura (LTR / RTL)
- Tema (Normal / Sepia — no dark mode, va contra el estilo)
- Ruta de almacenamiento
- Sobre la app / versión

---

## Data Models

```dart
class Comic {
  final String id;
  final String title;
  final String filePath;
  final String coverImagePath;
  final ComicFormat format; // CBZ, CBR, PDF
  final int totalPages;
  final DateTime dateAdded;
  final ReadingProgress? progress;
}

class ReadingProgress {
  final String comicId;
  final int currentPage;
  final DateTime lastRead;
  double get percentage => currentPage / comic.totalPages;
}

enum ComicFormat { cbz, cbr, pdf }
```

---

## Tech Stack

| Package | Version | Purpose |
|---|---|---|
| `flutter` | latest stable | Framework |
| `provider` | ^6.1.0 | State management (presentación) |
| `get_it` | ^7.6.0 | Inyección de dependencias |
| `dartz` | ^0.10.1 | Either para manejo de errores |
| `equatable` | ^2.0.5 | Comparación de entidades |
| `sqflite` | ^2.3.0 | Local database |
| `archive` | ^3.4.0 | CBZ/CBR parsing |
| `pdfx` | ^2.6.0 | PDF rendering |
| `photo_view` | ^0.14.0 | Zoomable image viewer |
| `path_provider` | ^2.1.0 | File system paths |
| `file_picker` | ^6.1.0 | Import comics from device |
| `google_fonts` | ^6.1.0 | Bangers + Space Grotesk |
| `flutter_animate` | ^4.5.0 | Declarative animations |
| `permission_handler` | ^11.0.0 | Storage permissions |

---

## Color System

```dart
// app_theme.dart
class InkwellColors {
  // Base (Neo-Brutalism)
  static const background     = Color(0xFFFFFDF7); // crema — papel de cómic
  static const surface        = Color(0xFFFFFFFF); // blanco puro para cards
  static const border         = Color(0xFF111111); // negro duro — todos los bordes
  static const shadow         = Color(0xFF111111); // box-shadow offset

  // Acento primario
  static const yellow         = Color(0xFFFFE500); // header, CTA, tab activo
  static const yellowDark     = Color(0xFFCCB800); // yellow pressed state

  // Colores de portadas (planos, saturados, sin gradientes)
  static const coverRed       = Color(0xFFFF6B6B);
  static const coverTeal      = Color(0xFF4ECDC4);
  static const coverPurple    = Color(0xFFA78BFA);
  static const coverOrange    = Color(0xFFFF9F43);
  static const coverBlue      = Color(0xFF48CAE4);
  static const coverGreen     = Color(0xFF6BCB77);

  // Badges
  static const badgeNew       = Color(0xFFFF6B6B); // rojo — badge "NEW"
  static const badgeInfo      = Color(0xFF4ECDC4); // teal — formato CBZ/PDF
  static const badgePrimary   = Color(0xFFFFE500); // amarillo — género/acción

  // Texto
  static const textPrimary    = Color(0xFF111111);
  static const textSecondary  = Color(0xFF555555);
  static const textMuted      = Color(0xFF888888);
  static const textOnYellow   = Color(0xFF111111); // texto sobre fondo amarillo
  static const textOnDark     = Color(0xFFFFFFFF); // texto sobre covers oscuros

  // Progress
  static const progressBg     = Color(0xFFE0E0E0);
  static const progressFill   = yellow;
}

// Paleta de box-shadows — usar siempre estos, nunca elevation de Material
class InkwellShadows {
  static const card    = BoxShadow(color: Color(0xFF111111), offset: Offset(4, 4));
  static const button  = BoxShadow(color: Color(0xFF111111), offset: Offset(3, 3));
  static const small   = BoxShadow(color: Color(0xFF111111), offset: Offset(2, 2));
  // Al presionar un botón: BoxShadow(offset: Offset(0, 0)) + Transform.translate(3,3)
}
```

---

## Typography

Dos fuentes. Sin excepciones.

- **`Bangers`** — títulos de pantalla, nombres de cómic, números grandes (stats, paginación), logo. Siempre con `letterSpacing: 2+`
- **`Space Grotesk`** — todo lo demás. Weight 700 para labels/botones, 500 para body, 400 para texto secundario

```dart
// In app_theme.dart
static TextTheme textTheme = TextTheme(
  // Logo / títulos grandes de cómic
  displayLarge: GoogleFonts.bangers(
    fontSize: 48, letterSpacing: 3, color: InkwellColors.textPrimary
  ),
  // Nombre de cómic en cards y detail
  titleLarge: GoogleFonts.bangers(
    fontSize: 28, letterSpacing: 2, color: InkwellColors.textPrimary
  ),
  // Números de stats (capítulos, páginas, %)
  titleMedium: GoogleFonts.bangers(
    fontSize: 22, letterSpacing: 1.5, color: InkwellColors.textPrimary
  ),
  // Etiquetas de navegación y sección (uppercase forzado en widget)
  labelLarge: GoogleFonts.spaceGrotesk(
    fontSize: 11, fontWeight: FontWeight.w700, color: InkwellColors.textPrimary,
    letterSpacing: 1.5
  ),
  // Body principal
  bodyLarge: GoogleFonts.spaceGrotesk(
    fontSize: 14, fontWeight: FontWeight.w500, color: InkwellColors.textPrimary
  ),
  // Texto secundario (capítulo, fecha, metadata)
  bodyMedium: GoogleFonts.spaceGrotesk(
    fontSize: 12, fontWeight: FontWeight.w400, color: InkwellColors.textSecondary
  ),
);
```

Agregar a `pubspec.yaml`:
```yaml
google_fonts: ^6.1.0
# Bangers + Space Grotesk — no DM Sans
```

---

## Animation Guidelines

```dart
// animations.dart
class InkwellAnimations {
  // Durations
  static const fast    = Duration(milliseconds: 200);
  static const normal  = Duration(milliseconds: 350);
  static const slow    = Duration(milliseconds: 600);
  static const splash  = Duration(milliseconds: 1800);

  // Curves
  static const springy   = Curves.elasticOut;
  static const smooth    = Curves.easeInOutCubic;
  static const snappy    = Curves.easeOutExpo;

  // Stagger delay for grid items
  static Duration stagger(int index) =>
    Duration(milliseconds: 50 + (index * 40));
}
```

**Key animations to implement:**
- Grid cards: `flutter_animate` with `.fadeIn().slideY(begin: 0.3)` staggered
- Cover press: `GestureDetector` + `AnimatedContainer` for scale + shadow
- Reader page turn: `PageView` with custom `PageTransitionsBuilder`
- Progress bar: `TweenAnimationBuilder` with ink-fill effect
- Hero transitions: Flutter's built-in `Hero` widget on cover images

---

## File Support

| Format | Extension | Parser | Notes |
|---|---|---|---|
| Comic Book ZIP | `.cbz` | `archive` package | Most common, images inside ZIP |
| Comic Book RAR | `.cbr` | `archive` package | May need native support |
| PDF | `.pdf` | `pdfx` package | Full support |

**CBZ Parsing flow:**
1. User picks file via `file_picker`
2. Copy to app documents directory
3. Use `archive` to extract image list (don't extract to disk, read in memory)
4. Sort images naturally (page_001, page_002...)
5. Extract cover (first image) and cache it
6. Store comic metadata in SQLite

---

## Development Phases

### Phase 1 — Foundation (Week 1-2)
- [ ] Flutter project setup with all dependencies
- [ ] Theme system (colors, fonts, dark mode)
- [ ] Basic navigation structure
- [ ] Splash screen with animation

### Phase 2 — Library (Week 3-4)
- [ ] File scanner & CBZ/PDF parser
- [ ] SQLite database setup
- [ ] Library grid screen with stagger animation
- [ ] Comic card widget with press animation
- [ ] Import flow (file picker → parse → save)

### Phase 3 — Reader (Week 5-6)
- [ ] Basic page viewer (horizontal swipe)
- [ ] Zoom support with photo_view
- [ ] Reader controls overlay (tap to show/hide)
- [ ] Progress saving on page change
- [ ] Reading direction support

### Phase 4 — Polish (Week 7-8)
- [ ] Comic detail screen with Hero animation
- [ ] "Continue Reading" carousel
- [ ] Settings screen
- [ ] Empty states with illustrations
- [ ] Performance optimization (image preloading)
- [ ] App icon + splash screen final assets

---

## Code Style

- Use `Provider` for state, keep widgets dumb
- All colors/fonts from theme — never hardcode
- Widget files max ~150 lines, extract sub-widgets aggressively
- Animations in dedicated widget or mixin, not mixed into business logic
- Name files with feature prefix: `library_grid.dart`, `reader_controls.dart`
- Comment "why", not "what"

---

## Getting Started

```bash
# 1. Create project
flutter create inkwell --org com.yourname

# 2. Add dependencies to pubspec.yaml (see Tech Stack above)
flutter pub get

# 3. Run on device/emulator
flutter run

# 4. Build APK for testing
flutter build apk --debug
```

---

*Built with Flutter • Neo-Brutalism • Diseñado para amantes de los cómics*

---

## Git Workflow

### Estrategia de ramas (GitFlow simplificado)

```text
main ──────────────────────────────────────── producción / releases
  └── develop ──────────────────────────────── integración continua
        ├── feature/library-grid ─────────────── features individuales
        ├── feature/reader-screen
        ├── release/1.0.0 ────────────────────── prep de release
        └── hotfix/crash-on-import ───────────── fixes urgentes en prod
```

| Rama | Propósito | Origen | Destino |
|---|---|---|---|
| `main` | Código en producción. Siempre estable y releaseable | — | — |
| `develop` | Integración de features. Base de trabajo diario | `main` | `main` (via release) |
| `feature/<nombre>` | Una funcionalidad o tarea concreta | `develop` | `develop` (via PR) |
| `release/<version>` | Preparación de release: bump version, último QA | `develop` | `main` + `develop` |
| `hotfix/<nombre>` | Fix urgente directamente sobre producción | `main` | `main` + `develop` |

**Reglas absolutas:**

- Nunca hacer push directo a `main` ni a `develop`
- Todo cambio entra via Pull Request
- `main` solo recibe merges de `release/*` y `hotfix/*`
- Una feature = una rama = un PR

---

### Convención de commits (Conventional Commits)

```text
<tipo>(<scope>): <descripción corta en imperativo>

[cuerpo opcional — explica el por qué, no el qué]

[footer opcional — refs, breaking changes]
```

**Tipos:**

| Tipo | Cuándo usarlo |
|---|---|
| `feat` | Nueva funcionalidad visible para el usuario |
| `fix` | Corrección de bug |
| `style` | Cambios de UI/diseño sin lógica (colores, padding, fuentes) |
| `refactor` | Refactoring interno sin cambio de comportamiento |
| `chore` | Dependencias, config, scripts, archivos de proyecto |
| `test` | Agregar o modificar tests |
| `docs` | Documentación, CLAUDE.md, comentarios |
| `perf` | Mejora de rendimiento |

**Ejemplos:**
```bash
feat(library): add staggered entrance animation to comic grid
fix(reader): prevent crash when CBZ has no cover image
style(theme): update button shadow offset to match neo-brutalism spec
chore(deps): bump flutter_animate to 4.5.0
refactor(reader): extract page preloading logic to separate service
```

**Scope** = el feature o módulo afectado: `library`, `reader`, `detail`, `settings`, `theme`, `core`, `router`.

---

### Flujo de trabajo día a día

#### Iniciar una nueva feature

```bash
git checkout develop
git pull origin develop
git checkout -b feature/nombre-descriptivo
```

#### Trabajar y commitear

```bash
# Hacer cambios...
git add lib/features/library/...
git commit -m "feat(library): add comic card press animation"

# Varios commits pequeños y atómicos — no un commit gigante al final
```

#### Abrir Pull Request

1. Push de la rama: `git push origin feature/nombre-descriptivo`
2. Abrir PR en GitHub: **base `develop`**, no `main`
3. Título del PR = mensaje de commit principal (sigue Conventional Commits)
4. Descripción: qué hace, capturas si hay cambio visual, cómo testear
5. Usar **Squash and Merge** para mantener historial limpio en `develop`

#### Preparar un release

```bash
git checkout develop
git pull origin develop
git checkout -b release/1.0.0

# Bump version en pubspec.yaml: version: 1.0.0+1
# Último QA, fix de detalles menores

git commit -m "chore(release): bump version to 1.0.0"

# PR release/1.0.0 → main (Merge Commit, no squash — preservar historial)
# Después de merge a main:
git checkout main && git pull
git tag -a v1.0.0 -m "Release v1.0.0 — MVP launch"
git push origin v1.0.0

# Sync de vuelta a develop:
git checkout develop
git merge main
git push origin develop
```

#### Hotfix en producción

```bash
git checkout main
git pull origin main
git checkout -b hotfix/descripcion-del-bug

# Fix...
git commit -m "fix(reader): resolve null pointer on empty CBZ file"

# PR hotfix/* → main
# Después del merge, tag y sync a develop (igual que release)
```

---

### Versionado (Semantic Versioning)

`v MAJOR . MINOR . PATCH + BUILD`

| Tipo | Cuándo incrementar |
| --- | --- |
| `MAJOR` | Cambio que rompe compatibilidad (raro en una app, reservar para re-arquitecturas) |
| `MINOR` | Nueva feature completa y estable |
| `PATCH` | Bug fix o mejora menor |
| `BUILD` | Número interno para Play Store (siempre incremental) |

```yaml
# pubspec.yaml
version: 1.2.3+15   # 1.2.3 = versión pública, 15 = build number
```

Tags en `main` siempre que se mergea un release: `v1.0.0`, `v1.1.0`, `v1.1.1`

---

### Nombrado de ramas

```
feature/splash-screen-animation
feature/cbz-parser
feature/library-empty-state
feature/reader-zoom-support
release/1.0.0
hotfix/reader-crash-empty-cbz
```

- Lowercase, separado por guiones
- Descriptivo pero conciso (máximo 4-5 palabras)
- Incluir el feature/módulo como prefijo cuando aplique

---

### Lo que NO va en el repositorio

El `.gitignore` del proyecto ya excluye lo siguiente — nunca hacer commit de:

- `/build/` — artefactos compilados
- `*.apk`, `*.aab` — binarios de release (van a Play Store / GitHub Releases)
- `.dart_tool/`, `.flutter-plugins` — generados por Flutter
- `*.env`, `local.properties` — configuración local con secretos
- `google-services.json` — si se integra Firebase (va en CI/CD secrets)
