import 'package:compiti_2/database/evento_dao.dart';
import 'package:compiti_2/models/evento_status.dart';
import 'package:flutter/material.dart';

import '../../models/evento.dart';
import 'item_evento.dart';

class TodosEventos extends StatefulWidget {
  List<Evento> listaEventos;

  TodosEventos(this.listaEventos);

  @override
  _TodosEventosState createState() => _TodosEventosState();
}

class _TodosEventosState extends State<TodosEventos> {
  EventoDao _dao = EventoDao();
  Color _corRealizadas;
  Color _corTextoRealizadas;
  Color _corNaoRealizadas ;
  Color _corTextoNaoRealizadas;
  bool realizadas = false;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(realizadas){
      _corRealizadas = Colors.grey[400];
      _corTextoRealizadas = Colors.black;
      _corNaoRealizadas = Color(0xFF626262);
      _corTextoNaoRealizadas = Colors.white;
    } else {
      _corRealizadas = Color(0xFF626262);
      _corTextoRealizadas = Colors.white;
      _corNaoRealizadas = Colors.grey[400];
      _corTextoNaoRealizadas = Colors.black;
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    setState(() {
                      realizadas = true;
                    });
                  },
                  child: Container(
                    color: _corRealizadas,
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Center(
                      child: Text(
                        'Realizadas',
                        style: TextStyle(
                          color: _corTextoRealizadas,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      realizadas = false;
                    });
                  },
                  child: Container(
                    color: _corNaoRealizadas,
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Center(
                      child: Text(
                        'Não realizadas',
                        style: TextStyle(
                          color: _corTextoNaoRealizadas,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
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
          ),
        ],
      ),
    );
  }
}
