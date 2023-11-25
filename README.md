# mbtiles

A dart package that gives support for MBTiles files.

![Pub Likes](https://img.shields.io/pub/likes/mbtiles)
![Pub Points](https://img.shields.io/pub/points/mbtiles)
![Pub Popularity](https://img.shields.io/pub/popularity/mbtiles)
![Pub Version](https://img.shields.io/pub/v/mbtiles)

![GitHub last commit](https://img.shields.io/github/last-commit/josxha/dart_mbtiles)
![GitHub issues](https://img.shields.io/github/issues/josxha/dart_mbtiles)
![GitHub Repo stars](https://img.shields.io/github/stars/josxha/dart_mbtiles?style=social)

## Getting started

#### pubspec.yaml
```yaml
dependencies:
  # this package:
  mbtiles: ^0.0.1
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
final tile = mbtiles.getTile(0, 0, 0);

// close mbtiles
mbtiles.dispose();
```

## Additional information

- [MBTiles specification](https://github.com/mapbox/mbtiles-spec)