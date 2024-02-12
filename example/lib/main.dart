import 'dart:io';
import 'dart:math';

import 'package:mbtiles/mbtiles.dart';

void main() {
  // Get paths for the current platform. This is not needed if you
  // use `sqlite3_flutter_libs` on Android or iOS.
  final sqlitePath = Platform.isWindows
      ? r'assets\windows\sqlite3.dll'
      : 'assets/${Platform.operatingSystem}/sqlite3';

  print('RASTER MBTILES');

  // open mbtiles
  final sep = Platform.pathSeparator;
  final rasterMbtiles = MBTiles(
    mbtilesPath: 'assets${sep}mbtiles${sep}countries-raster.mbtiles',
    sqlitePath: sqlitePath,
  );

  // get metadata
  final metadata = rasterMbtiles.getMetadata();
  print(metadata);

  // get tile data
  final rasterTile = rasterMbtiles.getTile(z: 0, x: 0, y: 0);
  final rasterTileSize = rasterTile?.length ?? 0;
  print('Tile size: ${formatSize(rasterTileSize)}\n');

  // close mbtiles
  rasterMbtiles.dispose();

  print('VECTOR MBTILES');

  // open mbtiles
  final vectorMbtiles = MBTiles(
    mbtilesPath: 'assets${sep}mbtiles${sep}countries-vector.mbtiles',
    sqlitePath: sqlitePath,
  );

  // get metadata
  print(vectorMbtiles.getMetadata());

  // get tile data
  final vectorTile = vectorMbtiles.getTile(z: 0, x: 0, y: 0);
  final vectorTileSize = vectorTile?.length ?? 0;
  print('Uncompressed tile size: ${formatSize(vectorTileSize)}');

  // close mbtiles
  vectorMbtiles.dispose();
}

/// Return a formatted String for an amount of bytes
/// (from https://stackoverflow.com/a/74568711/9439899)
String formatSize(int amountBytes, {int decimals = 0}) {
  const suffixes = ["b", "kb", "mb", "gb", "tb"];
  if (amountBytes == 0) return '0${suffixes[0]}';
  final i = (log(amountBytes) / log(1024)).floor();
  return ((amountBytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
}
