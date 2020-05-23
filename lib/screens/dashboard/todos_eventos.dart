import 'package:compiti_2/models/evento_status.dart';
import 'package:flutter/material.dart';

import '../../models/evento.dart';
import 'item_evento.dart';

class TodosEventos extends StatefulWidget {
  @override
  _TodosEventosState createState() => _TodosEventosState();
}

class _TodosEventosState extends State<TodosEventos> {
  List<Evento> listaEventos = List();
  Color _corRealizadas;
  Color _corTextoRealizadas;
  Color _corNaoRealizadas ;
  Color _corTextoNaoRealizadas;
  bool realizadas = false;


  @override
  void initState() {
    for (int i = 0; i < 15; i++) {
      listaEventos.add(Evento(0, 'teste', 'teste', 'TimeOfDay.now()', 'TimeOfDay.now()', DateTime.now(), DateTime.now(), EventoStatus.agendado));
    }
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
          ),
        ],
      ),
    );
  }
}
