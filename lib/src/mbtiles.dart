import 'dart:ffi';
import 'dart:typed_data';

import 'package:mbtiles/mbtiles.dart';
import 'package:mbtiles/src/repositories/metadata_repository.dart';
import 'package:mbtiles/src/repositories/tiles_repository.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';

class MBTiles {
  static const _notEditableAssertMsg =
      'Database not editable, please set the parameter '
      '`MBTiles(..., editable: true).';
  late final Database _database;
  late final MetadataRepository _metadataRepo;
  late final TilesRepository _tileRepo;

  /// Set to true if the mbtiles database can be modified, defaults to false.
  final bool editable;

  /// cached metadata values
  MBTilesMetadata? _metadata;

  /// Open a MBTiles file.
  /// Use the [sqlitePath] parameter if you don't use the
  /// `sqlite3_flutter_libs` package.
  /// Set [isPBF] to true if the format of the mbtiles file is vector pbf. This
  /// flag is optional but will gain a small performance benefit at the begin.
  MBTiles({
    required String mbtilesPath,
    String? sqlitePath,
    bool? isPBF,
    this.editable = false,
  }) {
    if (sqlitePath != null) {
      open.overrideForAll(() => DynamicLibrary.open(sqlitePath));
    }
    _database = sqlite3.open(
      mbtilesPath,
      mode: editable ? OpenMode.readWriteCreate : OpenMode.readOnly,
    );
    _metadataRepo = MetadataRepository(database: _database);
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

  /// Create all tables for the mbtiles file
  void createTables() {
    assert(editable, _notEditableAssertMsg);
    _metadataRepo.createTable();
    _tileRepo.createTable();
  }

  /// Inserts or updates a tile
  void putTile(int z, int x, int y, Uint8List bytes) {
    assert(editable, _notEditableAssertMsg);
    _tileRepo.putTile(z, x, y, bytes);
  }

  /// Call dispose to correctly close the sqlite database
  void dispose() {
    _metadataRepo.dispose();
    _tileRepo.dispose();
    _database.dispose();
  }
}
