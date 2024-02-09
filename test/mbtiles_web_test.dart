import 'package:mbtiles/src/mbtiles.dart';
import 'package:test/test.dart';

const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');

void main() {
  test('Test compilation for web', () {
    if (!kIsWeb) return;

    expect(
      () => MBTiles(mbtilesPath: 'noRealFile.mbtiles'),
      throwsA(const TypeMatcher<UnimplementedError>()),
    );
  });
}
