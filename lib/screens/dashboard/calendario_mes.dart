import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class CalendarioMes extends StatefulWidget {
  @override
  _CalendarioMesState createState() => _CalendarioMesState();
}

class _CalendarioMesState extends State<CalendarioMes> {
  DateTime mesSelecionado = DateTime.now();
  final DateFormat dateFormat = DateFormat(DateFormat.MONTH, 'pt_BR');
  String data;
  DateTime ultimoDiaDoMes;
  DateTime primeiroDia;
  int numeroDias;
  bool primeiro;
  DateTime iteracao;

  @override
  void initState() {
    posicaoMes(mesSelecionado);
    super.initState();
  }

  void posicaoMes(DateTime mesNovo) {
    setState(() {
      mesSelecionado = mesNovo;
      primeiroDia = Utils.firstDayOfMonth(mesNovo);
      ultimoDiaDoMes = Utils.lastDayOfMonth(mesNovo);
      if (ultimoDiaDoMes.day == 28 && primeiroDia.weekday == 7) {
        numeroDias = 28;
      } else {
        if((primeiroDia.weekday > 3 && ultimoDiaDoMes.day == 31) || (primeiroDia.weekday == 6 && ultimoDiaDoMes.day == 30)){
          numeroDias = 42;
        } else {
          numeroDias = 35;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    primeiro = false;
    iteracao = primeiroDia;
    if (primeiroDia.weekday < 7) {
      for (int i = primeiroDia.weekday; i >= 0; i--) {
        iteracao = DateTime(iteracao.year, iteracao.month, iteracao.day-1);
      }
    } else {
      iteracao = DateTime(iteracao.year, iteracao.month, iteracao.day-1);
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
            child: InkWell(
              splashColor: Colors.white,
              onTap: () async {
                var novoMes = await showMonthPicker(
                    context: context, initialDate: DateTime.now());
                posicaoMes(novoMes);
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                color: Colors.grey[400],
                child: Center(
                  child: Text(
                    dateFormat.format(mesSelecionado) +
                        ' ' +
                        mesSelecionado.year.toString(),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 50.0,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0),
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              itemCount: 7,
              itemBuilder: (BuildContext context, int index) {
                String texto;
                switch (index) {
                  case 0:
                    texto = 'D';
                    break;
                  case 1:
                    texto = 'S';
                    break;
                  case 2:
                    texto = 'T';
                    break;
                  case 3:
                    texto = 'Q';
                    break;
                  case 4:
                    texto = 'Q';
                    break;
                  case 5:
                    texto = 'S';
                    break;
                  case 6:
                    texto = 'S';
                    break;
                  default:
                    texto = 'S';
                    break;
                }
                return Container(
                  height: 10.0,
                  width: 10.0,
                  color: Colors.black,
                  child: Center(
                    child: Text(
                      texto,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              itemCount: numeroDias,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0),
              itemBuilder: (BuildContext context, int index) {
                Color color;
                int diaValidacao;
                if(index == 0){
                  diaValidacao = 7;
                } else {
                  diaValidacao = index;
                }
                if ((diaValidacao == primeiroDia.weekday || primeiro) &&
                    iteracao.isBefore(ultimoDiaDoMes)) {
                  color = Colors.white;
                  primeiro = true;
                } else {
                  color = Colors.black;
                  primeiro = false;
                }
                iteracao = DateTime(iteracao.year, iteracao.month, iteracao.day+1);
                return Container(
                  height: 10.0,
                  width: 10.0,
                  child: Center(
                    child: Text(
                      iteracao.day.toString(),
                      style: TextStyle(
                        color: color,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
