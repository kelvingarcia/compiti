import 'package:compiti_2/database/agendamento_dao.dart';
import 'package:compiti_2/models/agendamento.dart';
import 'package:compiti_2/models/evento_status.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'item_evento.dart';

class TodosEventos extends StatefulWidget {
  TodosEventosState todosEventosState;
  DashboardState dashboardState;

  TodosEventos({this.dashboardState});

  @override
  TodosEventosState createState() {
    todosEventosState = TodosEventosState();
    return todosEventosState;
  }
}

class TodosEventosState extends State<TodosEventos> {
  AgendamentoDao _dao = AgendamentoDao();
  List<Agendamento> agendamentos = List();
  List<Agendamento> listaAux = List();
  Color _corRealizadas;
  Color _corTextoRealizadas;
  Color _corNaoRealizadas;

  Color _corTextoNaoRealizadas;
  bool realizadas = false;

  @override
  void initState() {
    this.atualizaLista();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (realizadas) {
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
                  onTap: () {
                    setState(() {
                      realizadas = true;
                      this.fitraLista();
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
                  onTap: () {
                    setState(() {
                      realizadas = false;
                      this.fitraLista();
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
              itemCount: listaAux.length + 1,
              itemBuilder: (context, int index) {
                if (index == listaAux.length) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                  );
                }
                return ItemEvento(listaAux.elementAt(index), widget.dashboardState);
              },
            ),
          ),
        ],
      ),
    );
  }

  void atualizaLista() {
    _dao.findAll().then((lista) {
      setState(() {
        lista.sort((a, b) => a.dataInicial.compareTo(b.dataInicial));
        agendamentos = lista;
        this.fitraLista();
        widget.dashboardState.atualizouBanco = true;
      });
    });
  }

  void fitraLista(){
    setState(() {      
      listaAux.clear();
      if(realizadas){
        listaAux = agendamentos.where((agendamento) => agendamento.eventoStatus == EventoStatus.feito).toList();
      } else {
        listaAux = agendamentos.where((agendamento) => agendamento.eventoStatus != EventoStatus.feito).toList();
      }
    });
  }
}
