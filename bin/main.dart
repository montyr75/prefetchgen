import 'dart:io';
import 'package:path/path.dart' as Path;

// name of prefetch file to output
const String OUTPUT_FILENAME = "prefetch.html";

// list of supported image types
final List<String> imageExt = const <String>[
  ".jpg",
  ".jpeg",
  ".png",
  ".gif",
  ".webp",
  ".tif",
  ".tiff",
  ".jp2",
  ".jpx",
  ".j2k",
  ".j2c"
];

void main() {
  StringBuffer screenBuffer = new StringBuffer();
  StringBuffer fileBuffer = new StringBuffer();

  // start from the current directory
  Directory dir = Directory.current;

  // get a list of all child entities (files and directories)
  List<FileSystemEntity> entList = dir.listSync(recursive: true, followLinks: false);

  // filter the list down to only image files
  List<FileSystemEntity> imgFileList = entList.where((FileSystemEntity ent) => ent is File && imageExt.contains(Path.extension(ent.path))).toList();

  // create a list of image file paths relative to the current directory
  List<String> imgPaths = imgFileList.map((File f) => f.path.split("${dir.path}\\").last.replaceAll(r"\", r"/")).toList();

  print("Found ${imgPaths != null ? imgPaths.length : 0} images...");

  // if we found images, write the list to the screen and create the prefetch file
  if (imgPaths != null && imgPaths.length > 0) {
    for (String img in imgPaths) {
      screenBuffer.writeln("  $img");
      fileBuffer.writeln('<link rel="prefetch" href="$img"/>');
    }

    screenBuffer.writeln();

    stdout.write("${screenBuffer.toString()}");

    new File(OUTPUT_FILENAME).writeAsString(fileBuffer.toString())
      .then((_) => stdout.writeln("$OUTPUT_FILENAME created."))
      .catchError(() {
        exitCode = 2;
        print("Error writing file.");
    });
  }
}
