import 'package:flutter/material.dart';

import 'evento_status.dart';

class Evento {
  final int id;
  final String titulo;
  final String descricao;
  final String horaInicial;
  final String horaFinal;
  final DateTime dataInicial;
  final DateTime dataFinal;
  final EventoStatus eventoStatus;

  Evento(this.id, this.titulo, this.descricao, this.horaInicial, this.horaFinal,
      this.dataInicial, this.dataFinal, this.eventoStatus);

  @override
  String toString() {
    return 'Evento{id: $id, titulo: $titulo, descricao: $descricao, horaInicial: $horaInicial, horaFinal: $horaFinal, dataInicial: $dataInicial, dataFinal: $dataFinal, eventoStatus: $eventoStatus}';
  }
}