import 'package:flutter/material.dart';

import 'semana.dart';

class EventoDto {
  final String titulo;
  final String descricao;
  final TimeOfDay horaInicial;
  final TimeOfDay horaFinal;
  final DateTime dataInicial;
  final DateTime dataFinal;
  final List<Semana> diasDaSemana;

  EventoDto(this.titulo, this.descricao, this.horaInicial, this.horaFinal,
      this.dataInicial, this.dataFinal, this.diasDaSemana);
}