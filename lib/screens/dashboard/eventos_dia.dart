import 'package:compiti/database/agendamento_dao.dart';
import 'package:compiti/models/agendamento.dart';
import 'package:compiti/screens/dashboard/dashboard.dart';
import 'package:compiti/screens/dashboard/item_evento.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventosDia extends StatefulWidget {
  EventosDiaState eventosDiaState;
  DashboardState dashboardState;

  EventosDia({this.dashboardState});

  @override
  EventosDiaState createState() {
    eventosDiaState = EventosDiaState();
    return eventosDiaState;
  }
}

class EventosDiaState extends State<EventosDia> {
  AgendamentoDao _dao = AgendamentoDao();
  List<Agendamento> agendamentos = List();
  final DateFormat dateFormat = DateFormat(DateFormat.MONTH, 'pt_BR');

  @override
  void initState() {
    this.atualizaLista();
    super.initState();
  }

  void mudaDia(DateTime novoDia) {
    setState(() {
      widget.dashboardState.currentDate = novoDia;
      atualizaLista();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              child: GestureDetector(
                onTap: () => widget.dashboardState.mesFromDia(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => mudaDia(DateTime(
                          widget.dashboardState.currentDate.year,
                          widget.dashboardState.currentDate.month,
                          widget.dashboardState.currentDate.day - 1)),
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.dashboardState.mesFromDia();
                      },
                      child: Text(
                        widget.dashboardState.currentDate.day.toString() +
                            ' de ' +
                            dateFormat
                                .format(widget.dashboardState.currentDate) +
                            ' de ' +
                            widget.dashboardState.currentDate.year.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => mudaDia(DateTime(
                          widget.dashboardState.currentDate.year,
                          widget.dashboardState.currentDate.month,
                          widget.dashboardState.currentDate.day + 1)),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              itemCount: agendamentos.length + 1,
              itemBuilder: (context, int index) {
                if (index == agendamentos.length) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                  );
                }
                return ItemEvento(
                    agendamentos.elementAt(index), widget.dashboardState);
              },
            ),
          ),
        ],
      ),
    );
  }

  void atualizaLista() {
    _dao.findAll().then((lista) {
      listaDoDia(lista).then((listaDoDia) {
        setState(() {
          listaDoDia.sort((a, b) => a.dataInicial.compareTo(b.dataInicial));
          agendamentos = listaDoDia;
          widget.dashboardState.atualizouBanco = true;
        });
      });
    });
  }

  Future<List<Agendamento>> listaDoDia(List<Agendamento> lista) async {
    List<Agendamento> listaDoDia = List();
    lista.forEach((agendamento) {
      if ((agendamento.dataInicial.isAfter(widget.dashboardState.currentDate) ||
              agendamento.dataInicial
                  .isAtSameMomentAs(widget.dashboardState.currentDate)) &&
          agendamento.dataInicial.isBefore(
              widget.dashboardState.currentDate.add(Duration(days: 1)))) {
        listaDoDia.add(agendamento);
      }
    });
    return listaDoDia;
  }
}
