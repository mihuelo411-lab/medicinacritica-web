import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

QueryExecutor createConnection() {
  const dbName = 'nutrivigil.db';

  if (Platform.isAndroid || Platform.isIOS) {
    return SqfliteQueryExecutor.inDatabaseFolder(
      path: dbName,
      singleInstance: true,
    );
  }

  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, dbName));
    return NativeDatabase.createInBackground(file);
  });
}
