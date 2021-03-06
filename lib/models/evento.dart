import 'package:compiti/models/semana.dart';
import 'package:flutter/material.dart';

class Evento {
  int id;
  final String titulo;
  final String descricao;
  final TimeOfDay horaInicial;
  final TimeOfDay horaFinal;
  final DateTime dataInicial;
  final DateTime dataFinal;
  final List<Semana> diasDaSemana;
  final List<int> listaNotificar;

  Evento(this.id, this.titulo, this.descricao, this.horaInicial, this.horaFinal,
      this.dataInicial, this.dataFinal, this.diasDaSemana, this.listaNotificar);

  @override
  String toString() {
    return 'Evento{id: $id, titulo: $titulo, descricao: $descricao, horaInicial: $horaInicial, horaFinal: $horaFinal, dataInicial: $dataInicial, dataFinal: $dataFinal, diasDaSemana: $diasDaSemana}';
  }
}
