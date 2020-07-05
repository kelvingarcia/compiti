import 'package:compiti/database/agendamento_dao.dart';
import 'package:compiti/database/evento_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'compiti.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(EventoDao.tableSql);
      db.execute(AgendamentoDao.tableSql);
    },
    version: 1,
  );
}
