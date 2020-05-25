import 'package:compiti_2/database/evento_dao.dart';
import 'package:compiti_2/models/evento.dart';
import 'package:compiti_2/models/evento_status.dart';
import 'package:compiti_2/screens/dashboard/item_evento.dart';
import 'package:compiti_2/screens/dashboard/toggle_dashboard.dart';
import 'package:flutter/material.dart';

class EventosDia extends StatefulWidget {
  List<Evento> listaEventos;

  EventosDia(this.listaEventos);

  @override
  _EventosDiaState createState() => _EventosDiaState();
}

class _EventosDiaState extends State<EventosDia> {
  EventoDao _dao = EventoDao();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder<List<Evento>>(
        initialData: List(),
        future: _dao.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              final List<Evento> eventos = snapshot.data;
              eventos.add(eventos.last);
              return ListView.builder(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                itemCount: eventos.length,
                itemBuilder: (context, int index) {
                  if (index == eventos.length-1) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                    );
                  }
                  return ItemEvento(eventos.elementAt(index));
                },
              );
              break;
          }
          widget.listaEventos.add(widget.listaEventos.last);
          return ListView.builder(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            itemCount: widget.listaEventos.length,
            itemBuilder: (context, int index) {
              if (index == widget.listaEventos.length-1) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                );
              }
              return ItemEvento(widget.listaEventos.elementAt(index));
            },
          );
        },
      ),
    );
  }
}
