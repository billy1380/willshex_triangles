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

  AppDrawer({
    TrianglesRoutePaths? paths,
    String? basePath,
    this.themeCubit,
    super.key,
  }) : paths = paths ??
            (basePath != null && basePath.isNotEmpty
                ? TrianglesRoutePaths.withPrefix(basePath)
                : const TrianglesRoutePaths());

  @override
  Widget build(BuildContext context) {
    final String location = GoRouter.of(context).location;
    ThemeCubit? cubit = themeCubit;
    if (cubit == null) {
      try {
        cubit = BlocProvider.of<ThemeCubit>(context, listen: false);
      } catch (_) {
        cubit = null;
      }
    }
    final Widget navDrawer = NavigationDrawer(
      selectedIndex: _getSelectedIndex(location),
      onDestinationSelected: (int index) {
        final String destination = _getRouteByIndex(index);
        Navigator.pop(context);
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
        const NavigationDrawerDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text(AppStrings.navWelcome),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 16, 10),
          child: Text(
            AppStrings.navTypes,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.colorize_outlined),
          selectedIcon: Icon(Icons.colorize),
          label: Text(AppStrings.navPalettePicker),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.code_outlined),
          selectedIcon: Icon(Icons.code),
          label: Text(AppStrings.navHtmlColour),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.shuffle_outlined),
          selectedIcon: Icon(Icons.shuffle),
          label: Text(AppStrings.navRandomPalette),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.contrast_outlined),
          selectedIcon: Icon(Icons.contrast),
          label: Text(AppStrings.navRandomGrayscale),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.image_outlined),
          selectedIcon: Icon(Icons.image),
          label: Text(AppStrings.imagePalette),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.palette_outlined),
          selectedIcon: Icon(Icons.palette),
          label: Text(AppStrings.imageSamplerPalette),
        ),
        const SizedBox(height: 12),
        const NavigationDrawerDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text(AppStrings.navSettings),
        ),
        if (paths.welcome != TrianglesRoutePaths.defaultWelcome) ...[
          const SizedBox(height: 12),
          const NavigationDrawerDestination(
            icon: Icon(Icons.arrow_back),
            label: Text("Back to Willshex"),
          ),
        ],
        if (cubit != null) const SizedBox(height: 96),
      ],
    );

    if (cubit == null) {
      return navDrawer;
    }

    final theme = Theme.of(context);
    final backgroundColor = theme.navigationDrawerTheme.backgroundColor ??
        theme.drawerTheme.backgroundColor ??
        theme.colorScheme.surface;

    return Stack(
      children: [
        navDrawer,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(28),
            ),
            child: SafeArea(
              top: false,
              child: Container(
                color: backgroundColor,
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 16),
                child: DrawerThemeDropdown(cubit: cubit),
              ),
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

class DrawerThemeDropdown extends StatelessWidget {
  final ThemeCubit cubit;

  const DrawerThemeDropdown({required this.cubit, super.key});

  static IconData _icon(AppThemeMode mode) => switch (mode) {
        AppThemeMode.system => Icons.brightness_auto,
        AppThemeMode.light => Icons.light_mode,
        AppThemeMode.dark => Icons.dark_mode,
      };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemeMode>(
      bloc: cubit,
      builder: (context, current) => DropdownButtonFormField<AppThemeMode>(
        key: ValueKey(current),
        initialValue: current,
        isDense: true,
        isExpanded: true,
        decoration: const InputDecoration(
          labelText: AppStrings.theme,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        items: [
          for (final mode in AppThemeMode.values)
            DropdownMenuItem<AppThemeMode>(
              value: mode,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_icon(mode), size: 18),
                  const SizedBox(width: 8),
                  Text(mode.label),
                ],
              ),
            ),
        ],
        onChanged: (mode) {
          if (mode != null) cubit.setMode(mode);
        },
      ),
    );
  }
}
