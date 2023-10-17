import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:willshex_triangles/parts/app_drawer.dart';

class ImageSamplerPalettePage extends StatefulWidget {
  static const String routePath = "/imagesamplerpalette";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const ImageSamplerPalettePage._();
  }

  const ImageSamplerPalettePage._();

  @override
  State<ImageSamplerPalettePage> createState() => _ImageSamplerPalettePageState();
}

class _ImageSamplerPalettePageState extends State<ImageSamplerPalettePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Image Sampler Palette page"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Image Sampler Palette page body",
            ),
          ],
        ),
      ),
    );
  }
}
