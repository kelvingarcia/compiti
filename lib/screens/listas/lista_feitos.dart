import 'package:compiti/models/agendamento.dart';
import 'package:compiti/screens/dashboard/dashboard.dart';
import 'package:compiti/screens/dashboard/item_evento.dart';
import 'package:compiti/screens/listas/todos_eventos.dart';
import 'package:flutter/material.dart';

class ListaFeitos extends StatefulWidget {
  final TodosEventosState todosEventosState;
  final DashboardState dashboardState;
  final List<Agendamento> agendamentosFeitos;

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
          widget.agendamentosFeitos.insert(indexWhere, agendamento);
          listKey.currentState.insertItem(indexWhere);
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
        return ItemEvento(
          widget.agendamentosFeitos[index],
          widget.dashboardState,
        );
      },
    );
  }
}
