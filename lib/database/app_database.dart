import 'package:compiti_2/database/evento_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'compiti.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(EventoDao.tableSql);
    },
    version: 1,
  );
}