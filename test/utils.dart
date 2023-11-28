import 'dart:io';

final assetsDirPath = 'example${Platform.pathSeparator}assets';

final sqliteLibPath = Platform.isWindows
    ? '$assetsDirPath\\windows\\sqlite3.dll'
    : '$assetsDirPath/${Platform.operatingSystem}/sqlite3';

final mbtilesDirPath =
    '$assetsDirPath${Platform.pathSeparator}mbtiles${Platform.pathSeparator}';

final vectorMbtilesPath = '${mbtilesDirPath}countries-vector.mbtiles';
final rasterMbtilesPath = '${mbtilesDirPath}countries-raster.mbtiles';
