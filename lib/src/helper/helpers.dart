import 'dart:ffi';

import 'package:sqlite3/open.dart';

/// Use the sqlite3 library from the provided path
void loadSqLiteLib(String? sqlitePath) {
  if (sqlitePath != null) {
    open.overrideForAll(() => DynamicLibrary.open(sqlitePath));
  }
}
