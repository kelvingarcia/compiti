import 'package:charts_flutter/flutter.dart';
import 'package:compiti/models/agendamento.dart';
import 'package:compiti/models/evento_status.dart';
import 'package:compiti/screens/charts/dado_relatorio.dart';
import 'package:flutter/material.dart';

class GraficoPizza extends StatefulWidget {
  final List<Agendamento> listaAgendamentos;

  GraficoPizza(this.listaAgendamentos);

  @override
  _GraficoPizzaState createState() => _GraficoPizzaState();
}

class _GraficoPizzaState extends State<GraficoPizza> {
  List<Series<DadoRelatorio, String>> _seriesPieData = List();

  @override
  void initState() {
    super.initState();
    _geraDados();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listaAgendamentos.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Relatórios'),
          backgroundColor: Colors.blueAccent[200],
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  Icon(Icons.warning),
                  Text('Você ainda não tem agendamentos!'),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatórios'),
        backgroundColor: Colors.blueAccent[200],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: PieChart(
              _seriesPieData,
              animate: true,
              animationDuration: Duration(seconds: 1),
              defaultRenderer: ArcRendererConfig(
                arcWidth: 100,
                arcRendererDecorators: [
                  ArcLabelDecorator(labelPosition: ArcLabelPosition.inside),
                ],
              ),
              behaviors: [
                DatumLegend(
                  outsideJustification: OutsideJustification.endDrawArea,
                  horizontalFirst: false,
                  desiredMaxRows: 2,
                  cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _geraDados() {
    double porcFeitos = 0.0;
    double porcNaoFeitos = 0.0;
    double porcAgendados = 0.0;
    if (widget.listaAgendamentos.length > 0) {
      var feitos = widget.listaAgendamentos.where(
          (agendamento) => agendamento.eventoStatus == EventoStatus.feito);
      var naoFeitos = widget.listaAgendamentos.where(
          (agendamento) => agendamento.eventoStatus == EventoStatus.nao_feito);
      var agendados = widget.listaAgendamentos.where(
          (agendamento) => agendamento.eventoStatus == EventoStatus.agendado);
      porcFeitos = (feitos.length * 100) / widget.listaAgendamentos.length;
      porcNaoFeitos =
          (naoFeitos.length * 100) / widget.listaAgendamentos.length;
      porcAgendados =
          (agendados.length * 100) / widget.listaAgendamentos.length;
    }
    var dados = [
      DadoRelatorio('Feitos', porcFeitos),
      DadoRelatorio('Não feitos', porcNaoFeitos),
      DadoRelatorio('Agendados', porcAgendados),
    ];
    _seriesPieData.add(
      Series(
        data: dados,
        domainFn: (DadoRelatorio dado, _) => dado.texto,
        measureFn: (DadoRelatorio dado, _) => dado.valor,
        id: 'Relatório pizza',
        labelAccessorFn: (DadoRelatorio dado, _) => '${dado.valor}',
      ),
    );
  }
}
