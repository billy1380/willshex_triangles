import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:image/image.dart" as img;
import "package:willshex_draw/willshex_draw.dart";
import "package:willshex_triangles/triangles/graphics/image_pixel_palette.dart";
import "package:willshex_triangles/triangles/graphics/palette_provider/generator_palette_provider.dart";
import "package:willshex_triangles/triangles/image_generator.dart";
import "package:willshex_triangles/triangles/image_generator_config.dart";

void main() {
  test("ImageGenerator generates a PNG image", () async {
    final properties = {
      ImageGeneratorConfig.widthKey: "100",
      ImageGeneratorConfig.heightKey: "100",
      ImageGeneratorConfig.typeKey: "Tiles",
      ImageGeneratorConfig.formatKey: "png",
      ImageGeneratorConfig.indexKey: "0",
    };

    final tempFile = File("test_output.png");
    final sink = tempFile.openWrite();

    final format = await ImageGenerator.generate(
      properties,
      GeneratorPaletteProvider(() async => Palette("test")
        ..addColors([Color.grayscaleColor(0.5)])), // Mock palette supplier
      sink,
      null, // store
    );

    await sink.flush();
    await sink.close();

    expect(format, equals("png"));
    expect(await tempFile.exists(), isTrue);
    expect(await tempFile.length(), greaterThan(0));

    // Cleanup
    if (await tempFile.exists()) {
      await tempFile.delete();
    }
  });

  test("ImageGenerator generates with explicit Palette", () async {
    final properties = {
      ImageGeneratorConfig.widthKey: "50",
      ImageGeneratorConfig.heightKey: "50",
      ImageGeneratorConfig.typeKey: "Ribbons",
      ImageGeneratorConfig.formatKey: "jpg",
    };

    final tempFile = File("test_output.jpg");
    final sink = tempFile.openWrite();

    final format = await ImageGenerator.generate(
      properties,
      GeneratorPaletteProvider(
          () async => Palette("test")..addColors([Color.grayscaleColor(0.5)])),
      sink,
      null,
    );

    await sink.flush();
    await sink.close();

    expect(format, equals("jpg"));
    expect(await tempFile.exists(), isTrue);
    expect(await tempFile.length(), greaterThan(0));

    if (await tempFile.exists()) {
      await tempFile.delete();
    }
  });

  test("ImageGenerator generates annotated image (triggers font load)",
      () async {
    final properties = {
      ImageGeneratorConfig.widthKey: "300",
      ImageGeneratorConfig.heightKey: "300",
      ImageGeneratorConfig.typeKey: "Tiles",
      ImageGeneratorConfig.formatKey: "png",
      ImageGeneratorConfig.annotateKey: "1", // Enable annotation
    };

    final tempFile = File("test_output_annotated.png");
    final sink = tempFile.openWrite();

    final format = await ImageGenerator.generate(
      properties,
      GeneratorPaletteProvider(
          () async => Palette("test")..addColors([Color.grayscaleColor(0.5)])),
      sink,
      null,
    );

    await sink.flush();
    await sink.close();

    expect(format, equals("png"));
    expect(await tempFile.exists(), isTrue);
    expect(await tempFile.length(), greaterThan(0));

    if (await tempFile.exists()) {
      await tempFile.delete();
    }
  });

  test("ImageGenerator generates using ImagePixelPalette", () async {
    final properties = {
      ImageGeneratorConfig.widthKey: "50",
      ImageGeneratorConfig.heightKey: "50",
      ImageGeneratorConfig.typeKey: "Tiles",
      ImageGeneratorConfig.formatKey: "png",
    };

    final tempFile = File("test_output_ipp.png");
    final sink = tempFile.openWrite();

    // Create a simple ImagePixelPalette
    final img.Image sourceImage = img.Image(width: 10, height: 10);
    img.fill(sourceImage, color: img.ColorRgb8(255, 0, 0)); // Red image
    final palette = ImagePixelPalette(sourceImage);

    final format = await ImageGenerator.generate(
      properties,
      GeneratorPaletteProvider(() async => palette),
      sink,
      null,
    );

    await sink.flush();
    await sink.close();

    expect(format, equals("png"));
    expect(await tempFile.exists(), isTrue);
    expect(await tempFile.length(), greaterThan(0));

    // Cleanup
    if (await tempFile.exists()) {
      await tempFile.delete();
    }
  });
}
