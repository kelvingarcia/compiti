import 'package:flutter/material.dart';


class Evento {
  final int id;
  final String titulo;
  final String descricao;
  final TimeOfDay horaInicial;
  final TimeOfDay horaFinal;
  final DateTime dataInicial;
  final DateTime dataFinal;

  Evento(this.id, this.titulo, this.descricao, this.horaInicial, this.horaFinal,
      this.dataInicial, this.dataFinal);

  @override
  String toString() {
    return 'Evento{id: $id, titulo: $titulo, descricao: $descricao, horaInicial: $horaInicial, horaFinal: $horaFinal, dataInicial: $dataInicial, dataFinal: $dataFinal}';
  }

}