import "package:go_router/go_router.dart";
import "package:willshex_triangles/pages/welcome_page.dart";
import "package:willshex_triangles/pages/html_colour_page.dart";
import "package:willshex_triangles/pages/random_palette_page.dart";
import "package:willshex_triangles/pages/random_grayscale_palette_page.dart";
import "package:willshex_triangles/pages/image_palette_page.dart";
import "package:willshex_triangles/pages/image_sampler_palette_page.dart";
import "package:willshex_triangles/pages/settings_page.dart";
import "package:willshex_triangles/pages/about_page.dart";
import "package:willshex_triangles/pages/palette_picker_page.dart";

final GoRouter router = GoRouter(
  initialLocation: WelcomePage.routePath,
  routes: [
    GoRoute(
      name: "WelcomePage",
      path: WelcomePage.routePath,
      builder: WelcomePage.builder,
    ),
    GoRoute(
      name: "PalettePickerPage",
      path: PalettePickerPage.routePath,
      builder: PalettePickerPage.builder,
    ),
    GoRoute(
      name: "HtmlColourPage",
      path: HtmlColourPage.routePath,
      builder: HtmlColourPage.builder,
    ),
    GoRoute(
      name: "RandomPalettePage",
      path: RandomPalettePage.routePath,
      builder: RandomPalettePage.builder,
    ),
    GoRoute(
      name: "RandomGrayscalePalettePage",
      path: RandomGrayscalePalettePage.routePath,
      builder: RandomGrayscalePalettePage.builder,
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
    GoRoute(
      name: "AboutPage",
      path: AboutPage.routePath,
      builder: AboutPage.builder,
    ),
  ],
);
