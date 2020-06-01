import 'package:flutter/material.dart';

import 'evento.dart';
import 'evento_status.dart';

class Agendamento {
  final int id;
  final DateTime data;
  final TimeOfDay horaInicial;
  final TimeOfDay horaFinal;
  final Evento evento;
  final EventoStatus eventoStatus;

  Agendamento(this.id, this.data, this.horaInicial, this.horaFinal, this.evento,
      this.eventoStatus);

  @override
  String toString() {
    return 'Agendamento{id: $id, data: $data, horaInicial: $horaInicial, horaFinal: $horaFinal, eventoStatus: $eventoStatus}';
  }
}