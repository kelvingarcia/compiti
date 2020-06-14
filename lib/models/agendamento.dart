
import 'evento.dart';
import 'evento_status.dart';

class Agendamento {
  int id;
  final DateTime dataInicial;
  final DateTime dataFinal;
  final Evento evento;
  EventoStatus eventoStatus;


  Agendamento(this.id, this.dataInicial, this.dataFinal, this.evento,
      this.eventoStatus);

  @override
  String toString() {
    return 'Agendamento{id: $id, dataInicial: $dataInicial, dataFinal: $dataFinal, evento: $evento, eventoStatus: $eventoStatus}';
  }
}