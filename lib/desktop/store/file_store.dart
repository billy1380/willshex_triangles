import "dart:io";
import "package:logging/logging.dart";
import "../../triangles/store.dart";

/// File-based implementation of the Store interface
class FileStore implements Store {
  static final Logger _log = Logger("FileStore");

  @override
  StoreImage? load(String name, int index) {
    StoreImage? image;

    final Directory folder = _folder(name);

    if (folder.existsSync()) {
      final String prefix = _nameFromIndex(index);
      final List<FileSystemEntity> files = folder
          .listSync()
          .where((entity) => entity is File && entity.path.contains(prefix))
          .toList();

      if (files.isNotEmpty) {
        if (files.length > 1) {
          _log.warning("More than one file found!?");
        }

        final File file = files.first as File;
        image = StoreImage();

        try {
          image.content = file.readAsBytesSync();
          image.format = file.path.split(".").last;
        } catch (e) {
          _log.severe("Could not read file: $e");
        }
      }
    }

    return image;
  }

  @override
  void save(StoreImage image, String name, int index) {
    final Directory folder = _createFolder(name);
    final String fileName = "${_nameFromIndex(index)}${image.format}";
    final File file = File("${folder.path}/$fileName");

    try {
      if (image.content != null) {
        file.writeAsBytesSync(image.content!);
      }
    } catch (e) {
      _log.severe("Could not write to file: $e");
    }
  }

  /// Generate filename from index
  String _nameFromIndex(int index) {
    return "image_$index.";
  }

  /// Create folder for storing images
  Directory _createFolder(String name) {
    final Directory folder = _folder(name);

    if (!folder.existsSync()) {
      folder.createSync(recursive: true);
    }

    return folder;
  }

  /// Get folder path for a given name
  Directory _folder(String name) {
    return Directory("output/named/$name");
  }
}
