import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:willshex_triangles/pages/colour_lovers_page.dart";
import "package:willshex_triangles/pages/welcome_page.dart";
import "package:willshex_triangles/pages/html_colour_page.dart";
import "package:willshex_triangles/pages/image_palette_page.dart";
import "package:willshex_triangles/pages/image_sampler_palette_page.dart";
import "package:willshex_triangles/pages/settings_page.dart";
import "package:willshex_triangles/pages/about_page.dart";

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
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text("Types", style: Theme.of(context).textTheme.titleLarge),
          ),
          _anchor(
            context,
            title: "Welcome",
            icon: Icons.home,
            location: WelcomePage.routePath,
          ),
          _anchor(
            context,
            title: "HTML Colour",
            icon: Icons.code,
            location: HtmlColourPage.routePath,
          ),
          _anchor(
            context,
            title: "COLOUR Lovers",
            icon: Icons.favorite,
            location: ColourLoversPage.routePath,
          ),
          _anchor(
            context,
            title: "Image Palette",
            icon: Icons.image,
            location: ImagePalettePage.routePath,
          ),
          _anchor(
            context,
            title: "Image Sampler Palette",
            icon: Icons.palette,
            location: ImageSamplerPalettePage.routePath,
          ),
          const Divider(),
          _anchor(
            context,
            title: "Settings",
            icon: Icons.settings,
            location: SettingsPage.routePath,
          ),
          const Divider(),
          _anchor(
            context,
            title: "About",
            icon: Icons.info_rounded,
            location: AboutPage.routePath,
          ),
        ],
      ),
    );
  }

  Widget _anchor(
    BuildContext context, {
    required String title,
    required String location,
    IconData? icon,
  }) {
    return ListTile(
      title: Text(
        title,
      ),
      leading: icon == null ? null : Icon(icon),
      onTap: GoRouter.of(context).location == location
          ? null
          : () => GoRouter.of(context).go(location),
    );
  }
}
