import 'dart:io';
import 'dart:math';

import 'package:mbtiles/mbtiles.dart';

void main() {
  // Get paths for the current platform. This is not needed if you
  // use `sqlite3_flutter_libs` on Android or iOS.
  final sqlitePath = Platform.isWindows
      ? r'assets\windows\sqlite3.dll'
      : 'assets/${Platform.operatingSystem}/sqlite3';

  // open mbtiles
  final sep = Platform.pathSeparator;
  final mbtiles = MBTiles(
    mbtilesPath: 'assets${sep}mbtiles${sep}countries-raster.mbtiles',
    sqlitePath: sqlitePath,
  );

  // get metadata
  final metadata = mbtiles.getMetadata();
  print(metadata);

  // get tile data
  final tile = mbtiles.getTile(0, 0, 0);
  final tileSize = tile?.length ?? 0;
  print('Tile size: ${formatFileSize(tileSize)}');

  // close mbtiles
  mbtiles.dispose();
}

/// Return a formatted String for an amount of bytes
/// (from https://stackoverflow.com/a/74568711/9439899)
String formatFileSize(int amountBytes, {int decimals = 0}) {
  const suffixes = ["b", "kb", "mb", "gb", "tb"];
  if (amountBytes == 0) return '0${suffixes[0]}';
  final i = (log(amountBytes) / log(1024)).floor();
  return ((amountBytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
}
