# mbtiles

Mapbox MBTiles v1.3 files, support for vector and raster tiles.

- Supported raster tiles: `jpg`, `png`, `webp` 
- Supported vector tiles: `pbf`
- Web is not supported because of its missing support for SQLite.

[![Pub Version](https://img.shields.io/pub/v/mbtiles)](https://pub.dev/packages/mbtiles)
[![likes](https://img.shields.io/pub/likes/mbtiles?logo=flutter)](https://pub.dev/packages/mbtiles)
[![Pub Points](https://img.shields.io/pub/points/mbtiles)](https://pub.dev/packages/mbtiles/score)
[![Pub Popularity](https://img.shields.io/pub/popularity/mbtiles)](https://pub.dev/packages/mbtiles)

[![GitHub last commit](https://img.shields.io/github/last-commit/josxha/dart_mbtiles)](https://github.com/josxha/dart_mbtiles)
[![stars](https://badgen.net/github/stars/josxha/dart_mbtiles?label=stars&color=green&icon=github)](https://github.com/josxha/dart_mbtiles/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/josxha/dart_mbtiles)](https://github.com/josxha/dart_mbtiles/issues)
[![codecov](https://codecov.io/gh/josxha/dart_mbtiles/graph/badge.svg?token=RGB99KA1GJ)](https://codecov.io/gh/josxha/dart_mbtiles)

## Getting started

#### pubspec.yaml
```yaml
dependencies:
  # this package:
  mbtiles: ^0.3.0
  # coordinates will be returned as `LatLng`, include the following package 
  # if you want to work with them.
  latlong2: ^0.9.0
  # sqlite libraries in case not otherwise bundled (requires flutter):
  sqlite3_flutter_libs: ^0.5.18
```

## Usage

```dart
// Get paths for the current platform (Windows would need "\" instead of "/"). 
// This is not needed if you use `sqlite3_flutter_libs` on Android or iOS.
final sqlitePath = 'assets/${Platform.operatingSystem}/sqlite3';

// open mbtiles
final mbtiles = MBTiles(
  mbtilesPath: 'assets/mbtiles/countries-raster.mbtiles',
  sqlitePath: sqlitePath,
);

// get metadata
final metadata = mbtiles.getMetadata();
// get tile data
final tile = mbtiles.getTile(z: 0, x: 0, y: 0);

// close mbtiles
mbtiles.dispose();
```

See the [example program](https://pub.dev/packages/mbtiles/example) for more information.

## Additional information

- [MBTiles specification](https://github.com/mapbox/mbtiles-spec)
- [Read about MBTiles in the OpenStreetMap Wiki](https://wiki.openstreetmap.org/wiki/MBTiles)