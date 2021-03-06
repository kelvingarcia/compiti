import 'package:compiti/controllers/controlador_agendamento.dart';
import 'package:compiti/models/agendamento.dart';
import 'package:compiti/models/opcao_snackbar.dart';
import 'package:compiti/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class BarraInferiorInfo extends StatefulWidget {
  DashboardState dashboardState;
  BarraInferiorInfoState barraInferiorInfoState;

  @override
  BarraInferiorInfoState createState() => BarraInferiorInfoState();
}

class BarraInferiorInfoState extends State<BarraInferiorInfo> {
  ControladorAgendamento _controladorAgendamento = ControladorAgendamento();
  Agendamento agendamento;
  List<Agendamento> listaAgendamentos;
  Agendamento agendamentoNew;
  String texto = '';
  OpcaoSnackBar opcaoSnackBar;
  bool desfez = false;
  bool _visibilidadeButton = false;

  @override
  void initState() {
    super.initState();
    widget.barraInferiorInfoState = this;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  texto,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Visibility(
              visible: _visibilidadeButton,
              child: FlatButton(
                onPressed: () {
                  _dialogo();
                },
                child: Text(
                  'DESFAZER',
                  style: TextStyle(color: Color(0xFF6599FF)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void toggleOpcao(OpcaoSnackBar opcaoSnackBar,
      {Agendamento agendamento,
      Agendamento agendamentoNew,
      List<Agendamento> listaAgendamentos}) {
    if (!desfez) {
      setState(() {
        if (agendamento != null) {
          this.agendamento = agendamento;
        }
        if (agendamentoNew != null) {
          this.agendamentoNew = agendamentoNew;
        }
        if (listaAgendamentos != null) {
          this.listaAgendamentos = listaAgendamentos;
          this.agendamento = listaAgendamentos[0];
        }
        this.opcaoSnackBar = opcaoSnackBar;
        switch (opcaoSnackBar) {
          case OpcaoSnackBar.deletou_todos:
            texto = listaAgendamentos[0].evento.titulo + ' foi deletado';
            _visibilidadeButton = true;
            break;
          case OpcaoSnackBar.deletou_um:
            texto = agendamento.evento.titulo + ' foi deletado';
            _visibilidadeButton = true;
            break;
          case OpcaoSnackBar.editou_todos:
            texto = listaAgendamentos[0].evento.titulo + ' foi editado';
            _visibilidadeButton = true;
            break;
          case OpcaoSnackBar.editou_um:
            texto = agendamento.evento.titulo + ' foi editado';
            _visibilidadeButton = true;
            break;
          case OpcaoSnackBar.adicionou:
            texto = agendamento.evento.titulo + ' foi adicionado';
            _visibilidadeButton = false;
            break;
        }
        widget.dashboardState.toggleSnackBar();
      });
    }
  }

  Future<void> _dialogo() async {
    var textoDialogo;
    switch (opcaoSnackBar) {
      case OpcaoSnackBar.adicionou:
        break;
      case OpcaoSnackBar.deletou_todos:
        textoDialogo = 'remoção de todos os eventos ';
        break;
      case OpcaoSnackBar.deletou_um:
        textoDialogo = 'remoção do evento ';
        break;
      case OpcaoSnackBar.editou_todos:
        textoDialogo = 'edição de todos os eventos ';
        break;
      case OpcaoSnackBar.editou_um:
        textoDialogo = 'edição do evento ';
        break;
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Atenção'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tem certeza que deseja desfazer a ' +
                    textoDialogo +
                    agendamento.evento.titulo +
                    '?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Não'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Sim'),
              onPressed: () {
                switch (this.opcaoSnackBar) {
                  case OpcaoSnackBar.deletou_todos:
                    this.desfez = true;
                    _controladorAgendamento.salvarPorLista(
                        context, widget.dashboardState, this.listaAgendamentos);
                    this.operacaoDesfeita();
                    break;
                  case OpcaoSnackBar.deletou_um:
                    this.desfez = true;
                    _controladorAgendamento.salvarSomenteAgendamento(
                        context, widget.dashboardState, agendamento);
                    this.operacaoDesfeita();
                    break;
                  case OpcaoSnackBar.editou_todos:
                    this.desfez = true;
                    _controladorAgendamento.deletaTodosAgendamentosComEvento(
                        agendamentoNew, widget.dashboardState);
                    _controladorAgendamento.salvarPorLista(
                        context, widget.dashboardState, this.listaAgendamentos);
                    this.operacaoDesfeita();
                    break;
                  case OpcaoSnackBar.editou_um:
                    this.desfez = true;
                    _controladorAgendamento.deletaTodosAgendamentosComEvento(
                        agendamentoNew, widget.dashboardState);
                    _controladorAgendamento.salvarSomenteAgendamento(
                        context, widget.dashboardState, agendamento);
                    this.operacaoDesfeita();
                    break;
                  case OpcaoSnackBar.adicionou:
                    break;
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void operacaoDesfeita() {
    setState(() {
      texto = 'Operação desfeita.';
      _visibilidadeButton = false;
      widget.dashboardState.toggleSnackBar();
    });
  }
}
