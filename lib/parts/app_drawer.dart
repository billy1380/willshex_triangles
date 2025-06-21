import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:willshex_triangles/pages/colour_lovers_page.dart';
import 'package:willshex_triangles/pages/html_colour_page.dart';
import 'package:willshex_triangles/pages/image_palette_page.dart';
import 'package:willshex_triangles/pages/image_sampler_palette_page.dart';
import 'package:willshex_triangles/pages/settings_page.dart';

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
    final TextStyle? headingStyle = Theme.of(context).textTheme.headlineSmall;
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text("Types", style: Theme.of(context).textTheme.titleLarge),
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
          ListTile(
            title: const Text("About"),
            leading: const Icon(Icons.info_rounded),
            onTap: () {
              GoRouter.of(context).pop();
              showAboutDialog(
                context: context,
                children: [
                  const Text(
                    "Triangles is written and maintained by WillShex Ltd for fun and because we like triangles (in case you have not noticed).",
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Software",
                    style: headingStyle,
                  ),
                  const Text(
                    "Triangles is possible because of tons of software we did not actually write.",
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Roadmap",
                    style: headingStyle,
                  ),
                  const Text(
                    "Add settings e.g. triangle size... Make generated cavases downloadable via app-engine service Support less than 5 colours Properly link to all the projects we used Integrate more colour services - Update: for some reason random queries on Kuler started to return the same colour palette, so I switched to using COLOURLovers, not sure if there are any others out there.",
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Legal",
                    style: headingStyle,
                  ),
                  const Text(
                      """You can use any of the images you generate/download for free for all commercial and non-commercial projects. We would also love to hear from you about how you are using the images and for what projects. Finally if you feel like giving us a mention we would really appreciate that too.
"""),
                ],
              );
            },
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
