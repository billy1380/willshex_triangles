import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:triangles_common/client_common.dart";

extension GoRouterLocation on GoRouter {
  String get location => (routerDelegate.currentConfiguration.last
              is ImperativeRouteMatch
          ? (routerDelegate.currentConfiguration.last as ImperativeRouteMatch)
              .matches
          : routerDelegate.currentConfiguration)
      .uri
      .toString();
}

class AppDrawer extends StatelessWidget {
  final TrianglesRoutePaths paths;
  final ThemeCubit? themeCubit;
  final String? currentLocation;

  AppDrawer({
    TrianglesRoutePaths? paths,
    String? basePath,
    this.themeCubit,
    this.currentLocation,
    super.key,
  }) : paths = paths ??
            (basePath != null && basePath.isNotEmpty
                ? TrianglesRoutePaths.withPrefix(basePath)
                : const TrianglesRoutePaths());

  static const double _destinationChromeWidth = 100;

  static Widget _destLabel(String text) => Text(
        text,
        softWrap: false,
        maxLines: 1,
      );

  static double _widestLabel(TextStyle style, Iterable<String> labels) {
    double widest = 0;
    for (final String label in labels) {
      final TextPainter painter = TextPainter(
        text: TextSpan(text: label, style: style),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();
      if (painter.width > widest) widest = painter.width;
    }
    return widest;
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.maybeOf(context);
    final String location =
        currentLocation ?? (router != null ? router.location : "");
    ThemeCubit? cubit = themeCubit;
    if (cubit == null) {
      try {
        cubit = BlocProvider.of<ThemeCubit>(context, listen: false);
      } catch (_) {
        cubit = null;
      }
    }
    final bool pinToggle = MediaQuery.sizeOf(context).height >= 600;
    final theme = Theme.of(context);
    final backgroundColor = theme.navigationDrawerTheme.backgroundColor ??
        theme.drawerTheme.backgroundColor ??
        theme.colorScheme.surface;

    final bool hasBackLink =
        paths.welcome != TrianglesRoutePaths.defaultWelcome;
    final double neededWidth = _widestLabel(
          theme.textTheme.labelLarge ?? const TextStyle(),
          [
            AppStrings.navWelcome,
            AppStrings.navPalettePicker,
            AppStrings.navHtmlColour,
            AppStrings.navRandomPalette,
            AppStrings.navRandomGrayscale,
            AppStrings.imagePalette,
            AppStrings.imageSamplerPalette,
            AppStrings.navSettings,
            if (hasBackLink) "Back to Willshex",
          ],
        ) +
        _destinationChromeWidth;

    final Widget navigation = NavigationDrawer(
      backgroundColor: backgroundColor,
      elevation: 0,
      selectedIndex: _getSelectedIndex(location),
      onDestinationSelected: (int index) {
        final String destination = _getRouteByIndex(index);
        final scaffold = Scaffold.maybeOf(context);
        if (scaffold != null && scaffold.isDrawerOpen) {
          scaffold.closeDrawer();
        }
        if (location != destination) {
          context.go(destination);
        }
      },
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            AppStrings.appName,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: _destLabel(AppStrings.navWelcome),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 16, 10),
          child: Text(
            AppStrings.navTypes,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.colorize_outlined),
          selectedIcon: const Icon(Icons.colorize),
          label: _destLabel(AppStrings.navPalettePicker),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.code_outlined),
          selectedIcon: const Icon(Icons.code),
          label: _destLabel(AppStrings.navHtmlColour),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.shuffle_outlined),
          selectedIcon: const Icon(Icons.shuffle),
          label: _destLabel(AppStrings.navRandomPalette),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.contrast_outlined),
          selectedIcon: const Icon(Icons.contrast),
          label: _destLabel(AppStrings.navRandomGrayscale),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.image_outlined),
          selectedIcon: const Icon(Icons.image),
          label: _destLabel(AppStrings.imagePalette),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.palette_outlined),
          selectedIcon: const Icon(Icons.palette),
          label: _destLabel(AppStrings.imageSamplerPalette),
        ),
        const SizedBox(height: 12),
        NavigationDrawerDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: _destLabel(AppStrings.navSettings),
        ),
        if (hasBackLink) ...[
          const SizedBox(height: 12),
          NavigationDrawerDestination(
            icon: const Icon(Icons.arrow_back),
            label: _destLabel("Back to Willshex"),
          ),
        ],
        if (cubit != null && pinToggle) const SizedBox(height: 96),
        if (cubit != null && !pinToggle)
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 28, 16),
            child: DrawerThemeToggle(cubit: cubit),
          ),
      ],
    );

    final Widget navDrawer = LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= neededWidth) {
          return navigation;
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: neededWidth,
            height: constraints.hasBoundedHeight ? constraints.maxHeight : null,
            child: navigation,
          ),
        );
      },
    );

    if (cubit == null || !pinToggle) {
      return navDrawer;
    }

    return Stack(
      children: [
        navDrawer,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            child: Container(
              color: backgroundColor,
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 16),
              child: DrawerThemeToggle(cubit: cubit),
            ),
          ),
        ),
      ],
    );
  }

  int _getSelectedIndex(String location) {
    if (location == paths.welcome ||
        location.startsWith("${paths.welcome}/") ||
        (paths.welcome == TrianglesRoutePaths.defaultWelcome &&
            (location == "/" || location.isEmpty))) {
      return 0;
    }
    if (location == paths.palettePicker ||
        location.startsWith("${paths.palettePicker}/")) {
      return 1;
    }
    if (location == paths.htmlColour ||
        location.startsWith("${paths.htmlColour}/")) {
      return 2;
    }
    if (location == paths.randomPalette ||
        location.startsWith("${paths.randomPalette}/")) {
      return 3;
    }
    if (location == paths.randomGrayscale ||
        location.startsWith("${paths.randomGrayscale}/")) {
      return 4;
    }
    if (location == paths.imagePalette ||
        location.startsWith("${paths.imagePalette}/")) {
      return 5;
    }
    if (location == paths.imageSampler ||
        location.startsWith("${paths.imageSampler}/")) {
      return 6;
    }
    if (location == paths.settings ||
        location.startsWith("${paths.settings}/")) {
      return 7;
    }
    return 0; // Default
  }

  String _getRouteByIndex(int index) {
    switch (index) {
      case 0:
        return paths.welcome;
      case 1:
        return paths.palettePicker;
      case 2:
        return paths.htmlColour;
      case 3:
        return paths.randomPalette;
      case 4:
        return paths.randomGrayscale;
      case 5:
        return paths.imagePalette;
      case 6:
        return paths.imageSampler;
      case 7:
        return paths.settings;
      case 8:
        return "/";
      default:
        return paths.welcome;
    }
  }
}

class DrawerThemeToggle extends StatelessWidget {
  final ThemeCubit cubit;

  const DrawerThemeToggle({required this.cubit, super.key});

  static IconData _icon(AppThemeMode mode) => switch (mode) {
        AppThemeMode.system => Icons.brightness_auto,
        AppThemeMode.light => Icons.light_mode,
        AppThemeMode.dark => Icons.dark_mode,
      };

  void _onToggleTheme(BuildContext context) {
    final isPlatformDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    cubit.toggle(isPlatformDark);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemeMode>(
      bloc: cubit,
      builder: (context, current) => SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _onToggleTheme(context),
          icon: Icon(_icon(current), size: 18),
          label: Text("${AppStrings.theme}: ${current.label}"),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

typedef DrawerThemeDropdown = DrawerThemeToggle;
