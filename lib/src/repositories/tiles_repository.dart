import 'dart:io';
import 'dart:typed_data';

import 'package:sqlite3/sqlite3.dart';

class TilesRepository {
  final Database database;
  final bool useGzip;

  const TilesRepository({required this.database, required this.useGzip});

  Uint8List? getTile(int zoom, int column, int row) {
    final rows = database.select(
      '''
    SELECT tile_data FROM tiles 
    WHERE zoom_level = ? AND tile_column = ? AND tile_row = ?
    LIMIT 1
    ''',
      [zoom, column, row],
    );
    if (rows.isEmpty) return null;
    final bytes = rows.first['tile_data'] as Uint8List;
    if (!useGzip) return bytes;
    return gzip.decode(bytes) as Uint8List;
  }
}
