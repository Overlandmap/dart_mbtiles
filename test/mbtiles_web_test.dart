import 'package:mbtiles/src/mbtiles.dart';
import 'package:test/test.dart';

void main() {
  const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');

  test('Test compilation for web', () {
    if (!kIsWeb) return;
    final _ = MBTiles(
      mbtilesPath: 'noRealFile.mbtiles',
    );
  });
}
