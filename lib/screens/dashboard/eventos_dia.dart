import 'package:compiti_2/database/agendamento_dao.dart';
import 'package:compiti_2/models/agendamento.dart';
import 'package:compiti_2/screens/dashboard/dashboard.dart';
import 'package:compiti_2/screens/dashboard/item_evento.dart';
import 'package:flutter/material.dart';


class EventosDia extends StatefulWidget {
  EventosDiaState eventosDiaState;
  DateTime data;
  DashboardState dashboardState;

  EventosDia({this.data, this.dashboardState});

  @override
  EventosDiaState createState() {
    eventosDiaState = EventosDiaState();
    return eventosDiaState;
  }
}

class EventosDiaState extends State<EventosDia> {
  AgendamentoDao _dao = AgendamentoDao();
  List<Agendamento> agendamentos = List();

  @override
  void initState() {
    if (widget.data == null) {
      var now = DateTime.now();
      widget.data = DateTime(now.year, now.month, now.day);
    }
    this.atualizaLista();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              color: Colors.grey[400],
              child: Center(
                child: Text(
                  widget.data.toString().substring(0, 10),
                  style: TextStyle(
                    color: Colors.black,
                  ),
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
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.3,
                  );
                }
                return ItemEvento(agendamentos.elementAt(index), widget.dashboardState);
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
      if ((agendamento.dataInicial.isAfter(widget.data) || agendamento.dataInicial.isAtSameMomentAs(widget.data)) && agendamento.dataInicial.isBefore(widget.data.add(Duration(days: 1)))) {
        listaDoDia.add(agendamento);
      }
    });
    return listaDoDia;
  }


}

