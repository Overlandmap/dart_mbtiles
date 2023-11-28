import 'package:mbtiles/mbtiles.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  test('Open read only raster Database', () {
    final _ = MBTiles(
      mbtilesPath: rasterMbtilesPath,
      sqlitePath: sqliteLibPath,
    );
  });
  test('Open read write raster Database', () {
    final _ = MBTiles(
      mbtilesPath: rasterMbtilesPath,
      sqlitePath: sqliteLibPath,
      editable: true,
    );
  });
}
