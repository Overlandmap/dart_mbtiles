import 'dart:ffi';
import 'dart:typed_data';

import 'package:mbtiles/mbtiles.dart';
import 'package:mbtiles/src/repositories/metadata_repository.dart';
import 'package:mbtiles/src/repositories/tiles_repository.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';

class MBTiles {
  late final Database _database;
  late final MetadataRepository _metadataRepo;
  late final TilesRepository _tileRepo;

  /// cached metadata values
  MBTilesMetadata? _metadata;

  /// Open a MBTiles file. Use the [sqlitePath] parameter if you don't use the
  /// `sqlite3_flutter_libs` package.
  MBTiles({
    required String mbtilesPath,
    String? sqlitePath,
    bool? isPBF,
  }) {
    if (sqlitePath != null) {
      open.overrideForAll(() => DynamicLibrary.open(sqlitePath));
    }
    _database = sqlite3.open(mbtilesPath);
    _metadataRepo = MetadataRepository(_database);
    _tileRepo = TilesRepository(
      database: _database,
      useGzip: isPBF ?? getMetadata().format == 'pbf',
    );
  }

  /// Cached metadata that is stored inside the mbtiles file
  MBTilesMetadata getMetadata({bool allowCache = true}) {
    if (_metadata != null && allowCache) return _metadata!;
    return _metadata = _metadataRepo.getAll();
  }

  /// Fetch the data for a tile, returns null if the tile is not found
  Uint8List? getTile(int z, int x, int y) => _tileRepo.getTile(z, x, y);

  /// Call dispose to correctly close the sqlite database
  void dispose() {
    _database.dispose();
  }
}
