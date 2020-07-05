import 'package:compiti/database/evento_dao.dart';
import 'package:compiti/models/agendamento.dart';
import 'package:compiti/models/evento.dart';
import 'package:compiti/models/evento_status.dart';
import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

class AgendamentoDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_dataInicial TEXT,'
      '$_dataFinal TEXT,'
      '$_evento INTEGER,'
      '$_status TEXT)';
  static const String _tableName = 'agendamentos';
  static const String _id = 'id';
  static const String _dataInicial = 'dataInicial';
  static const String _dataFinal = 'dataFinal';
  static const String _status = 'status';
  static const String _evento = 'evento';

  Future<int> save(Agendamento agendamento) async {
    final Database db = await getDatabase();
    Map<String, dynamic> eventoMap = _toMap(agendamento);
    return db.insert(_tableName, eventoMap);
  }

  Future<List<Agendamento>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Agendamento> agendamentos = await _toList(result);
    return agendamentos;
  }

  Map<String, dynamic> _toMap(Agendamento agendamento) {
    final Map<String, dynamic> agendamentoMap = Map();
    agendamentoMap[_dataInicial] = agendamento.dataInicial.toString();
    agendamentoMap[_dataFinal] = agendamento.dataFinal.toString();
    agendamentoMap[_status] = agendamento.eventoStatus.toString();
    agendamentoMap[_evento] = agendamento.evento.id;
    return agendamentoMap;
  }

  Future<List<Agendamento>> _toList(List<Map<String, dynamic>> result) async {
    final EventoDao _dao = EventoDao();
    final List<Agendamento> agendamentos = List();
    for (Map<String, dynamic> row in result) {
      EventoStatus eventoStatus;
      if (row[_status] == 'EventoStatus.agendado') {
        eventoStatus = EventoStatus.agendado;
      } else {
        if (row[_status] == 'EventoStatus.nao_feito') {
          eventoStatus = EventoStatus.nao_feito;
        } else {
          eventoStatus = EventoStatus.feito;
        }
      }
      final Evento evento = await _dao.find(int.parse(row[_evento].toString()));
      final Agendamento agendamento = Agendamento(
        row[_id],
        DateTime.parse(row[_dataInicial]),
        DateTime.parse(row[_dataFinal]),
        evento,
        eventoStatus,
      );
      agendamentos.add(agendamento);
    }
    return agendamentos;
  }

  Future<Agendamento> find(int id) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $_tableName where id=$id');
    List<Agendamento> agendamentos = await _toList(result);
    return agendamentos.removeLast();
  }

  Future<void> editar(Agendamento agendamento) async {
    final Database db = await getDatabase();
    Map<String, dynamic> agendamentoMap = _toMap(agendamento);
    await db.update(_tableName, agendamentoMap,
        where: "id = ?", whereArgs: [agendamento.id]);
  }

  Future<List<Agendamento>> findByEvento(Evento evento) async {
    final Database db = await getDatabase();
    final int id = evento.id;
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $_tableName where evento=$id');
    List<Agendamento> agendamentos = await _toList(result);
    return agendamentos;
  }

  Future<void> deleteAgendamento(Agendamento agendamento) async {
    final Database db = await getDatabase();
    int id = agendamento.id;
    await db.rawQuery('DELETE FROM $_tableName where id=$id');
  }

  Future<void> deleteFromEvento(Evento evento) async {
    final Database db = await getDatabase();
    int id = evento.id;
    await db.rawQuery('DELETE FROM $_tableName where $_evento=$id');
  }

  void deleteAll() async {
    final Database db = await getDatabase();
    db.delete(_tableName);
  }
}
