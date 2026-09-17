/// Centralized string constants used across clients (Flutter, Web, CLI).
class AppStrings {
  AppStrings._();

  // App & Brand
  static const String appName = "Triangles";

  // Navigation & Generator Titles
  static const String navWelcome = "Welcome";
  static const String navTypes = "Types";
  static const String navPalettePicker = "Palette Picker";
  static const String navHtmlColour = "HTML Colour";
  static const String navRandomPalette = "Random Palette";
  static const String navRandomGrayscale = "Random Grayscale";
  static const String imagePalette = "Image Palette";
  static const String imageSamplerPalette = "Image Sampler Palette";
  static const String navPreferences = "Preferences";
  static const String navSettings = "Settings";
  static const String navAbout = "About";

  // Welcome Screen
  static const String welcomeHeadline = "Our triangles wallpaper project!";
  static const String welcomeSubtitle =
      "You can generate many variations of images with different colours and textures. "
      "Check out some of the samples below to get an idea.";
  static const String welcomeGetGeneratingTitle = "Get Generating";
  static const String welcomeInstructions =
      "To begin, just select a pattern from the types menu and get generating. "
      "Make changes by refreshing the palette or refreshing the positions of the triangles and colours.";
  static const String welcomeEnjoy = "Enjoy!";

  // Generator Controls & Overlays
  static const String type = "Type";
  static const String texture = "Texture";
  static const String textureNone = "None";
  static const String blendMode = "Blend Mode";
  static const String downloadImage = "Download Image";
  static const String buildingTriangles = "Building Triangles...";
  static const String generatedTriangles = "Generated Triangles";
  static const String referencePaletteSource = "Reference Palette Source";
  static const String noPaletteSelected = "No palette selected";
  static const String createPalette = "Create Palette";
  static const String showReference = "Show Reference";
  static const String hideReference = "Hide Reference";
  static const String showHistory = "Show History";

  // Zoom & Pan Controls
  static const String zoomIn = "Zoom in (+25%)";
  static const String zoomOut = "Zoom out (-20%)";
  static const String resetZoomAndPosition = "Reset zoom and position";

  // History Drawer
  static const String history = "History";
  static const String newPalette = "New Palette";
  static const String clearHistory = "Clear History";
  static const String noHistoryYet = "No history yet";
  static const String untitledPalette = "Untitled Palette";
  static const String editPalette = "Edit Palette";
  static const String deletePalette = "Delete Palette";

  // Palette Picker Dialog & Modal
  static const String createCustomPalette = "Create Custom Palette";
  static const String paletteName = "Palette Name";
  static const String addColor = "Add Color";
  static const String removeColor = "Remove Color";
  static const String editColor = "Edit Color";
  static const String selectColorPrompt = "Select a color to edit";
  static const String red = "Red";
  static const String green = "Green";
  static const String blue = "Blue";
  static const String labelR = "R";
  static const String labelG = "G";
  static const String labelB = "B";
  static const String cancel = "Cancel";
  static const String select = "Select";
  static const String close = "Close";
  static const String defaultCustomPaletteName = "My Custom Palette";

  // Navigation & Drawer Controls
  static const String closeSidebar = "Close sidebar";
  static const String toggleMenu = "Toggle menu";

  // File & Download Defaults
  static const String defaultImageFilename = "triangles";
  static const String fileExtensionPng = "png";
  static const String defaultDownloadFilename = "triangles.png";
  static const String sampleImagePrefix = "Sample";

  // Status & Error Messages
  static const String noPaletteProvided = "No palette provided";
  static const String errorGeneratingPalette = "Error generating palette";
  static const String errorGeneratingImage = "Error generating image";
  static const String errorCreatingImage = "Error creating image";
  static const String errorPaletteProviderNull = "Palette provider returned null palette";
  static const String errorImageNotGenerated = "Looks like image was not generated";
  static const String errorFailedToDecodeImage = "Failed to decode image";

  // Palette Names & Providers
  static const String paletteRandomColors = "Random Colors";
  static const String paletteRandomWarmColors = "Random Warm Colors";
  static const String paletteRandomCoolColors = "Random Cool Colors";
  static const String paletteRandomComplementaryColors = "Random Complementary Colors";
  static const String paletteRandomAnalogousColors = "Random Analogous Colors";
  static const String paletteNamedColors = "Named Colors";
  static const String paletteFixed = "Fixed";
  static const String paletteCommaSeparated = "Comma Separated";
  static const String paletteImageSample = "Image Sample Palette";

  // Settings Page & Screen
  static const String imageConfiguration = "Image Configuration";
  static const String imageWidth = "Width";
  static const String imageHeight = "Height";
  static const String scaleFactor = "Scale Factor";
  static const String addTriangleGradients = "Add triangle gradients";
  static const String annotateWithDimensions = "Annotate with dimensions";

  // About Page & Screen
  static const String aboutProjectTitle = "Project";
  static const String aboutProjectDescription =
      "Triangles is written and maintained by WillShex Limited for fun "
      "and because we like triangles (in case you have not noticed).";
  static const String aboutSoftwareTitle = "Software";
  static const String aboutSoftwareDescription =
      "Triangles is built with Flutter and made possible by many open source libraries:";
  static const String aboutJasprLink = "Jaspr (Web Framework)";
  static const String aboutJasprUrl = "https://docs.jaspr.site/";
  static const String aboutFlutterLink = "Flutter";
  static const String aboutFlutterUrl = "https://flutter.dev/";
  static const String aboutRomainGuyLink = "Romain Guy's blend modes";
  static const String aboutRomainGuyUrl =
      "http://www.curious-creature.org/2006/09/20/new-blendings-modes-for-java2d/";
  static const String aboutImagesTitle = "Images";
  static const String aboutImagesDescription =
      "Sample images and backgrounds are provided by:";
  static const String aboutLoremPicsumLink = "Lorem Picsum";
  static const String aboutLoremPicsumUrl = "https://picsum.photos/";
  static const String aboutSubtlePatternsLink = "Subtle Patterns";
  static const String aboutSubtlePatternsUrl =
      "https://www.toptal.com/designers/subtlepatterns/";
  static const String aboutLegalTitle = "Legal";
  static const String aboutLegalDescription =
      "You can use any of the images you generate/download for free for all commercial "
      "and non-commercial projects. We would love to hear from you about how you are using the images "
      "and for what projects. If you feel like giving us a mention we would really appreciate that too.";

  // Theme
  static const String toggleTheme = "Toggle Theme";
  static const String lightMode = "Light Mode";
  static const String darkMode = "Dark Mode";
}
