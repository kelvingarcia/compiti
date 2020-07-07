import 'package:compiti/controllers/notificacao_controller.dart';
import 'package:compiti/database/agendamento_dao.dart';
import 'package:compiti/database/evento_dao.dart';
import 'package:compiti/models/agendamento.dart';
import 'package:compiti/models/evento.dart';
import 'package:compiti/models/evento_status.dart';
import 'package:compiti/models/opcao_snackbar.dart';
import 'package:compiti/models/semana.dart';
import 'package:compiti/screens/dashboard/dashboard.dart';
import 'package:flutter/cupertino.dart';

class ControladorAgendamento {
  final EventoDao _eventoDao = EventoDao();
  final AgendamentoDao _agendamentoDao = AgendamentoDao();

  Future<void> salvarEventoAgendamento(Evento evento, BuildContext context,
      DashboardState dashboardState) async {
    NotificacaoController notificacaoController =
        NotificacaoController(context);
    DateTime dataAgendamento = DateTime(evento.dataInicial.year,
        evento.dataInicial.month, evento.dataInicial.day - 1);
    final int id = await _eventoDao.save(evento);
    evento.id = id;
    var testeInicial = DateTime.now().add(Duration(
        hours: evento.horaInicial.hour, minutes: evento.horaInicial.minute));
    var testeFinal = DateTime.now().add(Duration(
        hours: evento.horaFinal.hour, minutes: evento.horaFinal.minute));
    for (int i = 0;
        i <= evento.dataFinal.difference(evento.dataInicial).inDays;
        i++) {
      bool diaValidado = false;
      dataAgendamento = DateTime(
          dataAgendamento.year, dataAgendamento.month, dataAgendamento.day + 1);
      evento.diasDaSemana.forEach((dia) {
        if (dataAgendamento.weekday - 1 == dia.index) {
          diaValidado = true;
        }
      });
      if (diaValidado) {
        DateTime dataAgendamentoFinal = dataAgendamento;
        if (testeFinal.isBefore(testeInicial)) {
          dataAgendamentoFinal = DateTime(dataAgendamento.year,
              dataAgendamento.month, dataAgendamento.day + 1);
        }
        await _agendamentoDao.save(
          Agendamento(
            0,
            dataAgendamento.add(Duration(
                hours: evento.horaInicial.hour,
                minutes: evento.horaInicial.minute)),
            dataAgendamentoFinal.add(Duration(
                hours: evento.horaFinal.hour,
                minutes: evento.horaFinal.minute)),
            evento,
            EventoStatus.agendado,
          ),
        );
        notificacaoController.agendaNotificacao(
          dataAgendamento.add(
            Duration(
              hours: evento.horaInicial.hour,
              minutes: evento.horaInicial.minute,
            ),
          ),
          evento,
        );
      }
    }

    Agendamento agendamento = Agendamento(0, null, null, evento, null);
    dashboardState.eventosDia.eventosDiaState.atualizaLista();
    dashboardState.todosEventos.todosEventosState.atualizaLista();
    dashboardState.eventosDia.eventosDiaState.widget.dashboardState
        .barraInferiorInfo.barraInferiorInfoState
        .toggleOpcao(OpcaoSnackBar.adicionou, agendamento: agendamento);
  }

  Future<void> salvarSomenteAgendamento(BuildContext context,
      DashboardState dashboardState, Agendamento agendamento) async {
    NotificacaoController notificacaoController =
        NotificacaoController(context);
    agendamento.id = 0;
    final int id = await _agendamentoDao.save(agendamento);
    notificacaoController.agendaNotificacao(
      agendamento.dataInicial,
      agendamento.evento,
    );
    agendamento.id = id;
    dashboardState.eventosDia.eventosDiaState.atualizaLista();
    dashboardState.todosEventos.todosEventosState.atualizaLista();
    dashboardState.eventosDia.eventosDiaState.widget.dashboardState
        .barraInferiorInfo.barraInferiorInfoState
        .toggleOpcao(OpcaoSnackBar.adicionou, agendamento: agendamento);
  }

  Future<void> salvarPorLista(
      BuildContext context,
      DashboardState dashboardState,
      List<Agendamento> listaAgendamentos) async {
    NotificacaoController notificacaoController =
        NotificacaoController(context);
    var evento = listaAgendamentos.elementAt(0).evento;
    evento.id = 0;
    var idEvento = await _eventoDao.save(evento);
    listaAgendamentos.forEach((agendamento) {
      agendamento.id = 0;
      agendamento.evento.id = idEvento;
    });
    listaAgendamentos.forEach((agendamento) async {
      await _agendamentoDao.save(agendamento);
      notificacaoController.agendaNotificacao(
        agendamento.dataInicial,
        agendamento.evento,
      );
    });
    dashboardState.eventosDia.eventosDiaState.atualizaLista();
    dashboardState.todosEventos.todosEventosState.atualizaLista();
    dashboardState.eventosDia.eventosDiaState.widget.dashboardState
        .barraInferiorInfo.barraInferiorInfoState
        .toggleOpcao(OpcaoSnackBar.adicionou,
            agendamento: listaAgendamentos[0]);
  }

  Future<void> editarSomenteAgendamento(
      Evento evento,
      DashboardState dashboardState,
      BuildContext context,
      Agendamento agendamento) async {
    NotificacaoController notificacaoController =
        NotificacaoController(context);
    final int id = await _eventoDao.save(evento);
    evento.id = id;
    await _agendamentoDao.deleteAgendamento(agendamento);
    Agendamento agendamentoNew = Agendamento(
      0,
      evento.dataInicial.add(Duration(
          hours: evento.horaInicial.hour, minutes: evento.horaInicial.minute)),
      evento.dataFinal.add(Duration(
          hours: evento.horaFinal.hour, minutes: evento.horaFinal.minute)),
      evento,
      EventoStatus.agendado,
    );
    final int idAgendamento = await _agendamentoDao.save(
      agendamentoNew,
    );
    notificacaoController.agendaNotificacao(
      evento.dataInicial.add(Duration(
          hours: evento.horaInicial.hour, minutes: evento.horaInicial.minute)),
      evento,
    );
    agendamentoNew.id = idAgendamento;
    dashboardState.eventosDia.eventosDiaState.atualizaLista();
    dashboardState.todosEventos.todosEventosState.atualizaLista();
    dashboardState.eventosDia.eventosDiaState.widget.dashboardState
        .barraInferiorInfo.barraInferiorInfoState
        .toggleOpcao(OpcaoSnackBar.editou_um,
            agendamento: agendamento, agendamentoNew: agendamentoNew);
  }

  Future<void> editarEventoAgendamento(
      Evento eventoNew,
      DashboardState dashboardState,
      BuildContext context,
      Evento evento) async {
    List<Agendamento> listaAgendamento =
        await _agendamentoDao.findByEvento(evento);
    NotificacaoController notificacaoController =
        NotificacaoController(context);
    _eventoDao.editar(eventoNew);
    if (evento.horaInicial != eventoNew.horaInicial ||
        evento.horaFinal != eventoNew.horaFinal ||
        evento.dataInicial != eventoNew.dataInicial ||
        evento.dataFinal != eventoNew.dataFinal) {
      var dataInicialAgendamento = eventoNew.dataInicial.add(Duration(
          hours: eventoNew.horaInicial.hour,
          minutes: eventoNew.horaInicial.minute));
      var dataFinalAgendamento = eventoNew.dataInicial.add(Duration(
          hours: eventoNew.horaFinal.hour,
          minutes: eventoNew.horaFinal.minute));
      listaAgendamento.forEach((agendamento) {
        bool diaValidado = false;
        eventoNew.diasDaSemana.forEach((dia) {
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
      DateTime dataAgendamentoInicial = eventoNew.dataInicial.add(Duration(
          hours: eventoNew.horaInicial.hour,
          minutes: eventoNew.horaInicial.minute));
      DateTime dataAgendamentoFinal = eventoNew.dataInicial.add(Duration(
          hours: eventoNew.horaFinal.hour,
          minutes: eventoNew.horaFinal.minute));
      for (int i = 0;
          i <= eventoNew.dataFinal.difference(eventoNew.dataInicial).inDays;
          i++) {
        bool diaValidado = false;
        eventoNew.diasDaSemana.forEach((dia) {
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
    Agendamento agendamentoNew = Agendamento(0, null, null, eventoNew, null);
    dashboardState.eventosDia.eventosDiaState.atualizaLista();
    dashboardState.todosEventos.todosEventosState.atualizaLista();
    dashboardState.eventosDia.eventosDiaState.widget.dashboardState
        .barraInferiorInfo.barraInferiorInfoState
        .toggleOpcao(OpcaoSnackBar.editou_todos,
            listaAgendamentos: listaAgendamento,
            agendamentoNew: agendamentoNew);
  }

  Future<void> editaStatus(Agendamento agendamento, String status,
      DashboardState dashboardState) async {
    switch (status) {
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
    dashboardState.barraInferiorInfo.barraInferiorInfoState
        .toggleOpcao(OpcaoSnackBar.deletou_um, agendamento: agendamento);
  }

  Future<void> deletaUmAgendamentoComEvento(
      Agendamento agendamento, DashboardState dashboardState) async {
    await _agendamentoDao.deleteAgendamento(agendamento);
    await _eventoDao.deleteEvento(agendamento.evento);
    dashboardState.eventosDia.eventosDiaState.atualizaLista();
    dashboardState.todosEventos.todosEventosState.atualizaLista();
    List<Agendamento> listaAgendamentos = List();
    listaAgendamentos.add(agendamento);
    dashboardState.barraInferiorInfo.barraInferiorInfoState.toggleOpcao(
        OpcaoSnackBar.deletou_todos,
        listaAgendamentos: listaAgendamentos);
  }

  Future<void> deletaTodosAgendamentosComEvento(
      Agendamento agendamento, DashboardState dashboardState) async {
    List<Agendamento> listaAgendamentos =
        await _agendamentoDao.findByEvento(agendamento.evento);
    await _agendamentoDao.deleteFromEvento(agendamento.evento);
    await _eventoDao.deleteEvento(agendamento.evento);
    dashboardState.eventosDia.eventosDiaState.atualizaLista();
    dashboardState.todosEventos.todosEventosState.atualizaLista();
    dashboardState.barraInferiorInfo.barraInferiorInfoState.toggleOpcao(
        OpcaoSnackBar.deletou_todos,
        listaAgendamentos: listaAgendamentos);
  }

  List<Semana> diasDaSemanaAgendamento(Agendamento agendamento) {
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
