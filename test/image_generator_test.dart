import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:willshex_triangles/server/image_generator.dart';
import 'package:willshex_triangles/triangles/graphics/graphics.dart';
import 'package:willshex_triangles/triangles/image_generator_config.dart';
import 'package:willshex_draw/willshex_draw.dart';

void main() {
  test('ImageGenerator generates a PNG image', () async {
    final properties = {
      ImageGeneratorConfig.widthKey: '100',
      ImageGeneratorConfig.heightKey: '100',
      ImageGeneratorConfig.typeKey: 'Tiles',
      ImageGeneratorConfig.formatKey: 'png',
      ImageGeneratorConfig.indexKey: '0',
    };

    final tempFile = File('test_output.png');
    final sink = tempFile.openWrite();

    final format = await ImageGenerator.generate(
      properties,
      () async => Palette('test'), // Mock palette supplier
      sink,
      null, // store
    );

    await sink.flush();
    await sink.close();

    expect(format, equals('png'));
    expect(await tempFile.exists(), isTrue);
    expect(await tempFile.length(), greaterThan(0));

    // Cleanup
    if (await tempFile.exists()) {
      await tempFile.delete();
    }
  });

  test('ImageGenerator generates with explicit Palette', () async {
    final properties = {
      ImageGeneratorConfig.widthKey: '50',
      ImageGeneratorConfig.heightKey: '50',
      ImageGeneratorConfig.typeKey: 'Ribbons',
      ImageGeneratorConfig.formatKey: 'jpg',
      ImageGeneratorConfig.paletteKey: 'Random Named',
    };

    final tempFile = File('test_output.jpg');
    final sink = tempFile.openWrite();

    final format = await ImageGenerator.generate(
      properties,
      () async => Palette('test'),
      sink,
      null,
    );

    await sink.flush();
    await sink.close();

    expect(format, equals('jpg'));
    expect(await tempFile.exists(), isTrue);
    expect(await tempFile.length(), greaterThan(0));

    if (await tempFile.exists()) {
      await tempFile.delete();
    }
  });

  test('ImageGenerator generates annotated image (triggers font load)',
      () async {
    final properties = {
      ImageGeneratorConfig.widthKey: '300',
      ImageGeneratorConfig.heightKey: '300',
      ImageGeneratorConfig.typeKey: 'Tiles',
      ImageGeneratorConfig.formatKey: 'png',
      ImageGeneratorConfig.annotateKey: '1', // Enable annotation
    };

    final tempFile = File('test_output_annotated.png');
    final sink = tempFile.openWrite();

    final format = await ImageGenerator.generate(
      properties,
      () async => Palette('test'),
      sink,
      null,
    );

    await sink.flush();
    await sink.close();

    expect(format, equals('png'));
    expect(await tempFile.exists(), isTrue);
    expect(await tempFile.length(), greaterThan(0));

    if (await tempFile.exists()) {
      await tempFile.delete();
    }
  });
}
