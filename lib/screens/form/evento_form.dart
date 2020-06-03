import 'package:compiti_2/controllers/controlador_agendamento.dart';
import 'package:compiti_2/models/evento_dto.dart';
import 'package:compiti_2/models/semana.dart';
import 'package:compiti_2/screens/dashboard/eventos_dia.dart';
import 'package:compiti_2/screens/dashboard/todos_eventos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventoForm extends StatefulWidget {
  final TodosEventosState todosEventosState;
  final EventosDiaState eventosDiaState;

  EventoForm(this.todosEventosState, this.eventosDiaState);

  @override
  EventoFormState createState() => EventoFormState();
}

class EventoFormState extends State<EventoForm> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _horaInicialController = TextEditingController();
  final TextEditingController _horaFinalController = TextEditingController();
  final TextEditingController _dataInicialController = TextEditingController();
  final TextEditingController _dataFinalController = TextEditingController();
  final ControladorAgendamento controladorAgendamento = ControladorAgendamento();
  List<Semana> diasDaSemana = List();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black,
          ),
        ),
        Positioned(
          top: 25,
          left: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: TextField(
                      controller: _tituloController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Título',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: TextField(
                      controller: _descricaoController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Descrição',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _horaInicialController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Hora inicial',
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _horaFinalController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Hora final',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _dataInicialController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Data inicial',
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _dataFinalController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Data final',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: Container(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return SemanaButton(index, this);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton(
                          child: Text('Adicionar'),
                          onPressed: () {
                            var dataInicialSplit =
                                _dataInicialController.text.split('/');
                            var dataFinalSplit =
                                _dataFinalController.text.split('/');
                            var horaInicialSplit =
                                _horaInicialController.text.split(':');
                            var horaFinalSplit =
                                _horaFinalController.text.split(':');
                            controladorAgendamento
                                .salvarEventoAgendamento(
                              EventoDto(
                                _tituloController.text,
                                _descricaoController.text,
                                TimeOfDay(
                                  hour:
                                      int.parse(horaInicialSplit.elementAt(0)),
                                  minute:
                                      int.parse(horaInicialSplit.elementAt(1)),
                                ),
                                TimeOfDay(
                                  hour: int.parse(horaFinalSplit.elementAt(0)),
                                  minute:
                                      int.parse(horaFinalSplit.elementAt(1)),
                                ),
                                DateTime(
                                  int.parse(dataInicialSplit.elementAt(2)),
                                  int.parse(dataInicialSplit.elementAt(1)),
                                  int.parse(dataInicialSplit.elementAt(0)),
                                ),
                                DateTime(
                                  int.parse(dataFinalSplit.elementAt(2)),
                                  int.parse(dataFinalSplit.elementAt(1)),
                                  int.parse(dataFinalSplit.elementAt(0)),
                                ),
                                diasDaSemana,
                              ),
                              widget,
                              context
                            );
                            Navigator.pop(context);
                          },
                        ),
                        RaisedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancelar'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void addDiaDaSemana(int dia){
    switch(dia) {
      case 0:
        diasDaSemana.add(Semana.domingo);
        break;
      case 1:
        diasDaSemana.add(Semana.segunda);
        break;
      case 2:
        diasDaSemana.add(Semana.terca);
        break;
      case 3:
        diasDaSemana.add(Semana.quarta);
        break;
      case 4:
        diasDaSemana.add(Semana.quinta);
        break;
      case 5:
        diasDaSemana.add(Semana.sexta);
        break;
      case 6:
        diasDaSemana.add(Semana.sabado);
        break;
      default:
        break;
    }
  }

  void removeDiaDaSemana(int dia){
    switch(dia) {
      case 0:
        diasDaSemana.removeAt(diasDaSemana.indexOf(Semana.domingo));
        break;
      case 1:
        diasDaSemana.removeAt(diasDaSemana.indexOf(Semana.segunda));
        break;
      case 2:
        diasDaSemana.removeAt(diasDaSemana.indexOf(Semana.terca));
        break;
      case 3:
        diasDaSemana.removeAt(diasDaSemana.indexOf(Semana.quarta));
        break;
      case 4:
        diasDaSemana.removeAt(diasDaSemana.indexOf(Semana.quinta));
        break;
      case 5:
        diasDaSemana.removeAt(diasDaSemana.indexOf(Semana.sexta));
        break;
      case 6:
        diasDaSemana.removeAt(diasDaSemana.indexOf(Semana.sabado));
        break;
      default:
        break;
    }
  }
}

class SemanaButton extends StatefulWidget {
  final int _dia;
  final EventoFormState eventoFormState;

  SemanaButton(this._dia, this.eventoFormState);

  @override
  _SemanaButtonState createState() => _SemanaButtonState();
}

class _SemanaButtonState extends State<SemanaButton> {
  String _textoDia;
  Color _color = Colors.white;
  Color _colorSplash = Colors.white;

  @override
  Widget build(BuildContext context) {
    switch(widget._dia) {
      case 0:
        _textoDia = 'D';
        break;
      case 1:
        _textoDia = 'S';
        break;
      case 2:
        _textoDia = 'T';
        break;
      case 3:
        _textoDia = 'Q';
        break;
      case 4:
        _textoDia = 'Q';
        break;
      case 5:
        _textoDia = 'S';
        break;
      case 6:
        _textoDia = 'S';
        break;
      default:
        _textoDia = 'S';
        break;
    }
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Material(
        color: _color,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          splashColor: _colorSplash,
          customBorder: CircleBorder(),
          onTap: () {
            setState(() {
              if(_color == Colors.white) {
                _color = Colors.cyan;
                _colorSplash = Colors.cyan;
                widget.eventoFormState.addDiaDaSemana(widget._dia);
              } else {
                _color = Colors.white;
                _colorSplash = Colors.white;
                widget.eventoFormState.removeDiaDaSemana(widget._dia);
              }
            });
          },
          child: Container(
            width: 35.0,
            height: 35.0,
            child: Center(
              child: Text(_textoDia),
            ),
          ),
        ),
      ),
    );
  }
}
