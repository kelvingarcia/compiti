import 'package:flutter/material.dart';

import 'evento.dart';
import 'evento_status.dart';

class Agendamento {
  final int id;
  final DateTime data;
  final TimeOfDay hora;
  final Evento evento;
  final EventoStatus eventoStatus;

  Agendamento(this.id, this.data, this.hora, this.evento, this.eventoStatus);
}