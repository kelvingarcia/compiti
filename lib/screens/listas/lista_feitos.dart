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
  int nextItem;

  @override
  void initState() {
    nextItem = widget.agendamentosFeitos.length;
    widget.todosEventosState.listaFeitosState = this;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedList(
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
      ),
    );
  }
}
