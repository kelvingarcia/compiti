import 'evento.dart';
import 'evento_status.dart';

class Agendamento {
  int id;
  final DateTime dataInicial;
  final DateTime dataFinal;
  final Evento evento;
  EventoStatus eventoStatus;
  List<int> notificacoes;

  Agendamento(this.id, this.dataInicial, this.dataFinal, this.evento,
      this.eventoStatus, this.notificacoes);

  @override
  String toString() {
    return 'Agendamento{id: $id, dataInicial: $dataInicial, dataFinal: $dataFinal, evento: $evento, eventoStatus: $eventoStatus}';
  }
}
