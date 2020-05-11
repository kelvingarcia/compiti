import 'package:compiti_2/models/evento.dart';
import 'package:compiti_2/screens/dashboard/item_evento.dart';
import 'package:compiti_2/screens/dashboard/toggle_dashboard.dart';
import 'package:flutter/material.dart';

class CorpoDashboard extends StatefulWidget {
  @override
  _CorpoDashboardState createState() => _CorpoDashboardState();
}

class _CorpoDashboardState extends State<CorpoDashboard> {
  List<Evento> listaEventos = List();

  @override
  void initState() {
    for (int i = 0; i < 7; i++) {
      listaEventos.add(Evento('teste', 'teste'));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Color(0xFF383838),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          )),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.only(top: 24.0, bottom: 24.0),
          child: Column(
            children: <Widget>[
              ToggleDashboard(),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: listaEventos.length,
                  itemBuilder: (context, int index) {
                    return ItemEvento();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
