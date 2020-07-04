import 'package:compiti_2/database/agendamento_dao.dart';
import 'package:compiti_2/models/agendamento.dart';
import 'package:compiti_2/models/evento_status.dart';
import 'package:compiti_2/screens/listas/lista_feitos.dart';
import 'package:compiti_2/screens/listas/lista_nao_feitos.dart';
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

class TodosEventosState extends State<TodosEventos>
    with TickerProviderStateMixin {
  AnimationController _controllerNaoFeitos;
  Animation<Offset> _animationNaoFeitos;

  AnimationController _controllerFeitos;
  Animation<Offset> _animationFeitos;

  ListaFeitosState listaFeitosState;
  ListaNaoFeitosState listaNaoFeitosState;

  AgendamentoDao _dao = AgendamentoDao();
  List<Agendamento> agendamentos = List();
  List<Agendamento> agendamentosNaoFeitos = List();
  List<Agendamento> agendamentosFeitos = List();
  Color _corRealizadas;
  Color _corTextoRealizadas;
  Color _corNaoRealizadas;

  Color _corTextoNaoRealizadas;
  bool realizadas = false;

  @override
  void initState() {
    _controllerNaoFeitos = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationNaoFeitos = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(1.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controllerNaoFeitos,
        curve: Curves.ease,
      ),
    );
    _controllerFeitos = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationFeitos = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controllerFeitos,
        curve: Curves.ease,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => this.atualizaLista());
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
                      _controllerNaoFeitos.forward();
                      _controllerFeitos.forward();
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
                      _controllerNaoFeitos.reverse();
                      _controllerFeitos.reverse();
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
            child: Container(
              child: Stack(
                children: <Widget>[
                  SlideTransition(
                    position: _animationFeitos,
                    child: ListaFeitos(
                      dashboardState: widget.dashboardState,
                      agendamentosFeitos: agendamentosFeitos,
                      todosEventosState: this,
                    ),
                  ),
                  SlideTransition(
                    position: _animationNaoFeitos,
                    child: ListaNaoFeitos(
                      dashboardState: widget.dashboardState,
                      agendamentosNaoFeitos: agendamentosNaoFeitos,
                      todosEventosState: this,
                    ),
                  ),
                ],
              ),
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
        this.fitraLista(lista);
        widget.dashboardState.atualizouBanco = true;
        widget.dashboardState.listaAgendamentos = lista;
      });
    });
  }

  void fitraLista(List<Agendamento> novaLista) {
    var novaListaFeitos = novaLista
        .where((agendamento) => agendamento.eventoStatus == EventoStatus.feito)
        .toList();
    var diferencaFeitos = novaListaFeitos
        .toSet()
        .difference(listaFeitosState.widget.agendamentosFeitos.toSet())
        .toList();
    if (listaFeitosState.widget.agendamentosFeitos.length <
        novaListaFeitos.length) {
      diferencaFeitos.forEach((agendamento) {
        var indexWhere = listaFeitosState.widget.agendamentosFeitos
                .lastIndexWhere((agend) =>
                    agend.dataInicial.isBefore(agendamento.dataInicial)) +
            1;
        listaFeitosState.listKey.currentState.insertItem(indexWhere);
        listaFeitosState.widget.agendamentosFeitos
            .insert(indexWhere, agendamento);
      });
    } else {
      if (listaFeitosState.widget.agendamentosFeitos.length >
          novaListaFeitos.length) {
        List<Agendamento> diferencaRemovidos = List();
        diferencaRemovidos.addAll(listaFeitosState.widget.agendamentosFeitos);
        diferencaFeitos.forEach((agendamento) {
          diferencaRemovidos.removeWhere((agend) => agend.id == agendamento.id);
        });
        diferencaRemovidos.forEach((agendamento) {
          var indexOf = listaFeitosState.widget.agendamentosFeitos
              .indexWhere((agend) => agend.id == agendamento.id);
          listaFeitosState.widget.agendamentosFeitos.removeAt(indexOf);
          listaFeitosState.listKey.currentState.removeItem(indexOf,
              (context, animation) {
            return SizeTransition(
              axis: Axis.vertical,
              sizeFactor: animation,
              child: ItemEvento(
                agendamento,
                widget.dashboardState,
              ),
            );
          });
        });
      }
    }

    var novaListaNaoFeitos = novaLista
        .where((agendamento) => agendamento.eventoStatus != EventoStatus.feito)
        .toList();
    var diferencaNaoFeitos = novaListaNaoFeitos
        .toSet()
        .difference(listaNaoFeitosState.widget.agendamentosNaoFeitos.toSet())
        .toList();
    if (listaNaoFeitosState.widget.agendamentosNaoFeitos.length <
        novaListaNaoFeitos.length) {
      diferencaNaoFeitos.forEach((agendamento) {
        var indexWhere = listaNaoFeitosState.widget.agendamentosNaoFeitos
                .lastIndexWhere((agend) =>
                    agend.dataInicial.isBefore(agendamento.dataInicial)) +
            1;
        listaNaoFeitosState.listKey.currentState.insertItem(indexWhere);
        listaNaoFeitosState.widget.agendamentosNaoFeitos
            .insert(indexWhere, agendamento);
      });
    } else {
      if (listaNaoFeitosState.widget.agendamentosNaoFeitos.length >
          novaListaNaoFeitos.length) {
        List<Agendamento> diferencaRemovidos = List();
        diferencaRemovidos
            .addAll(listaNaoFeitosState.widget.agendamentosNaoFeitos);
        diferencaNaoFeitos.forEach((agendamento) {
          diferencaRemovidos.removeWhere((agend) => agend.id == agendamento.id);
        });
        diferencaRemovidos.forEach((agendamento) {
          var indexOf = listaNaoFeitosState.widget.agendamentosNaoFeitos
              .indexWhere((agend) => agend.id == agendamento.id);
          listaNaoFeitosState.widget.agendamentosNaoFeitos.removeAt(indexOf);
          listaNaoFeitosState.listKey.currentState.removeItem(indexOf,
              (context, animation) {
            return SizeTransition(
              axis: Axis.vertical,
              sizeFactor: animation,
              child: ItemEvento(
                agendamento,
                widget.dashboardState,
              ),
            );
          });
        });
      }
    }
  }
}
