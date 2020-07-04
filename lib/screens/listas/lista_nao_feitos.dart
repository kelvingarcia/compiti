import 'package:compiti_2/models/agendamento.dart';
import 'package:compiti_2/screens/dashboard/dashboard.dart';
import 'package:compiti_2/screens/dashboard/item_evento.dart';
import 'package:compiti_2/screens/dashboard/todos_eventos.dart';
import 'package:flutter/material.dart';

class ListaNaoFeitos extends StatefulWidget {
  TodosEventosState todosEventosState;
  final DashboardState dashboardState;
  List<Agendamento> agendamentosNaoFeitos;

  ListaNaoFeitos(
      {Key key,
      this.dashboardState,
      this.agendamentosNaoFeitos,
      this.todosEventosState})
      : super(key: key);

  @override
  ListaNaoFeitosState createState() => ListaNaoFeitosState();
}

class ListaNaoFeitosState extends State<ListaNaoFeitos> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    widget.todosEventosState.listaNaoFeitosState = this;
    super.initState();
  }

  void insereNovoItem(List<Agendamento> novaListaNaoFeitos) {
    if (listKey.currentState != null) {
      var diferencaNaoFeitos = novaListaNaoFeitos
          .toSet()
          .difference(widget.agendamentosNaoFeitos.toSet())
          .toList();
      if (widget.agendamentosNaoFeitos.length < novaListaNaoFeitos.length) {
        diferencaNaoFeitos.forEach((agendamento) {
          var indexWhere = widget.agendamentosNaoFeitos.lastIndexWhere(
                  (agend) =>
                      agend.dataInicial.isBefore(agendamento.dataInicial)) +
              1;
          listKey.currentState.insertItem(indexWhere);
          widget.agendamentosNaoFeitos.insert(indexWhere, agendamento);
        });
      } else {
        if (widget.agendamentosNaoFeitos.length > novaListaNaoFeitos.length) {
          List<Agendamento> diferencaRemovidos = List();
          diferencaRemovidos.addAll(widget.agendamentosNaoFeitos);
          diferencaNaoFeitos.forEach((agendamento) {
            diferencaRemovidos
                .removeWhere((agend) => agend.id == agendamento.id);
          });
          diferencaRemovidos.forEach((agendamento) {
            var indexOf = widget.agendamentosNaoFeitos
                .indexWhere((agend) => agend.id == agendamento.id);
            widget.agendamentosNaoFeitos.removeAt(indexOf);
            listKey.currentState.removeItem(indexOf, (context, animation) {
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

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      key: listKey,
      initialItemCount: widget.agendamentosNaoFeitos.length + 1,
      itemBuilder: (context, index, animation) {
        if (index == widget.agendamentosNaoFeitos.length) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
          );
        }
        return SizeTransition(
          axis: Axis.vertical,
          sizeFactor: animation,
          child: ItemEvento(
            widget.agendamentosNaoFeitos[index],
            widget.dashboardState,
          ),
        );
      },
    );
  }
}
