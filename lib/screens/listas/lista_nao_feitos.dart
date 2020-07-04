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
