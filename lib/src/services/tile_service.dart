import 'dart:typed_data';

import 'package:mbtiles/mbtiles.dart';
import 'package:sqlite3/sqlite3.dart';

class TileService {
  final Database _database;

  const TileService(this._database);

  Uint8List? getTile(int zoom, int column, int row) {
    final rows = _database.select('SELECT tile_data FROM tiles LIMIT 1');
    if (rows.isEmpty) return null;
    return rows.first['tile_data'] as Uint8List;
  }

  TileLayerType? _parseTileLayerType(String? raw) => switch (raw) {
        'baselayer' => TileLayerType.baseLayer,
        'overlay' => TileLayerType.overlay,
        null => null,
        _ => throw Exception(
            'The MBTiles file contains an unsupported tile layer type: $raw',
          ),
      };
}
