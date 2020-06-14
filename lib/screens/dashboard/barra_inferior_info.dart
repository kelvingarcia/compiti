import 'package:compiti_2/controllers/controlador_agendamento.dart';
import 'package:compiti_2/models/agendamento.dart';
import 'package:compiti_2/models/opcao_snackbar.dart';
import 'package:compiti_2/models/semana.dart';
import 'package:compiti_2/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class BarraInferiorInfo extends StatefulWidget {
  DashboardState dashboardState;
  BarraInferiorInfoState barraInferiorInfoState;

  @override
  BarraInferiorInfoState createState() => BarraInferiorInfoState();
}

class BarraInferiorInfoState extends State<BarraInferiorInfo> {
  Color _buttonColor;
  ControladorAgendamento _controladorAgendamento = ControladorAgendamento();
  Agendamento agendamento;
  Agendamento agendamentoNew;
  String texto = '';
  OpcaoSnackBar opcaoSnackBar;

  @override
  void initState(){
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                texto,
                style: TextStyle(color: Colors.white),
              ),
            ),
            FlatButton(
              onPressed: () {
                _dialogo();
              },
              child: Text(
                'DESFAZER',
                style: TextStyle(color: _buttonColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void toggleOpcao(OpcaoSnackBar opcaoSnackBar, Agendamento agendamento, {Agendamento agendamentoNew}){
    setState(() {
      if(agendamento != null){
        this.agendamento = agendamento;
      }
      if(agendamentoNew != null){
        this.agendamentoNew = agendamentoNew;
      }
      this.opcaoSnackBar = opcaoSnackBar;
      switch(opcaoSnackBar){        
        case OpcaoSnackBar.deletou_todos:
          texto = 'O evento ' + agendamento.evento.titulo + ' foi deletado.';
          _buttonColor = Colors.cyan;
          break;
        case OpcaoSnackBar.deletou_um:
          texto = 'O evento ' + agendamento.evento.titulo + ' foi deletado.';
          _buttonColor = Colors.cyan;
          break;
        case OpcaoSnackBar.editou_todos:
          texto = 'O evento ' + agendamento.evento.titulo + ' foi editado.';
          _buttonColor = Colors.cyan;
          break;
        case OpcaoSnackBar.editou_um:
          texto = 'O evento ' + agendamento.evento.titulo + ' foi editado.';
          _buttonColor = Colors.cyan;
          break;
        case OpcaoSnackBar.adicionou:
          texto = 'Item foi adicionado.';
          _buttonColor = Colors.black;
          break;
      }
      widget.dashboardState.toggleSnackBar();
    });
  }

  Future<void> _dialogo() async {
    var textoDialogo;
    switch(opcaoSnackBar){      
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
                Text(
                    'Tem certeza que deseja desfazer a ' + textoDialogo + agendamento.evento.titulo + '?'),
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
                switch(this.opcaoSnackBar) {                  
                  case OpcaoSnackBar.deletou_todos:
                    _controladorAgendamento.salvarEventoAgendamento(agendamento.evento, context, widget.dashboardState);
                    break;
                  case OpcaoSnackBar.deletou_um:
                    _controladorAgendamento.salvarSomenteAgendamento(context, widget.dashboardState, agendamento);
                    break;
                  case OpcaoSnackBar.editou_todos:
                    _controladorAgendamento.deletaTodosAgendamentosComEvento(agendamento, widget.dashboardState);
                    _controladorAgendamento.salvarEventoAgendamento(agendamento.evento, context, widget.dashboardState);
                    break;
                  case OpcaoSnackBar.editou_um:
                    _controladorAgendamento.deletaTodosAgendamentosComEvento(agendamentoNew, widget.dashboardState);
                    _controladorAgendamento.salvarSomenteAgendamento(context, widget.dashboardState, agendamento);                    
                    break;
                  case OpcaoSnackBar.adicionou:
                    // TODO: Handle this case.
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
}
