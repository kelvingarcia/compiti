import 'package:compiti_2/controllers/notificacao_controller.dart';
import 'package:compiti_2/database/agendamento_dao.dart';
import 'package:compiti_2/database/evento_dao.dart';
import 'package:compiti_2/models/agendamento.dart';
import 'package:compiti_2/models/evento.dart';
import 'package:compiti_2/models/evento_dto.dart';
import 'package:compiti_2/models/evento_status.dart';
import 'package:compiti_2/screens/dashboard/dashboard.dart';
import 'package:compiti_2/screens/form/evento_form.dart';
import 'package:flutter/cupertino.dart';

class ControladorAgendamento {
  final EventoDao _eventoDao = EventoDao();
  final AgendamentoDao _agendamentoDao = AgendamentoDao();

  Future<void> salvarEventoAgendamento(
      EventoDto eventoDto, EventoForm eventoForm, BuildContext context) async {
    NotificacaoController notificacaoController =
        NotificacaoController(context);
    DateTime dataAgendamento =
        eventoDto.dataInicial.subtract(Duration(days: 1));
    final int id = await _eventoDao.save(Evento(
      0,
      eventoDto.titulo,
      eventoDto.descricao,
      eventoDto.horaInicial,
      eventoDto.horaFinal,
      eventoDto.dataInicial,
      eventoDto.dataFinal,
    ));
    final Evento evento = await _eventoDao.find(id);
    for (int i = 0;
        i <= eventoDto.dataFinal.difference(eventoDto.dataInicial).inDays;
        i++) {
      bool diaValidado = false;
      dataAgendamento = dataAgendamento.add(Duration(days: 1));
      eventoDto.diasDaSemana.forEach((dia) {
        if (dataAgendamento.weekday - 1 == dia.index) {
          diaValidado = true;
        }
      });
      if (diaValidado) {
        await _agendamentoDao.save(
          Agendamento(
            0,
            dataAgendamento.add(Duration(hours: eventoDto.horaInicial.hour, minutes: eventoDto.horaInicial.minute)),
            dataAgendamento.add(Duration(hours: eventoDto.horaFinal.hour, minutes: eventoDto.horaFinal.minute)),
            evento,
            EventoStatus.agendado,
          ),
        );
        notificacaoController.agendaNotificacao(
          dataAgendamento.add(
            Duration(
              hours: eventoDto.horaInicial.hour,
              minutes: eventoDto.horaInicial.minute,
            ),
          ),
          evento,
        );
      }
    }
    eventoForm.eventosDiaState.atualizaLista();
    eventoForm.todosEventosState.atualizaLista();
  }

  Future<void> deletaUmAgendamento(Agendamento agendamento, DashboardState dashboardState) async {
    await _agendamentoDao.deleteAgendamento(agendamento);
    dashboardState.eventosDia.eventosDiaState.atualizaLista();
    dashboardState.todosEventos.todosEventosState.atualizaLista();
  }

  Future<void> deletaUmAgendamentoComEvento(Agendamento agendamento, DashboardState dashboardState) async {
    await _agendamentoDao.deleteAgendamento(agendamento);
    await _eventoDao.deleteEvento(agendamento.evento);
    dashboardState.eventosDia.eventosDiaState.atualizaLista();
    dashboardState.todosEventos.todosEventosState.atualizaLista();
  }

  Future<void> deletaTodosAgendamentosComEvento(Agendamento agendamento, DashboardState dashboardState) async {
    await _agendamentoDao.deleteFromEvento(agendamento.evento);
    await _eventoDao.deleteEvento(agendamento.evento);
    dashboardState.eventosDia.eventosDiaState.atualizaLista();
    dashboardState.todosEventos.todosEventosState.atualizaLista();
  }
}
