import 'package:go_router/go_router.dart';
import 'package:willshex_triangles/pages/colour_lovers_page.dart';
import 'package:willshex_triangles/pages/image_palette_page.dart';
import 'package:willshex_triangles/pages/image_sampler_palette_page.dart';
import 'package:willshex_triangles/pages/settings_page.dart';

final GoRouter router = GoRouter(
  initialLocation: ColourLoversPage.routePath,
  routes: [
    GoRoute(
      name: "ColourLoversPage",
      path: ColourLoversPage.routePath,
      builder: ColourLoversPage.builder,
    ),
    GoRoute(
      name: "ImagePalettePage",
      path: ImagePalettePage.routePath,
      builder: ImagePalettePage.builder,
    ),
    GoRoute(
      name: "ImageSamplerPalettePage",
      path: ImageSamplerPalettePage.routePath,
      builder: ImageSamplerPalettePage.builder,
    ),
    GoRoute(
      name: "SettingsPage",
      path: SettingsPage.routePath,
      builder: SettingsPage.builder,
    ),
  ],
);
