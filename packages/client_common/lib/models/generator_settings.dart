import "package:equatable/equatable.dart";
import "package:client_common/triangles/image_generator_config.dart";

class GeneratorSettings extends Equatable {
  static const String keyWidth = "image_width";
  static const String keyHeight = "image_height";
  static const String keyScaleFactor = "size_ratio";
  static const String keyAddTriangleGradients = "add_triangle_gradients";
  static const String keyAnnotateWithDimensions = "annotate_with_dimensions";

  static const int defaultWidth = ImageGeneratorConfig.defaultWidth;
  static const int defaultHeight = ImageGeneratorConfig.defaultHeight;
  static const double defaultScaleFactor =
      ImageGeneratorConfig.defaultRatioN / ImageGeneratorConfig.defaultRatioD;
  static const int defaultRatioN = 10000;
  static const int defaultRatioD = 833;
  static const bool defaultAddTriangleGradients = true;
  static const bool defaultAnnotateWithDimensions = false;

  final int width;
  final int height;
  final double scaleFactor;
  final int ratioN;
  final int ratioD;
  final bool addTriangleGradients;
  final bool annotateWithDimensions;

  const GeneratorSettings({
    this.width = defaultWidth,
    this.height = defaultHeight,
    this.scaleFactor = defaultScaleFactor,
    this.ratioN = defaultRatioN,
    this.ratioD = defaultRatioD,
    this.addTriangleGradients = defaultAddTriangleGradients,
    this.annotateWithDimensions = defaultAnnotateWithDimensions,
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
    final w = width ?? defaultWidth;
    final h = height ?? defaultHeight;
    var s = scaleFactor ?? defaultScaleFactor;
    if (s >= 1.0) {
      s = 1.0 / s;
    }
    const rn = 10000;
    var rd = (s * 10000).toInt();
    if (rd == 0) rd = 1;

    return GeneratorSettings(
      width: w,
      height: h,
      scaleFactor: s,
      ratioN: rn,
      ratioD: rd,
      addTriangleGradients: addTriangleGradients ?? defaultAddTriangleGradients,
      annotateWithDimensions:
          annotateWithDimensions ?? defaultAnnotateWithDimensions,
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
