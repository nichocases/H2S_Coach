import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:sqlite3/wasm.dart';

QueryExecutor openConnection() {
  return DatabaseConnection.delayed(Future(() async {
    final sqlite3 = await WasmSqlite3.loadFromUrl(Uri.parse('sqlite3.wasm'));
    final fs = await IndexedDbFileSystem.open(dbName: 'inline_hockey_coach');
    sqlite3.registerVirtualFileSystem(fs, makeDefault: true);
    return DatabaseConnection(WasmDatabase(sqlite3: sqlite3, path: '/app.db'));
  }));
}

QueryExecutor openMemoryConnection() {
  return DatabaseConnection.delayed(Future(() async {
    final sqlite3 = await WasmSqlite3.loadFromUrl(Uri.parse('sqlite3.wasm'));
    final fs = InMemoryFileSystem();
    sqlite3.registerVirtualFileSystem(fs, makeDefault: true);
    return DatabaseConnection(WasmDatabase(sqlite3: sqlite3, path: '/test.db'));
  }));
}
