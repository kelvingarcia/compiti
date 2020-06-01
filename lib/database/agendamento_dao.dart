import 'package:compiti_2/database/evento_dao.dart';
import 'package:compiti_2/models/agendamento.dart';
import 'package:compiti_2/models/evento.dart';
import 'package:compiti_2/models/evento_status.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

class AgendamentoDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_data TEXT,'
      '$_horaInicial TEXT,'
      '$_horaFinal TEXT,'
      '$_evento INTEGER,'
      '$_status TEXT)';
  static const String _tableName = 'agendamentos';
  static const String _id = 'id';
  static const String _horaInicial = 'hora_inicial';
  static const String _horaFinal = 'hora_final';
  static const String _data = 'data';
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
    agendamentoMap[_horaInicial] = agendamento.horaInicial.toString();
    agendamentoMap[_horaFinal] = agendamento.horaFinal.toString();
    agendamentoMap[_data] = agendamento.data.toString();
    agendamentoMap[_status] = agendamento.eventoStatus.toString();
    agendamentoMap[_evento] = agendamento.evento.id;
    return agendamentoMap;
  }

  Future<List<Agendamento>> _toList(List<Map<String, dynamic>> result) async {
    final EventoDao _dao = EventoDao();
    final List<Agendamento> agendamentos = List();
    for (Map<String, dynamic> row in result) {
      var dataSplit = row[_data].toString().substring(0, 10).split('-');
      var horaInicialSplit =
          row[_horaInicial].toString().substring(10, 15).split(':');
      var horaFinalSplit =
          row[_horaFinal].toString().substring(10, 15).split(':');
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
      debugPrint(row[_evento].toString());
      final Evento evento = await _dao.find(int.parse(row[_evento].toString()));
      final Agendamento agendamento = Agendamento(
        row[_id],
        DateTime(
          int.parse(dataSplit.elementAt(0)),
          int.parse(dataSplit.elementAt(1)),
          int.parse(dataSplit.elementAt(2)),
        ),
        TimeOfDay(
          hour: int.parse(horaInicialSplit.elementAt(0)),
          minute: int.parse(horaInicialSplit.elementAt(1)),
        ),
        TimeOfDay(
          hour: int.parse(horaFinalSplit.elementAt(0)),
          minute: int.parse(horaFinalSplit.elementAt(1)),
        ),
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

  void deleteAll() async {
    final Database db = await getDatabase();
    db.delete(_tableName);
  }
}
