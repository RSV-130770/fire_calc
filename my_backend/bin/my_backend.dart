// backend.dart
import 'dart:convert';
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

final settings = ConnectionSettings(
  host: 'localhost', // XAMPP MySQL is local
  port: 3306,
  user: 'root',
  password: '123', // your password if any
  db: 'flutter_test',
);

Future<Response> clearRecords(Request request) async {
  try
  {
    final conn = await MySqlConnection.connect(settings);
    final results = await conn.query('DELETE FROM records;');
    print('✅ Records deleted');
    await conn.close();
    return Response.ok('Records deleted');
  } catch (e, stack)
  {
    print('❌ Error deleting record: $e');
    print(stack); // Log full stack trace
    return Response.internalServerError(body: 'Failed to delete records: $e');
    }
}

Future<Response> addRecord(Request request) async {
  try {
    print('📥 Received POST to /addRecord');
    final body = await request.readAsString();
    final data = jsonDecode(body);
    final str = data['str'];

    final conn = await MySqlConnection.connect(settings);

    await conn.query('''
      CREATE TABLE IF NOT EXISTS records (
        id INT AUTO_INCREMENT PRIMARY KEY,
        date DATETIME DEFAULT CURRENT_TIMESTAMP,
        str VARCHAR(100)
      )
    ''');

    await conn.query(
      'INSERT INTO records (str) VALUES (?)',
      [str],
    );

    await conn.close();
    print('✅ Record inserted');
    return Response.ok('Record inserted');
  } catch (e, stack) {
    print('❌ Error adding record: $e');
    print(stack); // Log full stack trace
    return Response.internalServerError(body: 'Failed to insert record: $e');
  }
}


Future<Response> getRecords(Request request) async {
  try {
    final conn = await MySqlConnection.connect(settings);
    final results = await conn.query('SELECT * FROM records');
    final data = results
        .map((row) => {'id': row[0], 'str': row[1], 'date': row[2].toString()})
        .toList();
    await conn.close();
    print('server connected');
    return Response.ok(jsonEncode(data),
        headers: {'Content-Type': 'application/json'});

  } catch (e) {
    print('server failed');
    return Response.internalServerError(body: 'Fetch failed: $e');
  }
}

void main() async {
  final router = Router()
    ..get('/records', getRecords)
    ..post('/addRecord', addRecord)
    ..post('/clearHistory', clearRecords);
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(router.call);

  final server = await io.serve(handler, '0.0.0.0', 8080);
  print('✅ Server running on http://${server.address.host}:${server.port}');
}
