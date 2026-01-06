import 'package:drift/drift.dart';

import 'open_connection_stub.dart'
    if (dart.library.html) 'open_connection_web.dart'
    if (dart.library.io) 'open_connection_io.dart';

QueryExecutor openConnection() => createConnection();
