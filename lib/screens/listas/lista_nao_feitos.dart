import 'package:compiti/models/agendamento.dart';
import 'package:compiti/screens/dashboard/dashboard.dart';
import 'package:compiti/screens/dashboard/item_evento.dart';
import 'package:compiti/screens/listas/todos_eventos.dart';
import 'package:flutter/material.dart';

class ListaNaoFeitos extends StatefulWidget {
  final TodosEventosState todosEventosState;
  final DashboardState dashboardState;
  final List<Agendamento> agendamentosNaoFeitos;

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
      var diferencaNaoFeitos = List();
      diferencaNaoFeitos.addAll(novaListaNaoFeitos);
      if (widget.agendamentosNaoFeitos.length < novaListaNaoFeitos.length) {
        List<Agendamento> diferencaNovos = List();
        diferencaNovos.addAll(widget.agendamentosNaoFeitos);
        diferencaNovos.forEach((agendamento) {
          diferencaNaoFeitos.removeWhere((agend) => agend.id == agendamento.id);
        });
        diferencaNaoFeitos.forEach((agendamento) {
          var indexWhere = widget.agendamentosNaoFeitos.lastIndexWhere(
                  (agend) =>
                      agend.dataInicial.isBefore(agendamento.dataInicial)) +
              1;
          widget.agendamentosNaoFeitos.insert(indexWhere, agendamento);
          listKey.currentState.insertItem(indexWhere);
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
        return ItemEvento(
          widget.agendamentosNaoFeitos[index],
          widget.dashboardState,
        );
      },
    );
  }
}
