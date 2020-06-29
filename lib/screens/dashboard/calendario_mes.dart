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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                await showMonthPicker(
                    context: context, initialDate: DateTime.now());
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
              itemCount: 31,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 10.0,
                  width: 10.0,
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                        color: Colors.white,
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
