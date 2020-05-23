import 'package:compiti_2/models/evento.dart';
import 'package:compiti_2/models/evento_status.dart';
import 'package:compiti_2/screens/dashboard/item_evento.dart';
import 'package:compiti_2/screens/dashboard/toggle_dashboard.dart';
import 'package:flutter/material.dart';

class EventosDia extends StatefulWidget {
  @override
  _EventosDiaState createState() => _EventosDiaState();
}

class _EventosDiaState extends State<EventosDia> {
  List<Evento> listaEventos = List();

  @override
  void initState() {
    for (int i = 0; i < 15; i++) {
      listaEventos.add(Evento(0, 'teste', 'teste', 'teste', 'TimeOfDay.now()', DateTime.now(), DateTime.now(), EventoStatus.agendado));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        itemCount: listaEventos.length,
        itemBuilder: (context, int index) {
          if (index == listaEventos.length - 1) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.2,
            );
          }
          return ItemEvento();
        },
      ),
    );
  }
}

