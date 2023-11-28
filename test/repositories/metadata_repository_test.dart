import 'dart:ffi';

import 'package:mbtiles/mbtiles.dart';
import 'package:mbtiles/src/repositories/metadata_repository.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  test('Put and get Metadata', () {
    // given
    const metadata1 = MBTilesMetadata(
      name: 'Example MBTiles',
      format: 'pbf',
      minZoom: 1,
      maxZoom: 12,
      version: 23,
      json: "{}",
      description: "A small description",
      defaultZoom: 6,
      defaultCenter: (47, 9),
      attributionHtml: "Not a real attribution message",
      bounds: ((-180, -90), (180, 90)),
    );
    open.overrideForAll(() => DynamicLibrary.open(sqliteLibPath));
    final database = sqlite3.openInMemory();
    final repo = MetadataRepository(database: database);

    // when
    repo.createTable();
    repo.putAll(metadata1);
    final metadata2 = repo.getAll();

    // then
    expect(metadata2, metadata1);
  });
}
