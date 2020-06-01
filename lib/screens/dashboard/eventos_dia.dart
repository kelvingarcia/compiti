import 'package:compiti_2/database/agendamento_dao.dart';
import 'package:compiti_2/models/agendamento.dart';
import 'package:compiti_2/screens/dashboard/item_evento.dart';
import 'package:flutter/material.dart';


class EventosDia extends StatefulWidget {
  EventosDiaState eventosDiaState;

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
          return ItemEvento(agendamentos.elementAt(index));
        },
      ),
    );
  }

  void atualizaLista() {
    _dao.findAll().then((lista) {
      setState(() {
        agendamentos = lista;
      });
    });
  }
}

