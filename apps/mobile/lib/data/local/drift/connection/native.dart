import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

QueryExecutor openConnection() {
  return LazyDatabase(() async {
    final appDocuments = await getApplicationDocumentsDirectory();
    final file = File(p.join(appDocuments.path, 'inline_hockey_coach.sqlite'));
    return NativeDatabase(file);
  });
}
QueryExecutor openMemoryConnection() => NativeDatabase.memory();
