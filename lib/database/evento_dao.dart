import 'package:compiti_2/models/evento.dart';
import 'package:compiti_2/models/evento_status.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

class EventoDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_titulo TEXT, '
      '$_descricao TEXT,'
      '$_horaInicial TEXT,'
      '$_horaFinal TEXT,'
      '$_dataInicial TEXT,'
      '$_dataFinal TEXT,'
      '$_status TEXT)';
  static const String _tableName = 'events';
  static const String _id = 'id';
  static const String _titulo = 'titulo';
  static const String _descricao = 'descricao';
  static const String _horaInicial = 'hora_inicial';
  static const String _horaFinal = 'hora_final';
  static const String _dataInicial = 'data_inicial';
  static const String _dataFinal = 'data_final';
  static const String _status = 'status';

  Future<int> save(Evento evento) async {
    final Database db = await getDatabase();
    Map<String, dynamic> eventoMap = _toMap(evento);
    return db.insert(_tableName, eventoMap);
  }

  Future<List<Evento>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Evento> eventos = _toList(result);
    return eventos;
  }

  Map<String, dynamic> _toMap(Evento evento) {
    final Map<String, dynamic> eventoMap = Map();
    eventoMap[_titulo] = evento.titulo;
    eventoMap[_descricao] = evento.descricao;
    eventoMap[_horaInicial] = evento.horaInicial.toString();
    eventoMap[_horaFinal] = evento.horaFinal.toString();
    eventoMap[_dataInicial] = evento.dataInicial.toString();
    eventoMap[_dataFinal] = evento.dataFinal.toString();
    eventoMap[_status] = evento.eventoStatus.toString();
    return eventoMap;
  }

  List<Evento> _toList(List<Map<String, dynamic>> result) {
    final List<Evento> eventos = List();
    for (Map<String, dynamic> row in result) {
      var dataInicialSplit =
          row[_dataInicial].toString().substring(0, 10).split('-');
      var dataFinalSplit =
          row[_dataFinal].toString().substring(0, 10).split('-');
      var horaInicialSplit = row[_horaInicial].toString().substring(10, 15).split(':');
      var horaFinalSplit = row[_horaFinal].toString().substring(10, 15).split(':');
      EventoStatus eventoStatus;
      if(row[_status] == 'EventoStatus.agendado'){
        eventoStatus = EventoStatus.agendado;
      } else {
        if(row[_status] == 'EventoStatus.nao_feito'){
          eventoStatus = EventoStatus.nao_feito;
        } else {
          eventoStatus = EventoStatus.feito;
        }
      }
      final Evento evento = Evento(
        row[_id],
        row[_titulo],
        row[_descricao],
        TimeOfDay(
          hour: int.parse(
              horaInicialSplit.elementAt(0)),
          minute: int.parse(
              horaInicialSplit.elementAt(1)),
        ),
        TimeOfDay(
          hour: int.parse(
              horaFinalSplit.elementAt(0)),
          minute: int.parse(
              horaFinalSplit.elementAt(1)),
        ),
        DateTime(
          int.parse(dataInicialSplit.elementAt(0)),
          int.parse(dataInicialSplit.elementAt(1)),
          int.parse(dataInicialSplit.elementAt(2)),
        ),
        DateTime(
          int.parse(dataFinalSplit.elementAt(0)),
          int.parse(dataFinalSplit.elementAt(1)),
          int.parse(dataFinalSplit.elementAt(2)),
        ),
        eventoStatus,
      );
      eventos.add(evento);
    }
    return eventos;
  }

  void deleteAll() async {
    final Database db = await getDatabase();
    db.delete(_tableName);
  }
}
