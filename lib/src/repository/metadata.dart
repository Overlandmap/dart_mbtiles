import 'package:mbtiles/mbtiles.dart';
import 'package:sqlite3/common.dart';

class MetadataRepository {
  final CommonDatabase database;

  const MetadataRepository({required this.database});

  MBTilesMetadata getAll() {
    final rows = database.select('SELECT * FROM metadata');
    final map = <String, String>{};
    for (final row in rows) {
      final name = row['name'] as String;
      final value = row['value'] as String;
      map[name] = value;
    }

    assert(
      map.containsKey('name'),
      'Invalid metadata table: The table must contain a name row.',
    );
    assert(
      map.containsKey('format'),
      'Invalid metadata table: The table must contain a format row.',
    );

    // tile layer bounds
    ((double, double), (double, double))? bounds;
    if (map.containsKey('bounds')) {
      final values = map['bounds']!.split(',');
      bounds = (
        (double.parse(values[0]), double.parse(values[1])),
        (double.parse(values[2]), double.parse(values[3])),
      );
    }

    // default tile layer center and zoom level
    (double, double)? center;
    double? zoom;
    if (map.containsKey('center')) {
      final values = map['center']!.split(',');
      center = (double.parse(values[0]), double.parse(values[1]));
      zoom = double.parse(values[2]);
    }

    return MBTilesMetadata(
      name: map['name']!,
      format: map['format']!,
      type: _parseTileLayerType(map['type']),
      bounds: bounds,
      attributionHtml: map['attribution'],
      defaultCenter: center,
      defaultZoom: zoom,
      description: map['description'],
      json: map['json'],
      maxZoom: map['max_zoom'] == null ? null : int.parse(map['max_zoom']!),
      minZoom: map['min_zoom'] == null ? null : int.parse(map['min_zoom']!),
      version: map['version'] == null ? null : int.parse(map['version']!),
    );
  }

  TileLayerType? _parseTileLayerType(String? raw) => switch (raw) {
        'baselayer' => TileLayerType.baseLayer,
        'overlay' => TileLayerType.overlay,
        null => null,
        _ => throw Exception(
            'The MBTiles file contains an unsupported tile layer type: $raw',
          ),
      };

  void createTable() => database.execute('''
      CREATE TABLE metadata (name text PRIMARY KEY, value text);
      ''');

  void putAll(MBTilesMetadata metadata) {
    assert(
      metadata.defaultCenter == null && metadata.defaultZoom == null ||
          metadata.defaultCenter != null && metadata.defaultZoom != null,
      'Default center and zoom need to be both set if one is set.',
    );

    final stmt = database.prepare('''
        INSERT OR REPLACE INTO metadata
        (name, value) 
        VALUES (?, ?);
        ''');
    stmt.execute(['name', metadata.name]);
    stmt.execute(['format', metadata.format]);
    if (metadata.bounds != null) {
      stmt.execute([
        'bounds',
        '${metadata.bounds!.$1.$1},${metadata.bounds!.$1.$2},${metadata.bounds!.$2.$1},${metadata.bounds!.$2.$2}',
      ]);
    }
    if (metadata.type != null) {
      stmt.execute(['type', metadata.type!.name]);
    }
    if (metadata.defaultZoom != null && metadata.defaultCenter != null) {
      stmt.execute([
        'center',
        '${metadata.defaultCenter?.$1},${metadata.defaultCenter?.$2},${metadata.defaultZoom}',
      ]);
    }
    if (metadata.attributionHtml != null) {
      stmt.execute(['attribution', metadata.attributionHtml]);
    }
    if (metadata.description != null) {
      stmt.execute(['description', metadata.description]);
    }
    if (metadata.json != null) {
      stmt.execute(['json', metadata.json]);
    }
    if (metadata.maxZoom != null) {
      stmt.execute(['max_zoom', metadata.maxZoom]);
    }
    if (metadata.minZoom != null) {
      stmt.execute(['min_zoom', metadata.minZoom]);
    }
    if (metadata.version != null) {
      stmt.execute(['version', metadata.version]);
    }
  }
}
