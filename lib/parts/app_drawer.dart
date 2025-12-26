import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:willshex_triangles/pages/about_page.dart";
import "package:willshex_triangles/pages/colour_lovers_page.dart";
import "package:willshex_triangles/pages/html_colour_page.dart";
import "package:willshex_triangles/pages/image_palette_page.dart";
import "package:willshex_triangles/pages/image_sampler_palette_page.dart";
import "package:willshex_triangles/pages/settings_page.dart";
import "package:willshex_triangles/pages/welcome_page.dart";

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
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouter.of(context).location;
    return NavigationDrawer(
      selectedIndex: _getSelectedIndex(location),
      onDestinationSelected: (int index) {
        final String destination = _getRouteByIndex(index);
        if (location != destination) {
          context.go(destination);
        } else {
          Navigator.pop(context); // Close drawer if already on page
        }
      },
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            "Triangles",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text("Welcome"),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            "Types",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.code_outlined),
          selectedIcon: Icon(Icons.code),
          label: Text("HTML Colour"),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.favorite_border),
          selectedIcon: Icon(Icons.favorite),
          label: Text("COLOUR Lovers"),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.image_outlined),
          selectedIcon: Icon(Icons.image),
          label: Text("Image"),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.palette_outlined),
          selectedIcon: Icon(Icons.palette),
          label: Text("Image Sampler"),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text("Settings"),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.info_outline_rounded),
          selectedIcon: Icon(Icons.info_rounded),
          label: Text("About"),
        ),
      ],
    );
  }

  int _getSelectedIndex(String location) {
    if (location.startsWith(WelcomePage.routePath)) return 0;
    if (location.startsWith(HtmlColourPage.routePath)) return 1;
    if (location.startsWith(ColourLoversPage.routePath)) return 2;
    if (location.startsWith(ImagePalettePage.routePath)) return 3;
    if (location.startsWith(ImageSamplerPalettePage.routePath)) return 4;
    if (location.startsWith(SettingsPage.routePath)) return 5;
    if (location.startsWith(AboutPage.routePath)) return 6;
    return 0; // Default
  }

  String _getRouteByIndex(int index) {
    switch (index) {
      case 0:
        return WelcomePage.routePath;
      case 1:
        return HtmlColourPage.routePath;
      case 2:
        return ColourLoversPage.routePath;
      case 3:
        return ImagePalettePage.routePath;
      case 4:
        return ImageSamplerPalettePage.routePath;
      case 5:
        return SettingsPage.routePath;
      case 6:
        return AboutPage.routePath;
      default:
        return WelcomePage.routePath;
    }
  }
}
