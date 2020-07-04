import 'package:compiti_2/models/agendamento.dart';
import 'package:compiti_2/screens/dashboard/dashboard.dart';
import 'package:compiti_2/screens/dashboard/item_evento.dart';
import 'package:compiti_2/screens/dashboard/todos_eventos.dart';
import 'package:flutter/material.dart';

class ListaFeitos extends StatefulWidget {
  TodosEventosState todosEventosState;
  final DashboardState dashboardState;
  List<Agendamento> agendamentosFeitos;

  ListaFeitos(
      {Key key,
      this.dashboardState,
      this.agendamentosFeitos,
      this.todosEventosState})
      : super(key: key);

  @override
  ListaFeitosState createState() => ListaFeitosState();
}

class ListaFeitosState extends State<ListaFeitos> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    widget.todosEventosState.listaFeitosState = this;
    super.initState();
  }

  void atualizaLista(List<Agendamento> novaListaFeitos) {
    if (listKey.currentState != null) {
      var diferencaFeitos = novaListaFeitos
          .toSet()
          .difference(widget.agendamentosFeitos.toSet())
          .toList();
      if (widget.agendamentosFeitos.length < novaListaFeitos.length) {
        diferencaFeitos.forEach((agendamento) {
          var indexWhere = widget.agendamentosFeitos.lastIndexWhere((agend) =>
                  agend.dataInicial.isBefore(agendamento.dataInicial)) +
              1;
          listKey.currentState.insertItem(indexWhere);
          widget.agendamentosFeitos.insert(indexWhere, agendamento);
        });
      } else {
        if (widget.agendamentosFeitos.length > novaListaFeitos.length) {
          List<Agendamento> diferencaRemovidos = List();
          diferencaRemovidos.addAll(widget.agendamentosFeitos);
          diferencaFeitos.forEach((agendamento) {
            diferencaRemovidos
                .removeWhere((agend) => agend.id == agendamento.id);
          });
          diferencaRemovidos.forEach((agendamento) {
            var indexOf = widget.agendamentosFeitos
                .indexWhere((agend) => agend.id == agendamento.id);
            widget.agendamentosFeitos.removeAt(indexOf);
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
      initialItemCount: widget.agendamentosFeitos.length + 1,
      itemBuilder: (context, index, animation) {
        if (index == widget.agendamentosFeitos.length) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
          );
        }
        return SizeTransition(
          axis: Axis.vertical,
          sizeFactor: animation,
          child: ItemEvento(
            widget.agendamentosFeitos[index],
            widget.dashboardState,
          ),
        );
      },
    );
  }
}
