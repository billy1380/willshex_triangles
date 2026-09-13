import "package:equatable/equatable.dart";
import "package:client_common/triangles/image_generator_config.dart";

class GeneratorSettings extends Equatable {
  final int width;
  final int height;
  final double scaleFactor;
  final int ratioN;
  final int ratioD;
  final bool addTriangleGradients;
  final bool annotateWithDimensions;

  const GeneratorSettings({
    this.width = ImageGeneratorConfig.defaultWidth,
    this.height = ImageGeneratorConfig.defaultHeight,
    this.scaleFactor = 11.0 / 69.0,
    this.ratioN = 10000,
    this.ratioD = 1594,
    this.addTriangleGradients = true,
    this.annotateWithDimensions = false,
  });

  GeneratorSettings copyWith({
    int? width,
    int? height,
    double? scaleFactor,
    int? ratioN,
    int? ratioD,
    bool? addTriangleGradients,
    bool? annotateWithDimensions,
  }) {
    return GeneratorSettings(
      width: width ?? this.width,
      height: height ?? this.height,
      scaleFactor: scaleFactor ?? this.scaleFactor,
      ratioN: ratioN ?? this.ratioN,
      ratioD: ratioD ?? this.ratioD,
      addTriangleGradients: addTriangleGradients ?? this.addTriangleGradients,
      annotateWithDimensions:
          annotateWithDimensions ?? this.annotateWithDimensions,
    );
  }

  static GeneratorSettings fromValues({
    int? width,
    int? height,
    double? scaleFactor,
    bool? addTriangleGradients,
    bool? annotateWithDimensions,
  }) {
    final w = width ?? ImageGeneratorConfig.defaultWidth;
    final h = height ?? ImageGeneratorConfig.defaultHeight;
    final s = scaleFactor ??
        (ImageGeneratorConfig.defaultRatioN /
            ImageGeneratorConfig.defaultRatioD);
    const rn = 10000;
    var rd = (s * 10000).toInt();
    if (rd == 0) rd = 1;

    return GeneratorSettings(
      width: w,
      height: h,
      scaleFactor: s,
      ratioN: rn,
      ratioD: rd,
      addTriangleGradients: addTriangleGradients ?? true,
      annotateWithDimensions: annotateWithDimensions ?? false,
    );
  }

  @override
  List<Object?> get props => [
        width,
        height,
        scaleFactor,
        ratioN,
        ratioD,
        addTriangleGradients,
        annotateWithDimensions,
      ];
}
