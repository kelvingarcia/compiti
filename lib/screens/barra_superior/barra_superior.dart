import 'package:compiti_2/models/agendamento.dart';
import 'package:compiti_2/screens/barra_superior/reportar_problema.dart';
import 'package:compiti_2/screens/charts/grafico_pizza.dart';
import 'package:compiti_2/screens/barra_superior/item_menu.dart';
import 'package:flutter/material.dart';
import 'package:compiti_2/screens/dashboard/dashboard.dart';
import 'package:launch_review/launch_review.dart';

class BarraSuperior extends StatefulWidget {
  final DashboardState parent;
  final List<Agendamento> listaAgendamentos;

  BarraSuperior({this.parent, this.listaAgendamentos});

  @override
  _BarraSuperiorState createState() => _BarraSuperiorState();
}

class _BarraSuperiorState extends State<BarraSuperior> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.cyan,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Material(
                    color: Colors.cyan,
                    child: InkWell(
                      splashColor: Colors.white,
                      onTap: () {
                        if (this.widget.parent.topCorpo == 100.0) {
                          this.widget.parent.setState(() {
                            this.widget.parent.topCorpo = 400.0;
                          });
                        } else {
                          this.widget.parent.setState(() {
                            this.widget.parent.topCorpo = 100.0;
                          });
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 32.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 95.0),
                    child: Text(
                      'Compiti',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 36.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      ItemMenu(
                        hasTop: true,
                        icone: Icons.show_chart,
                        texto: 'Relatórios',
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Material(
                              child: GraficoPizza(widget.listaAgendamentos),
                            ),
                          ),
                        ),
                      ),
                      ItemMenu(
                        hasTop: false,
                        icone: Icons.report_problem,
                        texto: 'Reportar problema',
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Material(
                              child: ReportarProblema(),
                            ),
                          ),
                        ),
                      ),
                      ItemMenu(
                        hasTop: false,
                        icone: Icons.star,
                        texto: 'Avaliar app',
                        onPressed: () => LaunchReview.launch(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
