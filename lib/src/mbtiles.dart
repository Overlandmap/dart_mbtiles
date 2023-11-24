import 'dart:ffi';
import 'dart:typed_data';

import 'package:mbtiles/mbtiles.dart';
import 'package:mbtiles/src/services/metadata_service.dart';
import 'package:mbtiles/src/services/tile_service.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';

class MBTiles {
  late final Database _database;
  late final MetadataService _metadataService;
  late final TileService _tileService;

  /// cached metadata values
  MBTilesMetadata? _metadata;

  /// Open a MBTiles file. Use the [sqlitePath] parameter if you don't use the
  /// `sqlite3_flutter_libs` package.
  MBTiles({required String mbtilesPath, String? sqlitePath}) {
    // sqlite database
    if (sqlitePath != null) {
      open.overrideForAll(() => DynamicLibrary.open(sqlitePath));
    }
    _database = sqlite3.open(mbtilesPath);
    _metadataService = MetadataService(_database);
    _tileService = TileService(_database);
  }

  /// Cached metadata that is stored inside the mbtiles file
  MBTilesMetadata getMetadata() {
    if (_metadata != null) return _metadata!;
    return _metadata = _metadataService.getAll();
  }

  /// Fetch the data for a tile, returns null if the tile is not found
  Uint8List? getTile(int z, int x, int y) => _tileService.getTile(z, x, y);

  /// Call dispose to correctly close the sqlite database
  void dispose() {
    _database.dispose();
  }
}
