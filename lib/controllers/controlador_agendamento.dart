import 'package:compiti_2/controllers/notificacao_controller.dart';
import 'package:compiti_2/database/agendamento_dao.dart';
import 'package:compiti_2/database/evento_dao.dart';
import 'package:compiti_2/models/agendamento.dart';
import 'package:compiti_2/models/evento.dart';
import 'package:compiti_2/models/evento_dto.dart';
import 'package:compiti_2/models/evento_status.dart';
import 'package:compiti_2/models/semana.dart';
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
            dataAgendamento.add(Duration(
                hours: eventoDto.horaInicial.hour,
                minutes: eventoDto.horaInicial.minute)),
            dataAgendamento.add(Duration(
                hours: eventoDto.horaFinal.hour,
                minutes: eventoDto.horaFinal.minute)),
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

  Future<void> editarSomenteAgendamento(
      EventoDto eventoDto,
      EventoForm eventoForm,
      BuildContext context,
      Agendamento agendamento) async {
    NotificacaoController notificacaoController =
        NotificacaoController(context);
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
    await _agendamentoDao.deleteAgendamento(agendamento);
    await _agendamentoDao.save(
      Agendamento(
        0,
        eventoDto.dataInicial.add(Duration(
            hours: eventoDto.horaInicial.hour,
            minutes: eventoDto.horaInicial.minute)),
        eventoDto.dataFinal.add(Duration(
            hours: eventoDto.horaFinal.hour,
            minutes: eventoDto.horaFinal.minute)),
        evento,
        EventoStatus.agendado,
      ),
    );
    notificacaoController.agendaNotificacao(
      eventoDto.dataInicial.add(Duration(
          hours: eventoDto.horaInicial.hour,
          minutes: eventoDto.horaInicial.minute)),
      evento,
    );
    eventoForm.eventosDiaState.atualizaLista();
    eventoForm.todosEventosState.atualizaLista();
  }

  Future<void> editarEventoAgendamento(EventoDto eventoDto,
      EventoForm eventoForm, BuildContext context, Evento evento) async {
    NotificacaoController notificacaoController =
        NotificacaoController(context);
    _eventoDao.editar(Evento(
      evento.id,
      eventoDto.titulo,
      eventoDto.descricao,
      eventoDto.horaInicial,
      eventoDto.horaFinal,
      eventoDto.dataInicial,
      eventoDto.dataFinal,
    ));
    if (evento.horaInicial != eventoDto.horaInicial ||
        evento.horaFinal != eventoDto.horaFinal ||
        evento.dataInicial != eventoDto.dataInicial ||
        evento.dataFinal != eventoDto.dataFinal) {
      var dataInicialAgendamento = eventoDto.dataInicial.add(Duration(
          hours: eventoDto.horaInicial.hour,
          minutes: eventoDto.horaInicial.minute));
      var dataFinalAgendamento = eventoDto.dataInicial.add(Duration(
          hours: eventoDto.horaFinal.hour,
          minutes: eventoDto.horaFinal.minute));
      List<Agendamento> listaAgendamento =
          await _agendamentoDao.findByEvento(evento);
      listaAgendamento.forEach((agendamento) {
        bool diaValidado = false;
        eventoDto.diasDaSemana.forEach((dia) {
          if (agendamento.dataInicial.weekday - 1 == dia.index) {
            diaValidado = true;
          }
        });
        if (diaValidado) {
          _agendamentoDao.editar(Agendamento(
              agendamento.id,
              dataInicialAgendamento,
              dataFinalAgendamento,
              evento,
              agendamento.eventoStatus));
          notificacaoController.agendaNotificacao(
            dataInicialAgendamento,
            evento,
          );
        } else {
          _agendamentoDao.deleteAgendamento(agendamento);
        }
        dataInicialAgendamento = dataInicialAgendamento.add(Duration(days: 1));
        dataFinalAgendamento = dataFinalAgendamento.add(Duration(days: 1));
      });
      List<Agendamento> listaAgendamentoValidacao =
          await _agendamentoDao.findByEvento(evento);
      DateTime dataAgendamentoInicial = eventoDto.dataInicial.add(Duration(
          hours: eventoDto.horaInicial.hour,
          minutes: eventoDto.horaInicial.minute));
      DateTime dataAgendamentoFinal = eventoDto.dataInicial.add(Duration(
          hours: eventoDto.horaFinal.hour,
          minutes: eventoDto.horaFinal.minute));
      for (int i = 0;
          i <= eventoDto.dataFinal.difference(eventoDto.dataInicial).inDays;
          i++) {
        bool diaValidado = false;
        eventoDto.diasDaSemana.forEach((dia) {
          if (dataAgendamentoInicial.weekday - 1 == dia.index) {
            diaValidado = true;
          }
        });
        if (diaValidado) {
          bool existe = false;
          listaAgendamentoValidacao.forEach((agendamento) {
            if (agendamento.dataInicial == dataAgendamentoInicial) {
              existe = true;
            }
          });
          if (!existe) {
            await _agendamentoDao.save(
              Agendamento(
                0,
                dataAgendamentoInicial,
                dataAgendamentoFinal,
                evento,
                EventoStatus.agendado,
              ),
            );
            notificacaoController.agendaNotificacao(
              dataAgendamentoInicial,
              evento,
            );
          }
        }
        dataAgendamentoInicial = dataAgendamentoInicial.add(Duration(days: 1));
        dataAgendamentoFinal = dataAgendamentoFinal.add(Duration(days: 1));
      }
    }
    eventoForm.eventosDiaState.atualizaLista();
    eventoForm.todosEventosState.atualizaLista();
  }

  Future<void> editaStatus(Agendamento agendamento, String status, DashboardState dashboardState) async {
    switch(status){
      case 'Agendado':
        agendamento.eventoStatus = EventoStatus.agendado;
        break;
      case 'Não feito':
        agendamento.eventoStatus = EventoStatus.nao_feito;
        break;
      case 'Feito':
        agendamento.eventoStatus = EventoStatus.feito;
        break;
      default: 
        break;
    }
    _agendamentoDao.editar(agendamento);
    dashboardState.eventosDia.eventosDiaState.atualizaLista();
    dashboardState.todosEventos.todosEventosState.atualizaLista();
  }

  Future<void> deletaUmAgendamento(
      Agendamento agendamento, DashboardState dashboardState) async {
    await _agendamentoDao.deleteAgendamento(agendamento);
    dashboardState.eventosDia.eventosDiaState.atualizaLista();
    dashboardState.todosEventos.todosEventosState.atualizaLista();
  }

  Future<void> deletaUmAgendamentoComEvento(
      Agendamento agendamento, DashboardState dashboardState) async {
    await _agendamentoDao.deleteAgendamento(agendamento);
    await _eventoDao.deleteEvento(agendamento.evento);
    dashboardState.eventosDia.eventosDiaState.atualizaLista();
    dashboardState.todosEventos.todosEventosState.atualizaLista();
  }

  Future<void> deletaTodosAgendamentosComEvento(
      Agendamento agendamento, DashboardState dashboardState) async {
    await _agendamentoDao.deleteFromEvento(agendamento.evento);
    await _eventoDao.deleteEvento(agendamento.evento);
    dashboardState.eventosDia.eventosDiaState.atualizaLista();
    dashboardState.todosEventos.todosEventosState.atualizaLista();
  }

  void diasDaSemana(
      Evento evento, EventoFormState eventoFormState) async {
    List<Semana> listaSemana = List();
    var segunda = Semana.segunda;
    var terca = Semana.terca;
    var quarta = Semana.quarta;
    var quinta = Semana.quinta;
    var sexta = Semana.sexta;
    var sabado = Semana.sabado;
    var domingo = Semana.domingo;
    List<Agendamento> lista = await _agendamentoDao.findByEvento(evento);
      lista.forEach((agendamento) {
        switch (agendamento.dataInicial.weekday) {
          case 1:
            if (!listaSemana.contains(segunda)) listaSemana.add(segunda);
            break;
          case 2:
            if (!listaSemana.contains(terca)) listaSemana.add(terca);
            break;
          case 3:
            if (!listaSemana.contains(quarta)) listaSemana.add(quarta);
            break;
          case 4:
            if (!listaSemana.contains(quinta)) listaSemana.add(quinta);
            break;
          case 5:
            if (!listaSemana.contains(sexta)) listaSemana.add(sexta);
            break;
          case 6:
            if (!listaSemana.contains(sabado)) listaSemana.add(sabado);
            break;
          case 7:
            if (!listaSemana.contains(domingo)) listaSemana.add(domingo);
            break;
          default:
            break;
        }
      });
    eventoFormState.atualizaDiasDaSemana(listaSemana);
  }

  List<Semana> diasDaSemanaAgendamento(
      Agendamento agendamento, EventoFormState eventoFormState) {
    List<Semana> listaSemana = List();
    var segunda = Semana.segunda;
    var terca = Semana.terca;
    var quarta = Semana.quarta;
    var quinta = Semana.quinta;
    var sexta = Semana.sexta;
    var sabado = Semana.sabado;
    var domingo = Semana.domingo;
    switch (agendamento.dataInicial.weekday) {
      case 1:
        if (!listaSemana.contains(segunda)) listaSemana.add(segunda);
        break;
      case 2:
        if (!listaSemana.contains(terca)) listaSemana.add(terca);
        break;
      case 3:
        if (!listaSemana.contains(quarta)) listaSemana.add(quarta);
        break;
      case 4:
        if (!listaSemana.contains(quinta)) listaSemana.add(quinta);
        break;
      case 5:
        if (!listaSemana.contains(sexta)) listaSemana.add(sexta);
        break;
      case 6:
        if (!listaSemana.contains(sabado)) listaSemana.add(sabado);
        break;
      case 7:
        if (!listaSemana.contains(domingo)) listaSemana.add(domingo);
        break;
      default:
        break;
    }
    return listaSemana;
  }
}
