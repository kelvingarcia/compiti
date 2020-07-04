import 'package:compiti_2/database/agendamento_dao.dart';
import 'package:compiti_2/models/agendamento.dart';
import 'package:compiti_2/models/evento_status.dart';
import 'package:compiti_2/screens/listas/lista_feitos.dart';
import 'package:compiti_2/screens/listas/lista_nao_feitos.dart';
import 'package:flutter/material.dart';

import '../dashboard/dashboard.dart';

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
  ListaFeitos listaFeitos;
  ListaNaoFeitos listaNaoFeitos;

  ListaFeitosState listaFeitosState;
  ListaNaoFeitosState listaNaoFeitosState;

  AgendamentoDao _dao = AgendamentoDao();
  List<Agendamento> agendamentos = List();
  List<Agendamento> agendamentosNaoFeitos = List();
  List<Agendamento> agendamentosFeitos = List();

  bool realizadas = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => this.atualizaLista());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: TabBar(
                tabs: <Widget>[
                  Tab(
                    text: 'Realizadas',
                  ),
                  Tab(
                    text: 'Não realizadas',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  ListaFeitos(
                    dashboardState: widget.dashboardState,
                    agendamentosFeitos: agendamentosFeitos,
                    todosEventosState: this,
                  ),
                  ListaNaoFeitos(
                    dashboardState: widget.dashboardState,
                    agendamentosNaoFeitos: agendamentosNaoFeitos,
                    todosEventosState: this,
                  ),
                ],
              ),
            ),
          ],
        ),
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
    if (listaFeitosState != null)
      listaFeitosState.atualizaLista(novaListaFeitos);
    agendamentosFeitos = novaListaFeitos;

    var novaListaNaoFeitos = novaLista
        .where((agendamento) => agendamento.eventoStatus != EventoStatus.feito)
        .toList();
    if (listaNaoFeitosState != null)
      listaNaoFeitosState.insereNovoItem(novaListaNaoFeitos);
    agendamentosNaoFeitos = novaListaNaoFeitos;
  }
}
